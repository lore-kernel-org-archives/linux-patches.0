Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9047F35A93D;
	Fri,  9 Jan 2026 12:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960618; cv=none; b=O3MulRbkl+PusPb0X2OvB/GG/WcCqhOqV/pKFay6V0mvDdrhhoZgeMK5CawAXVx8LPuYkJDlL73XcQFSwAE4dO6Y8koSPaA+qxlISDRQcbmbsXb6PXjDT8lLVVtWe2fYBMnAtAkzNe357ZRTvzjI8e0Y+gbgjSBXD+Xh+oC7ILE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960618; c=relaxed/simple;
	bh=DtetrF+s8XhnbuXFvcijRgBp7NjPER7O1twII2XTLlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFLKLt831YV4BbG4ooeNMTJFMgelHx+jUj3ZUNKmEGZq7rMXioVqn0icKXRdqOjpUbIjTdgeOKTCsozQ3JJ4MHLSS0RFqIxPUx/CnlT93FO7HbLHDSriYYpJfjRqn67hlr7/pew6T4hklZFccvPEkfDXX9YA6VTUsPRaOOiIAV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfeWSD5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfeWSD5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA95C19425;
	Fri,  9 Jan 2026 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960618;
	bh=DtetrF+s8XhnbuXFvcijRgBp7NjPER7O1twII2XTLlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfeWSD5P2fBNoK1pYuEmOYwl5Y5PzCDahsHj8UyCv7Lyyd1BZpj0YNCN0SaaLveyI
	 6Z0v024xa8M/ZZodeHETrdLxgjERkNZq1Yzb27vyvdhm3zcPh8FxxNh/XLH2NWKlro
	 qQeumPNNIybt6vM/mm0ZV7Fm0oFj1ALsVn457wbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Rizzo <matteorizzo@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 468/737] KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
Date: Fri,  9 Jan 2026 12:40:07 +0100
Message-ID: <20260109112151.593870842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -676,6 +676,7 @@ static void nested_vmcb02_prepare_contro
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
+	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
 
 	/* Done at vmrun: asid.  */
 


