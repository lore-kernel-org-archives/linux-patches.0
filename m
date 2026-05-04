Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1233DE452;
	Mon,  4 May 2026 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904108; cv=none; b=lu5TrF9tpvdU1o4MBTcUoDrL3WyZmo6wZyxDO5gukbPiko/M8ZcK14lwq3R8fD9T9JMAT3lCJcLla+e2zr1zOs71vDSBiIIyZlp2jBdfAvqp8sA2ENze7HtJEoEq/kUys4oXjuZFabTEds8X75U2ynll0rV6r3UoCYIYKWLI+qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904108; c=relaxed/simple;
	bh=+iPGufx2KF6TFjQOZXa0/047F0AEQBkWIn26vwzwEOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVS063ycbsMDdl3U8tbchHiwVJ8F4c6pvz/xukcSb8VjEHgj23NKIpsKhCzsIhrWh4tmlU2aw70NebULSlUR382Hr7Efm9VouNh5gPoaDiUE8JanYQkBSkrr3Q8SV/8AyuXyG26Tr4+DQhufzjJhYMyFqQ4GtEnlzH6lSo9EOCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rICZoVVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rICZoVVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02066C2BCC4;
	Mon,  4 May 2026 14:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904108;
	bh=+iPGufx2KF6TFjQOZXa0/047F0AEQBkWIn26vwzwEOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rICZoVVbXfS9SaHjnQ9kMrI+5aaVV/h+kP5IGgh3htwUmn7aECSJxfGobdmoOp/sV
	 2UV5i5tzEALW/LzAIdGSIuZrJ9WsVdWh5KWEr1b3zFQ0nsqooRKJ207100290nfb3o
	 XXhDAB73GQzJN4vCfUwVk4RcQbuNkUZYQ8AVws6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 186/275] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
Date: Mon,  4 May 2026 15:52:06 +0200
Message-ID: <20260504135149.986934251@linuxfoundation.org>
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
@@ -992,6 +992,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		svm_set_gif(svm, false);
 		goto out;
 	}
 


