Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585573;
	b=GtyH2rfqPRU9TYxO6ewcw8gbFBjbVeN36i7NnFhDhFduHpLNK9drKT5oFrEOAVsUMCZ+
	 0cTfhbty5JLjatQPFWPDTzpAcEP/OIrJfH0gjB5HjuA4qLgubIx3LeZbFpd2DhWix37Wf
	 VN34jpcuarS1iz5k8PGfAKieEYOkATlA8TJ5I9dAa+TsTk569L6+r1rrHiX4gEQ+DXPYN
	 VSPUNNX1EffACgWZzR2f9petX7pNZCmAJTyd9MS8QQXkZ3gHIC7WCDXO7EeIgHY6liQru
	 lQEWJgpnbvoRHUCqfDtR3ZRb4FBXrnUMxhRMi8HPdO/ouonndeNMZIhm0sAwhHD1Uew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j7Sbw1OP7m03YbJaYSQe05fQ2x+ZZ1Gi/o7ua0xFrIc=;
	b=lWb7Txve3K+0tj37zEfn8GyD7NgukQWlzx28RWIaPtQ4fPWJjRqLatvqVniR1E0uRNCZ
	 FeZz4cdX4xBeghWMMVMZjwztr7zJZBb2FQBv8l4DrKg3xoWvGIKK5mosmM1k0h7MNbI70
	 lE2ItQHXvZgxX+Gp5qvLfJ7Nr8AjsFWoXQ4PL8oppzsYYjrZyhosjRK2tJKzV5spEJ+i1
	 DQbWIyJruqQfc92jiWbxAoa2mFCQSEW0iKNR4Q5d1llLewPwrq8LuSobUJGml63tMnL9n
	 BrCs++NbelCsnno05OIqEnvVvXkngaE6hDEftI4wxBrm4P1YxcvrFLiQXmXt1BpGcbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GApd/71J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED69606BAB5;
	Fri, 13 Nov 2026 15:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GApd/71J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF561F000C5;
	Fri, 13 Nov 2026 15:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585573;
	bh=j7Sbw1OP7m03YbJaYSQe05fQ2x+ZZ1Gi/o7ua0xFrIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GApd/71JlPG+u+Eosx47uLcezkcLMLNUCKM/GZ5dWfqgFIs2rqri4TyyeIEwKueHJ
	 OUm2LZcOgz11uPZaUEe0AAVFW3VluDE9hYpDx7cbio9RYW31/f9F/ebxgIB2PomU/y
	 ttLhxs+2AHTF28PnNYhyOpE8Sh6JYgnAc/czy2eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 206/507] KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure
Date: Fri, 13 Nov 2026 10:48:30 -0500
Message-ID: <20261113153801.461299305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit b2691b3a6cd230209736c89684dab90d939aa56b ]

Conditionally reschedule when retrying a guest PTE walk because the CMPXCHG
to update A/D bits failed, e.g. because a different task/vCPU modified the
relevant gPTEs.  On kernels without involuntary preemption of some kind, a
misbehaving guest can "capture" a pCPU effectively indefinitely and trigger
soft lockups by continuously modifying its gPTEs such that the result of
the walk is remains valid.

Fixes: b3e4e63fd9ee ("KVM: MMU: Use cmpxchg for pte updates on walk_addr()")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261022015903.282261-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 6e0153f231363..7454dac59b3a8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -339,6 +339,13 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gpa_t real_gpa;
 	gfn_t gfn;
 
+	/*
+	 * KVM might sleep/resched when retrying the walk if the updating A/D
+	 * fails because the gPTE changed between reading the gPTE and trying
+	 * the CMPXHG to set A/D bits.
+	 */
+	might_sleep();
+
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = w->cpu_role.base.level;
@@ -479,8 +486,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 							addr, write_fault);
 		if (unlikely(ret < 0))
 			goto error;
-		else if (ret)
+		else if (ret) {
+			cond_resched();
 			goto retry_walk;
+		}
 	}
 
 	return 1;
-- 
2.53.0



