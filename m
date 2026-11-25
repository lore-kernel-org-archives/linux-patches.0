Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621360;
	b=ESCFFyvXaRhC8K6Nk0P3Dc2/s6NTivZDarJSVztnRdza3tLWdmav7k/IPMIIpGCSi7MR
	 IE7f1jdcc2h4Z4wxLCBVT7LYbbNVlTgZvTv4+OGLAC/tGPrGBd7aK6oI+bvE2QjxON6El
	 WWoMnekA56fjVoZGgxB73Y3bqZQ4hKTADHq70afo8NwN+epr/Nhu70LS+1EA2SMvuV2eO
	 Bn/oCI6oU3IAUpjWQxBoE36MBHtqUe6aZQoGKb+0xr2iK4TVcnx8SqfC5/vvRARsiAl1W
	 W1QaMKNxklllKxxHBUvS3Q1ShsFUQYTNPZAHLKROCz9is4JmhmEo3rCZ4w5rJvnToFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nBdebUBdb6jf2+UvmI0Hqe5mc2f/x1RrPDT511TxOCc=;
	b=vH3w6X489IQS+pDhvu7c/1fbYRX0Jko3RqhaWTw64Mi4SMcyq775F7uyG2J4y8B8nyDE
	 Z432wWdlL1GwiAkiUYFtMxwBv9n7Jt+2LQIEaVqp+N6i3nqTAuvUETR4esrv0aaWlpxQo
	 v46rdNV0yCiQA8U2EJb9j3ujH87ByetqtEsdfKXycrPRWmALqxbRyZb1cL8NNKmFSyQQE
	 KpZpKPcLoZrKPXXb3LF1l7KtwhA7OiHytBi3kuOY6XIbI0RvgKSVY2siPDepReLHLcklu
	 EOsYM2DLvsNkrepnoHCLL2YhAXt8ZCwwlIDJQFKrOlpfLTVTvHH5PheMS6eYgEddMHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPoNXFkm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2F1606B3BD;
	Wed, 25 Nov 2026 15:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPoNXFkm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658391F000F0;
	Wed, 25 Nov 2026 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621359;
	bh=nBdebUBdb6jf2+UvmI0Hqe5mc2f/x1RrPDT511TxOCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPoNXFkmHrRLa9rQCZdsMf5AehuXELjkK03qVq5uwhmZBUJLugYZHDv+QvzJMdLyy
	 AKbC2MiNEfH9bbeFQBzyZlzOI+GGIicUkfKQBm0qcAkkPHdjj/InaXU1nZfONR/ebg
	 b3DCxO7cVZok8SC/jNNEf8wsMO1pnG5fzBKAb8Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a3f21220cbbb6e14ee2e@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 199/990] xfrm: iptfs: fix skb leak on error in __input_process_payload()
Date: Wed, 25 Nov 2026 15:26:06 +0100
Message-ID: <20261125143826.756459418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 64e45ed926cdd017c9816c8006d9117a7194c7e9 ]

syzbot reported a memory leak of the received skb (and its sec_path
extension) in the IP-TFS receive path.

__input_process_payload() parses the inner packets of an IP-TFS payload
and queues them on @sublist, which is only sent after the parsing loop.
Three error paths inside the loop (skb_copy_seq_read() failure, invalid
inner IPv4 header length, unknown IP version) jump to the "done" label,
which is placed after the code sending @sublist.

Any skb already queued on @sublist is then neither delivered nor freed.
This includes skbs added by iptfs_reassem_cont() before the call, newly
allocated inner packets, and, since the received skb can be reused for
the first inner packet, the received skb itself.

Move the "done" label before the trim/send code, so that inner packets
parsed before the error are delivered as on the normal exit path. The
received skb is then still freed (or consumed) as before when it was
not reused.

Fixes: 6c82d2433671 ("xfrm: iptfs: add basic receive packet (tunnel egress) handling")
Reported-by: syzbot+a3f21220cbbb6e14ee2e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6ae4102e.9c6421ad.36baac.0005.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Link: https://patch.msgid.link/20261030083358.2653599-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_iptfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 4d3489acb099a..9a539618cb8fd 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -1183,6 +1183,7 @@ static bool __input_process_payload(struct xfrm_state *x, u32 data,
 		/* this should not happen from the above code */
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMINIPTFSERROR);
 
+done:
 	if (first_skb && first_iplen && !defer && !first_skb_partial) {
 		/* first_skb is queued b/c !defer and not partial */
 		if (pskb_trim(first_skb, first_iplen)) {
@@ -1199,7 +1200,7 @@ static bool __input_process_payload(struct xfrm_state *x, u32 data,
 		if (xfrm_input(skb, 0, 0, -2))
 			kfree_skb(skb);
 	}
-done:
+
 	skb = skbseq->root_skb;
 	skb_abort_seq_read(skbseq);
 
-- 
2.53.0



