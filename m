Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D488E3A3E76;
	Sat, 30 May 2026 16:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160194; cv=none; b=iglRf7n+Uezzi0XJYglmjHt7Wm4M4qmayP1BI7Wcjxt3O3416zx3E0mD0gUIybIK7Bul6oOMND96nPd+mwyNOsQ5JxsWVePE46aPmbKKI/Wv13AmlTJ/vwbNJYlmrRj7u4OQH69Hn68wRxI9xcawnnprpSMMeoUZeXZlMJkHF88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160194; c=relaxed/simple;
	bh=xjSVlGjUIIV/x68C4CFwqMqNazaG8/QXwAxNBtUxHvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB0W6Dn66/F05CU9iQWUNrBEGjd9JLULeFVf83IIGjem4v8ZxVhN2BxHG7JR/st5pA8KFciygnbRH9PTmH62zYB7JLRwoR4oCNB3hDObHRxYTphtTo1SVs07mM6vOfC+n7k0wO03YxYy2YVseP6DTv3nzpQ941lN3EJaew6aTJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5Tt0kTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5Tt0kTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241241F00893;
	Sat, 30 May 2026 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160193;
	bh=xPqJMDokA8I3hZ6Lve2Tc3FmXDTPs9lQXuLUTfSczGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5Tt0kTI5x+dKKl2RV2Hy2HB/oqSHCZ4EbUAnizyCsZqIcv4a/BnbIT+KGZ8V2zpx
	 FNIy8Q/jePDZN+GYlBr+4Byithy/vxPdYtznl3tjlvdkFDPFZt2TF4iL5bUzEBEDCT
	 hwfW7p9vivKbQCqiTodMv0Pk6zGVVSUFcbWdQ9GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 233/969] KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
Date: Sat, 30 May 2026 17:55:57 +0200
Message-ID: <20260530160306.894468203@linuxfoundation.org>
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
@@ -4146,6 +4146,16 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 
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
 


