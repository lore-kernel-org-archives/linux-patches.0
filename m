Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F8B3115AF;
	Tue,  2 Sep 2025 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820784; cv=none; b=RiojtwEQJoag2l7qsjDy1Y5DnPAp/SIX+umtlnSI8rraJrQhwGi/+ms2A6v0wf1YJ20HIxj5aukMfIIx98U6SNqh/KIftbc3a7oEZHg2axm7b1v/fgemKVoDzB88P4tHLGqxixKmAfVN0clFzLZqXMaetrPVs4oelUDzF4PMHnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820784; c=relaxed/simple;
	bh=f+W9M9zdfTXTrNZYdet1Yz4mupRJhTwHzYyHC3eT3gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkT1Qt8lYBpi7J5DbT9ysqreZth/WvfkMfxym3rRsp2maoanvpmyQDGp5gzbhueCG4jAi6NOtvSSdx4qa85HxzsVTto7oxUuctGFoLjf07xRiWQFJeDvNoAqkwjtRxIfS4TTtZuHJGT0gMZdXafFBcWjlifTKRA5JAqfMcd3UKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4Au1Wm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4Au1Wm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42150C4CEED;
	Tue,  2 Sep 2025 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820784;
	bh=f+W9M9zdfTXTrNZYdet1Yz4mupRJhTwHzYyHC3eT3gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4Au1Wm4iiyI6jwxWXopgTL3+O/BqLjdXa6VHWLETMz+lEZxoyu2Wy+3dFHpVRmu9
	 Hrb+rPkU1CiOAIsjIq6a4seAFUgbm+7OPinyqEKxfLOSK22TTfa0uM2AlNtYMaHlCc
	 XvzgjrDTBIIVJZGppz2FR7FpCOQRYHEW13FFAdcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thijs Raymakers <thijs@raymakers.nl>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 17/23] KVM: x86: use array_index_nospec with indices that come from guest
Date: Tue,  2 Sep 2025 15:22:03 +0200
Message-ID: <20250902131925.418163908@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thijs Raymakers <thijs@raymakers.nl>

commit c87bd4dd43a624109c3cc42d843138378a7f4548 upstream.

min and dest_id are guest-controlled indices. Using array_index_nospec()
after the bounds checks clamps these values to mitigate speculative execution
side-channels.

Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
Cc: stable@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 715062970f37 ("KVM: X86: Implement PV sched yield hypercall")
Fixes: bdf7ffc89922 ("KVM: LAPIC: Fix pv ipis out-of-bounds access")
Fixes: 4180bf1b655a ("KVM: X86: Implement "send IPI" hypercall")
Link: https://lore.kernel.org/r/20250804064405.4802-1-thijs@raymakers.nl
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    3 +++
 arch/x86/kvm/x86.c   |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -589,6 +589,9 @@ int kvm_pv_send_ipi(struct kvm *kvm, uns
 
 	if (min > map->max_apic_id)
 		goto out;
+
+	min = array_index_nospec(min, map->max_apic_id + 1);
+
 	/* Bits above cluster_size are masked in the caller.  */
 	for_each_set_bit(i, &ipi_bitmap_low,
 		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7506,8 +7506,11 @@ static void kvm_sched_yield(struct kvm *
 	rcu_read_lock();
 	map = rcu_dereference(kvm->arch.apic_map);
 
-	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
-		target = map->phys_map[dest_id]->vcpu;
+	if (likely(map) && dest_id <= map->max_apic_id) {
+		dest_id = array_index_nospec(dest_id, map->max_apic_id + 1);
+		if (map->phys_map[dest_id])
+			target = map->phys_map[dest_id]->vcpu;
+	}
 
 	rcu_read_unlock();
 


