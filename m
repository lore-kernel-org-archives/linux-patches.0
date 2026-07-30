Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49944519AC;
	Thu, 30 Jul 2026 16:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427534; cv=none; b=njUzVvo1jvsA1aj2sQYztWIdilbeXYc3VyKQvn6bQdvsJQGLLbSD2gPOSd+Wr915nRH/Hb4fWsS34CoMYnkJJnel1eGorlWjz3b/lbuyzlaf9tu2lyocmYaM9cj+PCaNjg2Gc+mxm94E/livoM1Vn7TyMNhgJSETClbBIiZ82K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427534; c=relaxed/simple;
	bh=QfP1IXZbjsUgaHLf/AvrIZ4lSZbRVgwL8FzRWtuez4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZHgq8yluTxH2chf69O8S3GqU7CitVciileSVdkXdZt1RWJ9Prb6JL5LngIB/q+jva7d9MfKVT11Hh6tNLqanIBL5TMzgmH2IdaxftS9R3HYGgPIig7ccvnq7kSH9GRU2h/l8MZh/FT8OpZ4/2sv8ZmL1YFS/hHcxHJ6ZtNJEQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUAUhvWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUAUhvWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA3A1F000E9;
	Thu, 30 Jul 2026 16:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427533;
	bh=dh0RwCBpGAVg2XMfFaslyaqCQobkO8i3WTJNDmKfnTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUAUhvWcZ4c+ftirtxfI2dxIi9ZZ00wdiy2HQbMSzirj5SYC63fqBzyaXpzGN/zld
	 XcfH23E1Wq7PuF0Df7tbu+fHySkAmD5mi3/pGoIpHrUPRRw5ZpJ5WVM9yDGkCBOJEv
	 hyfUi6fDUAadSSovgx/zjkvjlNyX6PJZp4LhWtMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/484] bpf, sockmap: Fix cork use-after-free in tcp_bpf_sendmsg()
Date: Thu, 30 Jul 2026 16:11:41 +0200
Message-ID: <20260730141427.900557944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index da5e14ec8ed6da..337f6edd4757e3 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -590,7 +590,7 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
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



