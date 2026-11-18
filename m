Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015623;
	b=Hp8s/zffgHkxHNd4QXcroG6WV/V0IDU+Zxse+gQiFYZmGYxri81sMPGPc6Qnet38tnXg
	 LcHrejS7rHKsLNo8RlY6f1R5UvrQsP7eirCheIa5dLeV9wbHGZlaf/aF9UzDxv8VHNfVv
	 ZCpkb9kVWeHDV+MVbH5Y/kSjfD4zTcp3jRhUYpygLudt6H/lF/A0JBy/NyeICsh9lX6Vy
	 rZS8aKeHA/LJKI+oGTM74ZzcFYjobrAue1ep1DV2a9CGjjxpV5orDnrBrzXoByEhvU5MS
	 Si9NmO5X5uJbRb4F704gtbTJq6M4LYngjpyC6SM/EkRPS95cLa4Whp4Lep8E/pRUMJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DrUCWUpdcMsdsGHbTeHW8BWxR4Wdr9NSLscbmqn3vJU=;
	b=P2qG9Ko7XcSR6KrLQuYHffISA/C5p+6NukcYQ6cHhd7PsyMjzNP50Z2nGC4GMlLOhkV1
	 QEcidKoL8AfXQwioWjgWjYEEcLOpRPz9F1mxwoXT+n8R1N0peVCPOa5N6Fw8kd5ZNYBZZ
	 7JY/pDzmDwAijQgrkqZGdHAWF7DSc/eGRQ80Cpg6Hw1Df6IVfq4H2e+VT3AZExyX3o+TN
	 CFc+JdsGL1X6XX7eIO4wb6Eoflr1ZtCKCOtNj5KuC45dk0yVlB0otB7dVUL1EdG1brpdc
	 NfRtAZhknO20JJpj25aASY0SgsC3wJKuLJMPj7QtgXJxl+eBf9vB4ylP2dWZj98oORw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAsaBP5h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120B660A2607;
	Wed, 18 Nov 2026 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAsaBP5h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661AC1F000CB;
	Wed, 18 Nov 2026 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015622;
	bh=DrUCWUpdcMsdsGHbTeHW8BWxR4Wdr9NSLscbmqn3vJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAsaBP5hRcjNTmdo2PGXO+d4onENTVwPtA4dQmnB0E4owYPMvCxppisehkQiaO5ui
	 5cTrTAWuYbU/gGtUhOQahM0YNuTjejdC53nti1EccXdLDQ71ovIWKg46iz8hHSn6E1
	 mNs0y6QHfF5c6kG8aUn2jspioOgk1Tav4rhN5WAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0238/2651] ACPI: extlog: Defer CXL protocol error handling to avoid lock inversion
Date: Wed, 18 Nov 2026 15:24:38 +0100
Message-ID: <20261118150256.430560684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 179ef6d7f971d72a0f54b7c499daed1b244ee1a5 ]

extlog_print() calls cxl_cper_handle_prot_err() synchronously while the
MCE notifier chain rwsem is held, and that path takes the PCI device_lock
via guard(device)(). The probe path takes the two in the opposite order,
holding device_lock while mce_register_decode_chain() takes the rwsem, so
they can deadlock AB-BA.

ghes.c already avoids this by posting protocol errors to a kfifo and
handling them from a workqueue via cxl_cper_post_prot_err(). Export that
function and call it instead.

Declare it with the other CONFIG_ACPI_APEI_GHES exports rather than at the
end of the header. No #else stub: ACPI_EXTLOG selects ACPI_APEI_GHES, so
the only caller cannot exist without it.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-cxl/20260709165457.8BA181F000E9@smtp.kernel.org/
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-5-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 8bf58815315a ("ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 21 ++-------------------
 drivers/acpi/apei/ghes.c   |  5 +++--
 include/acpi/ghes.h        |  4 ++++
 3 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 4f78a3201c1b6..8c17c2719526e 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -183,23 +183,6 @@ static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 #endif
 }
 
-static void
-extlog_cxl_cper_handle_prot_err(struct cxl_cper_sec_prot_err *prot_err,
-				int severity)
-{
-#ifdef ACPI_APEI_PCIEAER
-	struct cxl_cper_prot_err_work_data wd;
-
-	if (cxl_cper_sec_prot_err_valid(prot_err))
-		return;
-
-	if (cxl_cper_setup_prot_err_work_data(&wd, prot_err, severity))
-		return;
-
-	cxl_cper_handle_prot_err(&wd);
-#endif
-}
-
 static int extlog_print(struct notifier_block *nb, unsigned long val,
 			void *data)
 {
@@ -264,8 +247,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 			struct cxl_cper_sec_prot_err *prot_err =
 				acpi_hest_get_payload(gdata);
 
-			extlog_cxl_cper_handle_prot_err(prot_err,
-							gdata->error_severity);
+			cxl_cper_post_prot_err(prot_err,
+					       gdata->error_severity);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index cf38adc60d688..96fdfb5830609 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -752,8 +752,8 @@ static DEFINE_KFIFO(cxl_cper_prot_err_fifo, struct cxl_cper_prot_err_work_data,
 static DEFINE_RAW_SPINLOCK(cxl_cper_prot_err_work_lock);
 struct work_struct *cxl_cper_prot_err_work;
 
-static void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
-				   int severity)
+void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
+			    int severity)
 {
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 	struct cxl_cper_prot_err_work_data wd;
@@ -777,6 +777,7 @@ static void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
 	schedule_work(cxl_cper_prot_err_work);
 #endif
 }
+EXPORT_SYMBOL_FOR_MODULES(cxl_cper_post_prot_err, "acpi_extlog");
 
 void cxl_cper_register_prot_err_work(struct work_struct *work)
 {
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 8d7e5caef3f18..be496bc0386fc 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -85,6 +85,10 @@ int devm_ghes_register_vendor_record_notifier(struct device *dev,
 struct list_head *ghes_get_devices(void);
 
 void ghes_estatus_pool_region_free(unsigned long addr, u32 size);
+
+struct cxl_cper_sec_prot_err;
+void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
+			    int severity);
 #else
 static inline struct list_head *ghes_get_devices(void) { return NULL; }
 
-- 
2.53.0



