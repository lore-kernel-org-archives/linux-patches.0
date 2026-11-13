Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590934;
	b=GJwSp2Agt9NlIsxWQxRSzM3kD88Uh+9iG3bSUuCfm13jA5hdMK3lNbiPvNBPTtT7RMzY
	 4Dl7wdcogYTX9rFAbTQJodFF5ShxXRH8L19/uAl3wGId/xpfV6u/DJBlNdqDE/2mJTVI3
	 1PEGWBXslTR114i5Ndp8s79THJXuhuN2f805CGGbs8VDbvipwOLqfySZAyRKVy35BTVUv
	 7QNBkpf9vbTjESPv5KjB7zp00sqzAJswbPS6IHSKyy1IxHRSyhVb2Iuot2PvY/8UbOARF
	 GhfuZrhGYwEnhHkPAnI7s1qaS1LIyxIfneQSX0eX6s5XUX3eJtra/XeFZFnHE8xOheA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jSpYvTgiUcxwxnuN58xNV1VNeHSK/xq8xbwLRScW6wY=;
	b=eF8pK42iXL8oCKMfFALGkcXE//9ys/Mf3SkFOv3Hjb11/z+gfShyXCW+/bEFVcOnVYb4
	 aiTSkb9TXjrgpjcKzhznrtREyS9M0c91Vpr/40ukHxMCD6ScGrkJo1JXxrgGlERbp8Ed/
	 J4aahtHNrcUgIQFIrt0Y5rYmXr02u2Kd5Q2KUWzw5gtsxC5jwez/v1c5mnK0szkjCQg0V
	 HAi0/uRXwPv7Hv3m8hfEW3i+Km9rDIpLeh3pGDHtpk9aOrH+d6tA6TfZNLC0c8h5edtJe
	 Fz3dHuXs62AoPxXMGsMcJH096IW94RIdRBhpnFsinj1KBH/tr2BCImGeDXJeBeLacYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xzj82D9c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECB7606B348;
	Fri, 13 Nov 2026 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xzj82D9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF02C1F000C4;
	Fri, 13 Nov 2026 17:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590934;
	bh=jSpYvTgiUcxwxnuN58xNV1VNeHSK/xq8xbwLRScW6wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xzj82D9cuFKWNtxQ/epFnRGj/i6yrajohIu9x1Km3siSEvT/yjqgFtaFQRqDQBYXX
	 U8pY5WYzYCCmNMifrOtI+Ks4N7wSwqu7qlJ+uNDJEO+u+JirGboiDyaFRoqZbVtXRI
	 L98+yvO0tHPi3QWVRl+1XjGeK0RdzR2x+WmFscYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/670] ax25: dont leave half a message on a connection when fragmenting fails
Date: Fri, 13 Nov 2026 10:44:43 -0500
Message-ID: <20261113153815.853457082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

ax25_output() puts each fragment on the write queue as soon as it is
built. If one allocation fails half way, it returns at once: the
fragments already queued go out and the peer gets the beginning of a
message whose end never comes, and the rest of the original skb is
never freed. That skb is charged to the sending socket, so
sk_has_allocations() stays true, ax25_destroy_timer() re-arms itself
every two seconds for good, and the socket, with its reference on the
ax25 module, is never freed.

Build the fragments on a list of our own, free that list and the
original skb if an allocation fails, and splice the fragments onto the
write queue once the message is complete. Two senders on the same
connection, as with several ROSE or NET/ROM circuits, also no longer
interleave the fragments of their messages.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link, PID 0x55, paclen 64 on the sender). The ax25 module
of the bench has a parameter that makes the allocation of a given
fragment fail. B sends 20 bytes, then 200 bytes in four fragments with
the third one failing, then 30 bytes, closes the socket and waits 30 s:

  before: ax25 refcount left one above its value before the socket,
          the socket is never freed
  after:  ax25 refcount back to its value before the socket, five
          runs out of five

A receives the 20 and 30 byte messages in both cases. Without the
failure, the 200 byte message is put back together whole by A before
and after the change.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 801c45b8d6d552b4150f33e2d86fcf74ad0ea85c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_out.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index 7c4ebef5ae6c2..50b014f7b0df5 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -137,7 +137,9 @@ EXPORT_SYMBOL(ax25_send_frame);
  */
 void ax25_output(ax25_cb *ax25, int paclen, struct sk_buff *skb)
 {
+	struct sk_buff_head frags;
 	struct sk_buff *skbn;
+	unsigned long flags;
 	unsigned char *p;
 	int frontlen, len, fragno, ka9qfrag, first = 1;
 
@@ -161,11 +163,20 @@ void ax25_output(ax25_cb *ax25, int paclen, struct sk_buff *skb)
 
 		frontlen = skb_headroom(skb);	/* Address space + CTRL */
 
+		/*
+		 * Build the fragments on a list of our own: a message that
+		 * cannot be fragmented whole is not sent at all, and its
+		 * fragments go on the write queue one after the other.
+		 */
+		__skb_queue_head_init(&frags);
+
 		while (skb->len > 0) {
 			spin_lock_bh(&ax25_frag_lock);
 			if ((skbn = alloc_skb(paclen + 2 + frontlen, GFP_ATOMIC)) == NULL) {
 				spin_unlock_bh(&ax25_frag_lock);
 				printk(KERN_CRIT "AX.25: ax25_output - out of memory\n");
+				__skb_queue_purge(&frags);
+				kfree_skb(skb);
 				return;
 			}
 
@@ -200,10 +211,14 @@ void ax25_output(ax25_cb *ax25, int paclen, struct sk_buff *skb)
 			}
 
 			skb_pull(skb, len);
-			skb_queue_tail(&ax25->write_queue, skbn); /* Throw it on the queue */
+			__skb_queue_tail(&frags, skbn);
 		}
 
 		kfree_skb(skb);
+
+		spin_lock_irqsave(&ax25->write_queue.lock, flags);
+		skb_queue_splice_tail_init(&frags, &ax25->write_queue);
+		spin_unlock_irqrestore(&ax25->write_queue.lock, flags);
 	} else {
 		skb_queue_tail(&ax25->write_queue, skb);	  /* Throw it on the queue */
 	}
-- 
2.53.0



