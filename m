Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D643502BD;
	Fri, 21 Nov 2025 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733518; cv=none; b=F2TmVEmFHm53tbyYy3K+7Nqby1mwXqTkM/sBcs4yjhw00t+BMoyVRQMMV/W+FCa5qcO2KVF8V7Lxij8/Z/Zrpgnz2d+ZfDnkp4cPr5R4fiOlRIKtrUdiDZNOQQ17bewtulYJ8S1n4RtIkl1T/pFdFzauJbJrZ5p828LQMEc99QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733518; c=relaxed/simple;
	bh=DDADBvhAL/GyopbpiAO/gwjNVfWxxLPdKU4Dgo+eqVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pf7BGBxA5SHDqGtGAPCywn6na7MbxL703N9JblUaQgOP3deBtp8spssbfqnZuy4S38mNH+nU8ttvNtcxvzcyipoC+SOVqRBhtsv2+YmuQ3DbZOsTMCPaRn+pzfF1o4Uw2T6z6Fja0exjyi2uPMmiJImZRHj6UIfG41F1v90D9g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hu9dLWup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hu9dLWup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A72BC4CEF1;
	Fri, 21 Nov 2025 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733518;
	bh=DDADBvhAL/GyopbpiAO/gwjNVfWxxLPdKU4Dgo+eqVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hu9dLWup2dZSiYkxhTyH0653HM6Fk/GFWKra9SdKOPu9XxodNV37VG+MP7/jz9EDr
	 bHSQlyYQdn4icTyj3+smETuB0HgjP/UBZYWZMzDg6Ew3F477FH8wcChDuqVeMUzfvi
	 R9CJkNMclP/HfxHqnHX08GocBu9LBapwhRtTJg3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Rizzo <matteorizzo@google.com>,
	evn@google.com,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 462/529] KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated
Date: Fri, 21 Nov 2025 14:12:41 +0100
Message-ID: <20251121130247.449726178@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit dc55b3c3f61246e483e50c85d8d5366f9567e188 upstream.

The APM lists the DbgCtlMsr field as being tracked by the VMCB_LBR clean
bit.  Always clear the bit when MSR_IA32_DEBUGCTLMSR is updated.

The history is complicated, it was correctly cleared for L1 before
commit 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when
L2 is running").  At that point svm_set_msr() started to rely on
svm_update_lbrv() to clear the bit, but when nested virtualization
is enabled the latter does not always clear it even if MSR_IA32_DEBUGCTLMSR
changed. Go back to clearing it directly in svm_set_msr().

Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
Reported-by: Matteo Rizzo <matteorizzo@google.com>
Reported-by: evn@google.com
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251108004524.1600006-2-yosry.ahmed@linux.dev
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3183,7 +3183,11 @@ static int svm_set_msr(struct kvm_vcpu *
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
+		if (svm_get_lbr_vmcb(svm)->save.dbgctl == data)
+			break;
+
 		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 		break;
 	case MSR_VM_HSAVE_PA:


