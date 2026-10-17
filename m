Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C226370ACE;
	Sat, 17 Oct 2026 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253371; cv=none; b=gNZMOHYNTNGG0zD7oIWQVgrNz1CUQQ6NMSME5gxHFu0f3OtfkJuWE3WERWhMTv7bcD+FSO/QBDtoyFkVsd2U12GMD2nBYiaAkz+l9zRQuIH7LC96aHx5Q1w7Vd8et9DatncLwxcLFydQNMnUktSv0B2p7+35XyH/rhqAv589uM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253371; c=relaxed/simple;
	bh=el4/Si9vcVmxaTXPzq2hXsyL2p8xZeWvalcH4XGsq/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fsB3Vw/TPWP40/nUZ+H8DoFE2ttFh7ov0KMrRpp/j/Jw4OPkDoFbZjqcUAOfon0zlsbBBF7ja44bzeTCvv3gBe2d8hrazV5cWv4U/juMEldQUN1IqUzb0SdGmv5PMq4WorvtxAEEuG2m6PfUVCFYL0oUBoqbd4v9KksfS1EMtE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G48iYLSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G48iYLSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42951F000C4;
	Sat, 17 Oct 2026 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253370;
	bh=W+msq27S+S7NQreixuYCSpgkI7K2JaDwUrlNdGuvyoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G48iYLSo7gVmWWdsr2127TOQql5NGU7/nK63o5Z1X256hsMyO5mnX36EGV7Cr6Kki
	 tGxdFMTgZbUnoq36SIkEoMb8tr4fR3ui6GRC34zkMsqQzec8467MwQecpOgLPO2vE2
	 EJvXVonPWg1W76C9CgP6AxB+LAE1qzwd1qTV/JCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/869] platform/x86/amd/pmf: Switch to platform_get_resource() and devm_ioremap_resource()
Date: Sat, 17 Oct 2026 17:48:56 +0200
Message-ID: <20261017160039.473262145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit ba6ad33d5c870d8b1d22388292c872ba4af98ea1 ]

Use platform_get_resource() to fetch the memory resource instead of
acpi_walk_resources() and devm_ioremap_resource() for mapping the
resources.

PS: We cannot use resource_size() here because it adds an extra byte to
round off the size. In the case of PMF ResourceTemplate(), this rounding
is already handled within the _CRS. Using resource_size() would increase
the resource size by 1, causing a mismatch with the length field and
leading to issues. Therefore, simply use end-start of the ACPI resource to
obtain the actual length.

Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20241104054829.620858-4-Shyam-sundar.S-k@amd.com
[ij: added a cast to resource_size_t printing]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

Keep the existing staged error unwinding after a policy mapping failure.
Also carry the callback mutex storage and its initialization and
destruction so the follow-up device-managed allocation conversion
applies cleanly without importing custom BIOS input support.

Stable-dep-of: d9db3a941270 ("platform/x86/amd: pmf: Use device managed allocations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/Kconfig  |  1 +
 drivers/platform/x86/amd/pmf/acpi.c   | 46 +++++++++++----------------
 drivers/platform/x86/amd/pmf/core.c   |  2 ++
 drivers/platform/x86/amd/pmf/pmf.h    |  7 ++--
 drivers/platform/x86/amd/pmf/tee-if.c |  8 ++---
 5 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/Kconfig b/drivers/platform/x86/amd/pmf/Kconfig
index f4fa8bd8bda83..99d67cdbd91e5 100644
--- a/drivers/platform/x86/amd/pmf/Kconfig
+++ b/drivers/platform/x86/amd/pmf/Kconfig
@@ -11,6 +11,7 @@ config AMD_PMF
 	select ACPI_PLATFORM_PROFILE
 	depends on TEE && AMDTEE
 	depends on AMD_SFH_HID
+	depends on HAS_IOMEM
 	help
 	  This driver provides support for the AMD Platform Management Framework.
 	  The goal is to enhance end user experience by making AMD PCs smarter,
diff --git a/drivers/platform/x86/amd/pmf/acpi.c b/drivers/platform/x86/amd/pmf/acpi.c
index d5b496433d697..1b9c7acf0ddf5 100644
--- a/drivers/platform/x86/amd/pmf/acpi.c
+++ b/drivers/platform/x86/amd/pmf/acpi.c
@@ -433,37 +433,29 @@ int apmf_install_handler(struct amd_pmf_dev *pmf_dev)
 	return 0;
 }
 
