Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5064312CDA5;
	Sun,  7 Jun 2026 10:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829947; cv=none; b=L861H8EGFy2kdM41i83Nj/1fUgt2k/5/bDfBIBP4g41by4YQU5ccbkyP5lZIDZsjIM1zNe31B1HJZH7odKGDrB5oiBUpuGurrUk42Z/7SiTZzUJ5z9zGwyz61qfmVcDU7L0oAEwhjn6yZDzKsekNKtMDPl/yq+8UBeDUSmPbp5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829947; c=relaxed/simple;
	bh=PzdtY0D+AcwelUJPyN0YVl8XIfvuVm2hqoM4th3/VoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HL3BTq17SWhg6+bQ3A0TaE3I0FpQFSihDT1f4hDNnSXGzkZRgvvXwogtweZnyu0zR/s0Kz4I+jI2A+3EGXrqM+AepMJHvUJbkilBn0QN/+aGV3Bv3co4pNDY8fX8UT7wc98H8UHuNKrk++wlXGHHhoifLSAAJwcwAQNkimqmkiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2h+Q1+FG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2h+Q1+FG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7731F00893;
	Sun,  7 Jun 2026 10:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829946;
	bh=VebN+vEgoqm8/Yl7t5oKSP8L0v8bxZ3N1Tydk7jkuX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2h+Q1+FGCLzncSuNIaugeeUlFprK8KlR/NhyJUIhStnZwGrW7lUz7q41K+qHukT2q
	 x5cykQOzZBFwjjO9roLn+oEwOP5m5uGMj/guxfZ+VGUju1bnVrQOTQoB9OEzvpglSW
	 jTgVVkgeb1sfqFQQslqNxQCMkppzd15ouFf+B/RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-afs@lists.infradead.org,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 268/307] rxrpc: Fix DATA decrypt vs splice() by copying data to buffer in recvmsg
Date: Sun,  7 Jun 2026 12:01:05 +0200
Message-ID: <20260607095737.549967841@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit d2bc90cf6c75cb96d2ce549be6c35efa3099d25b ]

This improves the fix for CVE-2026-43500.

Fix the pagecache corruption from in-place decryption of a DATA packet
transmitted locally by splice() by getting rid of the packet sharing in the
I/O thread and unconditionally extracting the packet content into a bounce
buffer in which the buffer is decrypted.  recvmsg() (or the kernel
equivalent) then copies the data from the bounce buffer to the destination
buffer.  The sk_buff then remains unmodified.

This has an additional advantage in that the packet is then arranged in the
buffer with the correct alignment required for the crypto algorithms to
process directly.  The performance of the crypto does seem to be a little
faster and, surprisingly, the unencrypted performance doesn't seem to
change much - possibly due to removing complexity from the I/O thread.

Yet another advantage is that the I/O thread doesn't have to copy packets
which would slow down packet distribution, ACK generation, etc..

The buffer belongs to the call and is allocated initially at 2K,
sufficiently large to hold a whole jumbo subpacket, but the buffer will be
increased in size if needed.  However, to take this work, MSG_PEEK may
cause a later packet to be decrypted into the buffer, in which case the
earlier one will need re-decrypting for a subsequent recvmsg().

Note that rx_pkt_offset may legitimately see 0 as a valid offset now, so
switch to using USHRT_MAX to indicate an invalid offset.

Note also that I would generally prefer to replace the buffers of the
current sk_buff with a new kmalloc'd buffer of the right size, ditching the
old data and frags as this makes the handling of MSG_PEEK easier and
removes the re-decryption issue, but this looks like quite a complicated
thing to achieve.  skb_morph() looks half way to what I want, but I don't
want to have to allocate a new sk_buff.

