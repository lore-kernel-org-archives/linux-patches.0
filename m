Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938B541A8F;
	Sat, 30 May 2026 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165885; cv=none; b=CMa2UQzdN/HsQMZF6S8Yarfv+kqXdCiR5IUhov9uaurSqOwm5AW9SvM3VOvi5IrEr93mZng3+j80BgxZjgqdtpfyo45rgfM6J0uovvXiT5FQ1qQA3ovEGPGbvVjf6BmiDvU5cWTBsb19pl31EyOoCcm0kkFTt3J2tEvhJyPbTHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165885; c=relaxed/simple;
	bh=onmZUzrQUeDy/Pe3cil1HcH5wv2r5rQ5+fTMl7VNYFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVAbndHO5+xh/qOF22wpcL43V3KJw+J+7F1540OQM5XNs/2fjVIan5XspzrgQhgzffkd6iN2Yxt9zxH78h/MOTO2OFQbP1Dwjlgr3kuvNBkHGI/7psxIug5uGUeQbkVtR2UqX0jkfFaZqJIx78uHMe6WKtRba4D3teHNbRtyeWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEG1Nb1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEG1Nb1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1101F00893;
	Sat, 30 May 2026 18:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165884;
	bh=P+w4yQwMOHPSiIQ7bHiqKb0qDWGZDICgULoAcrzeQe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hEG1Nb1ngB173BYw4hA9Ks0XuiTDph+rfjo2AAgxxUXcakrSc7+pap0tW4JjofPoh
	 XNRaUQY2hABzSBp4NvEZTKWt6XFtEmlbNRUcmv1at0BZTgewwrpZHtCwCxCjYoPww7
	 PHWU5PpOgyRDJHI+f16h8bUeoCt0AD1bhzSwd/tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 177/589] KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
Date: Sat, 30 May 2026 18:00:58 +0200
Message-ID: <20260530160229.538712833@linuxfoundation.org>
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
@@ -3677,6 +3677,16 @@ static __no_kcsan fastpath_t svm_vcpu_ru
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
 


