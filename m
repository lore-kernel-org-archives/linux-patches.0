Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D799443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B663C433C7;
	Sun, 13 Aug 2023 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962076;
	bh=sVv7R0aC/P2fnboMzPuPKHSrUVP9mpjiJVcakUEUut8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vdGzkWS+vQS0BKjYymlyy7SVOlX8q4+vEcZde6o1J2oCOg37qz0SKS2TMv9sBYAt
	 0dznTtB1RZyww5ZTfNjC/iRUFuJXh2xhV1tlYmXzlAA+X4KubzYWl9ayb5dHieeOuZ
	 DIwYV7J0+kG9i4hJBdqWrQmqijamXPoYZpFhRtXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.4 105/206] KVM: arm64: Fix hardware enable/disable flows for pKVM
Date: Sun, 13 Aug 2023 23:17:55 +0200
Message-ID: <20230813211728.061770860@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raghavendra Rao Ananta <rananta@google.com>

commit c718ca0e99401d80d2480c08e1b02cf5f7cd7033 upstream.

When running in protected mode, the hyp stub is disabled after pKVM is
initialized, meaning the host cannot enable/disable the hyp at
runtime. As such, kvm_arm_hardware_enabled is always 1 after
initialization, and kvm_arch_hardware_enable() never enables the vgic
maintenance irq or timer irqs.

Unconditionally enable/disable the vgic + timer irqs in the respective
calls, instead relying on the percpu bookkeeping in the generic code
to keep track of which cpus have the interrupts unmasked.

Fixes: 466d27e48d7c ("KVM: arm64: Simplify the CPUHP logic")
Reported-by: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Link: https://lore.kernel.org/r/20230719175400.647154-1-rananta@google.com
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1800,8 +1800,6 @@ static void _kvm_arch_hardware_enable(vo
 
 int kvm_arch_hardware_enable(void)
 {
-	int was_enabled;
-
 	/*
 	 * Most calls to this function are made with migration
 	 * disabled, but not with preemption disabled. The former is
@@ -1810,13 +1808,10 @@ int kvm_arch_hardware_enable(void)
 	 */
 	preempt_disable();
 
-	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
 	_kvm_arch_hardware_enable(NULL);
 
-	if (!was_enabled) {
-		kvm_vgic_cpu_up();
-		kvm_timer_cpu_up();
-	}
+	kvm_vgic_cpu_up();
+	kvm_timer_cpu_up();
 
 	preempt_enable();
 
@@ -1833,10 +1828,8 @@ static void _kvm_arch_hardware_disable(v
 
 void kvm_arch_hardware_disable(void)
 {
-	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
-		kvm_timer_cpu_down();
-		kvm_vgic_cpu_down();
-	}
+	kvm_timer_cpu_down();
+	kvm_vgic_cpu_down();
 
 	if (!is_protected_kvm_enabled())
 		_kvm_arch_hardware_disable(NULL);


