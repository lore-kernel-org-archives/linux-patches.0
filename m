Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE99333C53A;
	Fri,  9 Jan 2026 12:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962436; cv=none; b=BwuDG9Xc6ov9gpizPPubI4irxHkRPWpqfxCEEI7ug4hobLq/E2gu25o1Gg5W1fGzrNssFmOTpINKO//DjWE3f3Hni/DWwLsTy5vXqykrGvj5B+h4eTv+TeeXn/anpXJ5KLsq/JLpFX/JQoI5dXZuMqtLRZ8zqx/i8yBuenKJuZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962436; c=relaxed/simple;
	bh=YPn+kSfBXV130mBZgM5IVRVQzlIw0nA0mA9wmGt2irk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujhrnW7i3M6QxVTXUSVJTh6y1cGcmZCyBj4voOqWyzvYpqEj8vZGfX71g14xlvlPry60KB8agNAQ5LNC8xcAVvWLlRC+7ZjNW9t33SrlVE2NYbRHLnxf/IULKYwM978kfuNzQNYEl7B3ENTTQP3nCi/dAv74nNBeg/rTPniscE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMcvHWqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMcvHWqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08725C19421;
	Fri,  9 Jan 2026 12:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962436;
	bh=YPn+kSfBXV130mBZgM5IVRVQzlIw0nA0mA9wmGt2irk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMcvHWqkVkW0OztFbIlIZvhzZtKgozR5fo9BcueBwJq35sGWY/plQCbQEllFm3Ezs
	 XKf/I/AesX9t8dihM74dJ5Ubf5uzvyInKU+tCD1P//1ukG6sW5Km+fAKAspsGFl59d
	 1NIP9Pa6rjTdoAIeNeecMUSa6lWn0R06b/uFHtJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Rizzo <matteorizzo@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 365/634] KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
Date: Fri,  9 Jan 2026 12:40:43 +0100
Message-ID: <20260109112131.257886031@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
@@ -639,6 +639,7 @@ static void nested_vmcb02_prepare_contro
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
+	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
 
 	/* Done at vmrun: asid.  */
 


