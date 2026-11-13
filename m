Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590559;
	b=vXvB90Om7MjjmrM3GcCtd1tkV39Z3HcQCw4A9n0AQZa1r26Je4o98vaAiZ0XtE2aFKi2
	 7gjyEe5eBPinQ8A+tlx0Is15XuJz2CxNB7UieOR1uj81YIQ669N5oSQ8hPrZSQTmU4zmL
	 zmopwXMNkZ94Lg2DCiaN2DS6sGPQW63R8wW5EIHcxnPPyVEqsDwI62vogZZiS0EB/hvLQ
	 Px7sXGKUGrEJbiiYwwptAdZgmM4ePseQvhISfW/1eI1RVQM7jnnyqT9khUk3sDkdd85Ii
	 Z4OvxP7Azpn157kjsKsz4LeZmYEzbfz2H73M08xmoXp86airbTuQc7K2j//12ffQ9zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b20lmN9d5h1kPyd0KeIfvHZ8rYU5vDoxogqx/5SoyV0=;
	b=bAl/o2lkIAn+sXgDzgAhOJGCO3Fl/VUeedBv8p3+YBEv/oboBjn3Hy05FZX9daHg0s3/
	 dNzeyrhDQGetbLUmNHzhFwjpSsShHoca4q299O2THgANwwm4qVerwehUlYd05lKqfxETH
	 380ASmf8xYySueVvS5Ep/YYBhFuaBnjbpusbfGtPr2iENnOCMWIK/3ZTUgM5RiW6bCGdm
	 cKaz+DsSF3CYwkLCI/2qggYHdBC+kz+E6LTuwUKBWWw/V9cU3GMUdvp8HDFvTrru0f+Sh
	 ViRbtVnUvngp5xSv2u/yjWvYI2t6FDLZ4WCUAFzdVgIMMcepe4XWNStuJu0v3YArvyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSFaObX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6066084362;
	Fri, 13 Nov 2026 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSFaObX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416151F000C4;
	Fri, 13 Nov 2026 17:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590559;
	bh=b20lmN9d5h1kPyd0KeIfvHZ8rYU5vDoxogqx/5SoyV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSFaObX6uOxOi7qm1Ppe6hL0ytuKlArGpQsdQO6jSJSpBpEVAATMmHBCnv9dM6Ogd
	 /gLZVKQzAL1zhNML0c17lIv8TmbhIfFaqvsyPw8e9aXoz9OpPge+LEzbt9AWyKVO29
	 jWyvm92o+FKX8CadhXHO4WXv2Z5jeQi/ZgiL2ECk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 494/686] KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()
Date: Fri, 13 Nov 2026 10:50:27 -0500
Message-ID: <20261113153837.668309935@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 80b0b86dc5e4344e62a2fd3ee43d0ef816fe9122 ]

gmem_abort() maps at s2fd->fault_ipa, which HPFAR_EL2 holds at 4K
granularity whatever the page size. The generic page-table code aligns
it, but pkvm_pgtable_stage2_map() looks up existing mappings over
[addr, addr + size), so on a pKVM host with pages larger than 4K a
guest_memfd-backed guest that faults past the first 4K of a page can
find its neighbour's mapping, get -EAGAIN and take the same fault
forever.

The memory fault exit reports s2fd->fault_ipa too, which for a nested
guest's fault is the nested IPA rather than the canonical one
kvm_gmem_get_pfn() failed on.

Take the addresses from kvm_s2_fault_vma_info instead, as
user_mem_abort() does, and report the canonical gfn in the memory fault
exit. kvm_s2_fault_get_vma_info() itself isn't called: a guest_memfd
memslot's userspace_addr doesn't need to be backed by a VMA.

Fixes: a7b57e0995927 ("KVM: arm64: Handle guest_memfd-backed guest page faults")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260913175105.A57AC1F000FF@smtp.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Link: https://patch.msgid.link/20260928095454.3255918-4-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: Adapted upstream kvm_s2_fault_desc and kvm_s2_fault_vma_info usage to existing gmem_abort() arguments and local variables. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index af50fed5b5975..e8029ac82da74 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1536,6 +1536,8 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (ret)
 		return ret;
 
+	fault_ipa = ALIGN_DOWN(fault_ipa, PAGE_SIZE);
+
 	if (nested)
 		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
 	else
@@ -1552,7 +1554,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
 	if (ret) {
-		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
+		kvm_prepare_memory_fault_exit(vcpu, gfn_to_gpa(gfn), PAGE_SIZE,
 					      write_fault, exec_fault, false);
 		return ret;
 	}
-- 
2.53.0



