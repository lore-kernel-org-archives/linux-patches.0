Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047369;
	b=WxSbFOzRGrhTT8EHrnyLNDiU/HdzARyzdVsn4nmb4mtvl9dMFd4/jvFiPm5aI2KK2Nq/
	 MDvGkXqU38s1B/LqPWD8Uk8rpB2BQEOeNkWIE+zx0nbgKHFZsi8N5BTD27TJVrw1GcI/w
	 TalR7vmzgrJ6HoI5Dn2YcJE2gHEKI78ND9LuPDKJwG1Yofp7A79u+VfFYgfZRnMSRZLoG
	 asa+/hzy9FC7TjCawVGahQP/UrmEj9cfrqeDXEBPkFwIoKDfgpnamHMuk6hczV5EHDAQt
	 1q175EG9mbcBrQtwAYY0qe/5gfeYmMXonjwGoaZbljvGIFxPgPxvHl8DvHOCzSR7x7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hZXP6NCsEXpaUzqw0K4oIDKUa9V+fyzXBpcdRLvZffE=;
	b=g3KQKKIcX+OyTTqpmsKnR0GkuW0VffWqT8ZkreyktmHe9dC8fQpMxR6vXSg+CfRLSR8/
	 V/yBknRyIVI/NNCcTsVDpfrmIhnVY0ZzWlfsw3HJUHI+MROuQIt3BoH88J/Zmyqtf4Ndi
	 xY+ztQ3U3+I7OZL4r9UAPwy9o+/m0JdI6pBDj/hkA0IK3YrMDduCn3Sj7GMXEOYCBFiGK
	 ICZCaV6V0QM3GZQ5hRKyAUyMVXEalgeQP0YyftWklr6T1zFZYwu3hpZ70yjfECJnNlObS
	 xs3zy42W/rmluIAD0OnIrB6LqjYHLybTf+8sor95+8XNNG9GFM3fFS4LvtOidR7mxRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIuwVn+o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3BD606A32A;
	Thu, 19 Nov 2026 00:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIuwVn+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14951F000C5;
	Thu, 19 Nov 2026 00:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047369;
	bh=hZXP6NCsEXpaUzqw0K4oIDKUa9V+fyzXBpcdRLvZffE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIuwVn+oW50WNz7loxWbWhMgc/59vBwNugoXJAdX0D6JNEp4H/XnGi1lSaEjERxHp
	 cn7B7/LnNtlm1FQDoWhBltRUHWfQ6e/MAzdMoqu/OZOklf8PZRRYIknS1WQIM4gp9t
	 1e82dWUJVJobdLtboe89xvXow4XvOxMuOrQfROQE=
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
Subject: [PATCH 6.1 1614/2857] inet: frags: limit the truesize of a reassembly queue
Date: Wed, 18 Nov 2026 15:44:08 +0100
Message-ID: <20261118150259.466931735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: moved the truesize reset to ip_frag_reinit() because inet_frag_queue_flush() is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_frag.h  | 9 +++++++++
 net/ipv4/inet_fragment.c | 4 ++++
 net/ipv4/ip_fragment.c   | 1 +
 3 files changed, 14 insertions(+)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 0b0876610553f..2ed882dd089a7 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -76,6 +76,7 @@ struct frag_v6_compare_key {
  * @mono_delivery_time: stamp has a mono delivery time (EDT)
  * @flags: fragment queue flags
  * @max_size: maximum received fragment size
+ * @truesize: sum of the truesize of queued fragments
  * @fqdir: pointer to struct fqdir
  * @rcu: rcu head for freeing deferall
  */
@@ -97,6 +98,7 @@ struct inet_frag_queue {
 	u8			mono_delivery_time;
 	__u8			flags;
 	u16			max_size;
+	unsigned int		truesize;
 	struct fqdir		*fqdir;
 	struct rcu_head		rcu;
 };
@@ -179,6 +181,13 @@ extern const u8 ip_frag_ecn_table[16];
 #define IPFRAG_OK	0
 #define IPFRAG_DUP	1
 #define IPFRAG_OVERLAP	2
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
index 9586bbbe92f9c..ba1e851257002 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -384,6 +384,9 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 {
 	struct sk_buff *last = q->fragments_tail;
 
+	if (skb->truesize > INET_FRAG_MAX_TRUESIZE - q->truesize)
+		return IPFRAG_TOOBIG;
+
 	/* An IP fragment is never a GSO packet, but an untrusted source
 	 * (virtio_net_hdr) may have attached GSO metadata to it. Do not let
 	 * that reach the reassembled skb, whose head keeps the first
@@ -446,6 +449,7 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 
 	FRAG_CB(skb)->ip_defrag_offset = offset;
 
+	q->truesize += skb->truesize;
 	return IPFRAG_OK;
 }
 EXPORT_SYMBOL(inet_frag_queue_insert);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 43b1265f5ac19..be83c4b74036b 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -268,6 +268,7 @@ static int ip_frag_reinit(struct ipq *qp)
 	qp->q.rb_fragments = RB_ROOT;
 	qp->q.fragments_tail = NULL;
 	qp->q.last_run_head = NULL;
+	qp->q.truesize = 0;
 	qp->iif = 0;
 	qp->ecn = 0;
 
-- 
2.53.0



