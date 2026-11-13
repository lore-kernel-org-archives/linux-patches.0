Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591116;
	b=rm536jdpjaIJ1I8VE0V7ClXs32Xxp5oNc/+phx44s6erVMI3PaaCWfQ6m5MjZ+FncUvJ
	 3iaX02sNFfAsYm5eyhDMAem6DQRalKV/mSCiRDsPPPOphZVguRwkhRyuX6TBcm6zD+/rX
	 H5PZaZknwZEZAN49f4E03Pkm8A8Iu3urU7VV/Vq2eWi0Xd+Gmm04IGeiG0o2XJSuKOldB
	 bAe7pe4stB/kKm+MkU0MPLGZjbFIJmyBxzURzlZGdVJQVgQO0RkDFHhNcFzTURqHknGoN
	 t/jYs3F+1kyIiClaEV8YgC0pL90SZbdlh7/HAtCagV4Iz0OPTKi4VPiENhb1aUehPTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEfjtnBb1/zQaIQKEpxXPPSn/i5RcRl6yKqDxlmBb9Y=;
	b=yNl2huUrWgri28cQr01uKceR6PAhLprro2QIdLT/qSMV9CnETyWkGcaU3TrCvFSVQBrr
	 tNeZvBZk2lzho/sfQubV6acU6OqszQUWT/K3NlLLF9VVUkV590SWkbjNnu5NbkDqaHzJu
	 MJ9sh2u36ZHY+PpIOmyynpCW5a43wxxP7uPUnhR9wpB4MbvY1rPrqJaAvBOv+diFaKlTy
	 REVq2VQg5rl1Aqm+Hz5Qd1VEFLXFo2qIqRKKimpuuQd9+aEFW84ah9s6lJBY/rLrZBt34
	 Qlm3w/0YWgX9f+uzwnSsptJvE4a8jQimeYI8QweNBIZWWR7kKszD7E+6pc5vIwGG6eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EBWJh/eC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03840606A8B3;
	Fri, 13 Nov 2026 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EBWJh/eC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38FD1F000C5;
	Fri, 13 Nov 2026 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591115;
	bh=SEfjtnBb1/zQaIQKEpxXPPSn/i5RcRl6yKqDxlmBb9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBWJh/eCiYkggCTpmSLDvpxex0PfVxOnx3hRc5enWS8rddsoLrCyg4JJzaXXGQyD8
	 Q90NfV0OYJPGPXpgQ8dGD6Sp1MR2CDPS2LJnHBw99gIvnO4ydsdRarJbtimplM7bRC
	 JXTp7j7iA7Kgosb0ev3/TgtkVWTaUEHtKensPnFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/670] KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure
Date: Fri, 13 Nov 2026 10:47:10 -0500
Message-ID: <20261113153820.872825746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 10e9e87f14203..aa6abaa601173 100644
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



