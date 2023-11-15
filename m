Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C2841A80
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Tjo/5tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BC1C433CA;
	Wed, 15 Nov 2023 19:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076888;
	bh=VQkd+TX1bkYUuhxMN2kv3kuKOMlOxogJ04UkM6AOVr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Tjo/5tpmR/HWzsmewne0/jyYCnL590TonbreD+s8gjD3rYFcM+ARpenS5YkBudGF
	 6s5vMlaqFro5v1AsXY4EeExsZTYvx0xrMMnWnyxq+tgyxq3vvQ/0wkcoLPGlLi8+Od
	 Ef/BogaU+iGUiyv5iSDZxemdHPMuAiOK6zNQKSDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 454/550] cxl/pci: Clarify devm host for memdev relative setup
Date: Wed, 15 Nov 2023 14:17:18 -0500
Message-ID: <20231115191632.312253554@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit f29a824b0b6710328a78b018de3c2cfa9db65876 ]

It is all too easy to get confused about @dev usage in the CXL driver
stack. Before adding a new cxl_pci_probe() setup operation that has a
devm lifetime dependent on @cxlds->dev binding, but also references
@cxlmd->dev, and prints messages, rework the devm_cxl_add_memdev() and
cxl_memdev_setup_fw_upload() function signatures to make this
distinction explicit. I.e. pass in the devm context as an @host argument
rather than infer it from other objects.

This is in preparation for adding a devm_cxl_sanitize_setup_notifier().

Note the whitespace fixup near the change of the devm_cxl_add_memdev()
signature. That uncaught typo originated in the patch that added
cxl_memdev_security_init().

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 5f2da1971446 ("cxl/pci: Fix sanitize notifier setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/memdev.c    | 16 ++++++++--------
 drivers/cxl/cxlmem.h         |  5 +++--
 drivers/cxl/pci.c            |  4 ++--
 tools/testing/cxl/test/mem.c |  4 ++--
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 6efe4e2a2cf53..63353d9903745 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -960,12 +960,12 @@ static const struct fw_upload_ops cxl_memdev_fw_ops = {
         .cleanup = cxl_fw_cleanup,
 };
 
-static void devm_cxl_remove_fw_upload(void *fwl)
+static void cxl_remove_fw_upload(void *fwl)
 {
 	firmware_upload_unregister(fwl);
 }
 
-int cxl_memdev_setup_fw_upload(struct cxl_memdev_state *mds)
+int devm_cxl_setup_fw_upload(struct device *host, struct cxl_memdev_state *mds)
 {
 	struct cxl_dev_state *cxlds = &mds->cxlds;
 	struct device *dev = &cxlds->cxlmd->dev;
@@ -978,10 +978,9 @@ int cxl_memdev_setup_fw_upload(struct cxl_memdev_state *mds)
 				       &cxl_memdev_fw_ops, mds);
 	if (IS_ERR(fwl))
 		return PTR_ERR(fwl);
-
-	return devm_add_action_or_reset(cxlds->dev, devm_cxl_remove_fw_upload, fwl);
+	return devm_add_action_or_reset(host, cxl_remove_fw_upload, fwl);
 }
-EXPORT_SYMBOL_NS_GPL(cxl_memdev_setup_fw_upload, CXL);
+EXPORT_SYMBOL_NS_GPL(devm_cxl_setup_fw_upload, CXL);
 
 static const struct file_operations cxl_memdev_fops = {
 	.owner = THIS_MODULE,
@@ -1019,9 +1018,10 @@ static int cxl_memdev_security_init(struct cxl_memdev *cxlmd)
 	}
 
 	return devm_add_action_or_reset(cxlds->dev, put_sanitize, mds);
- }
+}
 
-struct cxl_memdev *devm_cxl_add_memdev(struct cxl_dev_state *cxlds)
+struct cxl_memdev *devm_cxl_add_memdev(struct device *host,
+				       struct cxl_dev_state *cxlds)
 {
 	struct cxl_memdev *cxlmd;
 	struct device *dev;
@@ -1053,7 +1053,7 @@ struct cxl_memdev *devm_cxl_add_memdev(struct cxl_dev_state *cxlds)
 	if (rc)
 		goto err;
 
-	rc = devm_add_action_or_reset(cxlds->dev, cxl_memdev_unregister, cxlmd);
+	rc = devm_add_action_or_reset(host, cxl_memdev_unregister, cxlmd);
 	if (rc)
 		return ERR_PTR(rc);
 	return cxlmd;
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 55f00ad17a772..fdb2c8dd98d0f 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -84,9 +84,10 @@ static inline bool is_cxl_endpoint(struct cxl_port *port)
 	return is_cxl_memdev(port->uport_dev);
 }
 
-struct cxl_memdev *devm_cxl_add_memdev(struct cxl_dev_state *cxlds);
+struct cxl_memdev *devm_cxl_add_memdev(struct device *host,
+				       struct cxl_dev_state *cxlds);
 struct cxl_memdev_state;
-int cxl_memdev_setup_fw_upload(struct cxl_memdev_state *mds);
+int devm_cxl_setup_fw_upload(struct device *host, struct cxl_memdev_state *mds);
 int devm_cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 			 resource_size_t base, resource_size_t len,
 			 resource_size_t skipped);
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 0ffa62088c6d2..5b22460c51c62 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -868,11 +868,11 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	cxlmd = devm_cxl_add_memdev(cxlds);
+	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlds);
 	if (IS_ERR(cxlmd))
 		return PTR_ERR(cxlmd);
 
-	rc = cxl_memdev_setup_fw_upload(mds);
+	rc = devm_cxl_setup_fw_upload(&pdev->dev, mds);
 	if (rc)
 		return rc;
 
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 464fc39ed2776..68118c37f0b56 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1450,11 +1450,11 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	mdata->mes.mds = mds;
 	cxl_mock_add_event_logs(&mdata->mes);
 
-	cxlmd = devm_cxl_add_memdev(cxlds);
+	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlds);
 	if (IS_ERR(cxlmd))
 		return PTR_ERR(cxlmd);
 
-	rc = cxl_memdev_setup_fw_upload(mds);
+	rc = devm_cxl_setup_fw_upload(&pdev->dev, mds);
 	if (rc)
 		return rc;
 
-- 
2.42.0



