Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829141;
	b=xsTC4zcpOqdQ9N7ol48+DTjg2sUREZkmscQghXgD7sGrHiDU5P8mG66j4zQuWkF5PD27
	 AVtd21SWKmVxVWY4sN+ncle0Z9eNp5jmO8vDUFlIlKRJaEcl43Sm0JDhnNSncMqLxvGHp
	 RFT9R1nVbyAc/xll2ngXQBJEBOHRd3+BzFvYVfIn7giF6GhJo+JqrlIlOF/yIBOUQPHiM
	 91Ai5lGjRrVslyJI98Pq8TX3ceegq5ae9xU/0KqRyfbHyI7jQY/HQQ4Y/c8CTQ57+KzUv
	 FMke5EmhGhDUHTmKhu6tIAo9qZWqQLJL8I7R8XrEQTgz01GTjETAsuCo3I8Cn07a3Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xVZPv0fuIr1Xm5BnitwJ/YYi1yh+np/oefdc8rIM06k=;
	b=giqB67zWngYqQU+qqnI+TKBF7ckTR6G30uPFApYp+dIfZLcyOWqJpf3lFw0MdFFRgOq7
	 Y+hwu/HJQmhEfTbUXhGGHeuHcdfbPJ4XmU7KwU19YkUEWD1kMDzEi7Q3iWLmoXAjyEvnp
	 n09ScsRY0lwplQGgGku/Y9VHEHqLoGyjgCw0/Xse/G5QVJ/ZKczxssMldKyqnN4sFWMQy
	 xAU6XIHzYxvYoXkzVvsF/glM/jT8yAwUkoRhN/c+GCbAQ5AEDLH78URimEUTJ1ohbVx35
	 D0p8M/sFDsu/R3yvStELI0aeufX7IrueFXxHgdv5g7KPZr06LnzcbtQP0WNlPI6FFyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaYxH9NS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72334608F113;
	Wed,  4 Nov 2026 21:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaYxH9NS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BB41F00919;
	Wed,  4 Nov 2026 21:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829141;
	bh=xVZPv0fuIr1Xm5BnitwJ/YYi1yh+np/oefdc8rIM06k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaYxH9NSxjKd/lW+RC4dvxOzEGc5TTdKAMgy5ApKzE0SWbdEEqMXcyAlz4xLJf6H3
	 6yLHJLs8aL8RH3FceF4HlC6Hn9F+rbC0gh+wtk5UmdWBZB2YF/nL6ffkHSkP7pzsh5
	 TW1m7eLbQaeH3Q+e9YTlMn9yn86EhVRx+fAxAJkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 471/547] KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak
Date: Wed,  4 Nov 2026 16:10:55 -0500
Message-ID: <20261104211051.746908542@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 2616f497506a772db53e7bb1024cde50b4c165e0 upstream.

Ensure all reserved flags are zeroed when setting the msg_pending flag as
part of SynIC message delivery, as setting only msg_pending can leak seven
bits of kernel stack data to the guest.  E.g. gcc typically uses a
bitwise-OR to set the msg_pending flag, without initializing the on-stack
variable.

Precisely zero the flags, e.g. as opposed to zeroing the entire structure,
to make it somewhat more obvious that the flags *need* to be zeroed.  E.g.
it would be quite easy to misread the initial read of guest memory and
think that zeroing the entire structure is completely superfluous.

Fixes: 3a0e7731724f ("x86: kvm: hyperv: simplify SynIC message delivery")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://patch.msgid.link/20260826184449.814130-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -802,7 +802,9 @@ static int synic_deliver_msg(struct kvm_
 		if (no_retry)
 			return 0;
 
+		hv_hdr.message_flags.asu8 = 0;
 		hv_hdr.message_flags.msg_pending = 1;
+
 		r = kvm_vcpu_write_guest_page(vcpu, msg_page_gfn,
 					      &hv_hdr.message_flags,
 					      msg_off +


