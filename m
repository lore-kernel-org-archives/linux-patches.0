Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B68115AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81708C433C8;
	Tue, 25 Jul 2023 10:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282279;
	bh=Puo2ywKsycAM5/PzEZl0qDeS+SlrJvR0ktGgJk+DU6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2zWVPtetu4XpfMQZqoRis1gI25SjtLjSaCAJTqa8t00inBt4okFOXsTXnJQfaEtl
	 eHi06bqXuFOHykxXnVLJ4ljv00xyfkxbJm0x1BvUiY2cXp9RdWwfR6+NxJkJHTOY0u
	 M3t2UYzkb0fhSOq5XMFANhw9dOhj0fWrR26McFnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.4 073/227] KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
Date: Tue, 25 Jul 2023 12:44:00 +0200
Message-ID: <20230725104517.784687016@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

commit 970dee09b230895fe2230d2b32ad05a2826818c6 upstream.

Since 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect
kvm_usage_count with kvm_lock"), hotplugging back a CPU whilst
a guest is running results in a number of ugly splats as most
of this code expects to run with preemption disabled, which isn't
the case anymore.

While the context is preemptable, it isn't migratable, which should
be enough. But we have plenty of preemptible() checks all over
the place, and our per-CPU accessors also disable preemption.

Since this affects released versions, let's do the easy fix first,
disabling preemption in kvm_arch_hardware_enable(). We can always
revisit this with a more invasive fix in the future.

Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
Tested-by: Kristina Martsenko <kristina.martsenko@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com
Cc: stable@vger.kernel.org # v6.3, v6.4
Link: https://lore.kernel.org/r/20230703163548.1498943-1-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1793,8 +1793,17 @@ static void _kvm_arch_hardware_enable(vo
 
 int kvm_arch_hardware_enable(void)
 {
-	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
+	int was_enabled;
 
+	/*
+	 * Most calls to this function are made with migration
+	 * disabled, but not with preemption disabled. The former is
+	 * enough to ensure correctness, but most of the helpers
+	 * expect the later and will throw a tantrum otherwise.
+	 */
+	preempt_disable();
+
+	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
 	_kvm_arch_hardware_enable(NULL);
 
 	if (!was_enabled) {
@@ -1802,6 +1811,8 @@ int kvm_arch_hardware_enable(void)
 		kvm_timer_cpu_up();
 	}
 
+	preempt_enable();
+
 	return 0;
 }
 


