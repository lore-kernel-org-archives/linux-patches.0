Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366B147125D;
	Tue, 21 Jul 2026 18:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659185; cv=none; b=NSQTZ1G6qPLRbOTPyrLbeQAxGXxFJ9/cetTgohEoR4JpLyfT5jUAz/+esGaCVBvJ6RfhajM1jY1o0OqQId6e3fwonbOUD68VGO8ZRUFmvanbx1mbnsQmQ7ktbxEY6PoR6nweuGsjvz9EW8GqYmVVoQDa2pTWvsP8N3xXjHCvydY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659185; c=relaxed/simple;
	bh=2PHucLINZRWmPGh1EVxeGEUwdtt9k96DHES3CcYKgQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHcHMVtXjRrMHD/wMHTYdpFYB1NFaHqyThQxuAkvieJvFLQ4HR+tZiDxMtIEa90PKvYEjz0iIy/2nxUniRpyK59Kw1zSRfzooXs5KyWFFEgL9wzKoTKeB0oZO3UXdxIVkMcgfSzjGTo6sVnM9vFHfUw0kBaJEfxJIQAVlMlWlxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqniFNms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqniFNms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCB91F000E9;
	Tue, 21 Jul 2026 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659184;
	bh=m8zs3Fi8/DKI2oCOny1AAJJYqwiXoIOn924RJgalg9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqniFNmsg84BjkaHf7XSDd5gQ9h1ev380Tgx+mBC/I881v6tbY/1MIBiSc5v+B7Qr
	 CNG3cgmF/oLzzVqPqw4aooBS3T5AOgeL30aE8D7QrWwy+/5lVGU6TIrYxAQUm0aCkq
	 WuqnSg5MKgR2WseQWghyLfUpEL4u0ySZqbZk/0Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Hongchen Zhang <zhanghongchen@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 1424/1611] LoongArch: Fix missing dirty page tracking in {pte,pmd}_wrprotect()
Date: Tue, 21 Jul 2026 17:25:40 +0200
Message-ID: <20260721152547.467072377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongchen Zhang <zhanghongchen@loongson.cn>

commit 018e9828eb523c638fa3d9bdf0fd4956b74555b2 upstream.

When hardware page table walker (PTW) is enabled on LoongArch, the CPU
may set _PAGE_DIRTY directly in the page table entry during a write TLB
miss, without going through the software TLB store handler. The software
TLB store handler (tlbex.S:254) sets both _PAGE_DIRTY and_PAGE_MODIFIED
together:

    ori t0, t0, (_PAGE_VALID | _PAGE_DIRTY | _PAGE_MODIFIED)

Since hardware PTW only sets _PAGE_DIRTY, the software-only bit, i.e.
_PAGE_MODIFIED is left unchanged. This creates a window where a PTE has
_PAGE_DIRTY set (hardware knows the page is dirty) but _PAGE_MODIFIED
clear (software is unaware).

When fork()/clone() triggers copy-on-write, __copy_present_ptes() calls
pte_wrprotect(), which unconditionally clears both the _PAGE_WRITE and
_PAGE_DIRTY bits:

    pte_val(pte) &= ~(_PAGE_WRITE | _PAGE_DIRTY);

Since _PAGE_MODIFIED was never set, the dirtiness information is lost
completely. Subsequently, when memory pressure triggers page reclaim,
page_mkclean() / try_to_unmap() sees the page as clean (i.e. pte_dirty()
returns false) and the page may be freed without writeback, causing data
corruption.

Fix this by propagating the _PAGE_DIRTY bit to the _PAGE_MODIFIED bit in
both pte_wrprotect() and pmd_wrprotect() before clearing writeable bits:

    if (pte_val(pte) & _PAGE_DIRTY)
        pte_val(pte) |= _PAGE_MODIFIED;

The pmd_wrprotect() fix handles the CONFIG_TRANSPARENT_HUGEPAGE case,
where pmd entries need the same treatment.

This ensures the software dirty tracking bit (checked by pte_dirty() and
pmd_dirty(), which read both the _PAGE_DIRTY and _PAGE_MODIFIED bits) is
preserved across fork COW write-protection.

The issue was found by the LTP madvise09 test case, which exercises page
reclaim after "madvise(MADV_FREE), write and fork" operation sequence on
private anonymous mappings.

Cc: stable@vger.kernel.org
Fixes: 09cfefb7fa70 ("LoongArch: Add memory management")
Co-developed-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/pgtable.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -392,6 +392,8 @@ static inline pte_t pte_mkwrite_novma(pt
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
+	if (pte_val(pte) & _PAGE_DIRTY)
+		pte_val(pte) |= _PAGE_MODIFIED;
 	pte_val(pte) &= ~(_PAGE_WRITE | _PAGE_DIRTY);
 	return pte;
 }
@@ -498,6 +500,8 @@ static inline pmd_t pmd_mkwrite_novma(pm
 
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
+	if (pmd_val(pmd) & _PAGE_DIRTY)
+		pmd_val(pmd) |= _PAGE_MODIFIED;
 	pmd_val(pmd) &= ~(_PAGE_WRITE | _PAGE_DIRTY);
 	return pmd;
 }


