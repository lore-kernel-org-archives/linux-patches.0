Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAF22D3A69;
	Sun,  7 Jun 2026 10:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828702; cv=none; b=d56ua4FEZy3UA9dz9ZnnxlvCqhoUPBVcPIrDXa0fnmksE2wZqz/k8PSRBf9anvf0bkSIgrKV8ZIr9ouAMy0BLvGzSq88qZli5KLTOm9FHHG3tg50tEm0VwDLSVaqyaqsgmBabf84vJR7QnEhcWmwziOFs2xkkHQWL//X8CUNm9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828702; c=relaxed/simple;
	bh=lqDreVlh8G8eO8U7jetHbYLaqlkXyzxIoyIRmX4CQBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9L5xduCzBS1Cbkrto1rDHpm+YsIXBRPciAJKDFj27SX3w+k6Xt8lgg8lQzIK3+/VbGIOqKj7nL67sJCpNwJFjzzqdZXwQnIsiSmqh8ufzybXvPVDwzM5in2G3hf08Qwu8byMfZT0Zsn6vYwssPyrvavBVAto9vjL6hIKzCCit4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAet9l5/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAet9l5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2611F00893;
	Sun,  7 Jun 2026 10:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828701;
	bh=rV4Ek9OVC8OXq+lNBKTigzGQ66hXsDsv1gDYPqIe/mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAet9l5/948FAqECnW6qlnRrYabTKKuXP6h2LVgq+3qir5TcoXeh7NzUekYqtErBU
	 M+KTdP+UgXvNTvG+pbHfHFEmGroeLxFY1kpXGeLkH1h92Q6IBA6p0bE0A9Xu2QS2IV
	 ExBWi7gttFI8xdSFnnOYmA5HKmADpaBPaX4NXcZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 159/307] KVM: SEV: Use READ_ONCE() when reading entries/indices from PSC buffer
Date: Sun,  7 Jun 2026 11:59:16 +0200
Message-ID: <20260607095733.564711196@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

commit c8cc238093ca6c99267032f6cfe78f59389f3157 upstream.

Use READ_ONCE() when reading entries/indices from the guest-accessible
Page State Change buffer to defend against TOCTOU bugs.

Don't bother with READ_ONCE()/WRITE_ONCE() for cases where KVM is writing
(and not consuming the result!), as the guest isn't supposed to touch the
buffer while it's being processed.  I.e. using READ_ONCE() is all about
protecting against misbehaving guests.

Fixes: 9b54e248d264 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-11-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3699,9 +3699,9 @@ static void __snp_complete_one_psc(struc
 	 */
 	for (idx = svm->sev_es.psc_idx; svm->sev_es.psc_inflight;
 	     svm->sev_es.psc_inflight--, idx++) {
-		struct psc_entry *entry = &entries[idx];
+		struct psc_entry entry = READ_ONCE(entries[idx]);
 
-		entry->cur_page = entry->pagesize ? 512 : 1;
+		entries[idx].cur_page = entry.pagesize ? 512 : 1;
 	}
 
 	hdr->cur_entry = idx;
@@ -3764,8 +3764,8 @@ next_range:
 	 * validation, so take care to only use validated copies of values used
 	 * for things like array indexing.
 	 */
-	idx_start = hdr->cur_entry;
-	idx_end = hdr->end_entry;
+	idx_start = READ_ONCE(hdr->cur_entry);
+	idx_end = READ_ONCE(hdr->end_entry);
 
 	if (idx_end >= max_nr_entries) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_HDR);
@@ -3774,7 +3774,7 @@ next_range:
 
 	/* Find the start of the next range which needs processing. */
 	for (idx = idx_start; idx <= idx_end; idx++, hdr->cur_entry++) {
-		entry_start = entries[idx];
+		entry_start = READ_ONCE(entries[idx]);
 
 		gfn = entry_start.gfn;
 		huge = entry_start.pagesize;
@@ -3818,7 +3818,7 @@ next_range:
 	 * KVM_HC_MAP_GPA_RANGE exit.
 	 */
 	while (++idx <= idx_end) {
-		struct psc_entry entry = entries[idx];
+		struct psc_entry entry = READ_ONCE(entries[idx]);
 
 		if (entry.operation != entry_start.operation ||
 		    entry.gfn != entry_start.gfn + npages ||


