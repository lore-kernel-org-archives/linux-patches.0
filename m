Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A529828AB1E;
	Tue,  2 Sep 2025 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820572; cv=none; b=kTDELwgy4+i0sTEWoRDTAIdrhJMVxRzdnLKZE73TQlqC6IeR0wMj+U2pNEzvLM+d3RlLTSXnlqSLwohO9Mmo4hVzC+JW8ybYVMY5wJryilrT6Ou2k5tgFuEm3VQiDARV8b9tBppznA5USfH9/9EZj2i/FmHQ2Bi2x0uVWl6XbnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820572; c=relaxed/simple;
	bh=nnoX/mQZ17ZeNXkexDp3yJdpjP2ih8/BXt4Jw+oIscc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLgQZL1eQWpD5wtZo6oserZkKtPkHPIPP+OI6KFkr/neBxQd8K+5OGx2mGqjFsXdfL73dqJWyHcNSMLIECGczosn1BSXry01QRTwLVfEsy69gBqqxbxT0QQK1ealyNqhJD0En5rAZfPgejRuf8cOU8WYYaw3+ZWQiQVYnd116cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USC9VXeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USC9VXeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6AAC4CEED;
	Tue,  2 Sep 2025 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820572;
	bh=nnoX/mQZ17ZeNXkexDp3yJdpjP2ih8/BXt4Jw+oIscc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USC9VXegILiSr0B80YbLWU+ar54aazYYxswwXs37WOy3Mty0VOZf0RCSJU+0eZekN
	 +lL30PqTGqFQiv42ZcS1VtKkJRGLgARIVGUF4yxi/fyB/gjZK0+fgtnq+n8VCyc5kc
	 /41QYPSF1I639ARIiisz3HPqW1pmyLzJUeUCMNS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thijs Raymakers <thijs@raymakers.nl>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 21/33] KVM: x86: use array_index_nospec with indices that come from guest
Date: Tue,  2 Sep 2025 15:21:39 +0200
Message-ID: <20250902131927.884915157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kvm/lapic.c |    2 ++
 arch/x86/kvm/x86.c   |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -613,6 +613,8 @@ static int __pv_send_ipi(unsigned long *
 	if (min > map->max_apic_id)
 		return 0;
 
+	min = array_index_nospec(min, map->max_apic_id + 1);
+
 	for_each_set_bit(i, ipi_bitmap,
 		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
 		if (map->phys_map[min + i]) {
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8923,8 +8923,11 @@ static void kvm_sched_yield(struct kvm_v
 	rcu_read_lock();
 	map = rcu_dereference(vcpu->kvm->arch.apic_map);
 
-	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
-		target = map->phys_map[dest_id]->vcpu;
+	if (likely(map) && dest_id <= map->max_apic_id) {
+		dest_id = array_index_nospec(dest_id, map->max_apic_id + 1);
+		if (map->phys_map[dest_id])
+			target = map->phys_map[dest_id]->vcpu;
+	}
 
 	rcu_read_unlock();
 


