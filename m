Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585580;
	b=FTDWZw7wxCwtWUc+/VGUKEGnwPecLAGuzGpVQYTxBIz6argvMAorJdcFWBr78W/6yNNx
	 N1j/5hzJ4tObg0O2lJIk1IGY+peKi+1cYvDEvedkdNTRUcUjsrQUfAgNOxFGhAx/IFFkC
	 OxBON1JFGVOI/zgBvxN6/Ly7bP1H/Kmjkfg17yo3IB6c9S2sk5EpwDi282Z8KwyWL8wdb
	 E9VmiGz7zjLgKRV3PRcmF7Rf09P9ZThdFSYCuDeItXiObXDrCNAYmNxlKUMqAkxnCBPk5
	 PbYLUJEJejO3F87COYAyCQCS9KeYh0t3yUpahpfi8sYFULHRHTqRvyQAuJFAJ4K9bUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5HZZkmi4P/xb0J36uD7JMHURy1B3/w6f7mQAIlUEBWs=;
	b=epkcDnecP2oOV2JLGbD7OsGJzH3PHJ/StzmQMwTgPDpe17D3Fjn+VgA0BoQ3jaIMIPBG
	 YztNp7cGL3nQ/B7pgPglbnd4L2QcO+y11dyh9sVyJloUV4jq7ePVyJT5TwnSinyxr76G0
	 pTpEa8l5TYmfD+EimIZb42nFvH5Lil7/iP4BUHu3ga9sA7pOQWi01NfarWi48Z1S02Q/7
	 Ct8UNYZw6q42ZUxDwOsNKUH3L4bPVlZ1Aaihpsoki2kQgzUfl50/RqldDKJqiPhsTg7TD
	 xCoU9qsFycQJOBU2je23iDQ3VOrwhgz6i6mYcrY6OONUhOVnVaeDyGZt3net+HgWXeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDJREg2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD71606EA9E;
	Fri, 13 Nov 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDJREg2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6F41F000C4;
	Fri, 13 Nov 2026 15:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585580;
	bh=5HZZkmi4P/xb0J36uD7JMHURy1B3/w6f7mQAIlUEBWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDJREg2Qn/GdYFgk+hUNWG0YjrPEThWuQsQ58sNmDlxC6gj4lVnLDmie+otsvl5p+
	 shvd8pFXdz8DOgLwTPKU805bUihXz9aKbCtaoiv9Gso8641sG6S5VpEV4Bj4qARrCM
	 KN1w1/5vXA+asxHScccSZi5vehd1sjaYSoEjOVKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Wang Zhan <wang.zhan@smartx.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 212/507] inet: frags: limit the truesize of a reassembly queue
Date: Fri, 13 Nov 2026 10:48:36 -0500
Message-ID: <20261113153801.671672012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 3ae20e4697eb969104fe4b1e98a675f0100382b6 ]

The truesize of fragments in a reassembly queue is only bounded by
the per netns ipfrag_high_thresh sysctl, which has no upper limit.

inet_frag_reasm_finish() sums the truesize of all fragments in an int.
If this sum reaches 2^32, it wraps, and the final sk_wmem_alloc
adjustment of the socket owning the reassembled skb can cancel its own
reference, leading to a use-after-free of this socket.

This can be triggered from an unprivileged user/network namespace,
raising ipfrag_high_thresh and using padded TUN packets, which keep
a large truesize after being trimmed by ip_rcv_core().

Track the sum of the truesize of fragments in each queue, and refuse
a fragment that would make it bigger than INT_MAX / 2. Callers kill
the queue on this error. This bound is far above the needs of
legitimate traffic.

Fixes: 18685451fc4e ("inet: inet_defrag: prevent sk release while still in use")
Cc: stable@vger.kernel.org
Reported-by: Kyle Zeng <kylebot@openai.com>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Tested-by: Wang Zhan <wang.zhan@smartx.com>
Link: https://patch.msgid.link/20261030081225.2575462-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_frag.h  | 9 +++++++++
 net/ipv4/inet_fragment.c | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index b02d2472b003e..c1fb419a9cf03 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -79,6 +79,7 @@ struct frag_v6_compare_key {
  * @tstamp_type: stamp has a mono delivery time (EDT)
  * @flags: fragment queue flags
  * @max_size: maximum received fragment size
+ * @truesize: sum of the truesize of queued fragments
  * @fqdir: pointer to struct fqdir
  * @rcu: rcu head for freeing deferall
  */
@@ -100,6 +101,7 @@ struct inet_frag_queue {
 	u8			tstamp_type;
 	__u8			flags;
 	u16			max_size;
+	unsigned int		truesize;
 	struct fqdir		*fqdir;
 	struct rcu_head		rcu;
 };
@@ -172,6 +174,13 @@ extern const u8 ip_frag_ecn_table[16];
 #define IPFRAG_DUP	1
 #define IPFRAG_OVERLAP	2
 #define IPFRAG_MIXED_SECPATH	3
+#define IPFRAG_TOOBIG	4
+
+/* Max sum of the truesize of fragments in a queue. This keeps the sums
+ * done in inet_frag_reasm_prepare() and inet_frag_reasm_finish() well
+ * below INT_MAX. Legitimate traffic stays far below this limit.
+ */
+#define INET_FRAG_MAX_TRUESIZE	(INT_MAX / 2)
 int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 			   int offset, int end);
 void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index c18da91c1f031..0b8d22ffafca6 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -336,6 +336,7 @@ void inet_frag_queue_flush(struct inet_frag_queue *q,
 	q->rb_fragments = RB_ROOT;
 	q->fragments_tail = NULL;
 	q->last_run_head = NULL;
+	q->truesize = 0;
 }
 EXPORT_SYMBOL(inet_frag_queue_flush);
 
@@ -446,6 +447,9 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 	if (last && !secpath_equal(last, skb))
 		return IPFRAG_MIXED_SECPATH;
 
+	if (skb->truesize > INET_FRAG_MAX_TRUESIZE - q->truesize)
+		return IPFRAG_TOOBIG;
+
 	/* An IP fragment is never a GSO packet, but an untrusted source
 	 * (virtio_net_hdr) may have attached GSO metadata to it. Do not let
 	 * that reach the reassembled skb, whose head keeps the first
@@ -510,6 +514,7 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 	if (offset)
 		nf_reset_ct(skb);
 
+	q->truesize += skb->truesize;
 	return IPFRAG_OK;
 }
 EXPORT_SYMBOL(inet_frag_queue_insert);
-- 
2.53.0



