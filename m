Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714F7425CEE;
	Tue, 16 Jun 2026 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627238; cv=none; b=SU3M1+ACTv/d0zJyRyHjUeoXBsERoU8qs1tnM+J0Lhl8AU2rrf66YiEhxatbLxW5D60lEeFggKqMSSCwwPThDyu81/Y2iR1aYhE8YG0ItJLdofPH3cfvXNbHr+C9gnJ2AmdoYN8GmE5oz8jfc/wOR7/98CkNOfhq2BhWpFTqolo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627238; c=relaxed/simple;
	bh=YgeJAsFhasyOoU8Dxl/toJsMdC9qNghb21mIaKLtJxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEvS03MwunsIFSbN6B83foU/DD4tItE05iIO0ZJl2sFTV8Q5O8wX3X2ShUIy9Y5YSuqHbESbvQQhGgc1TZ9XvkTPmRJoDlcQjSehhwOTw1Aqqu8HTehQ+JjPdUDqscDImjRBeGurB7SD6hlbmLM8wPGLCZz70dZROIL/wmem0Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjCaPXK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjCaPXK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6754C1F000E9;
	Tue, 16 Jun 2026 16:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627237;
	bh=1bkkJmEmEzIgLMD/e8KPdNDHm+SmWYC58if7cizpOxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjCaPXK96u4ZDEi923N8AJSYpqSoMI5kcXdQPNIH495y6v3o4/4twCu/17hzsqVZq
	 cVdI7DOJDf9vchrqIWXWS3+GoJyExKnkT20NAhMV0ASJ7dRZYkEWqua71R4Y6WUipL
	 KyAhkrmxIg7+o79PTO8AaubWZkPLh5BYAMKFxREI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 134/261] KVM: SEV: Decouple the need to sync the GHCB SA from the need to free the SA
Date: Tue, 16 Jun 2026 20:29:32 +0530
Message-ID: <20260616145051.292949092@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
@@ -3451,20 +3451,17 @@ void sev_es_unmap_ghcb(struct vcpu_svm *
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
@@ -3525,6 +3522,8 @@ static int setup_vmgexit_scratch(struct
 		goto e_scratch;
 	}
 
+	WARN_ON_ONCE(svm->sev_es.ghcb_sa_sync || svm->sev_es.ghcb_sa_free);
+
 	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
 		/* Scratch area begins within GHCB */
 		ghcb_scratch_beg = control->ghcb_gpa +
@@ -3546,6 +3545,8 @@ static int setup_vmgexit_scratch(struct
 		scratch_va = (void *)svm->sev_es.ghcb;
 		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
 
+		svm->sev_es.ghcb_sa_sync = false;
+		svm->sev_es.ghcb_sa_free = false;
 		svm->sev_es.ghcb_sa_len = ghcb_scratch_end - scratch_gpa_beg;
 	} else {
 		/* GHCB v2 requires the scratch area to be within the GHCB. */


