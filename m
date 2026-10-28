Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207850;
	b=jXG1jobeS/FlKsOCYEGuxeDpFJVHM2PXlKdqqInWk3tpQPEXx8xKZGNxYim+jn7m+Bmj
	 +unsNqBwTD3HC9V79OB1PLyRJTiCjsMXH+S4uDnl0CRU/4+3LYKVV+ECIMIu5jMnxCUom
	 S6qE2EHxLoRWA+hH66HVC/PmE38eQ1klXNUE5ELbfZJU8NBef7JU5SILhxg6IvPhAqAFZ
	 j+3OLNNt0PtMLrV7EDyEKEs4M2nBIJlwXax2Y7voT10Hqrp3IA3AoxRPXQA9WJ2jHC1X0
	 9lglloFSgrl6ZlkDpY0r75Q421Q7ZpaI+7Ii+89hwISY3ezJuq7Y5zWSs6yPmrH1T0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6JoO36ZUmBbqBfwr/idBgFjIV3Z5o1Zo83d+CmBybAA=;
	b=GF7dSdwlPGsSmJ3/EhA3i5mcrAfE5vgCtKV9ge4/+/nTQUTkRQNJZ5u61XvKJl6KgS+q
	 uAfWWpjWPA6/ofsYZJFGKJv4lyCj0RtsOMlC+A2NLDLbGgVef/6+xOlcqDutSENE8ep7U
	 JBl1IOfKVro1pghzyCD/PFFLWhatgAboGWg49kz4YX9ysba3OEe7zy+RmP395Nxnnajvv
	 qcn1STxlc67hPOdoFbf4vl7JCtuzDsftVydPr1ViZFwkKOZiKjgld9YLa2o96mEkEQ6pS
	 irbE06scxGoo/OwY0KPsux1+KuHU97yYKijkm8XpR/CZrfNENm6jgM2XBsLH60trk0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kores2M4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9682606A325;
	Wed, 28 Oct 2026 17:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kores2M4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCD31F01825;
	Wed, 28 Oct 2026 17:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207849;
	bh=6JoO36ZUmBbqBfwr/idBgFjIV3Z5o1Zo83d+CmBybAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kores2M4FxXkUUqPQ1EmvngqBSF2HfZ+xT95oxpJvMLDLw70PFpmv1LxKIWdqg79N
	 2e/yqY3gnpKH4UgnL3iU6MSZ5UW1r++AquAi8huOIwpysjeOliDosG+V/HYsSRSxv2
	 xDp48N0sXns9yhDQGrRsJx4/L5Llv1P9X9mKSGHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mashiro Chen <mashiro.chen@mailbox.org>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/247] netrom: bound fragment reassembly in nr_queue_rx_frame()
Date: Wed, 28 Oct 2026 17:59:23 +0100
Message-ID: <20261028165951.203777604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

nr_sock.fraglen is an unsigned short, but nr_sendmsg() accepts messages
of up to 65536 bytes, which nr_output() then splits into NR_INFO frames
with the MORE flag. Reassembling such a message on the receiving side
makes fraglen wrap to 0, so alloc_skb() returns a buffer far smaller
than the data copied into it just after. The same happens with any
stream of MORE fragments that adds up to more than 65535 bytes.

Mashiro Chen proposed rejecting fragments once the total would exceed
USHRT_MAX by returning 1 to the caller. Review pointed out that this
return value makes nr_state3_machine() put the frame back on the
resequencing queue after nr_queue_rx_frame() has already pulled its
headers, and that the limit would reject a legitimate 65536-byte
message.

Instead:
- make fraglen an unsigned int, so a full 64 KiB message fits;
- when a message would grow beyond 65536 bytes, drop what has been
  gathered so far, consume the frame and return 0, so the caller does
  not retry it;
- discard the remaining fragments of that message up to its last
  fragment, using a new NR_COND_FRAG_DISCARD condition bit, rather
  than delivering its tail as a separate message.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Mashiro Chen <mashiro.chen@mailbox.org>
Closes: https://patchwork.kernel.org/project/netdevbpf/patch/20260407171600.102988-2-mashiro.chen@mailbox.org/
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 6ad8be739b22495d6edc3f6d7b916098ceb3fdf0)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netrom.h |  3 ++-
 net/netrom/nr_in.c   | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/net/netrom.h b/include/net/netrom.h
index f0565a5987d1b..30ecf812b4ab4 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -46,6 +46,7 @@ enum {
 #define	NR_COND_REJECT			0x02
 #define	NR_COND_PEER_RX_BUSY		0x04
 #define	NR_COND_OWN_RX_BUSY		0x08
+#define	NR_COND_FRAG_DISCARD		0x10
 
 #define NR_DEFAULT_T1			120000		/* Outstanding frames - 120 seconds */
 #define NR_DEFAULT_T2			5000		/* Response delay     - 5 seconds */
@@ -74,7 +75,7 @@ struct nr_sock {
 	unsigned short		vs, vr, va, vl;
 	unsigned char		n2, n2count;
 	unsigned long		t1, t2, t4, idle;
-	unsigned short		fraglen;
+	unsigned int		fraglen;
 	struct timer_list	t1timer;
 	struct timer_list	t2timer;
 	struct timer_list	t4timer;
diff --git a/net/netrom/nr_in.c b/net/netrom/nr_in.c
index 97944db6b5ac6..b90a47dcf165e 100644
--- a/net/netrom/nr_in.c
+++ b/net/netrom/nr_in.c
@@ -26,6 +26,9 @@
 #include <linux/interrupt.h>
 #include <net/netrom.h>
 
+/* nr_sendmsg() never sends more than this in one message */
+#define NR_MAX_REASM_LEN	65536
+
 static int nr_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 {
 	struct sk_buff *skbo, *skbn = skb;
@@ -35,6 +38,29 @@ static int nr_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 
 	nr_start_idletimer(sk);
 
+	/* Rest of a message already found to be too long: drop it */
+	if (nr->condition & NR_COND_FRAG_DISCARD) {
+		if (!more)
+			nr->condition &= ~NR_COND_FRAG_DISCARD;
+		kfree_skb(skb);
+		return 0;
+	}
+
+	/*
+	 * Give up on a message that would grow beyond what a peer may
+	 * send. The frame is consumed rather than handed back to the
+	 * caller, which would queue it again after skb_pull().
+	 */
+	if ((more || nr->fraglen > 0) &&
+	    nr->fraglen + skb->len > NR_MAX_REASM_LEN) {
+		skb_queue_purge(&nr->frag_queue);
+		nr->fraglen = 0;
+		if (more)
+			nr->condition |= NR_COND_FRAG_DISCARD;
+		kfree_skb(skb);
+		return 0;
+	}
+
 	if (more) {
 		nr->fraglen += skb->len;
 		skb_queue_tail(&nr->frag_queue, skb);
-- 
2.53.0



