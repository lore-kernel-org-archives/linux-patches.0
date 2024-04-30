Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDB112C490;
	Tue, 30 Apr 2024 10:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474456; cv=none; b=JrpaxRh+fjajRUMymWltU+8FeHevPzizqqjGZGfUpD8NuQmpOUOAdG1uXSWEyg7pLQoUGorfGhSBTz3cZRVe2rCUBFi3RxcXC3amHP3cFm8Fl6Ku6wWP51h0gQafSe7NXenY/L4tScDM6Cvd2CzRm61aZfQyiHEjQVhBSZYKTrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474456; c=relaxed/simple;
	bh=hoCHWzuuQrhPPA+WtiyBDPcMLiMz97454kIdaEvUA6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/U6hitMQkLjKyXe90wl+M+mp1KXoRoP8rid0oR1YceB2lsbxR8jkH+pOY8dMx/kLEY/TSe3v8k5sFd/1tQwJJrofWc6axGSaTMA69SZuQ0Qg1RLRi3ZVBNaNv0/tTJvPtfHGL/9q2qm0hTjF42bjOwgsiB8in4pF7felZXKd/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMpvKk3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMpvKk3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDD7C2BBFC;
	Tue, 30 Apr 2024 10:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474456;
	bh=hoCHWzuuQrhPPA+WtiyBDPcMLiMz97454kIdaEvUA6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMpvKk3tH12Mg2k4V63AWQ83SdCfE1xrPuqIS3BqWFvLTTTm+R0891TvXD+3JcMIn
	 fscmwSn4lWaSZi359EHNRnKi+AEfRvftAgUucbv1jMqigdUmBvwf3d0ISJieN+8Z25
	 QnNDK3e0l6LCrRalORiexOsiIueuCz9mYaNSJ8A4=
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
Subject: [PATCH 6.8 162/228] x86/tdx: Preserve shared bit on mprotect()
Date: Tue, 30 Apr 2024 12:39:00 +0200
Message-ID: <20240430103108.482787659@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/coco.h          |    1 +
 arch/x86/include/asm/pgtable_types.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -24,6 +24,7 @@ u64 cc_mkdec(u64 val);
 void cc_random_init(void);
 #else
 #define cc_vendor (CC_VENDOR_NONE)
+static const u64 cc_mask = 0;
 
 static inline u64 cc_mkenc(u64 val)
 {
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -148,7 +148,7 @@
 #define _COMMON_PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |	\
 				 _PAGE_SPECIAL | _PAGE_ACCESSED |	\
 				 _PAGE_DIRTY_BITS | _PAGE_SOFT_DIRTY |	\
-				 _PAGE_DEVMAP | _PAGE_ENC | _PAGE_UFFD_WP)
+				 _PAGE_DEVMAP | _PAGE_CC | _PAGE_UFFD_WP)
 #define _PAGE_CHG_MASK	(_COMMON_PAGE_CHG_MASK | _PAGE_PAT)
 #define _HPAGE_CHG_MASK (_COMMON_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_PAT_LARGE)
 
@@ -173,6 +173,7 @@ enum page_cache_mode {
 };
 #endif
 
+#define _PAGE_CC		(_AT(pteval_t, cc_mask))
 #define _PAGE_ENC		(_AT(pteval_t, sme_me_mask))
 
 #define _PAGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)


