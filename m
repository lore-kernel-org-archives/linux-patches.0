Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83D7347BA9;
	Mon,  4 May 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903359; cv=none; b=bbyDOJHCmcPq0ifCNsHAcobihiZdrt9E00UrQx/UfgSCVIW1RtinGmn4a5bzr6Qhks46FMgp2aX3yDjy2cdf9LXlmLHVgy/Ct5OjAK+feLz2WzVxHU+3W+rH2cAHEhWzA2p1v8mcYhtdLMTXwjTAF4BfBwsVATNPNfjsdmSOvz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903359; c=relaxed/simple;
	bh=OvDrJ68uKcN8fgdTjuZe97oRxeyyhN8y43vgPuzuYWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9Zx/He/FX451BPfQq4MXykcmv1aEnlXzZqEcwtEshV1CscLWh+vz6tVBvWQmDGCiNGmVeCpulTor9BBpgoqUA+qSclajmC96KreknBfIjOP4m8GJhgLZ5/XMFJ+ISgUPHOqOztAxpLI68qcaDe1v2teNoZc19785Fr2GlaVIIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHqClG4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHqClG4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3F7C2BCC4;
	Mon,  4 May 2026 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903359;
	bh=OvDrJ68uKcN8fgdTjuZe97oRxeyyhN8y43vgPuzuYWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHqClG4ELHEmI7jPVhGYgBmHew92smWeA9cQ6S7368ryyMTzSdAuLnXbE0W1/zVxo
	 u3DIZWvgnU5AjKo1QN1FmFG97hspBX92hH57a98S3ymthqgiqVt+dbY/LFgVrNF8vE
	 A12o7Fj1bvudqD/bLfVgBoFqNcXMIAZHRzn6P7Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 202/307] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
Date: Mon,  4 May 2026 15:51:27 +0200
Message-ID: <20260504135150.482178252@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit e63fb1379f4b9300a44739964e69549bebbcdca4 upstream.

When restoring a vCPU in guest mode, any state restored before
KVM_SET_NESTED_STATE (e.g. KVM_SET_SREGS) will mark the corresponding
dirty bits in vmcb01, as it is the active VMCB before switching to
vmcb02 in svm_set_nested_state().

Hence, mark all fields in vmcb02 dirty in svm_set_nested_state() to
capture any previously restored fields.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260210010806.3204289-1-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1918,6 +1918,12 @@ static int svm_set_nested_state(struct k
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
 	/*
+	 * Any previously restored state (e.g. KVM_SET_SREGS) would mark fields
+	 * dirty in vmcb01 instead of vmcb02, so mark all of vmcb02 dirty here.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
+	/*
 	 * While the nested guest CR3 is already checked and set by
 	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
 	 * thus MMU might not be initialized correctly.


