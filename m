Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4427736EA89;
	Tue, 10 Mar 2026 11:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141049; cv=none; b=YykW7bSoQPjj08edfw7EqXUB4nmwDi8t8JpPvnS+OCTdISaHfeZKGdUFUN7nrK4/UhshzIFJIcCBayPEg6hCZCusrwDGWs47ulAMLLTfPTkGUCCkFEqfTGWeGJumPl3YTtbiHuUrSYQVQoKwv7IzvTgzxoZem7PmkvPy0aWAtQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141049; c=relaxed/simple;
	bh=GCEO8g/Tumy+RoWMzVWpcVPkmFcfYYiHkjsHY/3N6N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubHpgl8s0B0Pc2Abs5D73Z3VatwL2TN7dpVtKYd7e+OB8CORL40ftebcVCsU8DcKT5bobaI0MFMkTCOsQ5iVj9Bgdzsy7Hxty8dEqma1YjD3jqMOl/LcNf7+YKMNWtZ6QmSabIk1tKJQRB12tzJTNRzbbCvZ1IOYfI9mj/Legak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s489r3RF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s489r3RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4686CC19423;
	Tue, 10 Mar 2026 11:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141049;
	bh=GCEO8g/Tumy+RoWMzVWpcVPkmFcfYYiHkjsHY/3N6N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s489r3RFN17lsFjavSIj8Namesr7rFoh5hemx6IyG9aZEnIUFc7xttvvO249JzOx6
	 I1q9H3LbttWxIC6a7yXFgio8vUzIReiHiskF6efCYJheB5efvpJGAKCljlsgF6IuCb
	 fM3dEt3ndOB7NnggtVs5fr5zrNpHtRHNHOm/8/PXQ7p60oiKOp230GcbCikZ/5owI7
	 6xPn8vuWua1/P4JtViiss+exUzYFm9lXmBPf8mnz+Q8ccLV4UheyYUMCUW20yikLq9
	 DGv5TRLsXbSgzb8ruT5noS7INvvRt0p3BUw3MKMEVm1B0xJ3OhL7nLEZySMV4o4VNo
	 Z8MfrSxPD+rQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 047/311] cxl: Fix race of nvdimm_bus object when creating nvdimm objects
Date: Tue, 10 Mar 2026 07:01:34 -0400
Message-ID: <fe40757cf24fed68ea9c9918a6ab2e4afc95bdfe.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 96a1fd0d84b17360840f344826897fa71049870e ]

Found issue during running of cxl-translate.sh unit test. Adding a 3s
sleep right before the test seems to make the issue reproduce fairly
consistently. The cxl_translate module has dependency on cxl_acpi and
causes orphaned nvdimm objects to reprobe after cxl_acpi is removed.
The nvdimm_bus object is registered by the cxl_nvb object when
cxl_acpi_probe() is called. With the nvdimm_bus object missing,
__nd_device_register() will trigger NULL pointer dereference when
accessing the dev->parent that points to &nvdimm_bus->dev.

[  192.884510] BUG: kernel NULL pointer dereference, address: 000000000000006c
[  192.895383] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20250812-19.fc42 08/12/2025
[  192.897721] Workqueue: cxl_port cxl_bus_rescan_queue [cxl_core]
[  192.899459] RIP: 0010:kobject_get+0xc/0x90
[  192.924871] Call Trace:
[  192.925959]  <TASK>
[  192.926976]  ? pm_runtime_init+0xb9/0xe0
[  192.929712]  __nd_device_register.part.0+0x4d/0xc0 [libnvdimm]
[  192.933314]  __nvdimm_create+0x206/0x290 [libnvdimm]
[  192.936662]  cxl_nvdimm_probe+0x119/0x1d0 [cxl_pmem]
[  192.940245]  cxl_bus_probe+0x1a/0x60 [cxl_core]
[  192.943349]  really_probe+0xde/0x380

This patch also relies on the previous change where
devm_cxl_add_nvdimm_bridge() is called from drivers/cxl/pmem.c instead
of drivers/cxl/core.c to ensure the dependency of cxl_acpi on cxl_pmem.

1. Set probe_type of cxl_nvb to PROBE_FORCE_SYNCHRONOUS to ensure the
   driver is probed synchronously when add_device() is called.
2. Add a check in __devm_cxl_add_nvdimm_bridge() to ensure that the
   cxl_nvb driver is attached during cxl_acpi_probe().
3. Take the cxl_root uport_dev lock and the cxl_nvb->dev lock in
   devm_cxl_add_nvdimm() before checking nvdimm_bus is valid.
4. Set cxl_nvdimm flag to CXL_NVD_F_INVALIDATED so cxl_nvdimm_probe()
   will exit with -EBUSY.

The removal of cxl_nvdimm devices should prevent any orphaned devices
from probing once the nvdimm_bus is gone.

