Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7694304BCB;
	Sat, 30 May 2026 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163449; cv=none; b=f1v5JvbKsAIkYTVJbBJ/gkn1me/3XWNr52D27+rzkzIDnPJ1QQKw9yjqW4WqHdAbV2OMj/C81MO6980MfgiH8vPJQA7NiwZ/18YesovJJ1IYopi1rA+sexoISYz1hw1s9BIby2UH5yge3ORs81WciIAufadmgE20L80I8nUyulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163449; c=relaxed/simple;
	bh=elBKwq7aKBhwfC7rOeaF3mr05kBfbUpeeCtyXaU4cC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9LPMqbUwsanqnSH7S2kgtVDpRUIJvSNkAwaE4k+rr0xXFIfM9fVwOYTyUWTF4sn47qnoUmP8s0bk7FKoi0YsAT/gUkm0vt9D/OEMyU77El79XSZkQgZhGXPNOiHeJGvvmIln+ukOa9m6XGV1d4IJUqb3mEEuNvXP1HNIT0lxKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkb1E2kQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkb1E2kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D301F00893;
	Sat, 30 May 2026 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163448;
	bh=1CT9uzq54xWQMGdveHdb6R99jb/b+5KLJH7m4h1UJL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkb1E2kQnNFoS0NfpPw1NJngP6/E+MJD6Y+F4+mBVxrg1/whByhOdEhdKt2FT9za7
	 odKNrwaOe9Xn7jHSICkzr0MHgaAL7VtUc4v0X4OifXB4lEn7MlD2gcuQ1U+TwOPv4N
	 EoRhUPoLOg0mVPkH3xTwXu8MW+D0XWJE2KtNQ7QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 232/776] KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
Date: Sat, 30 May 2026 17:59:06 +0200
Message-ID: <20260530160246.525613842@linuxfoundation.org>
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
@@ -3952,6 +3952,16 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
 
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
 


