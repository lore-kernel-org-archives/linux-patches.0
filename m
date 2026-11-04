Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829140;
	b=2WxKVnnNLKjBgqVP9mnqy1N0G/690xtD+Gl6Y7zshhNgAOjcSaAaDSUyjUWN9PMvAOWu
	 2PJFkD+O57hzxaW1J0huQkZ9GK0eu4iNHKXaupmzdpYkUqnyLcgfgw+piSA3oG8Mu9poh
	 9SVce12yHvd+JiskhWDV1mkGYVp26jv9bu3La8MwWk8INZzw8ZGO8CfkEfC0RkaidM3CL
	 4KNElf5rO+1A8fKpcJLiyo/BHfvPodwW5VsF8sr4zu5i5d+EojZMblRhuQt1t1vxytTpA
	 rci0izyz9AX+WY/VdVdLq9aOt4KbmWfJpvrX4jqoaHMJsKgR2N8nyUCSWgd/TAMI/FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mRa5guKynFPfGUriHLi6gt11vshXhQxyHqn6jxTBTpo=;
	b=UCht/NJw2iN5XH1SzGQiyMSHa6+mrD13wo2lIiSLwR4WgQSzJRWwfP+GHDbZXo8/iVZG
	 AfchauA/tLGjvnc8NuBaX54+WnZXeBD31+GAVKvhSQP80cMII810FghZWbG8FFqNXtaMe
	 qcqx/ziWJVRIPoLNl3h4gyaM/N16TorBcE/LuTYEDw3ntv17L9Sr723hFCJZ9VgIHuHfg
	 RMSWw1rmbcdm+pEEkrplI6aSL79xeTU51H5eSvWL5X1Yw2WYj6ZKInjd5CCy4nqC8trG5
	 0ePlosSHLvLZWeozZ+H1c40xPhhJmo7QsEHLvTp/w32psZnumeGkI2Hxl4jemwxrs8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djKDQtQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FC8608F109;
	Wed,  4 Nov 2026 21:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djKDQtQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993CC1F00919;
	Wed,  4 Nov 2026 21:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829139;
	bh=mRa5guKynFPfGUriHLi6gt11vshXhQxyHqn6jxTBTpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djKDQtQcNznlngNRZQYB5cGUCNBh/xcB2UCIGzIg8Qg3qQbh4nqIvbe2sczfSE+bJ
	 1gSekt2bhQq0YLNkAkaX5jVcarmqEJFPu5GtoKs/3Vtc1HAYXyWyhh8GdgTHKVOiUl
	 9bzT3YYhtYpr+HAB+DcTnINoalU1bHN1HWEkxq50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 470/547] KVM: x86: Take SRCU in kvm_zap_gfn_range()
Date: Wed,  4 Nov 2026 16:10:54 -0500
Message-ID: <20261104211051.715444903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit b59a87c1ba3c347e8aec5f932eb7abf13064fd62 upstream.

kvm_zap_gfn_range() walks memslots and rmaps and may drop mmu_lock to
reschedule. Callers that do not already hold kvm->srcu (or slots_lock)
can race with memslot deletion: synchronize_srcu_expedited() does not
wait, kvm_free_memslot() frees the old slot and its rmap, and the zap
resumes on freed memory.

The VFIO noncoherent-DMA path hits this by zapping the entire GPA
space without SRCU. KASAN reported:

  BUG: KASAN: vmalloc-out-of-bounds in slot_rmap_walk_next+0x82/0x1c0
  Read of size 8 at addr ffffc900005c1008
  Call Trace:
   slot_rmap_walk_next+0x82/0x1c0
   __kvm_rmap_zap_gfn_range+0x17a/0x280
   kvm_zap_gfn_range+0x2a6/0x6a0
   kvm_vfio_set_attr+0x576/0x770
   kvm_device_ioctl+0x1ff/0x3b0

Take SRCU inside kvm_zap_gfn_range() so every caller is covered.
Nesting with an existing kvm->srcu critical section is fine; the
helper uses a local index. Drop the now-redundant SRCU pair from
__kvm_set_or_clear_apicv_inhibit().

Fixes: 362ff6dca541 ("KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/stops")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20260825183924.237727-1-nicoyip.dev@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 ++
 arch/x86/kvm/x86.c     |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7126,6 +7126,8 @@ void kvm_zap_gfn_range(struct kvm *kvm,
 	if (WARN_ON_ONCE(gfn_end <= gfn_start))
 		return;
 
+	guard(srcu)(&kvm->srcu);
+
 	write_lock(&kvm->mmu_lock);
 
 	kvm_mmu_invalidate_start(kvm);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7935,10 +7935,8 @@ void __kvm_set_or_clear_apicv_inhibit(st
 		kvm->arch.apicv_inhibit_reasons = new;
 		if (new) {
 			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
-			int idx = srcu_read_lock(&kvm->srcu);
 
 			kvm_zap_gfn_range(kvm, gfn, gfn+1);
-			srcu_read_unlock(&kvm->srcu, idx);
 		}
 	} else {
 		kvm->arch.apicv_inhibit_reasons = new;


