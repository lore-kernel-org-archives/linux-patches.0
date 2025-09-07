Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6F91CDFAC;
	Sun,  7 Sep 2025 20:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275844; cv=none; b=NadA6fFvbFKDQBPvlziKTiiFA33boDcFY/2OAM4kSpuAVkk4ZJ2yXrqHA6JlLINEyUvy1rZ/ZoOLNTTDez+8htntPd7QRKLJQQs/4NXaTxdzH2lN4gwtEfhc13Sx4MJ7SqZfypfZoIkbcCPyXWww+za9p1VlW/PI42Zy4xlcdr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275844; c=relaxed/simple;
	bh=bJfV83o661DJSftCwJP6kQy/P+cHU5gi//4G+5IPHCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOyq3MF+XyRU4n+wLC6+rKvdEoZ36v2Sv9QoKYxtdTRPSNoEp9H7GCCunMI9ufO6gqKVHpJ3ssHTgWLdHgQ9s9/o3UrbInuJtUVl5Fuzy5cSt2xGL+5vp1mcpZSrAlu5uKih4FT6akI3qd1Fm3xI4e6Y0SuroYC58FcQPat3qAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIlHF+mK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIlHF+mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E91AC4CEF0;
	Sun,  7 Sep 2025 20:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275844;
	bh=bJfV83o661DJSftCwJP6kQy/P+cHU5gi//4G+5IPHCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIlHF+mK9E2KrXZmXeUcvyANHmjWTu39U4tQtAmFq8MNH9kEdF9kGH50Ngd4/UdNl
	 988l+8Q1zKq4iKpHlildnLOIcHrZCA/YF0liJOpAhG6vjLfDprOueG8WBO+0CQOVCB
	 f+LFKvzo3TgqRgJkGd71s5M8JIvefkP0LeAPq+jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/45] KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
Date: Sun,  7 Sep 2025 21:58:14 +0200
Message-ID: <20250907195601.789753353@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit f1fb088d9cecde5c3066d8ff8846789667519b7d ]

Take irqfds.lock when adding/deleting an IRQ bypass producer to ensure
irqfd->producer isn't modified while kvm_irq_routing_update() is running.
The only lock held when a producer is added/removed is irqbypass's mutex.

Fixes: 872768800652 ("KVM: x86: select IRQ_BYPASS_MANAGER")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10394,11 +10394,18 @@ int kvm_arch_irq_bypass_add_producer(str
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
+	int ret;
 
+	spin_lock_irq(&kvm->irqfds.lock);
 	irqfd->producer = prod;
 
-	return kvm_x86_ops->update_pi_irte(irqfd->kvm,
+	ret = kvm_x86_ops->update_pi_irte(irqfd->kvm,
 					   prod->irq, irqfd->gsi, 1);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	return ret;
 }
 
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
@@ -10407,9 +10414,9 @@ void kvm_arch_irq_bypass_del_producer(st
 	int ret;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 
 	WARN_ON(irqfd->producer != prod);
-	irqfd->producer = NULL;
 
 	/*
 	 * When producer of consumer is unregistered, we change back to
@@ -10417,10 +10424,15 @@ void kvm_arch_irq_bypass_del_producer(st
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = NULL;
+
 	ret = kvm_x86_ops->update_pi_irte(irqfd->kvm, prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
 }
 
 int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,


