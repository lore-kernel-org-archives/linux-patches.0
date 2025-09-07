Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17CA1CDFAC;
	Sun,  7 Sep 2025 20:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275685; cv=none; b=jhE/gjJjrnPrsPrz4DmShacCxUcxnRMlPumazrQq4VX2BcYhvH8HGqZLsnvVpcbWA1l6t5yEEgVy2njARMUYtZaDOuc3tVh+YLZZtOkmx0qDYX/d/TU0BB4erMLzXgWNXjT1/BvHWU88MSG1hev6Y46uHqgkIpZGvz6+HISLo9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275685; c=relaxed/simple;
	bh=b3xMUPv4CT6/gF4aaXd+n+pqXmbP6CevkiEaDlX21+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KapmzQlXyeeT0FVSyMKbsJcvpTdKEGeyABitB23YVcoU6o5ZM+hCS0kF2e3KxV1vbcR3zk7krcgKmBShXmgvRF3S0CscLf+kUQPMn1XE3CUGtD6n/1OG0WMqAsw0wwT7OHxhpDFpxFwGL/GkQNjpXq9za2fJH87/oE2i2ivzvF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiyFFtsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiyFFtsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02864C4CEF0;
	Sun,  7 Sep 2025 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275684;
	bh=b3xMUPv4CT6/gF4aaXd+n+pqXmbP6CevkiEaDlX21+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiyFFtsd3IXp1uoPItYL7XqXxmor3sVgKAUDKSZ2k2M97h61Vk1eaK+l5J/dIi9fc
	 XLoHnWQ5DizfRpdWha5mp5cOT/INQL+IxuIOvxu6SP2C/BghKDBQRcWiIBACZKuqVd
	 GNQRx1DA42mK9+7Or8DN4LQvUGQzJxmOc/isFE0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/52] KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
Date: Sun,  7 Sep 2025 21:57:50 +0200
Message-ID: <20250907195602.859951366@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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
 arch/x86/kvm/x86.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11417,16 +11417,22 @@ int kvm_arch_irq_bypass_add_producer(str
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 	int ret;
 
-	irqfd->producer = prod;
 	kvm_arch_start_assignment(irqfd->kvm);
+
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = prod;
+
 	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
 					 prod->irq, irqfd->gsi, 1);
-
 	if (ret)
 		kvm_arch_end_assignment(irqfd->kvm);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	return ret;
 }
 
@@ -11436,9 +11442,9 @@ void kvm_arch_irq_bypass_del_producer(st
 	int ret;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 
 	WARN_ON(irqfd->producer != prod);
-	irqfd->producer = NULL;
 
 	/*
 	 * When producer of consumer is unregistered, we change back to
@@ -11446,11 +11452,17 @@ void kvm_arch_irq_bypass_del_producer(st
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = NULL;
+
 	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm, prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 


