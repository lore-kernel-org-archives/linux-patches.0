Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790B54078D3;
	Thu, 17 Sep 2026 18:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671421; cv=none; b=T1nrdFpq2ZUnvy14nlOtkTjmb03xfy0UYLNJmwXBOrnZ9YqyeyqKTiDK69hsYK/BaJeKl0rwxy/GOZb3gWYQqj4Bf92Lv3+5qGFRl5V0n0Ms9MU4l4ODJif7fpdanQNZmANRR37JjNnlcddl87i7IXyFyBD9XWiEyL7Coi6zM34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671421; c=relaxed/simple;
	bh=HKmtwys3PA0/E1pq/vJvjLb/gdWCnztaCMptfMH+CCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j//m+MEkizUfrGz6gKPiNbwBPI6keI4Jqvk4WCecN26pTGBmsvTEDhyPbcXh0HtjVbeKnrZXoj+eMIhLOZ7aN8OwFdsNAbkIYy0LpzxB6S/hWvYhc/2FuCOyBCFe6KJahDJwcMsCYYcynQCbeDV6C9Ym86nHGyW8uOkfKgSCvc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzRbBNsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzRbBNsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0261F000FF;
	Thu, 17 Sep 2026 18:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671420;
	bh=VY9wRVGNQHzOVO8xIUSXAIBbvzCtoIuRdvZ7XCbnXLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzRbBNsAX2hPwrX1G0efk/JNruf8UU4I/btaYiRU2oUCU0W5r+ombt7NI/iAMYmHT
	 jIlv35M/GoFcjqfvo82NaoJWpnZNw7cjtMtrN8N1Pw6yw8t/E8sfjK03+gZ+KChGMk
	 TkXd639k9H0KN1tUCaAdF9VgubDKlSSg7iOzMJCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0963/1102] KVM: SEV: Add an anonymous "psc" struct to track current PSC metadata
Date: Thu, 17 Sep 2026 16:15:06 +0100
Message-ID: <20260917151604.846387306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit 00b9744a3688758c5c492756d08a1cd599a76965 ]

Add a "psc" struct to vcpu_sev_es_state to avoid having to prefix all of
the fields with "psc_".

Take advantage of the code churn to opportunistically rename local
variables to "guest_psc" to make it more obvious that the buffer is guest
data, and more importantly, guest accessible!

Opportunistically rename inflight => batch_size as well, because there can
really only be one operation in-flight (per-vCPU), i.e. "inflight" _looks_
like a boolean, but in actuality is an integer tracking how many pages are
being handled by the current operation.

