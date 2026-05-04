Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF2C75801;
	Mon,  4 May 2026 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903470; cv=none; b=L3UQiSXBUFkgG2o7l0//QbnCc05g4/p/2qK5K3NYT3jv1KT6oAg9SzGjnn7uM6bmYrXCCmwlQ3NULOmP2qBN80EWCrGnFDtJAMT3cFN25PgKvAZxwPwZ3FS+5bsbeCgfsQwu9oc4mcmqciiLzR1T8/78h0REsQG20O5zQ/2A0Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903470; c=relaxed/simple;
	bh=I3oN7xA1HGrgt+P08ojP3GEQiRxuCpoIaG9fpf4G2+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gExmW4qSS5xAZFBGrPp89Ek7txBuMNxzGLkhHIRqxPQSnGFeSv2PpiVyzgckCGX1uxLrZ7YCQ9v5snMtis91cHcV56GWHpF5bVIvAnxQ4rcgdV51QGKRne0L1hGSvKLm7hQX7QlzcKW+1tPOK9rfXiA0pNlinKMRtlyI6Ai5n5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOBrEVzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOBrEVzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99DDC2BCB8;
	Mon,  4 May 2026 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903470;
	bh=I3oN7xA1HGrgt+P08ojP3GEQiRxuCpoIaG9fpf4G2+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOBrEVzHPtGrkhbhcxds5Cgw4+J0Trft7fB0TG797u4PvxmS+iY5Gld156fMCGt1G
	 fydKt272OT7MW0H8/App/fGGMN5QuRhZrF1oRZI0b5yQol8hgfPZxe+FibV9GplAak
	 sqwHLhspgJWZSsK7jiLUii1EwLDOndSCMJx7ENNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 203/307] KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
Date: Mon,  4 May 2026 15:51:28 +0200
Message-ID: <20260504135150.518299274@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

commit 778d8c1b2a6ffe622ddcd3bb35b620e6e41f4da0 upstream.

After VMRUN in guest mode, nested_sync_control_from_vmcb02() syncs
fields written by the CPU from vmcb02 to the cached vmcb12. This is
because the cached vmcb12 is used as the authoritative copy of some of
the controls, and is the payload when saving/restoring nested state.

NextRIP is also written by the CPU (in some cases) after VMRUN, but is
not sync'd to the cached vmcb12. As a result, it is corrupted after
save/restore (replaced by the original value written by L1 on nested
VMRUN). This could cause problems for both KVM (e.g. when injecting a
soft IRQ) or L1 (e.g. when using NextRIP to advance RIP after emulating
an instruction).

Fix this by sync'ing NextRIP to the cache after VMRUN of L2, but only
after completing interrupts (not in nested_sync_control_from_vmcb02()),
as KVM may update NextRIP (e.g. when re-injecting a soft IRQ).

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260225005950.3739782-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4436,6 +4436,16 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 
 	svm_complete_interrupts(vcpu);
 
+	/*
+	 * Update the cache after completing interrupts to get an accurate
+	 * NextRIP, e.g. when re-injecting a soft interrupt.
+	 *
+	 * FIXME: Rework svm_get_nested_state() to not pull data from the
+	 *        cache (except for maybe int_ctl).
+	 */
+	if (is_guest_mode(vcpu))
+		svm->nested.ctl.next_rip = svm->vmcb->control.next_rip;
+
 	return svm_exit_handlers_fastpath(vcpu);
 }
 


