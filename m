Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590098;
	b=0qJS0QtaUW8J1oi1ciuixpRr2og8rnENLGYpLERYVw7rEPY3+WeZUXuS8LNbbCl16rX7
	 pnOk7+sK1xLzTvY3vkuS/i8/v/z4mmOkPD/DXf9D4Ekf7g92PsVgLaaqy1vPcXnN7prnh
	 DEgMhGYYDQl6MrZGLVMmAPkozmlmBeWaJD/gb+ESlgaKO1sYZmpbV8RvB9/KFqTY802cT
	 7ff1dycmXTbG0XKNaYp8TAPebCkcMiHPp6eHzwI1NyuikvJygaC/A9fOpT3rjSGwRpE/M
	 rXiBS4bTkBhjl/GzZpLFTqYJnYPHELbsA6jx5HoOpes/iGV37aU92Vyt5ZEDuJ05obA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XxdHj49+CTRPxS4EKyFi70TCdcQqB4aLr/TbG2uYjjQ=;
	b=j3X14b586wIRsdfxjKl1VG5bK/yg/ugb99k5ywS2T5M1/2Oi+nR2jf79aw5SRjDovoJN
	 XW5SYuMhSKtadzz3+sssCcf1OWJhvUnN7qoXc47NbN1d5cZL/Y/VGyIi4Vw/MCjKOyUUP
	 upKsv8KyJdvF6yVte5ugQQEjpqHykpNLWShRV5vM2t4DbdyWqwRMJ6ijzi1DTg+DFQ8A0
	 kkV/dGovUiGfnVkU27g6bap2yU5frtGnUQ2rnCN7VLNa5iSvEl0kIeZWmjm7HbQRBbrcH
	 i0tzbsli5kyz/1hv8kHyrF+t4Wf5YXvb5pguWTKo+ZS5drBB0/bZFgikoSYQZFuF4gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGU1H955;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8826C606C0B9;
	Fri, 13 Nov 2026 17:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGU1H955
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE10D1F000C5;
	Fri, 13 Nov 2026 17:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590098;
	bh=XxdHj49+CTRPxS4EKyFi70TCdcQqB4aLr/TbG2uYjjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGU1H955QkmE9IgcINH28pMzhlgef348vZHS1xx+62YsC6xHGKrvJC+mlEAWNNxPU
	 PowJgc2QeGHdLlUdcMA71AvFqPNx1M7Q0G8KfA7EsODVMwxX1Xe037zelWtwk2ydZC
	 WL93kGbvwb4mdS7/Q7/tFj5MxZFzfGpYxf+KiWhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/686] ax25: dont leave half a message on a connection when fragmenting fails
Date: Fri, 13 Nov 2026 10:44:15 -0500
Message-ID: <20261113153824.962069098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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



