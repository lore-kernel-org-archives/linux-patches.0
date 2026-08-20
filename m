Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA323D8116;
	Thu, 20 Aug 2026 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239358; cv=none; b=hd+ukh8BpT4gjpkib7n0m9Vc+/45gGHmGDsj7gKrY2DdTz2vRNiNpB0izmyAtEKBTLiE13FDob/ZYZsUig13HAPLIvrKBMLahenoRqCPLvNa7/3y64IMfJIzkbu3LbCDC+/EgZXwxjtmLjaq4pCU08/yimVOW0id7OsZ0oPgp7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239358; c=relaxed/simple;
	bh=FOJKzVosmoFMMsdhrXPrUuo1wRsoFdLlTEuCCHdT7Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItydtM9MtHblnbsQf1pBUycF0+hsgGXZphce8ynqQL72/GVy6gqGaZymf6lRaFOfixcznujE+4MWjbXVZm9c9iMPDUglTzuvr4Ug5ZTqOXrr8NW2rfLU34MShVZ7bEa+4UOarfmHqELFHiX6tuLqGMkivymnbvKACiTHvhb5r3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSKM8158; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSKM8158"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CA71F00A3A;
	Thu, 20 Aug 2026 15:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239357;
	bh=pZlHPXE2t8zSqKeo4OtEBa6A9drsZu51GsY2h/W/Pbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSKM81587Syo0BTCy51L4raFR6Vn+dAJOHUOZYZ4hqfA/dI/Ov3JtRfk+pAnpvdU+
	 tHZ0AuFbVCqXdBUNwrp2E8U8KDxtfeQ48y3+9GnDcBzEdAG2OSG3ALS4IRvyAUK0Kg
	 wQ4Rl+WoV44jRDa2x0PWdM9JqU6s7XURtsRUA684=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/220] crypto: ccp: Add external API interface for PSP module initialization
Date: Thu, 20 Aug 2026 16:53:24 +0200
Message-ID: <20260820145223.924879876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 435b344a7042e91fb4719d589f18310e8919e39f ]

KVM is dependent on the PSP SEV driver and PSP SEV driver needs to be
loaded before KVM module. In case of module loading any dependent
modules are automatically loaded but in case of built-in modules there
is no inherent mechanism available to specify dependencies between
modules and ensure that any dependent modules are loaded implicitly.

Add a new external API interface for PSP module initialization which
allows PSP SEV driver to be loaded explicitly if KVM is built-in.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <15279ca0cad56a07cf12834ec544310f85ff5edc.1739226950.git.ashish.kalra@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-dev.c | 14 ++++++++++++++
 include/linux/psp-sev.h     |  9 +++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index ccbe009ad6e58..f204aa5df96e2 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/ccp.h>
 
+#include "sev-dev.h"
 #include "ccp-dev.h"
 #include "sp-dev.h"
 
@@ -265,8 +266,12 @@ struct sp_device *sp_get_psp_master_device(void)
 static int __init sp_mod_init(void)
 {
 #ifdef CONFIG_X86
+	static bool initialized;
 	int ret;
 
+	if (initialized)
+		return 0;
+
 	ret = sp_pci_init();
 	if (ret)
 		return ret;
@@ -275,6 +280,8 @@ static int __init sp_mod_init(void)
 	psp_pci_init();
 #endif
 
+	initialized = true;
+
 	return 0;
 #endif
 
@@ -291,6 +298,13 @@ static int __init sp_mod_init(void)
 	return -ENODEV;
 }
 
+#if IS_BUILTIN(CONFIG_KVM_AMD) && IS_ENABLED(CONFIG_KVM_AMD_SEV)
+int __init sev_module_init(void)
+{
+	return sp_mod_init();
+}
+#endif
+
 static void __exit sp_mod_exit(void)
 {
 #ifdef CONFIG_X86
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 6a4435cfa977e..0f5f94137f6da 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -816,6 +816,15 @@ struct sev_data_snp_commit {
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
+/**
+ * sev_module_init - perform PSP SEV module initialization
+ *
+ * Returns:
+ * 0 if the PSP module is successfully initialized
+ * negative value if the PSP module initialization fails
+ */
+int sev_module_init(void);
+
 /**
  * sev_platform_init - perform SEV INIT command
  *
-- 
2.53.0



