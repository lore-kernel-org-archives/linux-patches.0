Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3066C1DB520;
	Wed,  6 Nov 2024 12:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897162; cv=none; b=fRFa7SPC1y6NUtzx/ZSE7uC/LbtG5/VhzqZDaxTyxfXPRA6wpe/eqPJmJ9dnjhPYIF1YTpl/FewLcDwsdL/IwI8trTCovok6b5QBYk1E48XRF4BhRuQyKXIv4QkZhJY8MN21qq1ASKRCnEFMVQVRw9YtYP61dU5U5cRw4dcqz5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897162; c=relaxed/simple;
	bh=tdERx2KfG9hyPVxEbBoFmwFfiFDoh74AiH2wkTTWV38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs60fCxLsL25Gr8wC2L7SZgdIs4JnXVsx6chVGCpw7T5zwNDc+S9HCC+0PH3XcZC/Ul/N3ZiZmJ5Njh2aLMSXHP7bfQHeMCM597xaET6sOANqiM0TayKkCS9t9aehTBavoRovxZwcDQX0InXR/v0DRe5emd/6iTXTC3trGa0yg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4lK34Jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4lK34Jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F65C4CECD;
	Wed,  6 Nov 2024 12:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897162;
	bh=tdERx2KfG9hyPVxEbBoFmwFfiFDoh74AiH2wkTTWV38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4lK34Jq29tOfpCTfY5S+Je8p6w450Ivn3j14Xc8mPzUn+ilzQpB0J0v2Z/EtsgZD
	 RGBrv6FdkgVBlZ7lxF/fsEhq3ixLiIyWVYls+TpTgP+mPUu55MDcQaSgi2Sdsf7Lnx
	 RGiefTUVAPgl2NjvRm/uAvFq/2nbNVjBB9RPNWG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/126] cxl/acpi: Move rescan to the workqueue
Date: Wed,  6 Nov 2024 13:04:49 +0100
Message-ID: <20241106120308.451385062@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 4029c32fb601d505dfb92bdf0db9fdcc41fe1434 ]

Now that the cxl_mem driver has a need to take the root device lock, the
cxl_bus_rescan() needs to run outside of the root lock context. That
need arises from RCH topologies and the locking that the cxl_mem driver
does to attach a descendant to an upstream port. In the RCH case the
lock needed is the CXL root device lock [1].

Link: http://lore.kernel.org/r/166993045621.1882361.1730100141527044744.stgit@dwillia2-xfh.jf.intel.com [1]
Tested-by: Robert Richter <rrichter@amd.com>
Link: http://lore.kernel.org/r/166993042884.1882361.5633723613683058881.stgit@dwillia2-xfh.jf.intel.com
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 3d6ebf16438d ("cxl/port: Fix cxl_bus_rescan() vs bus_rescan_devices()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c      | 17 +++++++++++++++--
 drivers/cxl/core/port.c | 19 +++++++++++++++++--
 drivers/cxl/cxl.h       |  3 ++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index dd610556a3afa..d7d789211c173 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -509,7 +509,8 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 		return rc;
 
 	/* In case PCI is scanned before ACPI re-trigger memdev attach */
-	return cxl_bus_rescan();
+	cxl_bus_rescan();
+	return 0;
 }
 
 static const struct acpi_device_id cxl_acpi_ids[] = {
@@ -533,7 +534,19 @@ static struct platform_driver cxl_acpi_driver = {
 	.id_table = cxl_test_ids,
 };
 
-module_platform_driver(cxl_acpi_driver);
+static int __init cxl_acpi_init(void)
+{
+	return platform_driver_register(&cxl_acpi_driver);
+}
+
+static void __exit cxl_acpi_exit(void)
+{
+	platform_driver_unregister(&cxl_acpi_driver);
+	cxl_bus_drain();
+}
+
+module_init(cxl_acpi_init);
+module_exit(cxl_acpi_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_IMPORT_NS(CXL);
 MODULE_IMPORT_NS(ACPI);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 1f1483a9e5252..f0875fa86c616 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1786,12 +1786,27 @@ static void cxl_bus_remove(struct device *dev)
 
 static struct workqueue_struct *cxl_bus_wq;
 
-int cxl_bus_rescan(void)
+static void cxl_bus_rescan_queue(struct work_struct *w)
 {
-	return bus_rescan_devices(&cxl_bus_type);
+	int rc = bus_rescan_devices(&cxl_bus_type);
+
+	pr_debug("CXL bus rescan result: %d\n", rc);
+}
+
+void cxl_bus_rescan(void)
+{
+	static DECLARE_WORK(rescan_work, cxl_bus_rescan_queue);
+
+	queue_work(cxl_bus_wq, &rescan_work);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_bus_rescan, CXL);
 
+void cxl_bus_drain(void)
+{
+	drain_workqueue(cxl_bus_wq);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_bus_drain, CXL);
+
 bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
 {
 	return queue_work(cxl_bus_wq, &cxlmd->detach_work);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 7750ccb7652db..827fa94cddda1 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -564,7 +564,8 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   struct cxl_dport *parent_dport);
 struct cxl_port *find_cxl_root(struct device *dev);
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
-int cxl_bus_rescan(void);
+void cxl_bus_rescan(void);
+void cxl_bus_drain(void);
 struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd,
 				   struct cxl_dport **dport);
 bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd);
-- 
2.43.0



