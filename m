Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A271993A0;
	Thu,  6 Jun 2024 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683246; cv=none; b=XTDhPJabnIAQbky7wW93O29JFKRDbOnu27pgpwl4UzPPa4bNG9A39I5QZOWft+BhWlRATWWQ2X6iJ3dJLOqYCOCt27/s3blrm7Cn5Ved6Ue65MvAwB6C1n5am5pZHnltMgjA+G2hs1q7IeeNzotNpqgu5Rzy+t8Vl3LmSlSWUIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683246; c=relaxed/simple;
	bh=fBgT5EhwqPOGiKuXATOsO2pMVjgmoNPRwfy7aJRUG2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNZItSOLqC1FMrsj8RpHGyEBBKzM3duBQNFHuLhoBT+xz1U0eyRCQY8tcCoccVrLspLb7pplqDfenPLPDu1Hz0kTABoKZ+/VLYAFKk9yqyuJRAUKUKEg1UpBIHcRBydq3B5D+szb0wxiIZuo533wyXx3XRy7qSi0qRsxeag6zsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9NEXz4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9NEXz4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AB8C2BD10;
	Thu,  6 Jun 2024 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683246;
	bh=fBgT5EhwqPOGiKuXATOsO2pMVjgmoNPRwfy7aJRUG2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9NEXz4NBdGefiV0MNfAkLGtHoEm2HrZ1Mfmx0rzA9wsMW46N7Qn+TPnST9RE17Is
	 scj4xcosqGwfurhv69hri9VURX4veH8HqZU4o509yhPrBm3sS6nR4JEmuxfYR7byPo
	 RbMrRbKU5mxseFHZF+i8MH+uzISTw41F76OeN7oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jandryuk@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/473] x86/pat: Fix W^X violation false-positives when running as Xen PV guest
Date: Thu,  6 Jun 2024 16:00:52 +0200
Message-ID: <20240606131704.004461697@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 5bc8b0f5dac04cd4ebe47f8090a5942f2f2647ef ]

When running as Xen PV guest in some cases W^X violation WARN()s have
been observed. Those WARN()s are produced by verify_rwx(), which looks
into the PTE to verify that writable kernel pages have the NX bit set
in order to avoid code modifications of the kernel by rogue code.

As the NX bits of all levels of translation entries are or-ed and the
RW bits of all levels are and-ed, looking just into the PTE isn't enough
for the decision that a writable page is executable, too.

When running as a Xen PV guest, the direct map PMDs and kernel high
map PMDs share the same set of PTEs. Xen kernel initialization will set
the NX bit in the direct map PMD entries, and not the shared PTEs.

Fixes: 652c5bf380ad ("x86/mm: Refuse W^X violations")
Reported-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240412151258.9171-5-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index cf721614806b9..fd412dec01259 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -583,7 +583,8 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long start,
  * Validate strict W^X semantics.
  */
 static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long start,
-				  unsigned long pfn, unsigned long npg)
+				  unsigned long pfn, unsigned long npg,
+				  bool nx, bool rw)
 {
 	unsigned long end;
 
@@ -609,6 +610,10 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 	if ((pgprot_val(new) & (_PAGE_RW | _PAGE_NX)) != _PAGE_RW)
 		return new;
 
+	/* Non-leaf translation entries can disable writing or execution. */
+	if (!rw || nx)
+		return new;
+
 	end = start + npg * PAGE_SIZE - 1;
 	WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
 		  (unsigned long long)pgprot_val(old),
@@ -710,7 +715,7 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 EXPORT_SYMBOL_GPL(lookup_address);
 
 static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
-				  unsigned int *level)
+				  unsigned int *level, bool *nx, bool *rw)
 {
 	pgd_t *pgd;
 
@@ -719,7 +724,7 @@ static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 	else
 		pgd = cpa->pgd + pgd_index(address);
 
-	return lookup_address_in_pgd(pgd, address, level);
+	return lookup_address_in_pgd_attr(pgd, address, level, nx, rw);
 }
 
 /*
@@ -843,12 +848,13 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
 	pte_t new_pte, *tmp;
 	enum pg_level level;
+	bool nx, rw;
 
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
 	 */
-	tmp = _lookup_address_cpa(cpa, address, &level);
+	tmp = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
 	if (tmp != kpte)
 		return 1;
 
@@ -959,7 +965,8 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	new_prot = static_protections(req_prot, lpaddr, old_pfn, numpages,
 				      psize, CPA_DETECT);
 
-	new_prot = verify_rwx(old_prot, new_prot, lpaddr, old_pfn, numpages);
+	new_prot = verify_rwx(old_prot, new_prot, lpaddr, old_pfn, numpages,
+			      nx, rw);
 
 	/*
 	 * If there is a conflict, split the large page.
@@ -1040,6 +1047,7 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned int i, level;
 	pgprot_t ref_prot;
+	bool nx, rw;
 	pte_t *tmp;
 
 	spin_lock(&pgd_lock);
@@ -1047,7 +1055,7 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
 	 */
-	tmp = _lookup_address_cpa(cpa, address, &level);
+	tmp = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
 	if (tmp != kpte) {
 		spin_unlock(&pgd_lock);
 		return 1;
@@ -1588,10 +1596,11 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	int do_split, err;
 	unsigned int level;
 	pte_t *kpte, old_pte;
+	bool nx, rw;
 
 	address = __cpa_addr(cpa, cpa->curpage);
 repeat:
-	kpte = _lookup_address_cpa(cpa, address, &level);
+	kpte = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
 	if (!kpte)
 		return __cpa_process_fault(cpa, address, primary);
 
@@ -1613,7 +1622,8 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 		new_prot = static_protections(new_prot, address, pfn, 1, 0,
 					      CPA_PROTECT);
 
-		new_prot = verify_rwx(old_prot, new_prot, address, pfn, 1);
+		new_prot = verify_rwx(old_prot, new_prot, address, pfn, 1,
+				      nx, rw);
 
 		new_prot = pgprot_clear_protnone_bits(new_prot);
 
-- 
2.43.0



