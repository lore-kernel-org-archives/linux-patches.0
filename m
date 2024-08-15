Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DF318D630;
	Thu, 15 Aug 2024 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729412; cv=none; b=QG1LDN+/5xw2PjTE5TvIZdkCcmayIRd7dSBbHY6/t8bDXfoTVpLFGJlWsanflhF3SsXo7cGYko0iWga7Pi8EtPDVhcPQoJ16Q575vvqrL2XYTtk/BPN4ueSHDc4OcMbReb+RYHOFpvFRTwIlR+c72zdWuJjA6ZoE7h0eceBstVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729412; c=relaxed/simple;
	bh=19e2Nx0lmxkcwl1SpbdTrZqs9RqC9OkykX22rh+XfBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6VfzDclnnliQDo1jFUUi03h8TOnU7wVpB4kylpYC/ageV58AYsgsVLy3rUVHcF1M0e7o4YOdOBDYuGkz4UaeiGq1nPvf/vMSlfBBrnA9pBUkQveWLQsi4vmY9hAufL3VPEb+RsxFfglYVj3hQiqYzW2Ald3dO7oBfS+am8bmKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXgS0BFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXgS0BFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA3AC4AF0F;
	Thu, 15 Aug 2024 13:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729412;
	bh=19e2Nx0lmxkcwl1SpbdTrZqs9RqC9OkykX22rh+XfBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXgS0BFu5HuOUwKGX+akCJxuhx7pwqE2rEbdKJ18XfmXWJ+jGCeo0xkhDmDGXmGAN
	 M9TZTj8afkfO/SfB+NJWduLnfUMKskmuH7QZUlRsviOunWu/CJ9EYSZnF2I0j8BoVa
	 KqkZ0bb2RAB0ioNUHwdPneb8PEErSq2pZ0u2KEp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/484] KVM: s390: pv: properly handle page flags for protected guests
Date: Thu, 15 Aug 2024 15:19:07 +0200
Message-ID: <20240815131944.724687374@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 380d97bd02fca7b9b41aec2d1c767874d602bc78 ]

Introduce variants of the convert and destroy page functions that also
clear the PG_arch_1 bit used to mark them as secure pages.

The PG_arch_1 flag is always allowed to overindicate; using the new
functions introduced here allows to reduce the extent of overindication
and thus improve performance.

These new functions can only be called on pages for which a reference
is already being held.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210920132502.36111-7-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Stable-dep-of: 3f29f6537f54 ("s390/uv: Don't call folio_wait_writeback() without a folio reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pgtable.h |  9 ++++++---
 arch/s390/include/asm/uv.h      | 10 ++++++++--
 arch/s390/kernel/uv.c           | 34 ++++++++++++++++++++++++++++++++-
 arch/s390/mm/gmap.c             |  4 +++-
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b61426c9ef178..e434169502456 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1074,8 +1074,9 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	pte_t res;
 
 	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
@@ -1091,8 +1092,9 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	pte_t res;
 
 	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(vma->vm_mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
@@ -1116,8 +1118,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	} else {
 		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index fe92a4caf5ec8..bb94d2bec67bd 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -351,8 +351,9 @@ static inline int is_prot_virt_host(void)
 }
 
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
-int uv_destroy_page(unsigned long paddr);
+int uv_destroy_owned_page(unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
+int uv_convert_owned_from_secure(unsigned long paddr);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
 
 void setup_uv(void);
@@ -360,7 +361,7 @@ void setup_uv(void);
 #define is_prot_virt_host() 0
 static inline void setup_uv(void) {}
 
-static inline int uv_destroy_page(unsigned long paddr)
+static inline int uv_destroy_owned_page(unsigned long paddr)
 {
 	return 0;
 }
@@ -369,6 +370,11 @@ static inline int uv_convert_from_secure(unsigned long paddr)
 {
 	return 0;
 }
+
+static inline int uv_convert_owned_from_secure(unsigned long paddr)
+{
+	return 0;
+}
 #endif
 
 #endif /* _ASM_S390_UV_H */
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 09b80d371409b..8b0e62507d62e 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -100,7 +100,7 @@ static int uv_pin_shared(unsigned long paddr)
  *
  * @paddr: Absolute host address of page to be destroyed
  */
-int uv_destroy_page(unsigned long paddr)
+static int uv_destroy_page(unsigned long paddr)
 {
 	struct uv_cb_cfs uvcb = {
 		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
@@ -120,6 +120,22 @@ int uv_destroy_page(unsigned long paddr)
 	return 0;
 }
 
+/*
+ * The caller must already hold a reference to the page
+ */
+int uv_destroy_owned_page(unsigned long paddr)
+{
+	struct page *page = phys_to_page(paddr);
+	int rc;
+
+	get_page(page);
+	rc = uv_destroy_page(paddr);
+	if (!rc)
+		clear_bit(PG_arch_1, &page->flags);
+	put_page(page);
+	return rc;
+}
+
 /*
  * Requests the Ultravisor to encrypt a guest page and make it
  * accessible to the host for paging (export).
@@ -139,6 +155,22 @@ int uv_convert_from_secure(unsigned long paddr)
 	return 0;
 }
 
+/*
+ * The caller must already hold a reference to the page
+ */
+int uv_convert_owned_from_secure(unsigned long paddr)
+{
+	struct page *page = phys_to_page(paddr);
+	int rc;
+
+	get_page(page);
+	rc = uv_convert_from_secure(paddr);
+	if (!rc)
+		clear_bit(PG_arch_1, &page->flags);
+	put_page(page);
+	return rc;
+}
+
 /*
  * Calculate the expected ref_count for a page that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 32d9db5e6f53c..7a4320a9f6557 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2698,8 +2698,10 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
 {
 	pte_t pte = READ_ONCE(*ptep);
 
+	/* There is a reference through the mapping */
 	if (pte_present(pte))
-		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
+		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
+
 	return 0;
 }
 
-- 
2.43.0



