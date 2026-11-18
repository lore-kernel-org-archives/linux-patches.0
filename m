Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037661;
	b=u/W/eSO6DKmF92T7urLjpdZlxPYcfk+hE0Pe8M3omThTtngWIwz+mqhjYI03g6r5//iT
	 1Dzy8r88rUFv81aL1bXQ0WdUuXcGKAR8M8YmIG4HasY+Qp0TUa0GUup5/d8wUfY/ArIfV
	 Rzg9iJDs7DRcNwYaEZAWHTdFh2ZI+lzYI59Ssg9Ob2OCLIb813EJhF4JVQsOGFX6f8liV
	 YKofvBthBARa/XEBi7meBzs92O/lFGoZlsCtFFaCfXxOAulVeSeeFb1d2XnKFj0sv4/po
	 VpfHtSoQTdKtIZke4W+tf6qfDB5znmsX/WRy30Z4Em2NTe/Zx9Eu+ijeYLHTjfucg/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+8mHp7gl2I3rBQKN0hhe6I7b3jYwF2vjBnq0+cdjTn0=;
	b=o7kyW96EXkL6McCHHSVfMtLmS8Qs5ZofO6KFHvoCyHFrlwgU174RznuaGl6hr8RWAnaX
	 akJPhIr2MRvJgMKyB+DlBck7NPCVHtJpPJ5SXK3C+FF9ziKDgiTRfXinozNu1adWQprPz
	 BmAGZBKpzKTjr7Gt5/6+ic4XIMWYQEpfNWs3kQmXhZVKMQD7kV0oKsnGfziYIA7tVIFy3
	 pG+s09TKlz8SCRBfzs9vLHSaH2WdUfPx1ybSk2eF1eO29FMeAgJ3BJrMnq6Wix6BKLkQB
	 alriQhsJHFVXRX8Irp+EFkX4sVhqJu0ItX+7jWSbZZhcsof1Am6eHJ7CguzETFAYpKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqpyEYnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F8B606A32A;
	Wed, 18 Nov 2026 21:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqpyEYnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7E11F000C4;
	Wed, 18 Nov 2026 21:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037661;
	bh=+8mHp7gl2I3rBQKN0hhe6I7b3jYwF2vjBnq0+cdjTn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqpyEYnPcjyEWWh4olNIIr69H9BDneoWJVzChESKQMW9Nv6gx4XexfB3+Vez5WvFt
	 0xOt+P4VLAyCtHeg/i9uWQ9gtZZvL1co/Z4LoLxwTxlYPprimi9MjjmUqEpVPipP4a
	 sgGsxx49aynQCqCwPuz0qnVOE8I6PCSU6VijHEnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1468/3318] KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure
Date: Wed, 18 Nov 2026 15:34:50 +0100
Message-ID: <20261118150404.934631297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 991d7ead1a9ac..f2cfc90a3c6ba 100644
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
@@ -468,8 +475,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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



