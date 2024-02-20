Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDF1612D7;
	Tue, 20 Feb 2024 21:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463906; cv=none; b=gLFU4RuXWo+5nmfPMsOCWeC6fKYUfU86UOhSsRz6ne4NYp+OAVazt1G2rEF+2FNBfccuOAFC4gZjH7ZpBxMZP0K4XKnGiVLzuEIB9EzTFrhL+5cdjUhSlkO3qE8fMN7hJ7D596tBODdgCOX2xAWzTpXVy2Jmo9QmWNnFZ9qFfaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463906; c=relaxed/simple;
	bh=cr0zIS5PqahbwG/t2DOBiBq5XEYGp6WDIeaE3tl3d9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf1/8GZAaRW/1iRXjt9kanJaCGa1CjjRrNVUrYfgQH98XXxm336CxFYcbNg3OmloWi+SLtZvLkWCGUmHsoj0EmaIhWi7CdyRGIOhVXT8YhXZeNJVd1jStQxirwsmmg6zzCj7Gr2IYAi9yX7ICe+i5I6UpS2uGBZKuh9FvyBkXKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCoBGn3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCoBGn3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41AAC43390;
	Tue, 20 Feb 2024 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463906;
	bh=cr0zIS5PqahbwG/t2DOBiBq5XEYGp6WDIeaE3tl3d9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCoBGn3kO6hB8VfMtGs5BahomAYq50SMrlHefe+zxxX8Zx7tdaBxU1Hw9i7/195m9
	 K+1szaumNFZvBbWqyAQ2Uc3qww+EkNhlzwZ5EkRodwrmVx58o/7JAVO02g6ascd4kV
	 oIoiP+4m5dQPIY5TLNVfa9WsUJCklkV1VN64jiVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Pandit <pjp@fedoraproject.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 191/331] KVM: x86: make KVM_REQ_NMI request iff NMI pending for vcpu
Date: Tue, 20 Feb 2024 21:55:07 +0100
Message-ID: <20240220205643.577013924@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Prasad Pandit <pjp@fedoraproject.org>

commit 6231c9e1a9f35b535c66709aa8a6eda40dbc4132 upstream.

kvm_vcpu_ioctl_x86_set_vcpu_events() routine makes 'KVM_REQ_NMI'
request for a vcpu even when its 'events->nmi.pending' is zero.
Ex:
    qemu_thread_start
     kvm_vcpu_thread_fn
      qemu_wait_io_event
       qemu_wait_io_event_common
        process_queued_cpu_work
         do_kvm_cpu_synchronize_post_init/_reset
          kvm_arch_put_registers
           kvm_put_vcpu_events (cpu, level=[2|3])

This leads vCPU threads in QEMU to constantly acquire & release the
global mutex lock, delaying the guest boot due to lock contention.
Add check to make KVM_REQ_NMI request only if vcpu has NMI pending.

Fixes: bdedff263132 ("KVM: x86: Route pending NMIs from userspace through process_nmi()")
Cc: stable@vger.kernel.org
Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
Link: https://lore.kernel.org/r/20240103075343.549293-1-ppandit@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5300,7 +5300,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_e
 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
 		vcpu->arch.nmi_pending = 0;
 		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
-		kvm_make_request(KVM_REQ_NMI, vcpu);
+		if (events->nmi.pending)
+			kvm_make_request(KVM_REQ_NMI, vcpu);
 	}
 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
 


