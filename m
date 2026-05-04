Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612A53DEAC8;
	Mon,  4 May 2026 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904667; cv=none; b=rPxWtYwZWqQ8X8fZfwJtXbkN7q9bMu7kyQ4Hdw0drXrBirm1BULtgH1UOKfTjZQV+cyD2JWPiuDXSSFBeRM/OQxFKZ4s1qi+JQwnq77mGWaNh1csznh7+x2eLRWfWYbX7clZ7zLZ1HWpV3jIOZj4bdjncs1OP4ekQ4mvgZYlCo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904667; c=relaxed/simple;
	bh=CdiWGCHUSER/kK/Uwcdit9tvbBVIIAwkuYzNpypZyz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUuTjOumjOBhaRrbitvEuACSaQtSl7MinEeRGLzwEckf794dsu0AlsZzdjlgy2WozvGQbvMGwFLdo9hTqfVbPK+1nSAPnKE0+aJqYFyMf4cPRtKqM/jLS+4+Ks27Hm9VY87w5U16zglgxTKB3tkarm7hCqeChMhwDYoEdogCHd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsijKQoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsijKQoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DA2C2BCF5;
	Mon,  4 May 2026 14:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904667;
	bh=CdiWGCHUSER/kK/Uwcdit9tvbBVIIAwkuYzNpypZyz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsijKQoEYNQ+T3C91t/6i8bSymPcGIs2sgJyr9+AnWmbEAJVyABDlkRqPVBojLBRR
	 6y6QhO9LUDs/OD2M6bacgnWOup3uHQxuHAQ/LH23VF3dBFVBJahHeVOcKH+Rmg1cM7
	 GbLNRgZ+uUa4VhX6WjG0ulOGvlS5oFpTA3IVcEPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 127/215] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
Date: Mon,  4 May 2026 15:52:26 +0200
Message-ID: <20260504135134.788763684@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -886,6 +886,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		svm_set_gif(svm, false);
 		goto out;
 	}
 


