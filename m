Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AF735BDC4;
	Fri,  9 Jan 2026 12:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962431; cv=none; b=NZmHl78b1bOmkewipeP1ps22wxFQ1xgJp55vSqNI8yUN9S3dnfUU7LjAlQ/sZ6sCiabWpMAcBw5Nv+K0NV3shOCSlFNG2bVEN4emQZ9aV9qGUSBz03tjft8FUgS/gv30ha1VfSNjzhiaFaVAvSFrhH1RXnVHNPdQdHqG5oA4XKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962431; c=relaxed/simple;
	bh=z1dsYQwmeiAR9xEca2eEeIwKBzxPUonGgczO/ugVba4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWqtwwRl/lGtTG3QFOJMPnorQydbZcb4ClsJ4edg6+x7iUllfq5zeiaSlcjO4uA0e340GsTqsg/+NYQBhshpeSpiCAGBHdFJZHt7n9OA5LRCo0HCUPr0urO2y2sWj2Ey+3y1SK9OlQj5vdCTNre6AZOjYix7+csmNk93/58EN2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3RjKVRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3RjKVRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C59CC4CEF1;
	Fri,  9 Jan 2026 12:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962430;
	bh=z1dsYQwmeiAR9xEca2eEeIwKBzxPUonGgczO/ugVba4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3RjKVRozekHii7FEva9CqW7PowdX29ZJuE+VyjcFlAbD/cTp50dbrkq96lmJJJCI
	 BLm1Ec2hPLHxqhxTxwaolLrtUdDw0Z6m7NbTlbcJIy7dtqMno1xlNJr+FcnLPssN+4
	 eo9imkxA96xkQ/8EmaUfZdJGdalqUfpC+tv5EXHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 363/634] KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN
Date: Fri,  9 Jan 2026 12:40:41 +0100
Message-ID: <20260109112131.182843146@linuxfoundation.org>
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

commit 7c8b465a1c91f674655ea9cec5083744ec5f796a upstream.

Mark the VMCB_NPT bit as dirty in nested_vmcb02_prepare_save()
on every nested VMRUN.

If L1 changes the PAT MSR between two VMRUN instructions on the same
L1 vCPU, the g_pat field in the associated vmcb02 will change, and the
VMCB_NPT clean bit should be cleared.

Fixes: 4bb170a5430b ("KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit")
Cc: stable@vger.kernel.org
Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250922162935.621409-3-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -520,6 +520,7 @@ static void nested_vmcb02_prepare_save(s
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 
 	nested_vmcb02_compute_g_pat(svm);
+	vmcb_mark_dirty(vmcb02, VMCB_NPT);
 
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {


