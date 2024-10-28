Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0902618D649;
	Mon, 28 Oct 2024 06:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098424; cv=none; b=rshWE9yF6mPyhEmL4JgbeR9UQjS4aysO3KLkzOMaGsnrAO+c5dTrLllaouBsRUzyABDINEMUwKmHa3CepiVnaOsbAwyW7Ygxb6SOXSOlNxQiSuFWUhgU3OxQ00g7AVhRc88W/kCeQXDHa7uOXYp6n9+uxH8Gnr3XMrvZq2i3rTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098424; c=relaxed/simple;
	bh=L7EAANAT1kWs51yV7Fa1D2jAHuIrwNxWI6KMBV29uKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqqMUVDg7qfd0u7Mv1g958B6DzX3db9XeEaGBO2Qd4qoXmA904L3AZosruOx0xDYo1fl84MczpyfdJB8Oq2zUP2Pf0OUtFfiNPjcMsNcNpHyX56v2xCSzplGIC4vx3KAE5Vzazhb9kwvlOKKHiyL0uA6mk775rNQU/N7ekamnSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCt1DCKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCt1DCKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5C4C4CEC3;
	Mon, 28 Oct 2024 06:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098423;
	bh=L7EAANAT1kWs51yV7Fa1D2jAHuIrwNxWI6KMBV29uKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCt1DCKXIonyzJ0AiU64Vr3By+vWUp3+wn828VmTiSGR6BXsmMk8qVtGNb/PbtehV
	 qtcXjjiwDcvU+ZwtsnaO/nE3eM2dDJN/X3SH5qxPwMUZYEOUCUqyhvlhq83ECn6Lrn
	 j/+cJgfbAphucyiVtCnGyaK02cfrjnvKh9cBEORY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.11 221/261] KVM: arm64: Dont eagerly teardown the vgic on init error
Date: Mon, 28 Oct 2024 07:26:03 +0100
Message-ID: <20241028062317.648184386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -996,6 +996,9 @@ static int kvm_vcpu_suspend(struct kvm_v
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
@@ -556,10 +556,10 @@ int kvm_vgic_map_resources(struct kvm *k
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


