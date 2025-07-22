Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4FE2DEA8E;
	Tue, 22 Jul 2025 14:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193326; cv=none; b=GW6eObKyUjn8vEBUDaV8qa9eLlFqBy+EplF2x1R5wCb7mCwtRA/X1VFkGlop6y6fBXLmzraazOAHS5SIjCnMiXqyojxF1xqM/8BxxVnYouJ8+hfjtYn7twMrNGvco9GflgAUJmg+/5IqlUd0O2S4KNAw2TxC9PPBFUqXJLruytE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193326; c=relaxed/simple;
	bh=6xHqv56uvWVo6la5YhIRTpshRkJxLQBv2XX9EULiVwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqtmMAy8sgiFDCjuxMdyU3DktyuMW5wDCUDcROJWfwyWu72GRXawbSVs9Zch8TlU+w7+H+ItUrq7T3BjhuhAyz+JmMvuuuEmW1CHffGV+osOUIFLkS0CoPXV3d7LSvRu3FfiLOY+3IjEeVBDSqm29zTmEZWXfSVc4rUO2VCfG2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShFk8JRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShFk8JRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6027CC4CEEB;
	Tue, 22 Jul 2025 14:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193326;
	bh=6xHqv56uvWVo6la5YhIRTpshRkJxLQBv2XX9EULiVwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShFk8JRz5r7YyvJ65TEMz6zqI5CLXkKYAqdSvWsX3qOM0+jxuihF31TMBMRk2sPDA
	 fZBt/+0qmd++ktXqHYSp/RkTHYSP+QFA5ccVepYprO1zf5gvN6mx7yD9C5/5PdO2VG
	 o+wJetrT0XGueZfNEoaUeuv0p7fj/uV/kyevNGyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	LongJun Tang <tanglongjun@kylinos.cn>,
	Yun Lu <luyun@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.15 058/187] af_packet: fix soft lockup issue caused by tpacket_snd()
Date: Tue, 22 Jul 2025 15:43:48 +0200
Message-ID: <20250722134347.922449943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Lu <luyun@kylinos.cn>

commit 55f0bfc0370539213202f4ce1a07615327ac4713 upstream.

When MSG_DONTWAIT is not set, the tpacket_snd operation will wait for
pending_refcnt to decrement to zero before returning. The pending_refcnt
is decremented by 1 when the skb->destructor function is called,
indicating that the skb has been successfully sent and needs to be
destroyed.

If an error occurs during this process, the tpacket_snd() function will
exit and return error, but pending_refcnt may not yet have decremented to
zero. Assuming the next send operation is executed immediately, but there
are no available frames to be sent in tx_ring (i.e., packet_current_frame
returns NULL), and skb is also NULL, the function will not execute
wait_for_completion_interruptible_timeout() to yield the CPU. Instead, it
will enter a do-while loop, waiting for pending_refcnt to be zero. Even
if the previous skb has completed transmission, the skb->destructor
function can only be invoked in the ksoftirqd thread (assuming NAPI
threading is enabled). When both the ksoftirqd thread and the tpacket_snd
operation happen to run on the same CPU, and the CPU trapped in the
do-while loop without yielding, the ksoftirqd thread will not get
scheduled to run. As a result, pending_refcnt will never be reduced to
zero, and the do-while loop cannot exit, eventually leading to a CPU soft
lockup issue.

In fact, skb is true for all but the first iterations of that loop, and
as long as pending_refcnt is not zero, even if incremented by a previous
call, wait_for_completion_interruptible_timeout() should be executed to
yield the CPU, allowing the ksoftirqd thread to be scheduled. Therefore,
the execution condition of this function should be modified to check if
pending_refcnt is not zero, instead of check skb.

-	if (need_wait && skb) {
+	if (need_wait && packet_read_pending(&po->tx_ring)) {

As a result, the judgment conditions are duplicated with the end code of
the while loop, and packet_read_pending() is a very expensive function.
Actually, this loop can only exit when ph is NULL, so the loop condition
can be changed to while (1), and in the "ph = NULL" branch, if the
subsequent condition of if is not met,  the loop can break directly. Now,
the loop logic remains the same as origin but is clearer and more obvious.

Fixes: 89ed5b519004 ("af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET")
Cc: stable@kernel.org
Suggested-by: LongJun Tang <tanglongjun@kylinos.cn>
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2846,15 +2846,21 @@ static int tpacket_snd(struct packet_soc
 		ph = packet_current_frame(po, &po->tx_ring,
 					  TP_STATUS_SEND_REQUEST);
 		if (unlikely(ph == NULL)) {
-			if (need_wait && skb) {
+			/* Note: packet_read_pending() might be slow if we
+			 * have to call it as it's per_cpu variable, but in
+			 * fast-path we don't have to call it, only when ph
+			 * is NULL, we need to check the pending_refcnt.
+			 */
+			if (need_wait && packet_read_pending(&po->tx_ring)) {
 				timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
 				if (timeo <= 0) {
 					err = !timeo ? -ETIMEDOUT : -ERESTARTSYS;
 					goto out_put;
 				}
-			}
-			/* check for additional frames */
-			continue;
+				/* check for additional frames */
+				continue;
+			} else
+				break;
 		}
 
 		skb = NULL;
@@ -2943,14 +2949,7 @@ tpacket_error:
 		}
 		packet_increment_head(&po->tx_ring);
 		len_sum += tp_len;
-	} while (likely((ph != NULL) ||
-		/* Note: packet_read_pending() might be slow if we have
-		 * to call it as it's per_cpu variable, but in fast-path
-		 * we already short-circuit the loop with the first
-		 * condition, and luckily don't have to go that path
-		 * anyway.
-		 */
-		 (need_wait && packet_read_pending(&po->tx_ring))));
+	} while (1);
 
 	err = len_sum;
 	goto out_put;


