Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6A12D6629;
	Tue,  2 Sep 2025 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820729; cv=none; b=ng9Ibi3gYw2iBe0VJ+KK0Iau1Wdrvdq8h4kzn9fUz3ykqpjd2stkDZL1wiTMYJlRs3qOdi94uGf5UG0kWYtUJ9esXUUCIO8yBKXV+1iIyHPVva4r2kgULAJSpP4FibqrSS4xGxK/KzA1WlPB7tJszXi1fymO2dc367J2pU8JUCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820729; c=relaxed/simple;
	bh=BV+fo0qas66yPWw42Yg75lBExIxwlKrcEJ8q0IAT4Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKw3qcHoqMKftQ7Y55MVyZiazyxTaU1A0+3AKMpDEBFUPgU5ooeHHQ+DTAFeQo+RKymmAva7GvUNE/gFcvvp7U1kOd2UTkkD6OLDon2LZylln79RotvRoQSvivp6OMsUoBVbbcsxkYAs3jFTPQSY3zVY1waHQJdVH9PoTJvxXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOe4Kh+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOe4Kh+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E73C4CEF4;
	Tue,  2 Sep 2025 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820729;
	bh=BV+fo0qas66yPWw42Yg75lBExIxwlKrcEJ8q0IAT4Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOe4Kh+rqkC8CyjItyEBy9xDk5zf9K9y2HLiZXprzc6/BkYhyVjBX5j5Q6+b3tIN0
	 NPEm+Jask38r3NeJi2Kk3X669McSuPdRy1CnoaneBzUvdIy0PXemVu8mdl/e7ZdJ6x
	 n1QaUNHF3evBRPoACpWS9qwOoYBAeRovz+0pmVb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thijs Raymakers <thijs@raymakers.nl>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 19/34] KVM: x86: use array_index_nospec with indices that come from guest
Date: Tue,  2 Sep 2025 15:21:45 +0200
Message-ID: <20250902131927.385207470@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -610,6 +610,8 @@ static int __pv_send_ipi(unsigned long *
 	if (min > map->max_apic_id)
 		return 0;
 
+	min = array_index_nospec(min, map->max_apic_id + 1);
+
 	for_each_set_bit(i, ipi_bitmap,
 		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
 		if (map->phys_map[min + i]) {
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8359,8 +8359,11 @@ static void kvm_sched_yield(struct kvm *
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
 


