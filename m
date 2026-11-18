Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059055;
	b=C+pACAmbfBy5mtWNmr2IXezTXkGV5jJvIS0tThBpJdR1yAgCtzBpY7BMZPFvgdFKuUy1
	 lX9yuLtwkyV7EfN/STnIJC2/uUmiM59J7t5NzCy8E5vhQhOH2oK/ZrvRdySXhvcJ2RsAY
	 IIWzoHAiKqFNpp3Y7jJjsQYgIhY5zLEMG8hBJ1lCCitZ+UfhgDynb3va3sPKT+nGlxsLZ
	 nFosPwacQqLJMhXgrDD10CKecz6F8NAbvTMD6HCIv+Hqk+uV4gxxgpKm0JuMKvQeDqyl2
	 4xYDGCdYYVTmWY5unbh0v8M8v21RMysMWiQJk1wBjfwDUbVyJnaEYG+BpCfjokWtlOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EAQYiAl0nV0prMJxY6N0+wO7RZVepU3Xu7Qnvu2B+F4=;
	b=e+nAHNGbrF+Uucg/ygk4UTQMSXeGoDr5UTG7P/G2Pfd0CZVU0IkfIoldsYp3AxQQ+mIg
	 3GuwyWPT4Qs5fzPuy9y315vxzi/BW5IPeQcJaueH77dqWppF+JA3N5UqJTEDlC52V+aTG
	 4BzPMPY0kCEAtSS9+87vT71XpAW4u+dynjChllniooalnHhMhK0O6fSnmdzW/RUMIh6wI
	 gXMZKglFEkJlbEknTQPE1o1MSBWu2JB1YQ/8qwRd/vuAhl6N70lL4YIhb14rsfiOwHX38
	 HW5zGqRcD9/6iCvSWUcX4NrXC13TObm3dh0OZ1RtuToeJ5iQO463V43PMbjQocrCo7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZcsjwK8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3977606A325;
	Thu, 19 Nov 2026 03:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZcsjwK8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B8E1F000C4;
	Thu, 19 Nov 2026 03:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059054;
	bh=EAQYiAl0nV0prMJxY6N0+wO7RZVepU3Xu7Qnvu2B+F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZcsjwK8FCsMgV23jABQ+9mBJ25Axzgz4b6DiW/abiE6WZClgTHpWTS+wksV/Tzsx
	 aKL0k0z43Grnz+9Luh9jnsVhd399Lpqda9XKpXATpzjOdvwO1PyZL557Pk4AOewmMN
	 fmk84cdtfWz2254Etqmt3V1oMV3jg+k5KoTKD65I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0703/1848] KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure
Date: Wed, 18 Nov 2026 15:45:41 +0100
Message-ID: <20261118145945.274172547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c6daeeff1d9c9..3778070381a8b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -327,6 +327,13 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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
 	walker->level = mmu->root_level;
@@ -457,8 +464,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 							addr, write_fault);
 		if (unlikely(ret < 0))
 			goto error;
-		else if (ret)
+		else if (ret) {
+			cond_resched();
 			goto retry_walk;
+		}
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-- 
2.53.0



