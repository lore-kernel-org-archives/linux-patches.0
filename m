Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E9C18E368;
	Mon, 28 Oct 2024 06:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097875; cv=none; b=TnK2Ch9Uqtt4EalCVRaGeHLf7dHlyqJyO/4vx5A/wiAIdw8JoiVD+C63m09ya/dTu6bC2+R6O/mpW02E+cBUtLmTFR1QtNhrjqCLW5ejBHD+F425WaoAtHfO4je/YykBk7XOPp1bYKJ18DePQst+mNlxDVA3WuG+mIWT7oLTY7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097875; c=relaxed/simple;
	bh=MYG/MpmUUTdMwaA2qkbhaEEaB2zprtDbPQ9CPhZodLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgF3NJ99lM+M+BeNOFfVLvFnwgZjTiEZJHY5wBxpkxMJbgnI9rqxlBsA4yLWvmdtpZTtxQeCzVenuCczswGiUZGg8MKr6zJfwEoOYXoPUPZ6V90KdZSXIEJ9AFOvMHzmtf5ZvwHOoVQjqU13oiVB78xMBHP49F90RCaJJwH0tlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xk5Qpe+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xk5Qpe+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72234C4CEC3;
	Mon, 28 Oct 2024 06:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097875;
	bh=MYG/MpmUUTdMwaA2qkbhaEEaB2zprtDbPQ9CPhZodLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xk5Qpe+WZHi40nStu+0X5G5K/irQxYgQwOgSnJd8b0eauchsDOAOU0vguIZReMzXk
	 rgfnbMtYPkXyk1VTtvaMouPZ3DgNeVwx/3mU13/h63ho5Y76l8iy/yd8fsdo5rxmwu
	 eNkIyGTvDHXwar1peBMpn1DF/mAriCQXKZj4QQB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 187/208] KVM: arm64: Dont eagerly teardown the vgic on init error
Date: Mon, 28 Oct 2024 07:26:07 +0100
Message-ID: <20241028062311.235000715@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit df5fd75ee305cb5927e0b1a0b46cc988ad8db2b1 upstream.

As there is very little ordering in the KVM API, userspace can
instanciate a half-baked GIC (missing its memory map, for example)
at almost any time.

This means that, with the right timing, a thread running vcpu-0
can enter the kernel without a GIC configured and get a GIC created
behind its back by another thread. Amusingly, it will pick up
that GIC and start messing with the data structures without the
GIC having been fully initialised.

Similarly, a thread running vcpu-1 can enter the kernel, and try
to init the GIC that was previously created. Since this GIC isn't
properly configured (no memory map), it fails to correctly initialise.

And that's the point where we decide to teardown the GIC, freeing all
its resources. Behind vcpu-0's back. Things stop pretty abruptly,
with a variety of symptoms.  Clearly, this isn't good, we should be
a bit more careful about this.

It is obvious that this guest is not viable, as it is missing some
important part of its configuration. So instead of trying to tear
bits of it down, let's just mark it as *dead*. It means that any
further interaction from userspace will result in -EIO. The memory
will be released on the "normal" path, when userspace gives up.

Cc: stable@vger.kernel.org
Reported-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20241009183603.3221824-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c            |    3 +++
 arch/arm64/kvm/vgic/vgic-init.c |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -777,6 +777,9 @@ static int kvm_vcpu_suspend(struct kvm_v
 static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
+		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+			return -EIO;
+
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
 			kvm_vcpu_sleep(vcpu);
 
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -494,10 +494,10 @@ int kvm_vgic_map_resources(struct kvm *k
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 out_slots:
-	mutex_unlock(&kvm->slots_lock);
-
 	if (ret)
-		kvm_vgic_destroy(kvm);
+		kvm_vm_dead(kvm);
+
+	mutex_unlock(&kvm->slots_lock);
 
 	return ret;
 }


