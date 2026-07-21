Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D21244607D;
	Tue, 21 Jul 2026 19:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661194; cv=none; b=rqpEIksAEDZRmj2eFUFprOWVGrBj7zjaUVkE3fHNF9sssxiMV+E/B4F7SABi+NHW3R7/xWHnEjNb9ZofnH7GYzyuPo/WNLCRTiFkmwKQl0CWM9ukQMAAJXfFi0+p1wFLjjBYI+VzzQy2UGZm4R4mfOn5XizfDYakw7kSlO2Xby0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661194; c=relaxed/simple;
	bh=0MPw6MVH1wtwz/g+EGp++9pyC+/7/sUml5pDnXXNYhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSKrYMB+QW3PUBLN+tAUYofurKn+4jlpU8had2o9h0OPAav3xN1AVmSDotcDYZsApWq/9tTwXXmtYzARQGnCrrRytdR1NTIFP5wmXlKU8cPGj2SrhR0jnyte8qtSv4b/NOqlTTX/3fAmHMlkUlOeRsCcEo6mAZ/kX/xCJr1Zsuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpHtpr/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpHtpr/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8343C1F000E9;
	Tue, 21 Jul 2026 19:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661193;
	bh=/zxaoj7h8htKOkGhG6sFMAt1mYr3d+BcRgHuIq3mMuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpHtpr/GrGS53jN10enkVYJEPxrIpwczJSzRhG8OgDbnsuRyVUSJ1E35o+OBXsIUp
	 GOS+Nz0bgSecE3caedWLiBgq+Hsyka2fpUBvR8Z54q/Zwb6XBTQKFsY2fRH6M554mO
	 NcO7qzQheNCm6mwHixfiMCLA+q8SHlq8Z/+8rLuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1266/2077] s390/mm: Fix handling of _PAGE_UNUSED pte bit
Date: Tue, 21 Jul 2026 17:15:39 +0200
Message-ID: <20260721152622.677528252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit d4bb00704a66024502261fa7a523c07420249fea ]

The _PAGE_UNUSED softbit should not really be lying around. Its sole
purpose is to signal to try_to_unmap_one() and try_to_migrate_one()
that the page can be discarded instead of being moved / swapped.

KVM has no way to know why a page is being unmapped, so it sets the bit
on userspace ptes corresponding to unused guest pages every time they
get unmapped. KVM has no reasonable way to clear the bit once the page
is in use again.

While set_ptes() checks and clears the bit, other paths that set new
ptes did not. This led to used pages being thrown out as if they were
unused, causing guest corruption.

Fix the issue by clearing the _PAGE_UNUSED bit for present ptes in
set_pte(), i.e. whenever a present pte is getting set. The check in
set_ptes() is then redundant and can be removed.

Also fix gmap_helper_try_set_pte_unused() to only set the bit if the
pte is present; the _PAGE_UNUSED bit is only defined for present ptes
and thus should not be set for non-present ptes.

Fixes: c98175b7917f ("KVM: s390: Add gmap_helper_set_unused()")
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260623153331.233784-2-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pgtable.h | 4 ++--
 arch/s390/mm/gmap_helpers.c     | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2c6cee8241e044..4740c75649ebb5 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -980,6 +980,8 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 
 static inline void set_pte(pte_t *ptep, pte_t pte)
 {
+	if (pte_present(pte))
+		pte = clear_pte_bit(pte, __pgprot(_PAGE_UNUSED));
 	WRITE_ONCE(*ptep, pte);
 }
 
@@ -1332,8 +1334,6 @@ pgprot_t pgprot_writecombine(pgprot_t prot);
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t entry, unsigned int nr)
 {
-	if (pte_present(entry))
-		entry = clear_pte_bit(entry, __pgprot(_PAGE_UNUSED));
 	page_table_check_ptes_set(mm, addr, ptep, entry, nr);
 	for (;;) {
 		set_pte(ptep, entry);
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index 1cfe4724fbe2a6..60023b6fdcb138 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -181,7 +181,8 @@ void gmap_helper_try_set_pte_unused(struct mm_struct *mm, unsigned long vmaddr)
 	if (IS_ERR_OR_NULL(ptep))
 		return;
 
-	__atomic64_or(_PAGE_UNUSED, (long *)ptep);
+	if (pte_present(*ptep))
+		__atomic64_or(_PAGE_UNUSED, (long *)ptep);
 	pte_unmap_unlock(ptep, ptl);
 }
 EXPORT_SYMBOL_GPL(gmap_helper_try_set_pte_unused);
-- 
2.53.0



