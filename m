Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983F2304BCB;
	Sat, 30 May 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163370; cv=none; b=QMdUXP2ZliytGpiUzPXzWQ89NZlfrXnMZjfz72hRNeX7xx8xgOB7zMNgSULKgjm+6rP6d4X5ga1hJYR6TEsppEczwa8Fj13i93xs+oS4WFmbYLxnysuCH6J3QtLdZgH5oMZrKL5rqLnB0QPJfbfF+4siKjfJ57LW7vchh/qCu5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163370; c=relaxed/simple;
	bh=etiKDPLPMDhyh7IVlK2Rc3ofos0kUzCNjBEF4i3Ci0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf9AfgMcSz5v465AUZ/eswxa6FfB52yRZ2xNRQFGq8dvkL7TmvtMMyxntgJ5vITvKNRIT/+GXuA03EvFIZrjH0O07UKJ7rKihYABHo7SdDYqPOnWBcDG0dd88XqA07/lPe5nYXlVwIwHVZB4gyVknA36B8+nf+RaWKNCOsmDvjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXo6tDmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXo6tDmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF531F00893;
	Sat, 30 May 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163369;
	bh=OAlNjDFQqGkxyK/glH/RXhEwIFtVfZsTZyPFzszx5po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXo6tDmj6FsGQOyG2aWt4lDiZQJiW/tnVgADDfpjU5JM9vmen6ODT3Q6CWjMmIozE
	 Ackc0M5ILQ5pPPMTA7vK0xaEN1BcjQT2cvMv9voo2/amgtyb1GHa46FxLsGUsrakJo
	 tuqqZV4JI6WSx1JTUvY8g9VKJ5kQ3Dbd3Fb2RwsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 238/776] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
Date: Sat, 30 May 2026 17:59:12 +0200
Message-ID: <20260530160246.682989516@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -671,6 +671,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		svm_set_gif(svm, false);
 		goto out;
 	}
 


