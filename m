Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624F42D3A69;
	Sun,  7 Jun 2026 10:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828343; cv=none; b=GY7Mcgv97J4CrJ/EMANaoCq19SqGNf1pb2DGa2tM8G58C86KTN54m73u5F/2JM3MNXuDTJpGM67Tj/tTA0d+zwuJi2rmWlHLOhuMv9IQphGsu9t+v7BbUpm+CaQpJQtwh7J5bBH7zcPbMCWlB6iYRWOb0m9FtBn2efHbU+kRTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828343; c=relaxed/simple;
	bh=stF5sFI42AYyf5jDFwBuDi/MzK/GuvJngwrg0/cNv38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UROBYjluEH89SJlqLZ7ygvTTYNMfZntD7/7HD85KHVTUFybu4rO71W3E8dsRO6pPEs5rbIl6BFd2/DZhXfy/30OQ+JzzTHcag3Z9LJcTQonUNzvv4VZaXKD3ZOojBbootVkGlfBh5ucwb6/DYzbkvnz8ApJP/zvr8w4wmmGFqZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHRLtV6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHRLtV6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1AB1F00893;
	Sun,  7 Jun 2026 10:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828342;
	bh=T/pMFfAn8mSQ7t34uTMDiMHCzWik+o3zhHILp4aZUbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHRLtV6PvtOCpwyryH1e5ByBEp5jFJdSw653+TNfUWM9e2vqNbd8KfJvkgSwcp5wi
	 AObbLZmsuxSJS31NLXiErWtu2ccnmyOXpt9IIwzsoTJwJwk3kbOonwYm/lEYxyFVdC
	 S13Kzc9W5TnA5mkraUDf8BoUi75hkEk78rl2xPAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 151/315] KVM: SEV: Dont explicitly pass PSC buffer to snp_begin_psc()
Date: Sun,  7 Jun 2026 11:58:58 +0200
Message-ID: <20260607095733.152954953@linuxfoundation.org>
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

commit ebe4b2dc9cfbfb2d8f665667c4d08f4c6c9bec05 upstream.

Stop explicitly passing the PSC buffer to snp_begin_psc(): it *must*
be the scratch area.  This will allow fixing a variety of bugs without
further complicating the code.

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-9-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3789,7 +3789,7 @@ struct psc_buffer {
 	struct psc_entry entries[];
 } __packed;
 
-static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc);
+static int snp_begin_psc(struct vcpu_svm *svm);
 
 static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
 {
@@ -3831,7 +3831,6 @@ static void __snp_complete_one_psc(struc
 static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
 
 	if (vcpu->run->hypercall.ret) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
@@ -3841,11 +3840,13 @@ static int snp_complete_one_psc(struct k
 	__snp_complete_one_psc(svm);
 
 	/* Handle the next range (if any). */
-	return snp_begin_psc(svm, psc);
+	return snp_begin_psc(svm);
 }
 
-static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
+static int snp_begin_psc(struct vcpu_svm *svm)
 {
+	struct vcpu_sev_es_state *sev_es = &svm->sev_es;
+	struct psc_buffer *psc = sev_es->ghcb_sa;
 	struct psc_entry *entries = psc->entries;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct psc_hdr *hdr = &psc->hdr;
@@ -4494,7 +4495,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 		if (ret)
 			break;
 
-		ret = snp_begin_psc(svm, svm->sev_es.ghcb_sa);
+		ret = snp_begin_psc(svm);
 		break;
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);


