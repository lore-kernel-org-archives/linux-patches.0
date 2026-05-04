Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F3A3BE630;
	Mon,  4 May 2026 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904062; cv=none; b=YjQSeA3kK55oOezJQIXQkzwfYnMf48Go2emAsMBeawpQds8xPn6wdhKD4JQi9IYU9uNUMIUAV6jmQ1maV0FQDwtvrUD0fXf4zCXOPCDbDp8eGCvGUs0YSOyLJi5TsivutazmbBCUJ5XSI/FosYYyJcYreJiImc6L9EgN61rMqlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904062; c=relaxed/simple;
	bh=a0A5bH5KE0ARJmzCX9beuG93tR0bURAcwUKpXzNhgHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UO6fsllj04BqIiW1vtfRi2MNnB75Hmd15KUlFhIzQ+zbkjqOqjD8IX24Pn3Q+bYrc2nULGNErCDvPReF0SvjYWgzUPTuqK6tZ03mywuCiYgKwUFv8BlrXIQ/VKGWO8yGQGtkI76VH6BbASHVjlzBFDZh1loppmCwYacv3sqCglA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KC+a8xHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KC+a8xHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90578C2BCB8;
	Mon,  4 May 2026 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904061;
	bh=a0A5bH5KE0ARJmzCX9beuG93tR0bURAcwUKpXzNhgHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KC+a8xHnEWesWmqSugnv11liTS8Hjp87NroqY76fTEsmfcd/GRV5hrGm6AZi3nlWT
	 XgtGhMJv7DWi7kGDWSj2KUKF8BYZuhdstrwVeKsAeIkbH9G8dJ6XSoLHG09viRc2H1
	 msh6r30tOACtlNXi5dEZYbtxPW0ly5s5pZdIvFx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 169/275] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
Date: Mon,  4 May 2026 15:51:49 +0200
Message-ID: <20260504135149.336305377@linuxfoundation.org>
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
@@ -1875,6 +1875,12 @@ static int svm_set_nested_state(struct k
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