No functional change intended.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-13-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20260529183549.1104619-13-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 0060569e4f18 ("KVM: SEV: Extract loading of guest-provided VMSA to a separate helper")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   43 +++++++++++++++++++------------------------
 arch/x86/kvm/svm/svm.h |    8 +++++---
 2 files changed, 24 insertions(+), 27 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3726,17 +3726,14 @@ static int snp_begin_psc(struct vcpu_svm
 
 static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
 {
-	svm->sev_es.psc_inflight = 0;
-	svm->sev_es.psc_idx = 0;
-	svm->sev_es.psc_2m = false;
+	memset(&svm->sev_es.psc, 0, sizeof(svm->sev_es.psc));
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
 }
 
 static void __snp_complete_one_psc(struct vcpu_svm *svm)
 {
-	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
-	struct psc_entry *entries = psc->entries;
-	struct psc_hdr *hdr = &psc->hdr;
+	struct vcpu_sev_es_state *sev_es = &svm->sev_es;
+	struct psc_buffer *guest_psc = sev_es->ghcb_sa;
 	__u16 idx;
 
 	/*
@@ -3744,14 +3741,14 @@ static void __snp_complete_one_psc(struc
 	 * corresponding entries in the guest's PSC buffer and zero out the
 	 * count of in-flight PSC entries.
 	 */
-	for (idx = svm->sev_es.psc_idx; svm->sev_es.psc_inflight;
-	     svm->sev_es.psc_inflight--, idx++) {
-		struct psc_entry entry = READ_ONCE(entries[idx]);
+	for (idx = sev_es->psc.cur_idx; sev_es->psc.batch_size;
+	     sev_es->psc.batch_size--, idx++) {
+		struct psc_entry entry = READ_ONCE(guest_psc->entries[idx]);
 
-		entries[idx].cur_page = entry.pagesize ? 512 : 1;
+		guest_psc->entries[idx].cur_page = entry.pagesize ? 512 : 1;
 	}
 
-	hdr->cur_entry = idx;
+	guest_psc->hdr.cur_entry = idx;
 }
 
 static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
@@ -3772,10 +3769,8 @@ static int snp_complete_one_psc(struct k
 static int snp_begin_psc(struct vcpu_svm *svm)
 {
 	struct vcpu_sev_es_state *sev_es = &svm->sev_es;
-	struct psc_buffer *psc = sev_es->ghcb_sa;
-	struct psc_entry *entries = psc->entries;
+	struct psc_buffer *guest_psc = sev_es->ghcb_sa;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct psc_hdr *hdr = &psc->hdr;
 	struct psc_entry entry_start;
 	u16 idx, idx_start, idx_end, max_nr_entries;
 	int npages;
@@ -3802,7 +3797,7 @@ static int snp_begin_psc(struct vcpu_svm
 
 next_range:
 	/* There should be no other PSCs in-flight at this point. */
-	if (WARN_ON_ONCE(svm->sev_es.psc_inflight)) {
+	if (WARN_ON_ONCE(svm->sev_es.psc.batch_size)) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
 		return 1;
 	}
@@ -3812,8 +3807,8 @@ next_range:
 	 * validation, so take care to only use validated copies of values used
 	 * for things like array indexing.
 	 */
-	idx_start = READ_ONCE(hdr->cur_entry);
-	idx_end = READ_ONCE(hdr->end_entry);
+	idx_start = READ_ONCE(guest_psc->hdr.cur_entry);
+	idx_end = READ_ONCE(guest_psc->hdr.end_entry);
 
 	if (idx_end >= max_nr_entries) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_HDR);
@@ -3822,7 +3817,7 @@ next_range:
 
 	/* Find the start of the next range which needs processing. */
 	for (idx = idx_start; idx <= idx_end; idx++) {
-		entry_start = READ_ONCE(entries[idx]);
+		entry_start = READ_ONCE(guest_psc->entries[idx]);
 
 		gfn = entry_start.gfn;
 		huge = entry_start.pagesize;
@@ -3855,7 +3850,7 @@ next_range:
 		 * for READ_ONCE() as KVM doesn't consume the field, i.e. a
 		 * misbehaving guest can only break itself.
 		 */
-		hdr->cur_entry++;
+		guest_psc->hdr.cur_entry++;
 	}
 
 	if (idx > idx_end) {
@@ -3864,9 +3859,9 @@ next_range:
 		return 1;
 	}
 
-	svm->sev_es.psc_2m = huge;
-	svm->sev_es.psc_idx = idx;
-	svm->sev_es.psc_inflight = 1;
+	sev_es->psc.is_2m = huge;
+	sev_es->psc.cur_idx = idx;
+	sev_es->psc.batch_size = 1;
 
 	/*
 	 * Find all subsequent PSC entries that contain adjacent GPA
@@ -3874,14 +3869,14 @@ next_range:
 	 * KVM_HC_MAP_GPA_RANGE exit.
 	 */
 	while (++idx <= idx_end) {
-		struct psc_entry entry = READ_ONCE(entries[idx]);
+		struct psc_entry entry = READ_ONCE(guest_psc->entries[idx]);
 
 		if (entry.operation != entry_start.operation ||
 		    entry.gfn != entry_start.gfn + npages ||
 		    entry.cur_page || !!entry.pagesize != huge)
 			break;
 
-		svm->sev_es.psc_inflight++;
+		sev_es->psc.batch_size++;
 		npages += huge ? 512 : 1;
 	}
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -231,9 +231,11 @@ struct vcpu_sev_es_state {
 	bool ghcb_sa_free;
 
 	/* SNP Page-State-Change buffer entries currently being processed */
-	u16 psc_idx;
-	u16 psc_inflight;
-	bool psc_2m;
+	struct {
+		u16 cur_idx;
+		u16 batch_size;
+		bool is_2m;
+	} psc;
 
 	u64 ghcb_registered_gpa;
 


