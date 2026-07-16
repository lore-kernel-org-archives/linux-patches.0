Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643CB422E3D;
	Thu, 16 Jul 2026 13:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209019; cv=none; b=ApyavnJWbjg93bgkHfWnYpkeXVUDbP/AScJfaKVfjWv7No/DbceeJ+xRkkmnbeD2DFgq9iQ0OLklNgkb3YxH+A3UoOa7PrppfuMPGFWknFO85tHrS3+JoeauXWeMcS6yKGIgZ+95IAkG/OHGzyNJUHKQoKAClD3rGa/8pk26omE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209019; c=relaxed/simple;
	bh=1lnHNfll0hOa7MgIxgn64paUMjBkltSDvw79WX8Gito=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWD3d33ZiPO6ymiQKof0HCwpChvvr+jbI5sx9zjQx8ljIagTW2mk+8GlEDlVEMlIm4Skfsh8iO70UToq+WNO6WS+6jTYzn+GQ5GmPe41Y8UbtQMz/cxdoouGqdYAN4XaLHWwokMZB50DaxT4Lgf8Oekw39TSVo+FKs69nQOLJAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljhIayIA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljhIayIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8191F000E9;
	Thu, 16 Jul 2026 13:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209018;
	bh=G3YE36ewu/7+ft9FhbU6C4ZiTMKX5gm5IFatW0bAGAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljhIayIAB25qvKqOgiSaqIQY8iyJ+E6tF4Kb0JCiK3/wVCnQNZVWV11qHwb5xH97d
	 U3U/pvfYYWlCTwSrTvmtjOiFGBS5DIfcBbGpwN8++Yw+UMmjS5JuA8wnP5Zd87Fdmb
	 SSUIM0DaZ1aO/IratnHRSFtKamLVdikAFg8L6uec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingquan Liu <b1n@b1n.io>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 004/518] net/sched: dualpi2: fix GSO backlog accounting
Date: Thu, 16 Jul 2026 15:24:32 +0200
Message-ID: <20260716133047.874896720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -461,7 +461,7 @@ static int dualpi2_qdisc_enqueue(struct
 		if (IS_ERR_OR_NULL(nskb))
 			return qdisc_drop(skb, sch, to_free);
 
-		cnt = 1;
+		cnt = 0;
 		byte_len = 0;
 		orig_len = qdisc_pkt_len(skb);
 		skb_list_walk_safe(nskb, nskb, next) {
@@ -488,16 +488,15 @@ static int dualpi2_qdisc_enqueue(struct
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


