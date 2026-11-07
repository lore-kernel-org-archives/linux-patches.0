Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061762;
	b=J/X4uTG349XXGtQIK4b48vAAujPyqEVnmTbYG7kihVae1tO7drKWyb4zSACYmHyyI5x9
	 VHZKvt+HaO5XiYxIWAJBu2mvL7owyfZlA15Zz5JWuhuiDhzJme90CS60DRIpSleilI46b
	 62xaE0aFHIjY2oN4xe8HIqvGN84umUxWcQxExX//OYPwDXNnWatE2PPjQO7M/iRUBY7lG
	 yYtg/ThbP1pYch5hNfMA+kbWDAi7P2wn6YWmIkZ9ruHNmSiXBmTyNgoGWm20LuJmJABGW
	 XmQ4dGmsWpzbWEuH1ApXAWhCKaEllJdZg2LizeJzr8qho8zrdlN6TuDoxj2DUUGtJSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ax4YokxRnXnlh5gWoel+tMSK5of0lJgCI1r9ws4OEc0=;
	b=Lwg1yOH9x8b/zrylFtX0GeHfzccD5hQsQ07s2D8Y7Dkoy8b7yb5PVgIUdgnrCsXgD/bX
	 O4NaD7VWtDjPLtyvkhG/DbLZIaM7K+j3XntgESuJ89+AeNWDB/Ojj29LFt4+wuwWAWGGC
	 SJXDbwR4KGRJLNsfptUxJOdqikEduFtHa7x6+e1ms/pwodBRz9u867hY9rjvFcF6oZfel
	 K6/XCtF/g8fVB1b1vMowXQ2oASKEopZweBJ4mL+KsXxY40hKyznpANtsTwHRE1LuLMLqQ
	 kL0SKwyS4utE81h5YGSaaogF+x/szevF1XHsMjnN7111Q9pFWu1yIB+WSNkYydsGL7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4Mk070Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D5F606A326;
	Sat,  7 Nov 2026 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4Mk070Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15C71F0089F;
	Sat,  7 Nov 2026 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061761;
	bh=ax4YokxRnXnlh5gWoel+tMSK5of0lJgCI1r9ws4OEc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4Mk070Yr9NKf2Tx9vAZJ+GClXJekOg54miyGyFOkaz9GZm6pxAMK7o4YQrcDyiSa
	 XncRhcKdI0A7PqqDyGyzfTrrLtCCq0BmTBDUtn74t6XkD9zecgct4I107iFLxjowdc
	 xNr2Xy+yD8q0I7SI/tDno9In+ozkZ+srhg+qCKQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 0799/1536] KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_interrupt()
Date: Sat,  7 Nov 2026 08:46:55 -0500
Message-ID: <20261107135019.988292489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit aa8ad943f242ef14d136c5440b1178de77466c9e upstream.

kvm_gpc_check() checks the cached memslot generation against the current
one, which dereferences kvm->memslots and therefore requires kvm->srcu to
be held. __kvm_xen_has_interrupt() does not take it.

Most callers do happen to hold kvm->srcu, but not all of them:

 - kvm_emulate_halt() on the VM-Exit path, via kvm_vcpu_has_events() and
   kvm_cpu_has_extint(). vcpu_enter_guest() drops the vCPU's SRCU lock
   before entering the guest, so it is not held on the way back out.

 - kvm_vcpu_block() -> kvm_vcpu_check_block() -> kvm_arch_vcpu_runnable(),
   which is the case the existing comment in this function describes.

On a PROVE_RCU kernel the former produces:

  WARNING: suspicious RCU usage
  include/linux/kvm_host.h:1092 suspicious rcu_dereference_check() usage!
  ...
   kvm_gpc_check+0x344/0x3e0 [kvm]
   __kvm_xen_has_interrupt+0x83/0x310 [kvm]
   kvm_cpu_has_extint+0x1ff/0x370 [kvm]
   kvm_cpu_has_interrupt+0x16/0x100 [kvm]
   kvm_vcpu_has_events+0x4ce/0x690 [kvm]
   kvm_emulate_halt+0x52/0x1f0 [kvm]
   vmx_vcpu_run+0x988/0x2630 [kvm_intel]

Use guard(srcu) so that the three existing early returns don't each need
an explicit unlock. SRCU read sections nest, so this is harmless on the
paths which already hold it, and srcu_read_lock() does not sleep, so it
is also safe in the atomic case which this function already handles.

Fixes: 7caf9571563e ("KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info")
Cc: stable@vger.kernel.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://patch.msgid.link/20260831213632.81023-11-dwmw2@infradead.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -665,6 +665,16 @@ int __kvm_xen_has_interrupt(struct kvm_v
 	BUILD_BUG_ON(sizeof(rc) !=
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
+	/*
+	 * kvm_gpc_check() checks the memslot generation, so kvm->srcu must be
+	 * held. Most callers hold it already, but this is also reached from
+	 * kvm_emulate_halt() on the VM-Exit path and from kvm_vcpu_block(),
+	 * where vcpu_enter_guest() has already dropped the vCPU's SRCU lock.
+	 * Taking SRCU does not sleep, so it is safe even in the atomic case
+	 * which is handled below.
+	 */
+	guard(srcu)(&v->kvm->srcu);
+
 	read_lock_irqsave(&gpc->lock, flags);
 	while (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);


