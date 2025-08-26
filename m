Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B949D22DF99;
	Tue, 26 Aug 2025 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215085; cv=none; b=m6IcRsudgvGjyt6p5NAHYqIH6JzCNVZtrR9T/D6t6xRzAPW3kZLMmy2F0GVf3QlCVA3yVdg+gvscyZdZAdQWj5EFTDLV5p5x/+dK3NX49Jgtniwh+pvadWJlliSb+h6fGokfyS0OTcJQUtkpa6wAkw0jMijXm+aoO3FLLmKDWTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215085; c=relaxed/simple;
	bh=VnYknSU8wxi34jynTxP55KrcO2+Yit9hgDO/6YPrIxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aub1bh5XB66R8EnHfa4VefXmAOCz8OHJTsN3IvEqJyktTBUyAEuibR8cxLO4T7usesRLRT4WaTlZ1dO1P4jRf5ahzPEuq1k+1L7y+aa4ovYWFzX9HKKmrdzqYofTqaZIEg+r0RHTZjtNXsgqEQkVQ409ZH7UAhl8otU26LS7K1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+xWXvtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+xWXvtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B31AC4CEF1;
	Tue, 26 Aug 2025 13:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215085;
	bh=VnYknSU8wxi34jynTxP55KrcO2+Yit9hgDO/6YPrIxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+xWXvtLTlBiThBunp9eLpCuVVZjgWO2y22UxsddTotVQb8KjeceJoUY3x+yKB7Ax
	 l+LbbA/7sEW1P/Rl84vsrduvG3r+f0mvD+s/kBqbod1ynaaxbksdJn1B312WmDBagp
	 QCF9o0c7y0Zx3s2NH2+A26FgHQeBBRskqhxupdoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 380/482] KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
Date: Tue, 26 Aug 2025 13:10:33 +0200
Message-ID: <20250826110940.216394464@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f1fb088d9cecde5c3066d8ff8846789667519b7d upstream.

Take irqfds.lock when adding/deleting an IRQ bypass producer to ensure
irqfd->producer isn't modified while kvm_irq_routing_update() is running.
The only lock held when a producer is added/removed is irqbypass's mutex.

Fixes: 872768800652 ("KVM: x86: select IRQ_BYPASS_MANAGER")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: account for lack of kvm_x86_call()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13387,16 +13387,22 @@ int kvm_arch_irq_bypass_add_producer(str
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
 	ret = static_call(kvm_x86_pi_update_irte)(irqfd->kvm,
 					 prod->irq, irqfd->gsi, 1);
-
 	if (ret)
 		kvm_arch_end_assignment(irqfd->kvm);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	return ret;
 }
 
@@ -13406,9 +13412,9 @@ void kvm_arch_irq_bypass_del_producer(st
 	int ret;
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm *kvm = irqfd->kvm;
 
 	WARN_ON(irqfd->producer != prod);
-	irqfd->producer = NULL;
 
 	/*
 	 * When producer of consumer is unregistered, we change back to
@@ -13416,11 +13422,18 @@ void kvm_arch_irq_bypass_del_producer(st
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
+	spin_lock_irq(&kvm->irqfds.lock);
+	irqfd->producer = NULL;
+
+
 	ret = static_call(kvm_x86_pi_update_irte)(irqfd->kvm, prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 


