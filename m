Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215091;
	b=MAjCMXLDIfCf8s/AIkNrnItcUurQ8skIFImrOW6mAYtghev6FoZDVftENMjRnrSwCV50
	 vH7Tq7+NlE6yHnDssKC2MN1rR2L1mlLOWIw+aKXbcp7O6mp6BjEf9nman04LCirzuZiY0
	 /EbWP6BROJ7wGUta2QZu4496pi/iXKQJcC+IdevUNEY58lwAEJQEoxqI5TZUPpj4tFHiH
	 +WPr6fXnwlni8RZpN9pie9huAaiyA+VmuWwKP+6ysZS1QbK5tVqh9Lin1ZSBHehhj0+TW
	 5hnU905J7hc8O5FUC+ijdy5hFQPCKOEiD4QdfnrDX//j47FvklKw7+js1C3qBj80d4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UmKpNuYWr13XFWqKfz8VZ2X349OH/G0wIp0zRSThpE4=;
	b=DRLqAsSOviVEz/6c7ounCvBBusFh6wJabg/M3XpbRb/QFsODBKCiQQwy/WEeLNWDtSao
	 lhGVhq9Q7j2F9kfhY+X3IKwu9w22MuWurrB6dhqxG/U297TouuvfWsjQ/fDxaU5jRcCpf
	 4bwiNbnZPYLZfdtfMKl9RFVM48DE0zbZ0MM038v+87A5N2eVZwN7/gCub15Ofu6FsPsWQ
	 ACZHQMpqRooMDcE8HZnxRVrITy8GQf2K1Km6JXuVrLEdEnX5fGG8pdjlscUFkGx94GtqA
	 kbdvIEEpD+lAlZCHlpON8mByNPxSFmzxNuJu8Cv7q1GIRHrVjp2rE9uqYBzx/HfbGsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nMpRAcBg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CF7606A31A;
	Wed, 28 Oct 2026 19:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nMpRAcBg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673AE1F01825;
	Wed, 28 Oct 2026 19:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215090;
	bh=UmKpNuYWr13XFWqKfz8VZ2X349OH/G0wIp0zRSThpE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMpRAcBgnkvtS/v5p8+LLX8Ftrs8J9ZMNXgAJ+Bp62fb4AOkwfztS/JeCM7f0q0uK
	 C0Fcz7dBKIFisS+B6me8qxjltwJSy1e6R8JhE0sTooQJbhwWmJ+nVNlKqE/UCmdchY
	 nEFL0d+f5BlXI0pNYWHUDwyoMyov1054mPuJOaLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1045/1887] KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT
Date: Wed, 28 Oct 2026 17:52:21 +0100
Message-ID: <20261028170523.192209235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 5d291ef0585ed880ed4dd71ea1a5965e0a65fb53 ]

If loading L1's CR3 fails on a nested #VMEXIT, nested_svm_vmexit()
returns an error code that is ignored by most callers, and continues to
run L1 with corrupted state. A sane recovery is not possible in this
case, and HW behavior is to cause a shutdown. Inject a triple fault
instead, and do not return early from nested_svm_vmexit(). Continue
cleaning up the vCPU state (e.g. clear pending exceptions), to handle
the failure as gracefully as possible.

>From the APM:

  Upon #VMEXIT, the processor performs the following actions in order to
  return to the host execution context:

  ...

  if (illegal host state loaded, or exception while loading host state)
      shutdown
  else
      execute first host instruction following the VMRUN

Remove the return value of nested_svm_vmexit(), which is mostly
unchecked anyway.

Fixes: d82aaef9c88a ("KVM: nSVM: use nested_svm_load_cr3() on guest->host switch")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-10-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6a4a0d15d4a34..dbb4b3d2c8046 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1057,9 +1057,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true);
-	if (rc)
-		return 1;
+	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
-- 
2.53.0



