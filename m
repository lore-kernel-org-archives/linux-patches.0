Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565DF29E114;
	Sat, 28 Feb 2026 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301356; cv=none; b=SlM4N2Kk2LZNInOujnxy5TxrbZ1WVXFqJUDrICTrB2ncnsJfq5ep/YINuyP4em3I4O/Z78aKClZt9UWz5PfMjz1HS2+LW5c1HcdGU1287QhZh4CrlD+dx0aO20akbSigClSdp8xWBTkhiqKaiIIURukE6oZcPupeUhBA6Un5LsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301356; c=relaxed/simple;
	bh=7dU/V+2XQLzBWq9sNnZn08HsxV6n76VONcvRUq7usoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtwxSUDbKjiz+dUAId2YymlEIOGyhItN/mAU5aIfj8NGOEt1OWbN+UHCLF87PYiLhLvy3PxsEwNyMAjrF/wOirU9ttiQ/OMg2YzIP7X1BskcA6VzpUn0RQFXOjuk9xEs4zP+rfMrF7i4r4QMhSwcM8zgo1KZtEMADK8pQ04qIE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KW/U5ZaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KW/U5ZaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A19C19423;
	Sat, 28 Feb 2026 17:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301356;
	bh=7dU/V+2XQLzBWq9sNnZn08HsxV6n76VONcvRUq7usoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KW/U5ZaAwgeR0Qwr11mcaFO4BtRIBij7o2evQi4gcBzkPY/ig9dcnDxUKF1QALFXM
	 Wm6GhcQwk1WDp41gojIdDhPhwbmHBIKUdVOULs5F483l80CY8p/QXK5RVfXC7LcldZ
	 x6UYXbug5IeC1ctquBGclP4KeFq0Wai1n+b55YaUli9wYdO+GMqSEtvQOkOkzlHEtf
	 ckj6apqyLoly9ttnaOstZScH8TI/cDLf4v3UL3iidm4qnUEtv+kkxXpND9HfYuefu0
	 /Cn/9k5gICREG0O5zFRMo+/dsS2eU/Y1XMJgck5i9Wbu6OTRJxKqyJQqSQLVGjUf+3
	 1MJUwIgxix19g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	stable@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 544/752] KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation
Date: Sat, 28 Feb 2026 12:44:15 -0500
Message-ID: <20260228174750.1542406-544-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yosry Ahmed <yosry.ahmed@linux.dev>

[ Upstream commit 127ccae2c185f62e6ecb4bf24f9cb307e9b9c619 ]

Commit cc3ed80ae69f ("KVM: nSVM: always use vmcb01 to for vmsave/vmload
of guest state") made KVM always use vmcb01 for the fields controlled by
VMSAVE/VMLOAD, but it missed updating the VMLOAD/VMSAVE emulation code
to always use vmcb01.

As a result, if VMSAVE/VMLOAD is executed by an L2 guest and is not
intercepted by L1, KVM will mistakenly use vmcb02. Always use vmcb01
instead of the current VMCB.

Fixes: cc3ed80ae69f ("KVM: nSVM: always use vmcb01 to for vmsave/vmload of guest state")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260110004821.3411245-2-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d758bff6e068b..eed104207a11a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2094,12 +2094,13 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
+	/* KVM always performs VMLOAD/VMSAVE on VMCB01 (see __svm_vcpu_run()) */
 	if (vmload) {
-		svm_copy_vmloadsave_state(svm->vmcb, vmcb12);
+		svm_copy_vmloadsave_state(svm->vmcb01.ptr, vmcb12);
 		svm->sysenter_eip_hi = 0;
 		svm->sysenter_esp_hi = 0;
 	} else {
-		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
+		svm_copy_vmloadsave_state(vmcb12, svm->vmcb01.ptr);
 	}
 
 	kvm_vcpu_unmap(vcpu, &map);
-- 
2.51.0

