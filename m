Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408ED2FD699;
	Fri,  9 Jan 2026 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961002; cv=none; b=Z9Emy/u004p5t0+zSLZl8uPJ5E29GUHIyQ3tdy2c+8ixZF1SUIQlv6GjKlgyX1S4lN1opvoVUL4qPykDEhx9wnvjqceKNQ2BEOTw+C1sroo4WhdaRw1xV5VPKONairqQ2/IZ5Ro0+eVvL8oCXS946LwM18BiuTwGIbCwSyJQNUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961002; c=relaxed/simple;
	bh=bPrHOnn2kUaZ41v4tuF/5fCMSz2NSoR3D+uV7RAtCGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+rVIqwrUPf9XqkOXEMK5KTx95oPWJWxKEwS0FZFTTrHdLLcRywqqWSLxTjqoHmDFkT3IlYYJdclgR0X4AaCKsmgPt7/KIGcf2GxFBccQmQshWAhtZTiqWziRC6qc7DdgXUFGk53u0NpksHrAgEEAdFSzgTf6HE0VqR+2ccBFnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhgCwkEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhgCwkEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D2BC4CEF1;
	Fri,  9 Jan 2026 12:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961002;
	bh=bPrHOnn2kUaZ41v4tuF/5fCMSz2NSoR3D+uV7RAtCGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhgCwkEs8irvanV9aL2uiSqCTOgMSYCCD6RKw5aWRIn3grerR+E8D+HiKZEWVdpCb
	 CIUbZj6HgzuuVmsjt4xdTjGhqU4uQl3jigm0WT8TXF6V+mEOkUq0dpLI9JIzjA0uww
	 /XqsxrZhqnoMfZzkMOotP9nb6Cn6+vKGIejsELpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyl5933@chinaunicom.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 599/737] LoongArch: Use __pmd()/__pte() for swap entry conversions
Date: Fri,  9 Jan 2026 12:42:18 +0100
Message-ID: <20260109112156.542036095@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyl5933@chinaunicom.cn>

commit 4a71df151e703b5e7e85b33369cee59ef2665e61 upstream.

The __pmd() and __pte() helper macros provide the correct initialization
syntax and abstraction for the pmd_t and pte_t types.

Use __pmd() to fix follow warning about __swp_entry_to_pmd() with gcc-15
under specific configs [1] :

  In file included from ./include/linux/pgtable.h:6,
                   from ./include/linux/mm.h:31,
                   from ./include/linux/pagemap.h:8,
                   from arch/loongarch/mm/init.c:14:
  ./include/linux/swapops.h: In function ‘swp_entry_to_pmd’:
  ./arch/loongarch/include/asm/pgtable.h:302:34: error: missing braces around initializer [-Werror=missing-braces]
    302 | #define __swp_entry_to_pmd(x)   ((pmd_t) { (x).val | _PAGE_HUGE })
        |                                  ^
  ./include/linux/swapops.h:559:16: note: in expansion of macro ‘__swp_entry_to_pmd’
    559 |         return __swp_entry_to_pmd(arch_entry);
        |                ^~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

Also update __swp_entry_to_pte() to use __pte() for consistency.

[1]. https://download.01.org/0day-ci/archive/20251119/202511190316.luI90kAo-lkp@intel.com/config

Cc: stable@vger.kernel.org
Signed-off-by: Yuli Wang <wangyl5933@chinaunicom.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -285,9 +285,9 @@ static inline pte_t mk_swap_pte(unsigned
 #define __swp_offset(x)		((x).val >> 24)
 #define __swp_entry(type, offset) ((swp_entry_t) { pte_val(mk_swap_pte((type), (offset))) })
 #define __pte_to_swp_entry(pte) ((swp_entry_t) { pte_val(pte) })
-#define __swp_entry_to_pte(x)	((pte_t) { (x).val })
+#define __swp_entry_to_pte(x)	__pte((x).val)
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
-#define __swp_entry_to_pmd(x)	((pmd_t) { (x).val | _PAGE_HUGE })
+#define __swp_entry_to_pmd(x)	__pmd((x).val | _PAGE_HUGE)
 
 static inline int pte_swp_exclusive(pte_t pte)
 {


