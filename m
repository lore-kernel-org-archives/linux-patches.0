Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C59341AC7;
	Sat, 30 May 2026 17:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163462; cv=none; b=YnM9FArSjhx0dGL4LlDOSCqEYZ3mGmkxd+JcHULFCoLpQcIuykqJbuww6RN3WmflcoBaavP9NsRNmGSoJT1e/UBlG9Zgd7ijryKL2/RCPULDLi1i6TQyPC2/Wo78KyAiOltHnEoZnkkshw7sSdITi6FFYa40v+oyusSPL2hG3mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163462; c=relaxed/simple;
	bh=31bf+vrSLiyi7gPpFooDMIWt80GxMnpgJaRbEcUClZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTCMWXId265gUu6nxatSIPA5kLwOEMtGP3fc5cwQNEEMgjChVcapZe2JaFGHXox1qxLy+8m++rZHpBmxy75hn0VhfYGyROa5cdZ4E5OY2klbYnyvLSZAphyq6R/+5o5+yfYswkowvx42S5o9MyPaVNS6BuGTZ59Z6R73LavLYmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0wwe5UZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0wwe5UZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DEF1F00893;
	Sat, 30 May 2026 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163461;
	bh=8bVtsaH0stdXCBXoqomRAcnLAnkB0dImmB3thhhvmGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0wwe5UZ/W13+Kfl6wdp/o7eub7kKodWtSF6YUFpr+kk7Q0MMrmrnxM3ynhYRwCeT
	 5bWSiW3TVcDAF9p8P3PavDPTg1KKsuEll2nEGSCI0olclrx2I27u0t8LKGM3T5ES67
	 jZbN1jIw4T+ZYM6HBBJLCDJZp3piHoctm5OSsf3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 236/776] KVM: nSVM: Ensure AVIC is inhibited when restoring a vCPU to guest mode
Date: Sat, 30 May 2026 17:59:10 +0200
Message-ID: <20260530160246.628949472@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 24f7d36b824b65cf1a2db3db478059187b2a37b0 upstream.

On nested VMRUN, KVM ensures AVIC is inhibited by requesting
KVM_REQ_APICV_UPDATE, triggering a check of inhibit reasons, finding
APICV_INHIBIT_REASON_NESTED, and disabling AVIC.

However, when KVM_SET_NESTED_STATE is performed on a vCPU not in guest
mode with AVIC enabled, KVM_REQ_APICV_UPDATE is not requested, and AVIC
is not inhibited.

Request KVM_REQ_APICV_UPDATE in the KVM_SET_NESTED_STATE path if AVIC is
active, similar to the nested VMRUN path.

Fixes: f44509f849fe ("KVM: x86: SVM: allow AVIC to co-exist with a nested guest running")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260224225017.3303870-1-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1407,6 +1407,9 @@ static int svm_set_nested_state(struct k
 		goto out_free;
 
 
+	if (kvm_vcpu_apicv_active(vcpu))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:


