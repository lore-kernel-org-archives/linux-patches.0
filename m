Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829133;
	b=ob8HbEmDTfiuAmVUarXtM2gwvzmcXnYiBTWdb7cgDJCz8FvaoQRuadXFPIpfn/9P/rTg
	 K9TOCY9FnaODQWpGustZ7TejEQwGeWtyPnnEnYOa7ctD7W+onN3aNDdhCkFziSqNRSgPp
	 BCcbs28v1btqaEZAIs25z+IGWfvByBTn46dt4sEEjsFOYAJ2voYcWcn4r1PKkWeruBNpX
	 8hXuEQeaotiJD9sXfHNNBoChnf/WqaEefz3SQ9wSce4SCxvOVsgebLzEUDV5ostBfB4MT
	 E9mrYOYlGbtin4BQceEpVhXWSfnr//w5jgJXO4tbQC2x5cf/8fTsAANB+A5RA8aD9Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mQUJ8aFGq6/LiaWpdunAqpO5fITjD80mynCQWRxAjYg=;
	b=Sc63rMYCkQHRoY3b7ZUoS/AVseogF2wLpskUpHu1PrzqpqN0EAKpDhlS1DvKYNoYkkse
	 hSxc8zo4JFxBpxtQI/6rPtP4vlnNzv3wsE3eMLhmJdUdEpeOnOYzk/6VqbPYep20m3CUI
	 tEuFRaPPq0rdxfN2IwO86+RAeTrHCAYrABKO/Vc5Xq3UF5UMf+oT8VCKaJ5Kt3phC1fXa
	 zFI39QR5oaIrVcMbTIB71cR8huB63gJVhibIhU909hU/ij/eLMJiHBbWo61GyrUHrQbIs
	 A0T/PistKpHXqOCYzWlNSpXhDtsDwXgCy98NaqzlEESPfXzuDFTP8RPhi5kpcS+cBzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I/kf0LCg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDC8607350D;
	Wed,  4 Nov 2026 21:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I/kf0LCg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7AD1F00A17;
	Wed,  4 Nov 2026 21:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829132;
	bh=mQUJ8aFGq6/LiaWpdunAqpO5fITjD80mynCQWRxAjYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/kf0LCg9Jm/K23NGGXoJnwzD3/MdHH12cA6p1ZJQFgdJUPd85YEA4XJBW0xCzSxR
	 AjQZ988WipQ9oDp4VeVzJ237Xr7XQnHFSZ2ESXU75FGTJX8WnleBgR4+N9MzD5D9XD
	 2A3Qcxc+DBVKP/zkcwJWFDpSBOEBTHUK5EgJ2XEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.3 466/547] KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_interrupt()
Date: Wed,  4 Nov 2026 16:10:50 -0500
Message-ID: <20261104211051.594156888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -728,6 +728,16 @@ int __kvm_xen_has_interrupt(struct kvm_v
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


