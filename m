Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8FF313E34;
	Sat, 30 May 2026 18:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165892; cv=none; b=SYE0f8PS3ivBaokiVnBvF1yA4AaXqXZda6H/wpPHaOL/zSGnWBk0MoDPTIcD+mmA79l8m1i/AcLvGrba2nosGMFO1ZyGJoZonSswClhc/PM4W59sg1jgqOX8YCWgjvGsRtanHiWIJ8FfaUcxT7JTCoxky7SOh31BsgRJQcvg2X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165892; c=relaxed/simple;
	bh=dVYQddWqBMAhvPAyyU3vQukeqnwBb0BLpIN9+9F+IVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8eYtMrhsxwBcydPqcYcP94cMUBqHC9/XWJj4N8hA4+1eOE8FOSfidMt19+VAKYxm+diO8cBrBdkdhLNfrV5LU9p1RNn7VhxnkHIYpi2Ro3A4D4LMHOn8oAtUkTskWxh51KeSu8SdwYaf9gifStqhW8bI7N9WT9H5b30oJAJeTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBxiK8j9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBxiK8j9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D980B1F00893;
	Sat, 30 May 2026 18:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165891;
	bh=vQqrmxjB2WwMB5LIpRB0IDIzJEq4IgF+64DBh29k/Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBxiK8j92R5uDxLTP6liLaJ2ZVIsZzUB5USlPj0aYGse4g5i98nj4Jss9JN0uvcVp
	 ftdbX/StoeO1n8NOO+wTkjo+rohG34rFhK1SeZzg4s2/cDQTclMOOQTAH5g0SifKeD
	 IQLCJ3bHtZjl96OGVTXdRaByMyV3s31+6yxYh250=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 179/589] KVM: nSVM: Ensure AVIC is inhibited when restoring a vCPU to guest mode
Date: Sat, 30 May 2026 18:01:00 +0200
Message-ID: <20260530160229.592142604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1258,6 +1258,9 @@ static int svm_set_nested_state(struct k
 	load_nested_vmcb_control(svm, ctl);
 	nested_prepare_vmcb_control(svm);
 
+	if (kvm_vcpu_apicv_active(vcpu))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:


