Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509AF212564;
	Sun,  7 Jun 2026 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828714; cv=none; b=KXGUi1QX5Sp2yQ7e2N+xOacJSC+z/QWFCopEcH4O1mSqeMxjGLE3D0ChKuZ8sHL8s8bhSwiFUrgyVaPas8MM42za64j0yi1yNO9Xy161W1ylje3EhY5rT2BlNCX53LxAR1APYRMf4sLWAXQNGTDOv06JyhNJVw33UzyK5YWz+PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828714; c=relaxed/simple;
	bh=HFHaWuVvv/COKMsttcHp56B0kdUGjthrpABjJ6vIjCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmKsTu2Blyu/3MIJcuDPiabf9YT4uyOPCR5G/ohg+doS8LQDP1SasOhThW1Fn3QTSqt4j4tuajskm7LWiiafjEK6dzGEpPn3DKPOFu99oCYvUBs+5csimqqqEIY4HcFBP3c/TVRPRj9c2Y/CsBci2+KLDJ0jFkIk6gH/WcK1yaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bem741A4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bem741A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C871F00893;
	Sun,  7 Jun 2026 10:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828713;
	bh=Oq2kgl1xvLOm46xHvphg3/a8ByX816oZVZG4HObyfUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bem741A4U+nTi8JfHt1WvV8t7QlkyFVdT8E293Klt4CTn+t18P2Ha/145IpaXq2jM
	 zFccbocVWWXU9cw1agR/AjWCGMu0qslsMQ89QxFmb9INmdqQ+G8wgen57gJtcZhUeX
	 rFAFDERtY6GTR+VOAibWudqL7vhoZXnRLXwuDUzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 160/307] KVM: SEV: Dont explicitly pass PSC buffer to snp_begin_psc()
Date: Sun,  7 Jun 2026 11:59:17 +0200
Message-ID: <20260607095733.600155715@linuxfoundation.org>
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
@@ -3675,7 +3675,7 @@ struct psc_buffer {
 	struct psc_entry entries[];
 } __packed;
 
-static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc);
+static int snp_begin_psc(struct vcpu_svm *svm);
 
 static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
 {
@@ -3710,7 +3710,6 @@ static void __snp_complete_one_psc(struc
 static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
 
 	if (vcpu->run->hypercall.ret) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
@@ -3720,11 +3719,13 @@ static int snp_complete_one_psc(struct k
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
@@ -4414,7 +4415,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 		if (ret)
 			break;
 
-		ret = snp_begin_psc(svm, svm->sev_es.ghcb_sa);
+		ret = snp_begin_psc(svm);
 		break;
 	case SVM_VMGEXIT_AP_CREATION:
 		ret = sev_snp_ap_creation(svm);


