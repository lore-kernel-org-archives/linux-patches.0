Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775055;
	b=vSCWZm8oaWC8gWcGOfmyEbo87Ucfi+vgMMSqBT+X1J6VYazxLJ1L4DwZQS6KTY9tYrkb
	 dLhXTNU+1na3b8+N1i/aeIXx+68k61Sf4h78MBhYkXNBwnGqFG4MxFcO7+aBKS721aG2P
	 6bzsJuqdhmtlyzhMoGBe6GA1aRI1JUnavejHSYO7NlOkmrZoLwdqJo2ah/cGFs34yeYAW
	 DeKms7IbQ8+1u6eWfk10PAWFwJImGq2j79OR8Yc/rnCWngqNZzGqZWC7BtnuHfVXaBcHo
	 Dl6B0TJe5t9yNiCT/tOTImn7liYf7EaUdQi81iiZhu8oaj/raTurTHUUGHx7neL0vXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9C6rrmHj2Y4mqVcjFbHvaytJdO1IBDQWqNIWKu44YOM=;
	b=179vz5MaPcOKR67nYz0ptzcP3YErotL/cLPj86flKHR+g7mL2hJm+g8FUfrsqSpwKnnM
	 SAKjGjhMXIe48p8bXm/iwCHt0HgFsBYg2YBQFKCI4H8APsUnC1gAeug2/vS4eEtnPBBxj
	 WQzJ4CqV6fnrxkdpyyK30w1fDa2eNhuOS+bW4HFDP2u7PbTnoOcNA/48MdfKmIkh7RFPl
	 grO+1/Oz3zdVYYddv+P3pK6VWEZUr6O321V3WbsHVw0nm0suWSXIWJVG46Rpha5lwtyyG
	 dbIfg8+78nWaIRRu4D75yea3ktaJMQIDndi+OdbyiVUiQXdV9rcYPRE8L1SIxjeTCFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzi4dfP6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3572606A31D;
	Fri, 23 Oct 2026 17:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzi4dfP6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06B81F01825;
	Fri, 23 Oct 2026 17:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775055;
	bh=9C6rrmHj2Y4mqVcjFbHvaytJdO1IBDQWqNIWKu44YOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzi4dfP65qLeHAITxuoOlyO4H3pT8j7qd34Jw4z7USKBMVOqT3sFjYp6O8B6qOO3C
	 qWJtyn9u7Dnmy/mgLUL78hMXETh0xv5ZOjD2Iu3lkBxwlHg1jaVLmGkkR/IlHClBGl
	 iF/5us96zBfFhFVR6uJOMbhgwIo8Bo98fQZiOZ/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 215/242] net: psp: do not inherit the Rx association on clone
Date: Fri, 23 Oct 2026 18:40:57 +0200
Message-ID: <20261023163718.892583040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit 1d2929d0850fff683b8aff051275945e65f082c8 upstream.

sk->psp_assoc sits past sk_dontcopy_end, so sock_copy() copies it into
every socket accepted from a listener without taking a reference, while
inet_sock_destruct() puts for every inet socket. psp_twsk_init() does
refcount_inc() for the timewait socket, so a child closing through
TIME_WAIT cancels its own put and leaves the association with one
reference and N timewait sockets holding the same pointer. Closing the
listener frees it, and the timewait timers then put freed memory.

Rejecting the association on a listening socket is not sufficient: a socket
can acquire one while established and then be turned back into a listener,
because tcp_disconnect() leaves sk->psp_assoc in place.

  BUG: KASAN: slab-use-after-free in psp_twsk_assoc_free+0x6f/0xf0
  Write of size 4 at addr ffff888110f9255c by task swapper/7/0
   psp_twsk_assoc_free+0x6f/0xf0
   inet_twsk_put+0xda/0x1b0
   call_timer_fn+0x53/0x2e0
   __run_timers+0x764/0xa80
  Freed by task 99:
   kfree+0x1a7/0x500
   process_one_work+0x7ec/0x1100

An association carries a per-connection SPI and key, so a child must not
inherit the parent's. Clear it on clone.

Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/BC10EB92-ABB3-41B2-AB16-266BEEBE18C0@doyensec.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2495,6 +2495,9 @@ struct sock *sk_clone(const struct sock
 #ifdef CONFIG_BPF_SYSCALL
 	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
 #endif
+#if IS_ENABLED(CONFIG_INET_PSP)
+	RCU_INIT_POINTER(newsk->psp_assoc, NULL);
+#endif
 
 	/* SANITY */
 	if (likely(newsk->sk_net_refcnt)) {