Fixes: d0d5c0cd1e71 ("rxrpc: Use skb_unshare() rather than skb_cow_data()")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Closes: https://lore.kernel.org/r/afKV2zGR6rrelPC7@v4bel/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: Jiayuan Chen <jiayuan.chen@linux.dev>
cc: linux-afs@lists.infradead.org
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
Link: https://patch.msgid.link/20260515230516.2718212-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8bfab4b6ffc2 ("rxrpc: Fix RESPONSE packet verification to extract skb to a linear buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-internal.h |    7 ++-
 net/rxrpc/call_event.c  |   27 +--------------
 net/rxrpc/call_object.c |    2 +
 net/rxrpc/insecure.c    |    3 -
 net/rxrpc/recvmsg.c     |   68 ++++++++++++++++++++++++++++++-------
 net/rxrpc/rxkad.c       |   86 +++++++++++++++++-------------------------------
 6 files changed, 96 insertions(+), 97 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -203,8 +203,6 @@ struct rxrpc_skb_priv {
 		struct {
 			u16		offset;		/* Offset of data */
 			u16		len;		/* Length of data */
-			u8		flags;
-#define RXRPC_RX_VERIFIED	0x01
 		};
 		struct {
 			rxrpc_seq_t	first_ack;	/* First packet in acks table */
@@ -686,6 +684,11 @@ struct rxrpc_call {
 	/* Received data tracking */
 	struct sk_buff_head	recvmsg_queue;	/* Queue of packets ready for recvmsg() */
 	struct sk_buff_head	rx_oos_queue;	/* Queue of out of sequence packets */
+	void			*rx_dec_buffer;	/* Decryption buffer */
+	unsigned short		rx_dec_bsize;	/* rx_dec_buffer size */
+	unsigned short		rx_dec_offset;	/* Decrypted packet data offset */
+	unsigned short		rx_dec_len;	/* Decrypted packet data len */
+	rxrpc_seq_t		rx_dec_seq;	/* Packet in decryption buffer */
 
 	rxrpc_seq_t		rx_highest_seq;	/* Higest sequence number received */
 	rxrpc_seq_t		rx_consumed;	/* Highest packet consumed */
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -342,31 +342,8 @@ bool rxrpc_input_call_event(struct rxrpc
 	if (skb && skb->mark == RXRPC_SKB_MARK_ERROR)
 		goto out;
 
-	if (skb) {
-		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-
-		if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
-		    sp->hdr.securityIndex != 0 &&
-		    (skb_cloned(skb) ||
-		     skb_has_frag_list(skb) ||
-		     skb_has_shared_frag(skb))) {
-			/* Unshare the packet so that it can be modified for
-			 * in-place decryption.
-			 */
-			struct sk_buff *nskb = skb_copy(skb, GFP_ATOMIC);
-
-			if (nskb) {
-				rxrpc_new_skb(nskb, rxrpc_skb_new_unshared);
-				rxrpc_input_call_packet(call, nskb);
-				rxrpc_free_skb(nskb, rxrpc_skb_put_input);
-			} else {
-				/* OOM - Drop the packet. */
-				rxrpc_see_skb(skb, rxrpc_skb_see_unshare_nomem);
-			}
-		} else {
-			rxrpc_input_call_packet(call, skb);
-		}
-	}
+	if (skb)
+		rxrpc_input_call_packet(call, skb);
 
 	/* If we see our async-event poke, check for timeout trippage. */
 	now = ktime_get_real();
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -154,6 +154,7 @@ struct rxrpc_call *rxrpc_alloc_call(stru
 	spin_lock_init(&call->tx_lock);
 	refcount_set(&call->ref, 1);
 	call->debug_id		= debug_id;
+	call->rx_pkt_offset	= USHRT_MAX;
 	call->tx_total_len	= -1;
 	call->next_rx_timo	= 20 * HZ;
 	call->next_req_timo	= 1 * HZ;
@@ -535,6 +536,7 @@ static void rxrpc_cleanup_ring(struct rx
 {
 	rxrpc_purge_queue(&call->recvmsg_queue);
 	rxrpc_purge_queue(&call->rx_oos_queue);
+	kfree(call->rx_dec_buffer);
 }
 
 /*
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -29,9 +29,6 @@ static int none_secure_packet(struct rxr
 
 static int none_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 {
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-
-	sp->flags |= RXRPC_RX_VERIFIED;
 	return 0;
 }
 
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -143,15 +143,52 @@ static void rxrpc_rotate_rx_window(struc
 }
 
 /*
- * Decrypt and verify a DATA packet.
+ * Decrypt and verify a DATA packet.  The content of the packet is pulled out
+ * into a flat buffer rather than decrypting in place in the skbuff.  This also
+ * has the advantage of aligning the buffer correctly for the crypto routines.
+ *
+ * We keep track of the sequence number of the packet currently decrypted into
+ * the buffer in ->rx_dec_seq.  If MSG_PEEK is used and steps onto a new
+ * packet, subsequent recvmsg() calls will have to go back and re-decrypt the
+ * current packet.
  */
 static int rxrpc_verify_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	int ret;
 
-	if (sp->flags & RXRPC_RX_VERIFIED)
-		return 0;
-	return call->security->verify_packet(call, skb);
+	if (sp->len > call->rx_dec_bsize) {
+		/* Make sure we can hold a 1412-byte jumbo subpacket and make
+		 * sure that the buffer size is aligned to a crypto blocksize.
+		 */
+		size_t size = clamp(round_up(sp->len, 32), 2048, 65535);
+		void *buffer = krealloc(call->rx_dec_buffer, size, GFP_NOFS);
+
+		if (!buffer)
+			return -ENOMEM;
+		call->rx_dec_buffer = buffer;
+		call->rx_dec_bsize = size;
+	}
+
+	ret = -EFAULT;
+	if (skb_copy_bits(skb, sp->offset, call->rx_dec_buffer, sp->len) < 0)
+		goto err;
+
+	call->rx_dec_offset = 0;
+	call->rx_dec_len = sp->len;
+	call->rx_dec_seq = sp->hdr.seq;
+	ret = call->security->verify_packet(call, skb);
+	if (ret < 0)
+		goto err;
+	return 0;
+
+err:
+	kfree(call->rx_dec_buffer);
+	call->rx_dec_buffer = NULL;
+	call->rx_dec_bsize = 0;
+	call->rx_dec_offset = 0;
+	call->rx_dec_len = 0;
+	return ret;
 }
 
 /*
@@ -202,17 +239,22 @@ static int rxrpc_recvmsg_data(struct soc
 		if (msg)
 			sock_recv_timestamp(msg, sock->sk, skb);
 
-		if (rx_pkt_offset == 0) {
+		if (call->rx_dec_seq != sp->hdr.seq ||
+		    !call->rx_dec_buffer) {
 			ret2 = rxrpc_verify_data(call, skb);
 			trace_rxrpc_recvdata(call, rxrpc_recvmsg_next, seq,
-					     sp->offset, sp->len, ret2);
+					     call->rx_dec_offset,
+					     call->rx_dec_len, ret2);
 			if (ret2 < 0) {
 				kdebug("verify = %d", ret2);
 				ret = ret2;
 				goto out;
 			}
-			rx_pkt_offset = sp->offset;
-			rx_pkt_len = sp->len;
+		}
+
+		if (rx_pkt_offset == USHRT_MAX) {
+			rx_pkt_offset = call->rx_dec_offset;
+			rx_pkt_len = call->rx_dec_len;
 		} else {
 			trace_rxrpc_recvdata(call, rxrpc_recvmsg_cont, seq,
 					     rx_pkt_offset, rx_pkt_len, 0);
@@ -224,10 +266,10 @@ static int rxrpc_recvmsg_data(struct soc
 		if (copy > remain)
 			copy = remain;
 		if (copy > 0) {
-			ret2 = skb_copy_datagram_iter(skb, rx_pkt_offset, iter,
-						      copy);
-			if (ret2 < 0) {
-				ret = ret2;
+			ret2 = copy_to_iter(call->rx_dec_buffer + rx_pkt_offset,
+					    copy, iter);
+			if (ret2 != copy) {
+				ret = -EFAULT;
 				goto out;
 			}
 
@@ -248,7 +290,7 @@ static int rxrpc_recvmsg_data(struct soc
 		/* The whole packet has been transferred. */
 		if (sp->hdr.flags & RXRPC_LAST_PACKET)
 			ret = 1;
-		rx_pkt_offset = 0;
+		rx_pkt_offset = USHRT_MAX;
 		rx_pkt_len = 0;
 
 		skb = skb_peek_next(skb, &call->recvmsg_queue);
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -414,27 +414,25 @@ static int rxkad_verify_packet_1(struct
 				 rxrpc_seq_t seq,
 				 struct skcipher_request *req)
 {
-	struct rxkad_level1_hdr sechdr;
+	struct rxkad_level1_hdr *sechdr;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt iv;
-	struct scatterlist sg[16];
-	u32 data_size, buf;
+	struct scatterlist sg[1];
+	void *data = call->rx_dec_buffer;
+	u32 len = sp->len, data_size, buf;
 	u16 check;
 	int ret;
 
 	_enter("");
 
-	if (sp->len < 8)
+	if (len < 8)
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_1_short_header);
 
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
 	 */
-	sg_init_table(sg, ARRAY_SIZE(sg));
-	ret = skb_to_sgvec(skb, sg, sp->offset, 8);
-	if (unlikely(ret < 0))
-		return ret;
+	sg_init_one(sg, data, len);
 
 	/* start the decryption afresh */
 	memset(&iv, 0, sizeof(iv));
@@ -448,13 +446,11 @@ static int rxkad_verify_packet_1(struct
 		return ret;
 
 	/* Extract the decrypted packet length */
-	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0)
-		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
-					  rxkad_abort_1_short_encdata);
-	sp->offset += sizeof(sechdr);
-	sp->len    -= sizeof(sechdr);
+	sechdr = data;
+	call->rx_dec_offset = sizeof(*sechdr);
+	len -= sizeof(*sechdr);
 
-	buf = ntohl(sechdr.data_size);
+	buf = ntohl(sechdr->data_size);
 	data_size = buf & 0xffff;
 
 	check = buf >> 16;
@@ -463,10 +459,10 @@ static int rxkad_verify_packet_1(struct
 	if (check != 0)
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_1_short_check);
-	if (data_size > sp->len)
+	if (data_size > len)
 		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
 					  rxkad_abort_1_short_data);
-	sp->len = data_size;
+	call->rx_dec_len = data_size;
 
 	_leave(" = 0 [dlen=%x]", data_size);
 	return 0;
@@ -480,43 +476,28 @@ static int rxkad_verify_packet_2(struct
 				 struct skcipher_request *req)
 {
 	const struct rxrpc_key_token *token;
-	struct rxkad_level2_hdr sechdr;
+	struct rxkad_level2_hdr *sechdr;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt iv;
-	struct scatterlist _sg[4], *sg;
-	u32 data_size, buf;
+	struct scatterlist sg[1];
+	void *data = call->rx_dec_buffer;
+	u32 len = sp->len, data_size, buf;
 	u16 check;
-	int nsg, ret;
+	int ret;
 
-	_enter(",{%d}", sp->len);
+	_enter(",{%d}", len);
 
-	if (sp->len < 8)
+	if (len < 8)
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_2_short_header);
 
 	/* Don't let the crypto algo see a misaligned length. */
-	sp->len = round_down(sp->len, 8);
+	len = round_down(len, 8);
 
-	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
-	 * directly into the target buffer.
+	/* Decrypt in place in the call's decryption buffer.  TODO: We really
+	 * want to decrypt directly into the target buffer.
 	 */
-	sg = _sg;
-	nsg = skb_shinfo(skb)->nr_frags + 1;
-	if (nsg <= 4) {
-		nsg = 4;
-	} else {
-		sg = kmalloc_array(nsg, sizeof(*sg), GFP_NOIO);
-		if (!sg)
-			return -ENOMEM;
-	}
-
-	sg_init_table(sg, nsg);
-	ret = skb_to_sgvec(skb, sg, sp->offset, sp->len);
-	if (unlikely(ret < 0)) {
-		if (sg != _sg)
-			kfree(sg);
-		return ret;
-	}
+	sg_init_one(sg, data, len);
 
 	/* decrypt from the session key */
 	token = call->conn->key->payload.data[0];
@@ -524,11 +505,9 @@ static int rxkad_verify_packet_2(struct
 
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, sp->len, iv.x);
+	skcipher_request_set_crypt(req, sg, sg, len, iv.x);
 	ret = crypto_skcipher_decrypt(req);
 	skcipher_request_zero(req);
-	if (sg != _sg)
-		kfree(sg);
 	if (ret < 0) {
 		if (ret == -ENOMEM)
 			return ret;
@@ -537,13 +516,11 @@ static int rxkad_verify_packet_2(struct
 	}
 
 	/* Extract the decrypted packet length */
-	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0)
-		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
-					  rxkad_abort_2_short_len);
-	sp->offset += sizeof(sechdr);
-	sp->len    -= sizeof(sechdr);
+	sechdr = data;
+	call->rx_dec_offset = sizeof(*sechdr);
+	len -= sizeof(*sechdr);
 
-	buf = ntohl(sechdr.data_size);
+	buf = ntohl(sechdr->data_size);
 	data_size = buf & 0xffff;
 
 	check = buf >> 16;
@@ -553,17 +530,18 @@ static int rxkad_verify_packet_2(struct
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_2_short_check);
 
-	if (data_size > sp->len)
+	if (data_size > len)
 		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
 					  rxkad_abort_2_short_data);
 
-	sp->len = data_size;
+	call->rx_dec_len = data_size;
 	_leave(" = 0 [dlen=%x]", data_size);
 	return 0;
 }
 
 /*
- * Verify the security on a received packet and the subpackets therein.
+ * Verify the security on a received (sub)packet.  If the packet needs
+ * modifying (e.g. decrypting), it must be copied.
  */
 static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 {


