Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE63148C2;
	Thu, 16 Jul 2026 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210370; cv=none; b=cNik8ru/S4Q1M8csN0qwiOdUAM/FgTqNzO+yB/TMtaS6YrJ9+JfqU4/k7QmvZT4sz9qo7WM6KkTFUMyJuQdl04LhYFRFDCasZ3IJJth7dymRF9ZSyQQdmfBpOS2AH0ievCnTCu8L19aakmHMRbt59feCx3Wh1Mf5jMGRDcYRbSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210370; c=relaxed/simple;
	bh=4rPJwCatn5LEId++cvuym75N/s3n9oY/mKnSz5Br1VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXV6GELRzitrpiKN7lMVLUsCWGgI8q7ahyUvsCtm98Z/4ieCjZ5Se3vxKVG05j7SPnX4ALw1sXu9U9WJk/wcZXpO7zPRJ+vbBZGYDQoKRZfoEj1vX/uERgV+mGyY78ye/GMT76YKI7u+Qdo0HTrsOVUzLUHLLtPLV9ucfe4I6bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0egW6gN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0egW6gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550C01F000E9;
	Thu, 16 Jul 2026 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210368;
	bh=IONxUh57cCGYW3XMsUx6jeVQ7GzeIAdigkio3nPXPsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0egW6gNfT1iEtL744+uO0xTFqec2IfY63yZpkR0q3mKYkrYnKp8UKn2XdYVShGmk
	 urolDU9mW670GDjxm8lxrOCSEWM16Il8SRQQ2Y6vgS68f5wMiky+hZEyWCSyimflod
	 RQCwgA4aXeSchjxs1Ie3GhnoomXua1Iu1cF9rkxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingquan Liu <b1n@b1n.io>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 021/480] net/sched: dualpi2: fix GSO backlog accounting
Date: Thu, 16 Jul 2026 15:26:08 +0200
Message-ID: <20260716133045.156189849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingquan Liu <b1n@b1n.io>

commit 05ed733b65ab977dd931e7f7ac0f62fdb81205c2 upstream.

When DualPI2 splits a GSO skb into N segments, it propagates N
additional packets to its parent before returning NET_XMIT_SUCCESS.
The parent then accounts for the original skb once more, leaving its
qlen one larger than the number of packets actually queued.

With QFQ as the parent, after all real packets are dequeued, QFQ still
has a non-zero qlen while its in-service aggregate has no active
classes. qfq_choose_next_agg() returns NULL and qfq_dequeue() passes
the result to qfq_peek_skb(), causing a NULL pointer dereference.

Follow the same pattern used by tbf_segment() and taprio: count only
successfully queued segments, propagate the difference between the
original skb and those segments, and return NET_XMIT_SUCCESS whenever
at least one segment was queued.

Fixes: 8f9516daedd6 ("sched: Add enqueue/dequeue of dualpi2 qdisc")
Cc: stable@vger.kernel.org
Signed-off-by: Xingquan Liu <b1n@b1n.io>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260619151447.223640-1-b1n@b1n.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_dualpi2.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -463,7 +463,7 @@ static int dualpi2_qdisc_enqueue(struct
 		if (IS_ERR_OR_NULL(nskb))
 			return qdisc_drop(skb, sch, to_free);
 
-		cnt = 1;
+		cnt = 0;
 		byte_len = 0;
 		orig_len = qdisc_pkt_len(skb);
 		skb_list_walk_safe(nskb, nskb, next) {
@@ -489,16 +489,15 @@ static int dualpi2_qdisc_enqueue(struct
 				byte_len += nskb->len;
 			}
 		}
-		if (cnt > 1) {
+		if (cnt > 0) {
 			/* The caller will add the original skb stats to its
 			 * backlog, compensate this if any nskb is enqueued.
 			 */
-			--cnt;
-			byte_len -= orig_len;
+			qdisc_tree_reduce_backlog(sch, 1 - cnt,
+						  orig_len - byte_len);
 		}
-		qdisc_tree_reduce_backlog(sch, -cnt, -byte_len);
 		consume_skb(skb);
-		return err;
+		return cnt > 0 ? NET_XMIT_SUCCESS : err;
 	}
 	return dualpi2_enqueue_skb(skb, sch, to_free);
 }


