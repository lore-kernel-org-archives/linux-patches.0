Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C859812D746;
	Tue, 30 Apr 2024 11:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476714; cv=none; b=Ke3X4DBQWamXw+jVEiQzl3TLDQ8BXS4WpUxEYZ+OR/8m5m4dO2TxktSehzL2hKUjMDCEvixiYFJlETJ7OXh9spGM0ZWDglV7jj6YmWT9ABffzYSznZa/gU/YlBWO6eJzjmMgj0rFUQcM2cCGthqyUmKx5A7kxyGVS2AES44HbuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476714; c=relaxed/simple;
	bh=UTr7Juyhdzf4rULlY1lWg7bNJqH/BGeAWYMW4XstPJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIqQLf6Oa+F7wY5VInkJTlyInA33mVAtThwCA2JcNQYNgCoOooMsGTO2ox7wTerLJP8o1gEJg7d2MYMyUZH4PQ/VzATfHnINXwFb5OwTN2MRiL299oot1u6cIygorzXihk8uHQJhOrIDoGHaMhKREtu0laieW4IkhYZNVArXrzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+PsOkOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+PsOkOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2478C2BBFC;
	Tue, 30 Apr 2024 11:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476714;
	bh=UTr7Juyhdzf4rULlY1lWg7bNJqH/BGeAWYMW4XstPJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+PsOkOr61lNkJTl6Ywyi7wmUxVCipMzxvmnFiBf488mluaACLdoAdCTdToJd8bW+
	 OhqrPtNfACCSXoZBDJM+rrwu/1Kt5kBcMdBihGQ7jqvk6x4eLlyn00X8ULN0LUQCnC
	 L7KqjVKGtY25ynP0DAigfR/TgxSNvTX0xl4ejmJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Chris Oo <cho@microsoft.com>
Subject: [PATCH 6.1 091/110] x86/tdx: Preserve shared bit on mprotect()
Date: Tue, 30 Apr 2024 12:41:00 +0200
Message-ID: <20240430103050.257659260@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit a0a8d15a798be4b8f20aca2ba91bf6b688c6a640 upstream.

The TDX guest platform takes one bit from the physical address to
indicate if the page is shared (accessible by VMM). This bit is not part
of the physical_mask and is not preserved during mprotect(). As a
result, the 'shared' bit is lost during mprotect() on shared mappings.

_COMMON_PAGE_CHG_MASK specifies which PTE bits need to be preserved
during modification. AMD includes 'sme_me_mask' in the define to
preserve the 'encrypt' bit.

To cover both Intel and AMD cases, include 'cc_mask' in
_COMMON_PAGE_CHG_MASK instead of 'sme_me_mask'.

Reported-and-tested-by: Chris Oo <cho@microsoft.com>

Fixes: 41394e33f3a0 ("x86/tdx: Extend the confidential computing API to support TDX guests")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240424082035.4092071-1-kirill.shutemov%40linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/coco.h          |    5 ++++-
 arch/x86/include/asm/pgtable_types.h |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -13,9 +13,10 @@ enum cc_vendor {
 };
 
 extern enum cc_vendor cc_vendor;
-extern u64 cc_mask;
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
+extern u64 cc_mask;
+
 static inline void cc_set_mask(u64 mask)
 {
 	RIP_REL_REF(cc_mask) = mask;
@@ -25,6 +26,8 @@ u64 cc_mkenc(u64 val);
 u64 cc_mkdec(u64 val);
 void cc_random_init(void);
 #else
+static const u64 cc_mask = 0;
+
 static inline u64 cc_mkenc(u64 val)
 {
 	return val;
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -127,7 +127,7 @@
  */
 #define _COMMON_PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |	       \
 				 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY |\
-				 _PAGE_SOFT_DIRTY | _PAGE_DEVMAP | _PAGE_ENC | \
+				 _PAGE_SOFT_DIRTY | _PAGE_DEVMAP | _PAGE_CC | \
 				 _PAGE_UFFD_WP)
 #define _PAGE_CHG_MASK	(_COMMON_PAGE_CHG_MASK | _PAGE_PAT)
 #define _HPAGE_CHG_MASK (_COMMON_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_PAT_LARGE)
@@ -153,6 +153,7 @@ enum page_cache_mode {
 };
 #endif
 
+#define _PAGE_CC		(_AT(pteval_t, cc_mask))
 #define _PAGE_ENC		(_AT(pteval_t, sme_me_mask))
 
 #define _PAGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)


