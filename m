Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943AE3DE420;
	Mon,  4 May 2026 14:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904064; cv=none; b=dcOnUCWd4eRnAKGqQdXlnFQK+8MhWeWce3ZxYYcUEorxicB1CeLy7JTvz8wW4bEORLnTG4x4lN+SDLFj7YgnP/dFyuAit+1qpZqnNU65hSaEgwVHVCKrohCSH3fWK89Imk6rbcjJQo99/y8dhidstirx5GOMZtZOElssp0mCexA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904064; c=relaxed/simple;
	bh=9NMoExrYcWdGLbiKblXdZfLGlS72p8S2vB6UjYPWIgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZIZ6tq1uYiXP583xnEqiPnCvnCJLiveZ5wGXnTnRzC2PsZsUSTwaR68n6fJ6r/DgZcQZoF3YWfg7sVdKDR/sb43c+Xq5sQoJ03bL/aec0Fkf1qmLsQT4q5ZfCnx6n6QthQq625m9iBoDn2DEiOzUen1P6l7yJ37yBhPngE3nrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgweQK8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgweQK8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AECFC2BCB8;
	Mon,  4 May 2026 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904064;
	bh=9NMoExrYcWdGLbiKblXdZfLGlS72p8S2vB6UjYPWIgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgweQK8cCPlpLrs8UkYO7OZ+hmTWy4Y9KdrJ0Zy6neaN6xILQOvf4Qrhzuja9RuOx
	 Ygvc7ja2fblCs9T6lfX8hkOW2AZAb31iK3jfvHZO3hV36GCG5t4Yk2uMfDTZCedl1H
	 g9rfUb/1aTepFVm4eIa6GfKZbeWx70xi5kGxkNKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 170/275] KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
Date: Mon,  4 May 2026 15:51:50 +0200
Message-ID: <20260504135149.374970869@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -4343,6 +4343,16 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 
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
 


