Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1F51FE47B;
	Sun,  7 Jun 2026 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828317; cv=none; b=T7HbXct/vIwtXcbMLWDu2R91ClAmLrSywfLa+foIbtHxMRMZD0GQb8CRHZjpps7xPy8yY4JjLC5nPf9+7s0E8EIXI/K7ojZKoJ0iDtq2yxuMFE5FIM25SfZ33h3aVwaCvx9d8kEbCUrCjKmVbc5nQFMqPfnXXz+rYEOvaXFVioE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828317; c=relaxed/simple;
	bh=dLvr0BA6vzByhas1AN0BDV9T+YBWQFZsxI9cJdK7o5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhc5iIuyD9T5OSKVWOvXPGO1dii5ZNDR4KfaVlfY5KcHPQdVcw8Yr8hmyWKCwbK/JO2fti/yQXiOITBl78wLL8+m7bcrMo1HWbIh4bz6AYzz3E4K156vB/eK428KGnz9W7ln69j1jE5GroVvFltOE1VeLeOsWAWlT9DyrZBJO8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqZm4+1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqZm4+1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E8B1F00893;
	Sun,  7 Jun 2026 10:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828315;
	bh=wq8DzQUz6J/cj5ImNa7eNLXZFzbqTMXgyJnD9ljlT+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqZm4+1fFjiuwQS058/fgJaMl0eCLhO8Re4w7IcwncWIGWH+jXsHwHEI7n5HI5SeQ
	 3jEnsAgZwu5fr01zCGVzp6ZxMBLOOKPeuYznwcqXw1sL8OuPb7XaAKMytaZTTRF79F
	 Gkpdf6UI6asBXx7BVXgwo6Yc/diRy0K9xchgV18o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 149/315] KVM: SEV: Check PSC request indices against the actual size of the buffer
Date: Sun,  7 Jun 2026 11:58:56 +0200
Message-ID: <20260607095733.079756614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 121d88de56bc5c0ba0ce2f6381af67f948a7e7c1 upstream.

When processing Page State Change (PSC) requests, validate the PSC buffer
against the effective size of the scratch area, which could be less than
the maximum size if the guest provided a pointer that isn't exactly at the
start of the GHCB shared buffer.

Fixes: 9b54e248d264 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-10-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3850,7 +3850,7 @@ static int snp_begin_psc(struct vcpu_svm
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct psc_hdr *hdr = &psc->hdr;
 	struct psc_entry entry_start;
-	u16 idx, idx_start, idx_end;
+	u16 idx, idx_start, idx_end, max_nr_entries;
 	int npages;
 	bool huge;
 	u64 gfn;
@@ -3860,6 +3860,19 @@ static int snp_begin_psc(struct vcpu_svm
 		return 1;
 	}
 
+	/*
+	 * GHCB v2 requires the scratch area to reside within the GHCB itself,
+	 * and PSC requests are only supported for GHCB v2+.  Thus it should be
+	 * impossible to exceed the max PSC entry count (which is derived from
+	 * the size of the shared GHCB buffer).
+	 */
+	max_nr_entries = (sev_es->ghcb_sa_len - sizeof(struct psc_hdr)) /
+			 sizeof(struct psc_entry);
+	if (WARN_ON_ONCE(max_nr_entries > VMGEXIT_PSC_MAX_COUNT)) {
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
+		return 1;
+	}
+
 next_range:
 	/* There should be no other PSCs in-flight at this point. */
 	if (WARN_ON_ONCE(svm->sev_es.psc_inflight)) {
@@ -3875,7 +3888,7 @@ next_range:
 	idx_start = hdr->cur_entry;
 	idx_end = hdr->end_entry;
 
-	if (idx_end >= VMGEXIT_PSC_MAX_COUNT) {
+	if (idx_end >= max_nr_entries) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_HDR);
 		return 1;
 	}


