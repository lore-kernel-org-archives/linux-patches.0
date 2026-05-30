Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF033A542F;
	Sat, 30 May 2026 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160198; cv=none; b=WbLG6INVfliZQ9/p3HVBKmoE3YOGkshunmo2rJDhw6zlwAN0czZoQGaoNXUZVSA4p5sFz7YC/KpBVnjbdVchJ2Gecpg3Qke6RVppDCxS53u9z0xWwRKLNYC3QzNzMiU8ag/3mkPCY7Z/MpR3Nv74CT7f6/JhpYkJM9sj2cVr2j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160198; c=relaxed/simple;
	bh=cp7o8fbXY0RAQH45ZloItAZdlAeKlr7seNWmFkCyddE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlgZlYdH7LEXZ3BvfS4gM7Rvln8UIuteRubpVTQ/4/exlgBGIWlhZzqG19oR0KEIyvf7Fw59nKzCCKJPd6XaiWcqowqM4POOz3bqmGH0pK2bPNFqcejYLsUSX2LbJ3XsbZUeW4Aqy/MYprBRVcB0coK32wdg3Evhj9PKReGws1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpefL8kU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpefL8kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42EB1F00893;
	Sat, 30 May 2026 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160197;
	bh=1Tfkw3CGSqADUtOWflMUpq9ibblrJ2CGNZhtJZgJxDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpefL8kUPW/Cpn2NrJH8HDb6Wn4ACK0GrRE5HHfZHsRuq9S8OlwcCRopqxVKmYGsN
	 FqKWjne7e8rJIWHI9iq8TNGeultORnFeNoDXKRyuvxZj3XWFeSGT9WhJAWOp2lHB0L
	 dteLiSLeMXQZnBoACCyVoPy5AAPXGaLJRYX/jCoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 234/969] KVM: nSVM: Sync interrupt shadow to cached vmcb12 after VMRUN of L2
Date: Sat, 30 May 2026 17:55:58 +0200
Message-ID: <20260530160306.923628337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 03bee264f8ebfd39e0254c98e112d033a7aa9055 upstream.

After VMRUN in guest mode, nested_sync_control_from_vmcb02() syncs
fields written by the CPU from vmcb02 to the cached vmcb12. This is
because the cached vmcb12 is used as the authoritative copy of some of
the controls, and is the payload when saving/restoring nested state.

int_state is also written by the CPU, specifically bit 0 (i.e.
SVM_INTERRUPT_SHADOW_MASK) for nested VMs, but it is not sync'd to
cached vmcb12. This does not cause a problem if KVM_SET_NESTED_STATE
preceeds KVM_SET_VCPU_EVENTS in the restore path, as an interrupt shadow
would be correctly restored to vmcb02 (KVM_SET_VCPU_EVENTS overwrites
what KVM_SET_NESTED_STATE restored in int_state).

However, if KVM_SET_VCPU_EVENTS preceeds KVM_SET_NESTED_STATE, an
interrupt shadow would be restored into vmcb01 instead of vmcb02. This
would mostly be benign for L1 (delays an interrupt), but not for L2. For
L2, the vCPU could hang (e.g. if a wakeup interrupt is delivered before
a HLT that should have been in an interrupt shadow).

Sync int_state to the cached vmcb12 in nested_sync_control_from_vmcb02()
to avoid this problem. With that, KVM_SET_NESTED_STATE restores the
correct interrupt shadow state, and if KVM_SET_VCPU_EVENTS follows it
would overwrite it with the same value.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260225005950.3739782-3-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -400,6 +400,7 @@ void nested_sync_control_from_vmcb02(str
 	u32 mask;
 	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
 	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
+	svm->nested.ctl.int_state	= svm->vmcb->control.int_state;
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;


