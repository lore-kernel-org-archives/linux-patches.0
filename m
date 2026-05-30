Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400F4332EA7;
	Sat, 30 May 2026 16:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160080; cv=none; b=lMwV/6FULdkc1WQNWsYXT4cu4UPht88jqz9R5VNh7oH1/mrCZrjx7bz7pW7lnFfQ+uWRAoeqvYRIk8rUsx4NeKn0otUmdCpb6sQkQaDUf+ZBeV2x5tRBFcMs8aHaa/jciPthJ8ttMe6FLah3UmljAPRDSh//aR8/ynB4OcIgfmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160080; c=relaxed/simple;
	bh=S6VKAy8Hf0mWXpQ64IEh5kkTJcwUWwVXvhZ42CVtPUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1GhrnoVjoSv+LXOKm2HaC4W4nGTzRa0Opb8K/VefVJ7pKGjpB5xN3QBRwocHOfK63bQqlJhN5TVIDqxcZEVNYHlUyIuqvxN+Eot+vcbus34SonxX89mr1431l0uca83TpNWulkgRU+wkGJiB+Z7DhD/ePia6AZjxa9/tkXEk6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wh2jAkwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wh2jAkwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E2E1F00893;
	Sat, 30 May 2026 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160079;
	bh=8IkmMg2Mx2OqoCCl8b6mG1xTXmBiRnZvu5K9UQF7R9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wh2jAkwY/wKV6lvlpP07itRZvZTgiCQDN7ljYp3HfEpEVS5+p1kGMHNCeN+23QytB
	 fTigdZ51rdApYp2gHaB1E9TOGl5/nxEIC7Wy+CC9tzOoWtW4HlEeqZFgsolxKmkAqR
	 M/UaZV/AFPntklFQzaoNGh2vi6ZQHWdVK3T6nr/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 240/969] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
Date: Sat, 30 May 2026 17:56:04 +0200
Message-ID: <20260530160307.084393757@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -837,6 +837,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		svm_set_gif(svm, false);
 		goto out;
 	}
 


