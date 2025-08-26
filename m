Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40F718A6C4;
	Tue, 26 Aug 2025 13:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215391; cv=none; b=i1YSVo2QBJsrZCD1sf8b3/h/bSfeEnqUv8/MiwU2EYI98ADW+bEauYrR3tFV59xckv35CH8Qd8RKHRZwJvy6omLhyh9VPmRdNgnZ48ITnxc0wlAAWJhBtS377NpJhhoyZ64jyp4TY6nBkOORvvhFH1cwgh08s5FLRQMwfAJG020=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215391; c=relaxed/simple;
	bh=29ZF45MEV01WabYmcDd6tsu8ImuuN+rOIq7GZQuySlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjGHbWMqiXGFbY25tId17Y/g4raEUVWANM7eHnBePn/61YQXsulNCuLon/v5SU1Ui8jeXNNGPY6mnbXpiUJw5W8VO1pLealc+iD0Y+XE/vF1BjwEvPPghgLxcZGuyqP4nwlcjOle1hY29K3+ZGL4porGWuJz4v5IrugGhGin2oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDGSQLcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDGSQLcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76767C4CEF1;
	Tue, 26 Aug 2025 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215390;
	bh=29ZF45MEV01WabYmcDd6tsu8ImuuN+rOIq7GZQuySlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDGSQLcUrZqvZfjFWtLW5swps6fRjjxjA6qgF/xc/LAoG5Eh6vBWacTje7763pRA9
	 MAWoQLxiiYiBzEoAEMhExcEvljYJhwDDUS7sUsFrskAaA7EdZnx9nunLtlycMdXxvN
	 ThJR2en38tHZwAu5xummDwdPaiK7/he9NIL7AZX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	LongJun Tang <tanglongjun@kylinos.cn>,
	Yun Lu <luyun@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 016/644] af_packet: fix soft lockup issue caused by tpacket_snd()
Date: Tue, 26 Aug 2025 13:01:47 +0200
Message-ID: <20250826110946.914332638@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2803,15 +2803,21 @@ static int tpacket_snd(struct packet_soc
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
@@ -2901,14 +2907,7 @@ tpacket_error:
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