[ dj: Fixed 0-day reported kdoc issue. ]
[ dj: Fix cxl_nvb reference leak on error. Gregory (kreview-0811365) ]

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Fixes: 8fdcb1704f61 ("cxl/pmem: Add initial infrastructure for pmem support")
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com?>
Link: https://patch.msgid.link/20260205001633.1813643-3-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pmem.c | 29 +++++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |  5 +++++
 drivers/cxl/pmem.c      | 10 ++++++++--
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index e1325936183a6..e3a8b8d813333 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -115,6 +115,15 @@ static void unregister_nvb(void *_cxl_nvb)
 	device_unregister(&cxl_nvb->dev);
 }
 
+static bool cxl_nvdimm_bridge_failed_attach(struct cxl_nvdimm_bridge *cxl_nvb)
+{
+	struct device *dev = &cxl_nvb->dev;
+
+	guard(device)(dev);
+	/* If the device has no driver, then it failed to attach. */
+	return dev->driver == NULL;
+}
+
 struct cxl_nvdimm_bridge *__devm_cxl_add_nvdimm_bridge(struct device *host,
 						       struct cxl_port *port)
 {
@@ -138,6 +147,11 @@ struct cxl_nvdimm_bridge *__devm_cxl_add_nvdimm_bridge(struct device *host,
 	if (rc)
 		goto err;
 
+	if (cxl_nvdimm_bridge_failed_attach(cxl_nvb)) {
+		unregister_nvb(cxl_nvb);
+		return ERR_PTR(-ENODEV);
+	}
+
 	rc = devm_add_action_or_reset(host, unregister_nvb, cxl_nvb);
 	if (rc)
 		return ERR_PTR(rc);
@@ -247,6 +261,21 @@ int devm_cxl_add_nvdimm(struct cxl_port *parent_port,
 	if (!cxl_nvb)
 		return -ENODEV;
 
+	/*
+	 * Take the uport_dev lock to guard against race of nvdimm_bus object.
+	 * cxl_acpi_probe() registers the nvdimm_bus and is done under the
+	 * root port uport_dev lock.
+	 *
+	 * Take the cxl_nvb device lock to ensure that cxl_nvb driver is in a
+	 * consistent state. And the driver registers nvdimm_bus.
+	 */
+	guard(device)(cxl_nvb->port->uport_dev);
+	guard(device)(&cxl_nvb->dev);
+	if (!cxl_nvb->nvdimm_bus) {
+		rc = -ENODEV;
+		goto err_alloc;
+	}
+
 	cxl_nvd = cxl_nvdimm_alloc(cxl_nvb, cxlmd);
 	if (IS_ERR(cxl_nvd)) {
 		rc = PTR_ERR(cxl_nvd);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 2854e47fd9869..e477cd72d3000 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -563,11 +563,16 @@ struct cxl_nvdimm_bridge {
 
 #define CXL_DEV_ID_LEN 19
 
+enum {
+	CXL_NVD_F_INVALIDATED = 0,
+};
+
 struct cxl_nvdimm {
 	struct device dev;
 	struct cxl_memdev *cxlmd;
 	u8 dev_id[CXL_DEV_ID_LEN]; /* for nvdimm, string of 'serial' */
 	u64 dirty_shutdowns;
+	unsigned long flags;
 };
 
 struct cxl_pmem_region_mapping {
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 714beaf1704be..c00b84b960761 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -14,7 +14,7 @@
 static __read_mostly DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
 
 /**
- * __devm_cxl_add_nvdimm_bridge() - add the root of a LIBNVDIMM topology
+ * devm_cxl_add_nvdimm_bridge() - add the root of a LIBNVDIMM topology
  * @host: platform firmware root device
  * @port: CXL port at the root of a CXL topology
  *
@@ -143,6 +143,9 @@ static int cxl_nvdimm_probe(struct device *dev)
 	struct nvdimm *nvdimm;
 	int rc;
 
+	if (test_bit(CXL_NVD_F_INVALIDATED, &cxl_nvd->flags))
+		return -EBUSY;
+
 	set_exclusive_cxl_commands(mds, exclusive_cmds);
 	rc = devm_add_action_or_reset(dev, clear_exclusive, mds);
 	if (rc)
@@ -323,8 +326,10 @@ static int detach_nvdimm(struct device *dev, void *data)
 	scoped_guard(device, dev) {
 		if (dev->driver) {
 			cxl_nvd = to_cxl_nvdimm(dev);
-			if (cxl_nvd->cxlmd && cxl_nvd->cxlmd->cxl_nvb == data)
+			if (cxl_nvd->cxlmd && cxl_nvd->cxlmd->cxl_nvb == data) {
 				release = true;
+				set_bit(CXL_NVD_F_INVALIDATED, &cxl_nvd->flags);
+			}
 		}
 	}
 	if (release)
@@ -367,6 +372,7 @@ static struct cxl_driver cxl_nvdimm_bridge_driver = {
 	.probe = cxl_nvdimm_bridge_probe,
 	.id = CXL_DEVICE_NVDIMM_BRIDGE,
 	.drv = {
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 		.suppress_bind_attrs = true,
 	},
 };
-- 
2.51.0

