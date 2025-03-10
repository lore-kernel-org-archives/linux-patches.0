Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4E4BA3D;
	Mon, 10 Mar 2025 18:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630894; cv=none; b=f8ARnXNVpLCVvlj2yVY1cCbcsyBU7q4HdxlRezr3nWvPAXJdDk/fAASKxEExZLy35XwOqdCk7a0/asYYb+C6xYcNilNSzfXI6eM3SSPSIG89ZAi0/OVHQVaEvZd3sqmZdbUpDSsfMQD2Ximcg8TOdaFxKbX5pu18oYQYPjV1WE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630894; c=relaxed/simple;
	bh=4Az6KDQL25Psxn9PVk4tvesWybbgChUUFbtt7ReIYMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0nd3WleKtxpOeRh9zSSEltvKdNJvAXlaxTDXTeMYOYUyiZqqro/oaQ2o8W8oQWNz0nCtsIm7n9lTUUaiL1PJ9Kfa2Cz6VBrdgVHCu/C2K2o1G+GiSvTQ3LZNdZeQZDDQohwT0yyULXjul4hvA4LHK6JGv30qJUKf6nmitjWdGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHmnzTNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHmnzTNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B2FC4CEE5;
	Mon, 10 Mar 2025 18:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630894;
	bh=4Az6KDQL25Psxn9PVk4tvesWybbgChUUFbtt7ReIYMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHmnzTNW4xShvZzZWJD/pVxLLeCz0F6WCx6rXP5tNM5xHKxD+f+YbQ5bX//B1w+tg
	 u+HTa1cgHywrArQlB821YMxrN5m5AIZFMwBPB+4T8JQ+7kRJy+XtLEqwwQouwhghBZ
	 LExxvdnuCVdUdm0HNwKWMm8pjC0f90BIm31vcpIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haitao Huang <haitao.huang@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 572/620] x86/sgx: Support VA page allocation without reclaiming
Date: Mon, 10 Mar 2025 18:06:58 +0100
Message-ID: <20250310170608.120451529@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit a76e7f1f18884a94998ca82862c0a4e6d0fd2933 ]

struct sgx_encl should be protected with the mutex
sgx_encl->lock. One exception is sgx_encl->page_cnt that
is incremented (in sgx_encl_grow()) when an enclave page
is added to the enclave. The reason the mutex is not held
is to allow the reclaimer to be called directly if there are
no EPC pages (in support of a new VA page) available at the time.

Incrementing sgx_encl->page_cnt without sgc_encl->lock held
is currently (before SGX2) safe from concurrent updates because
all paths in which sgx_encl_grow() is called occur before
enclave initialization and are protected with an atomic
operation on SGX_ENCL_IOCTL.

SGX2 includes support for dynamically adding pages after
enclave initialization where the protection of SGX_ENCL_IOCTL
is not available.

Make direct reclaim of EPC pages optional when new VA pages
are added to the enclave. Essentially the existing "reclaim"
flag used when regular EPC pages are added to an enclave
becomes available to the caller when used to allocate VA pages
instead of always being "true".

When adding pages without invoking the reclaimer it is possible
to do so with sgx_encl->lock held, gaining its protection against
concurrent updates to sgx_encl->page_cnt after enclave
initialization.

No functional change.

Reported-by: Haitao Huang <haitao.huang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lkml.kernel.org/r/42c5934c229982ee67982bb97c6ab34bde758620.1652137848.git.reinette.chatre@intel.com
Stable-dep-of: 0d3e0dfd68fb ("x86/sgx: Fix size overflows in sgx_encl_create()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 6 ++++--
 arch/x86/kernel/cpu/sgx/encl.h  | 4 ++--
 arch/x86/kernel/cpu/sgx/ioctl.c | 8 ++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7cb9f89ee7365..2e93bafa7c475 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -981,6 +981,8 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
 
 /**
  * sgx_alloc_va_page() - Allocate a Version Array (VA) page
+ * @reclaim: Reclaim EPC pages directly if none available. Enclave
+ *           mutex should not be held if this is set.
  *
  * Allocate a free EPC page and convert it to a Version Array (VA) page.
  *
@@ -988,12 +990,12 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
  *   a VA page,
  *   -errno otherwise
  */
-struct sgx_epc_page *sgx_alloc_va_page(void)
+struct sgx_epc_page *sgx_alloc_va_page(bool reclaim)
 {
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_epc_page(NULL, true);
+	epc_page = sgx_alloc_epc_page(NULL, reclaim);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 90e3a1181bd62..b5e9602be127e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -114,14 +114,14 @@ void sgx_encl_put_backing(struct sgx_backing *backing);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr);
-struct sgx_epc_page *sgx_alloc_va_page(void);
+struct sgx_epc_page *sgx_alloc_va_page(bool reclaim);
 unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
 void sgx_encl_free_epc_page(struct sgx_epc_page *page);
 struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
-struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl);
+struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
 void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
 
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index f21890150216d..4de31b0b0dd5d 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -17,7 +17,7 @@
 #include "encl.h"
 #include "encls.h"
 
-struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
+struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim)
 {
 	struct sgx_va_page *va_page = NULL;
 	void *err;
@@ -30,7 +30,7 @@ struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 		if (!va_page)
 			return ERR_PTR(-ENOMEM);
 
-		va_page->epc_page = sgx_alloc_va_page();
+		va_page->epc_page = sgx_alloc_va_page(reclaim);
 		if (IS_ERR(va_page->epc_page)) {
 			err = ERR_CAST(va_page->epc_page);
 			kfree(va_page);
@@ -64,7 +64,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct file *backing;
 	long ret;
 
-	va_page = sgx_encl_grow(encl);
+	va_page = sgx_encl_grow(encl, true);
 	if (IS_ERR(va_page))
 		return PTR_ERR(va_page);
 	else if (va_page)
@@ -306,7 +306,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 		return PTR_ERR(epc_page);
 	}
 
-	va_page = sgx_encl_grow(encl);
+	va_page = sgx_encl_grow(encl, true);
 	if (IS_ERR(va_page)) {
 		ret = PTR_ERR(va_page);
 		goto err_out_free;
-- 
2.39.5



