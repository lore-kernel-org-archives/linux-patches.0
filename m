Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590311;
	b=NyP0OIRalCiMxQcsW+BbN3xHDECF5ntS6nOpMVRuujwUJBjeFoOmPssXJRGnL8XbdT20
	 eTAufBZIM4hV8VGATHPCzT4tw+HbuLXz9KReOf4hs6JnPVe0Sn256EmhkmnB898ZFju5M
	 33kG0Zx7LArQRSGFpNdOQDn7Rk4WmXi7H7+QXAxLOCAzJlZV903LMAFusywSeHCXcqP70
	 uoTVbEhIH1MlOmTpUmgPR+vYcxIzkV8Rf/9z+Zkkvg2SB54kwShlWkUIn3uXSD6rPevdi
	 jfdzgjuWDBlo0K/eGUu9I5o2A/v3j7P3PA302b5Mf8+1N4QViLmqh5Tvd2lLNZ0Lnww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oyKkYhUVd+SAhk6ddham6dqqoUU3tEQPzsQ0M1Lqu30=;
	b=Bxl2Nqk9W2calDJf09q27E0a1OpzKaSsSAvftpo6qnArIA8XboH612q+L8cdFCV/0Ug7
	 QltZuAOyS20VhVGig/5q0NEi6AOvDQejci673U771350NOg9VKSQkGXSyWRBi4aLB21EE
	 NN+bZg6lDnvulMkHAuhiP49p65B5ITlK7h5gvmQZ0y9Yg9JNFELTTY4KCKwKYVq0Gl47z
	 rE3AcRSQQe90oDa8eIPSKyR0uL0CDpmIrianLQP0DobO4KoL4Mwu0Gw+16w3wh/+q3QG2
	 wDpbJnTq1FoQufev4abYvi8Ev6FPxtjvpBg5Jdhf5cQbpILzmyMF6k2AamomrDGxUzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rh9yiQpZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29458607D2CF;
	Fri, 13 Nov 2026 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rh9yiQpZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D3A1F000C8;
	Fri, 13 Nov 2026 17:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590311;
	bh=oyKkYhUVd+SAhk6ddham6dqqoUU3tEQPzsQ0M1Lqu30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rh9yiQpZf6jb8pcvNwsXtgMi5NtwZQ047up6sxKeQLjGfC/uDneFlp7alxHVRq4Ps
	 XslQ813yZVg7xzcPsn1D11WWGRhxOUoEhyXc87l++6i7+/OfJRCyo804BYzoHSgmbU
	 cR1zw8LOFZbR5/PcqcpRN6BNAmp/fCPg1MJrx1SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 295/686] KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure
Date: Fri, 13 Nov 2026 10:47:08 -0500
Message-ID: <20261113153830.959881051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4e84b5a1eeaaa..ec265eb196da4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -321,6 +321,13 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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
 	walker->level = mmu->cpu_role.base.level;
@@ -471,8 +478,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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



