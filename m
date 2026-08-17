Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F89C3E025C;
	Mon, 17 Aug 2026 14:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976875; cv=none; b=ZG7sNxPGrgwGJTolrSta6k8wgzyPnpngio+BgMTxHA6FLb49PaZeqjRIvTfevaC+36KCQr2B3fWdb9ZWSF0Q7ufLeUDLz53cdUpkIy6vGBA+Dm8i5igYKN6PHfb4+jFomg4WPdzNu1niFhYo5gDd/LaKCBXM/Y+HxHgZyLYeOb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976875; c=relaxed/simple;
	bh=SS0LHo2PDgRyxZ7d9uEgcku0B5iQHiGOnopXVEQ+y/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRNbg5ophhd7R8Wu8PYXYnwYrEf7SJcTNQ5aO90r36boc9cqPd2okpSPfgRkIn7PGwOJGBo7+xW1an6Y/ruVYSqR8tfoiYxqpJomB10NgOo/8vWLAbQn1iXm4sFdh1E9ajXARnErE2irE4iRjrySGICed3cTFJEcdOk+TWmwxDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQEK8Lw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQEK8Lw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696C01F000E9;
	Mon, 17 Aug 2026 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976874;
	bh=H2OUSvcQ0jmTm4kaO9WCnq/AbQhYpvK41FbhxYZ5Wpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQEK8Lw89MJbgUNmeMYl+wAo6s5RIqE1k6P0CJvoDz8lFujCpDAzpEnTtelTkJMjb
	 G01fUhfX+W1j/P38yGfiGfPxOHuTf6KbQhNGd85KLxheaOvwsZA5ze0QZdV+9UcpFU
	 Ky01MJIcI3NIaNd5PUx60YzpUZHEMsX0OK688GPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/456] bpf, sockmap: Fix cork use-after-free in tcp_bpf_sendmsg()
Date: Mon, 17 Aug 2026 15:28:43 +0200
Message-ID: <20260817132545.304855359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 2d66a033864e27ab8d5e44cb36f31d9d2413bee4 ]

tcp_bpf_sendmsg() keeps msg_tx across sk_stream_wait_memory(), which
drops and reacquires the socket lock.  Its error path tries to decide
whether msg_tx names the local temporary message by comparing it with
the current value of psock->cork.

This comparison is unsafe when two threads send on the same socket:

  Thread A                         Thread B
  msg_tx = psock->cork
  sk_msg_alloc() fails
  sk_stream_wait_memory()
    releases the socket lock      acquires the socket lock
                                  completes the cork
                                  psock->cork = NULL
                                  frees the cork
    reacquires the socket lock
  msg_tx != psock->cork
  sk_msg_free(msg_tx)

The stale cork is therefore mistaken for the local temporary message
and freed again.  KASAN reported:

  BUG: KASAN: slab-use-after-free in sk_msg_free+0x49/0x50
  Read of size 4 at addr ffff88810c908800 by task poc/90
  Call Trace:
   sk_msg_free+0x49/0x50
   tcp_bpf_sendmsg+0x14f5/0x1cc0
   __sys_sendto+0x32c/0x3a0
   __x64_sys_sendto+0xdb/0x1b0
  Allocated by task 89:
   __kasan_kmalloc+0x8f/0xa0
   tcp_bpf_sendmsg+0x16b3/0x1cc0
  Freed by task 91:
   __kasan_slab_free+0x43/0x70
   kfree+0x131/0x3c0
   tcp_bpf_sendmsg+0xec3/0x1cc0

msg_tx can only name the stack-local tmp or the shared cork. Check for
tmp directly so a changed psock->cork cannot turn a shared message into
an apparent local one.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/87fr18lmzo.fsf%40cloudflare.com/
Link: https://lore.kernel.org/netdev/20260719161630.2901208-1-nicoyip.dev%40gmail.com/ [v1]
Link: https://patch.msgid.link/20260724103856.3399001-1-nicoyip.dev@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 11cb3a353cc6dd..f94b8d4ba23a36 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -525,7 +525,7 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 wait_for_memory:
 		err = sk_stream_wait_memory(sk, &timeo);
 		if (err) {
-			if (msg_tx && msg_tx != psock->cork)
+			if (msg_tx == &tmp)
 				sk_msg_free(sk, msg_tx);
 			goto out_err;
 		}
-- 
2.53.0



