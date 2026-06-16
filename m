Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E53466B59;
	Tue, 16 Jun 2026 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625561; cv=none; b=CLueyd9m35/eK2pJucqn4OjPhfc5s4jsVCvlB6qKyrxCLYF4JXWv7udRDzY5+lJq6dT1pNs79karX5llBfIcX8+3ivqyoyl949ffaJ4un7T1MgRUzuZY1OF4m2ULeKAYoZsqQtp1ibHpebE5JHg4sG5+mvbDYem8k2G8tRUWq18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625561; c=relaxed/simple;
	bh=3trlXIDLgG+7DXKnEdcl/5uX0iVSaoO7sqFsFDbocQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW/vGJJ/VQipPDSLMafEaRHeSDt8RF1UAERc/y7D/JhgXI3CooVLTDYpq4Czorh8DE65J5YTueGBErMFGisLddudgsdGlPiDK7f0bPQfUYD9y9rQU1ywn6A2B+EwIDzyFfVqpznAaLubA4MAvfZo+pc31XkVNGoQoFKL4VKRguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfOYHeoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfOYHeoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929331F000E9;
	Tue, 16 Jun 2026 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625560;
	bh=O9Iw9vkJsGiVIqOJzVk3aL5Z0mYf+wet8TMoM15wq7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfOYHeoA761jtGZvF+LrOg5JmaBK71mUZ5rNwYkKIwlXHMaE5MBE72ujHZ3RRbC1B
	 EqAtjtadG9ToSzn/l6PFRtrqN54ftgEoIVziCr2gXUX5Nsi86lSzvwLB9ALWzmXyfM
	 Do3qyCiEtzXOX7gEUX6SO2NYbjo0eLtzlyHQkV3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 166/325] KVM: SEV: Decouple the need to sync the GHCB SA from the need to free the SA
Date: Tue, 16 Jun 2026 20:29:22 +0530
Message-ID: <20260616145106.065002312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

commit f041dc80de4abbdd0909d871bf64f3f87d2350ff upstream.

Decouple synchronizing the GHCB SA from freeing/unpinning the SA, so that
the free/unpin path can be reused when freeing a vCPU.

Opportunistically add a WARN to harden KVM against stomping over (and thus
leaking) an already-allocated scratch area.

Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-17-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20260529183549.1104619-17-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3540,20 +3540,17 @@ void sev_es_unmap_ghcb(struct vcpu_svm *
 	if (!svm->sev_es.ghcb)
 		return;
 
-	if (svm->sev_es.ghcb_sa_free) {
-		/*
-		 * The scratch area lives outside the GHCB, so there is a
-		 * buffer that, depending on the operation performed, may
-		 * need to be synced, then freed.
-		 */
-		if (svm->sev_es.ghcb_sa_sync) {
-			kvm_write_guest(svm->vcpu.kvm,
-					svm->sev_es.sw_scratch,
-					svm->sev_es.ghcb_sa,
-					svm->sev_es.ghcb_sa_len);
-			svm->sev_es.ghcb_sa_sync = false;
-		}
+	/*
+	 * If the scratch area lives outside the GHCB, there's a buffer that,
+	 * depending on the operation performed, may need to be synced.
+	 */
+	if (svm->sev_es.ghcb_sa_sync) {
+		kvm_write_guest(svm->vcpu.kvm, svm->sev_es.sw_scratch,
+				svm->sev_es.ghcb_sa, svm->sev_es.ghcb_sa_len);
+		svm->sev_es.ghcb_sa_sync = false;
+	}
 
+	if (svm->sev_es.ghcb_sa_free) {
 		kvfree(svm->sev_es.ghcb_sa);
 		svm->sev_es.ghcb_sa = NULL;
 		svm->sev_es.ghcb_sa_free = false;
@@ -3633,6 +3630,8 @@ static int setup_vmgexit_scratch(struct
 		goto e_scratch;
 	}
 
+	WARN_ON_ONCE(svm->sev_es.ghcb_sa_sync || svm->sev_es.ghcb_sa_free);
+
 	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
 		/* Scratch area begins within GHCB */
 		ghcb_scratch_beg = control->ghcb_gpa +
@@ -3654,6 +3653,8 @@ static int setup_vmgexit_scratch(struct
 		scratch_va = (void *)svm->sev_es.ghcb;
 		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
 
+		svm->sev_es.ghcb_sa_sync = false;
+		svm->sev_es.ghcb_sa_free = false;
 		svm->sev_es.ghcb_sa_len = ghcb_scratch_end - scratch_gpa_beg;
 	} else {
 		/* GHCB v2 requires the scratch area to be within the GHCB. */