-static acpi_status apmf_walk_resources(struct acpi_resource *res, void *data)
+int apmf_check_smart_pc(struct amd_pmf_dev *pmf_dev)
 {
-	struct amd_pmf_dev *dev = data;
+	struct platform_device *pdev = to_platform_device(pmf_dev->dev);
 
-	switch (res->type) {
-	case ACPI_RESOURCE_TYPE_ADDRESS64:
-		dev->policy_addr = res->data.address64.address.minimum;
-		dev->policy_sz = res->data.address64.address.address_length;
-		break;
-	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-		dev->policy_addr = res->data.fixed_memory32.address;
-		dev->policy_sz = res->data.fixed_memory32.address_length;
-		break;
-	}
-
-	if (!dev->policy_addr || dev->policy_sz > POLICY_BUF_MAX_SZ || dev->policy_sz == 0) {
-		pr_err("Incorrect Policy params, possibly a SBIOS bug\n");
-		return AE_ERROR;
+	pmf_dev->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!pmf_dev->res) {
+		dev_dbg(pmf_dev->dev, "Failed to get I/O memory resource\n");
+		return -EINVAL;
 	}
 
-	return AE_OK;
-}
-
-int apmf_check_smart_pc(struct amd_pmf_dev *pmf_dev)
-{
-	acpi_handle ahandle = ACPI_HANDLE(pmf_dev->dev);
-	acpi_status status;
-
-	status = acpi_walk_resources(ahandle, METHOD_NAME__CRS, apmf_walk_resources, pmf_dev);
-	if (ACPI_FAILURE(status)) {
-		dev_dbg(pmf_dev->dev, "acpi_walk_resources failed :%d\n", status);
+	pmf_dev->policy_addr = pmf_dev->res->start;
+	/*
+	 * We cannot use resource_size() here because it adds an extra byte to round off the size.
+	 * In the case of PMF ResourceTemplate(), this rounding is already handled within the _CRS.
+	 * Using resource_size() would increase the resource size by 1, causing a mismatch with the
+	 * length field and leading to issues. Therefore, simply use end-start of the ACPI resource
+	 * to obtain the actual length.
+	 */
+	pmf_dev->policy_sz = pmf_dev->res->end - pmf_dev->res->start;
+
+	if (!pmf_dev->policy_addr || pmf_dev->policy_sz > POLICY_BUF_MAX_SZ ||
+	    pmf_dev->policy_sz == 0) {
+		dev_err(pmf_dev->dev, "Incorrect policy params, possibly a SBIOS bug\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index 2e352e475b562..e45a207c7425b 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -530,6 +530,7 @@ static int amd_pmf_probe(struct platform_device *pdev)
 
 	mutex_init(&dev->lock);
 	mutex_init(&dev->update_mutex);
+	mutex_init(&dev->cb_mutex);
 
 	amd_pmf_quirks_init(dev);
 	apmf_acpi_init(dev);
@@ -556,6 +557,7 @@ static void amd_pmf_remove(struct platform_device *pdev)
 	amd_pmf_dbgfs_unregister(dev);
 	mutex_destroy(&dev->lock);
 	mutex_destroy(&dev->update_mutex);
+	mutex_destroy(&dev->cb_mutex);
 	kfree(dev->buf);
 }
 
diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index b857ef4498903..8e9a07a082b78 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -13,6 +13,7 @@
 
 #include <linux/acpi.h>
 #include <linux/input.h>
+#include <linux/platform_device.h>
 #include <linux/platform_profile.h>
 
 #define POLICY_BUF_MAX_SZ		0x4b000
@@ -364,19 +365,21 @@ struct amd_pmf_dev {
 	/* Smart PC solution builder */
 	struct dentry *esbin;
 	unsigned char *policy_buf;
-	u32 policy_sz;
+	resource_size_t policy_sz;
 	struct tee_context *tee_ctx;
 	struct tee_shm *fw_shm_pool;
 	u32 session_id;
 	void *shbuf;
 	struct delayed_work pb_work;
 	struct pmf_action_table *prev_data;
-	u64 policy_addr;
+	resource_size_t policy_addr;
 	void __iomem *policy_base;
 	bool smart_pc_enabled;
 	u16 pmf_if_version;
 	struct input_dev *pmf_idev;
 	size_t mtable_size;
+	struct resource *res;
+	struct mutex cb_mutex;
 };
 
 struct apmf_sps_prop_granular_v2 {
diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index 6254423d05b06..0ddd76149425a 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -256,7 +256,7 @@ static int amd_pmf_invoke_cmd_init(struct amd_pmf_dev *dev)
 		return -ENODEV;
 	}
 
-	dev_dbg(dev->dev, "Policy Binary size: %u bytes\n", dev->policy_sz);
+	dev_dbg(dev->dev, "Policy Binary size: %llu bytes\n", (unsigned long long)dev->policy_sz);
 	memset(dev->shbuf, 0, dev->policy_sz);
 	ta_sm = dev->shbuf;
 	in = &ta_sm->pmf_input.init_table;
@@ -528,9 +528,9 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 	if (ret)
 		goto err_cancel_work;
 
-	dev->policy_base = devm_ioremap(dev->dev, dev->policy_addr, dev->policy_sz);
-	if (!dev->policy_base) {
-		ret = -ENOMEM;
+	dev->policy_base = devm_ioremap_resource(dev->dev, dev->res);
+	if (IS_ERR(dev->policy_base)) {
+		ret = PTR_ERR(dev->policy_base);
 		goto err_free_dram_buf;
 	}
 
-- 
2.53.0



