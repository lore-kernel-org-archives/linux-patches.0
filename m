Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324A1355049;
	Fri, 15 May 2026 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860854; cv=none; b=O+aGsJoHZXHydBjf3WHiWW3zxLSupmbGGlyZDqVBfXtMj2qPZFvGgtyd3q2ox202Th/U42d7l7BEhHYwnx4bko8NI18DUM79c6KWm1m2iAoS9Ai/3Y66iF7cc+ccIqO1Vv3Q0nWc4RGDslN0AmnVGsSx3VELmZi0bUZKLWblSis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860854; c=relaxed/simple;
	bh=IBWVrMXPYbrWdT+O63CwxRrfmq72pxehhX1aJSWM1k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GE5NCWGFxbxbiSmhJYRH4Gn0VTFoiouPI8b6oTQj/i1hrIbXEpDoIofWHAzF1ZrZQ0pT/hoZtak7MWnCaw2EOpR729Cx+ChvBgfTcoheK7Q5Nv47EHZrliwxElqEzMygasjLpWcT6KSxnY+liRyWgF425o2WgXnjqIhawuVv0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNaEwdI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNaEwdI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA8DC2BCB0;
	Fri, 15 May 2026 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860854;
	bh=IBWVrMXPYbrWdT+O63CwxRrfmq72pxehhX1aJSWM1k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNaEwdI0nqoTUEGwtfcWaQvvgx4njTkOyEgcE27TAiUBPTsiD1LAKt/QLl7esKBOx
	 hRZnY4bLfYdrkG2Jv/AUgib+r3YYKqf6OB0WDEArBXMo3VTtdi7zXK5npCcXVy7m5k
	 VHg8a75XNQhVop1Cd2bE1OI/b1+u8oUEOJh1j0nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 103/474] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
Date: Fri, 15 May 2026 17:43:32 +0200
Message-ID: <20260515154717.265996888@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

commit f85a6ce06e4a0d49652f57967a649ab09e06287c upstream.

According to the APM, GIF is set to 0 on any #VMEXIT, including
an #VMEXIT(INVALID) due to failed consistency checks. Clear GIF on
consistency check failures.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-11-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -884,6 +884,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		svm_set_gif(svm, false);
 		goto out;
 	}
 


