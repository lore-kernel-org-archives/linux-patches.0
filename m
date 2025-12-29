Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F25F3314C0;
	Mon, 29 Dec 2025 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025905; cv=none; b=CFHhm2BbF4U2xF1SkIdodlb04s7DFF65n7ZG2ySxev3gNpt2rtXqcbfzf1hd/53oUv3qcf4OSi3eciIj+kZRdC8tPnKg0qjbS7kBl8+IYJL43Gc2v99TKLICMF2AfJgLUzqAjh8+RJamQTy2P20TPiP4269N7YfWpbWUeuQG3wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025905; c=relaxed/simple;
	bh=uEqpNlfsNuC0h66dxAC3ohI1Notarjol9gSQ2hC9fxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsZqrod3H8nxl+aD+px02WI11gWFZufYnqy/tfokpEWfZqs/uGg1xvbSgZ9tbRNoW59o2sVSE7geudAu5gXEYjJK1Iwdxx2C/K7WisVucOQ2ik1dNQ9sS2hyqHx7y5Qg8/1Va0w8XC/xUSsUc1ucJAIGyesQ1QvtfPXRVfGruto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilOIJ9Ii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilOIJ9Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEB4C4CEF7;
	Mon, 29 Dec 2025 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025905;
	bh=uEqpNlfsNuC0h66dxAC3ohI1Notarjol9gSQ2hC9fxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilOIJ9IimVMfnXe1zV0OpROlslbWQ1KnkVN0sHq+9ozSSUYl7dfCzzFFHUBMyvhX/
	 ETNl1N2ycwSbUi8TgJJHvy5FB8mHjuRsCk/NGgwuI8sxUUuTi9mY2qeR8Hkt9sYSDU
	 qyr6Yn0k9EFyx+TaWnmaNOpFnQpc8ge6gVN55mjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Rizzo <matteorizzo@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 347/430] KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
Date: Mon, 29 Dec 2025 17:12:29 +0100
Message-ID: <20251229160737.096961279@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Jim Mattson <jmattson@google.com>

commit 93c9e107386dbe1243287a5b14ceca894de372b9 upstream.

Mark the VMCB_PERM_MAP bit as dirty in nested_vmcb02_prepare_control()
on every nested VMRUN.

If L1 changes MSR interception (INTERCEPT_MSR_PROT) between two VMRUN
instructions on the same L1 vCPU, the msrpm_base_pa in the associated
vmcb02 will change, and the VMCB_PERM_MAP clean bit should be cleared.

Fixes: 4bb170a5430b ("KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit")
Reported-by: Matteo Rizzo <matteorizzo@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250922162935.621409-2-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -752,6 +752,7 @@ static void nested_vmcb02_prepare_contro
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
+	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
 
 	/*
 	 * Stash vmcb02's counter if the guest hasn't moved past the guilty


