Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F24BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15172C433EF;
	Tue,  7 Mar 2023 18:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214336;
	bh=coSofe3UYko18P9rkEyENItiL7QL+e9k1FrigDpCrkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i14cUGiUYvks641vej/96oMqSBCV3h819dSRQJ/v5eJaAg+GWMqRD8vSm5KGxApmh
	 TCMb4pU6bE5TzhT0Enobuw5k7UHQttwB9kvbK2oQBXdslCQJAHJ22Wn8Mvl2q5ivBw
	 ns/MsZYcHXnXJQPWm1XbyujAqjErTZpQgkzahdgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.1 789/885] cxl/pmem: Fix nvdimm registration races
Date: Tue,  7 Mar 2023 18:02:03 +0100
Message-Id: <20230307170036.171331761@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

commit f57aec443c24d2e8e1f3b5b4856aea12ddda4254 upstream.

A loop of the form:

    while true; do modprobe cxl_pci; modprobe -r cxl_pci; done

...fails with the following crash signature:

    BUG: kernel NULL pointer dereference, address: 0000000000000040
    [..]
    RIP: 0010:cxl_internal_send_cmd+0x5/0xb0 [cxl_core]
    [..]
    Call Trace:
     <TASK>
     cxl_pmem_ctl+0x121/0x240 [cxl_pmem]
     nvdimm_get_config_data+0xd6/0x1a0 [libnvdimm]
     nd_label_data_init+0x135/0x7e0 [libnvdimm]
     nvdimm_probe+0xd6/0x1c0 [libnvdimm]
     nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
     really_probe+0xde/0x380
     __driver_probe_device+0x78/0x170
     driver_probe_device+0x1f/0x90
     __device_attach_driver+0x85/0x110
     bus_for_each_drv+0x7d/0xc0
     __device_attach+0xb4/0x1e0
     bus_probe_device+0x9f/0xc0
     device_add+0x445/0x9c0
     nd_async_device_register+0xe/0x40 [libnvdimm]
     async_run_entry_fn+0x30/0x130

...namely that the bottom half of async nvdimm device registration runs
after the CXL has already torn down the context that cxl_pmem_ctl()
needs. Unlike the ACPI NFIT case that benefits from launching multiple
nvdimm device registrations in parallel from those listed in the table,
CXL is already marked PROBE_PREFER_ASYNCHRONOUS. So provide for a
synchronous registration path to preclude this scenario.

Fixes: 21083f51521f ("cxl/pmem: Register 'pmem' / cxl_nvdimm devices")
Cc: <stable@vger.kernel.org>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/pmem.c         |    1 +
 drivers/nvdimm/bus.c       |   19 ++++++++++++++++---
 drivers/nvdimm/dimm_devs.c |    5 ++++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    3 +++
 5 files changed, 25 insertions(+), 4 deletions(-)

--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -75,6 +75,7 @@ static int cxl_nvdimm_probe(struct devic
 		goto out;
 
 	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_REGISTER_SYNC, &flags);
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -508,7 +508,7 @@ static void nd_async_device_unregister(v
 	put_device(dev);
 }
 
-void nd_device_register(struct device *dev)
+static void __nd_device_register(struct device *dev, bool sync)
 {
 	if (!dev)
 		return;
@@ -531,11 +531,24 @@ void nd_device_register(struct device *d
 	}
 	get_device(dev);
 
-	async_schedule_dev_domain(nd_async_device_register, dev,
-				  &nd_async_domain);
+	if (sync)
+		nd_async_device_register(dev, 0);
+	else
+		async_schedule_dev_domain(nd_async_device_register, dev,
+					  &nd_async_domain);
+}
+
+void nd_device_register(struct device *dev)
+{
+	__nd_device_register(dev, false);
 }
 EXPORT_SYMBOL(nd_device_register);
 
+void nd_device_register_sync(struct device *dev)
+{
+	__nd_device_register(dev, true);
+}
+
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
 {
 	bool killed;
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -617,7 +617,10 @@ struct nvdimm *__nvdimm_create(struct nv
 	nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &nvdimm_key);
-	nd_device_register(dev);
+	if (test_bit(NDD_REGISTER_SYNC, &flags))
+		nd_device_register_sync(dev);
+	else
+		nd_device_register(dev);
 
 	return nvdimm;
 }
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -107,6 +107,7 @@ int nvdimm_bus_create_ndctl(struct nvdim
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
 void nd_device_register(struct device *dev);
+void nd_device_register_sync(struct device *dev);
 struct nd_label_id;
 char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
 		      u32 flags);
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -36,6 +36,9 @@ enum {
 	/* dimm supports namespace labels */
 	NDD_LABELING = 6,
 
+	/* dimm provider wants synchronous registration by __nvdimm_create() */
+	NDD_REGISTER_SYNC = 8,
+
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 	ND_CMD_MAX_ELEM = 5,


