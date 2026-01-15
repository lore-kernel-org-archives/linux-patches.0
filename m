Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5D63BC4E8;
	Thu, 15 Jan 2026 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498505; cv=none; b=WyLCa1lY3v0bztCHepO21mvWs39uRDmiIfWaPeGtWLVD2tPvBdE0leBIVb9yROrjvRQlz2+0cJwlUXnMs7/fXEMYXHFnfyYB0kbu4xoyIwaVXnKp9f8XaN+qO4f3TVYjCaQWrFrPcu6cREiOUWRVSxaKd+ReQTFuxtv4rOcstxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498505; c=relaxed/simple;
	bh=lJUwe/oAvHSXMJXaR/wiG5RFAGpHGXQEPJ3kdQ2Y0Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJ9vTWmjmzH0NUlxvNGlfPfUH3Xn8lMg7wdHLss9F7LoxY9DEmP/d8XySRmLf1Y9/y7DEou+CeKUE+T83f8A+LP0GJ3NxfofPuasV5KD2/2MdUg8e1rgCNtfV0Lukm09T8rUAyKnAbwCv8P0RBHdjyjze/XYMzOeMSi+ePzAf00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJdid9z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJdid9z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B655C116D0;
	Thu, 15 Jan 2026 17:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498504;
	bh=lJUwe/oAvHSXMJXaR/wiG5RFAGpHGXQEPJ3kdQ2Y0Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJdid9z6sW+CZVeVeYZ1uYBHIUOe1SAX46tSHNoUyM0FvGgJVfO4rQ216nhMfX//U
	 wrJh1UNpSiEnP0miPNt7GYzCRgmY7NEOvwj7NcwSrd4dQ4TBQTE9TPcZ588C2/h8vv
	 XvjNE2zHzYwEO9CJJLvyoSraoUFUGrKiGEsgLV5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 454/554] KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN
Date: Thu, 15 Jan 2026 17:48:40 +0100
Message-ID: <20260115164302.707644804@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 7c8b465a1c91f674655ea9cec5083744ec5f796a ]

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
[ adapted vmcb02 local variable to svm->vmcb direct access pattern ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -456,6 +456,7 @@ static void nested_vmcb02_prepare_save(s
 	bool new_vmcb12 = false;
 
 	nested_vmcb02_compute_g_pat(svm);
+	vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {


