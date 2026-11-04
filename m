Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829137;
	b=zGyRH+YBDB4TXeVMSmHfH/nGaEo7ZX00lbi5OWhzTuqBEHylpSNjvb+2kX9wjLZdrg3I
	 ownZasVwyc9DlTjc3/6v/9SV8U2UvUhgJcGbD8XnD5y6GW4OY5zjZ8C1J5RqXfc/uvFyw
	 7tUR5cZfl3lFYSnu2c5OZBzu2xdgfuKZcz45O6go7MP1HtxBOVHMwOAdFZ4cfYRaYe6Nr
	 FCKzi2Dggd3Wd6oG5h8GbL1sZehzpVPsyQmsxtLJae7QazwfhBwkdqTCUM0CUjPxk3/DB
	 uq6IVoqXz0vpC5baVWrrfxFrRO4wRGZ1NORBL93iPB8NFXLlpRBGP1IpKOItG3b4VXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zkq72hHzpn5T6wnrQp8GXaECWnmF4StPO3SfeUjkAgY=;
	b=FpwFsR3NUpMH765uq4Bm1GM6k5QxnsksiyXG0MG0PXQCH9j1pwHP44cN0R3sRJamZMD+
	 iEPVtahoX8Sf4HdIVJNVBGs9uxJEPcFUcG9zEVVlJhRCCayVdiXomegJ53kd7WbEWm7Sh
	 80UsFOhDegW0LRQgAj6prHGhYhMTx7FxVNlYtKvQccfGR/YxkAcBf+GqjBkFl6Z9Gi3bN
	 OsMZxRdXZ/Tod/hJi7MTfJ/J5Vlzw427tBPF+9s5QcS4nyTVeVsgk4eQmmERGASseHCpo
	 I5yZKcRX9Va1HkMWUh3YxKqQmSl4nIliei09sYS6JQygupuP8JQWNIiXSt7VMhf9B6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCxjhxZu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C6A6070317;
	Wed,  4 Nov 2026 21:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCxjhxZu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6E61F0093A;
	Wed,  4 Nov 2026 21:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829136;
	bh=zkq72hHzpn5T6wnrQp8GXaECWnmF4StPO3SfeUjkAgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCxjhxZuRQlk4FzrALtXh2wZmrBfe98z+1BibrbY00al4Sm9wEr9fAGKFoNFrPBJ+
	 jU8L9jhlbwrCP5s90ZUMx4eWM5iij23gkpil91Noqvrqo1Z+IS7sDQIXvffqz0UD4J
	 ba0bbbnzdJKHTSghkZCYdTBWSgIMPbroQL+IC/AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loc Nguyen <loc@ryzome.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 469/547] KVM: x86: Request event processing for exception VM-Exits
Date: Wed,  4 Nov 2026 16:10:53 -0500
Message-ID: <20261104211051.685556447@linuxfoundation.org>
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

From: Loc Nguyen <loc@ryzome.com>

commit 88b23a2e8286b7016c3b58dc10093cf28c22aa3d upstream.

Request event processing whenever kvm_queue_exception_vmexit() queues an
exception VM-Exit.  Most callers reach the helper through
kvm_multiple_exception(), which already sets KVM_REQ_EVENT, but nested
asynchronous page faults call it directly.

Without another event request, vcpu_enter_guest() skips
kvm_check_and_inject_events() and re-enters L2.  A subsequent VM-Exit can
clear the pending exception while reconstructing vectoring state, losing
the synthetic #PF VM-Exit.  The APF reason remains PAGE_NOT_PRESENT and a
later regular #PF can consume the stale value.

Setting KVM_REQ_EVENT in the common helper ensures that L1 receives the
queued VM-Exit before KVM re-enters L2.

Fixes: 7709aba8f716 ("KVM: x86: Morph pending exceptions to pending VM-Exits at queue time")
Cc: stable@vger.kernel.org
Signed-off-by: Loc Nguyen <loc@ryzome.com>
Link: https://patch.msgid.link/20261002053723.3275202-2-loc@ryzome.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -456,6 +456,8 @@ static void kvm_queue_exception_vmexit(s
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
 
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	ex->vector = vector;
 	ex->injected = false;
 	ex->pending = true;


