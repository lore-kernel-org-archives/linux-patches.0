Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046342;
	b=nrJOYrikZEE1pELyMDbfleifQsaQDvhbAJAELw22s6OARqPGhqwI2vBr66kBJQ5+mvFz
	 gzXUZ5T2lxhEfU9c3k0WNEdfUw48FbDoUTwoB/LWQv7R5PucIhU8aj79BZzKfwm9yyVvi
	 rmkTIjrnCE6sRyhDxPP4CcU+XacH+hKhme/zRXNav0Sn6c7izggheBrkR31HLqzZsxkbo
	 Ky/PWecuFhKP4tcns71BjuaEFjfs4p7EnaDC6iidT79Lq3WtvEXBChj87cJAeDyEapoGY
	 ciuflzeuVWAG0x26EFcFkRE46/u36kOBiPmQs0u17iSPIE2+j8Y+8dyyyCRvOEj5M7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86enDxrj1EPW+n/RP252HIXDd2bBNsda3cRJOEBoR7M=;
	b=tDiq4GnSR/bNTKOvRyl6wrTXXSIJFQhV9YIrDSEZO9xnxBZyy1bi1IbSWWXWQOPaqTLh
	 7AKV4l2Iws2XZ5OArtbOZdV5oteAGGoiKKgUZ/926jsIA8pipmmafYQX3JPMRFfuW7Lkv
	 WpLUOeI2FaW/J/GW4WmPPxk6EsxqpG9T7D4ENFKBKN0L2zm7FcyKVy0wPHLwEvg7+Ldf8
	 WvrRBFOGPOCQNT0UtCUnepSk/0E/hSG5gAc9mn+jyNcpsbSRrWnTE86cKUjE6+KtRiAyM
	 yGG9osmUeJXfoNp9TvYVoruxgLwhduyKusq8+5lClu0V9G+H9RihKAYsLVm7ENF6AvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XOha8xN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAD8606A31C;
	Wed, 18 Nov 2026 23:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XOha8xN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0529E1F000C5;
	Wed, 18 Nov 2026 23:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046342;
	bh=86enDxrj1EPW+n/RP252HIXDd2bBNsda3cRJOEBoR7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2XOha8xNKwKS3zZYo6lhFJkVbQs3ZmGpDkGYdFqYNgN+zLzL1yw3ccEC3nCfIgbN2
	 Dxqh5WrcpvKsZZ9HDWdb8hhIKmlDoqv8TDKKR+0sBK0tBckseG3Pfb7/JGZuqQqrWN
	 kUvDUwW9T3ETV2pBL2Py/XdOZatpYyXf+jdepE18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1245/2857] KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure
Date: Wed, 18 Nov 2026 15:37:59 +0100
Message-ID: <20261118150246.374199762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 2ea7bd1a6bb5f..952f7e9b64fad 100644
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
@@ -452,8 +459,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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



