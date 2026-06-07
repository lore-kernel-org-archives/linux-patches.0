Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8388617B418;
	Sun,  7 Jun 2026 10:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827291; cv=none; b=r9plO/EfaHN8Fnt9FUdcu8Dmq/5NHzg2nTDNsvBMfRtFER854fOIYKvFCOC4XAHbDhrKUK0Zu3FnWX4U2bnZFy9wtr++54wKDdYfTrTfkYrnBLOIiF5lN1OluhmgqIUO3yR9fvVM1EwxC/6axMhVAK8ftXkKFJnOtQw1AjsyJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827291; c=relaxed/simple;
	bh=2bcFumZSIjiw9DLOgrepSNgSCNYTgFWDDq6vNt1ClSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7+eE3FM86n51VPLSyl1+c21VfftoVmOZy+mC+QuqHlEVp4Sh60xQ+y0xbzh4jV0F9kFj6yufKu/QKyQqIeaTV0Zgwwu5ZeDqdTfyJ5MqlPC/fzRRF8ZFxD347cxDzMrSdU0ZNSxv8Ntx309uGs6joPVlOJgKUb63M+OaKiZHxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYMWSbyC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYMWSbyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DD11F00893;
	Sun,  7 Jun 2026 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827290;
	bh=QC7ZCjuL+/jK3FWLHgZw9cNKhb4HSVySB0FryRPRURM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYMWSbyCm/fYo2NoaOvdGwcv4BkBhVKScJqPIc4YDqY+Z3A1FW0IZkqkLD1PTCM/d
	 Luvuctmy/sjX9Tho16s6GSjNthzoUNLmMdQnWStNGhsQXQUsBRujreYwee16zOd3BK
	 Kh+8k5avwjxwk1vKIFW8fT866LB54dKzcoRTe2TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Victor Nogueira <victor@mojatatu.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 080/332] net/sched: fix packet loop on netem when duplicate is on
Date: Sun,  7 Jun 2026 11:57:29 +0200
Message-ID: <20260607095731.081949281@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 9552b11e3edabc97cfcd9f29103d5afbce7ae183 ]

When netem duplicates a packet it re-enqueues the copy at the root qdisc.
If another netem sits in the tree the copy can be duplicated
again, recursing until the stack or memory is exhausted.

The original duplication guard temporarily zeroed q->duplicate around
the re-enqueue, but that does not cover all cases because it is
per-qdisc state shared across all concurrent enqueue paths
and is not safe without additional locking.

Use the skb tc_depth field introduced in an earlier patch:
 - increment it on the duplicate before re-enqueue
 - skip duplication for any skb whose tc_depth is already non-zero.

This marks the packet itself rather than mutating qdisc state,
therefore it is safe regardless of tree topology or concurrency.

Fixes: 0afb51e72855 ("[PKT_SCHED]: netem: reinsert for duplication")
Reported-by: William Liu <will@willsroot.io>
Reported-by: Savino Dicanosa <savy@syst3mfailure.io>
Closes: https://lore.kernel.org/netdev/8DuRWwfqjoRDLDmBMlIfbrsZg9Gx50DHJc1ilxsEBNe2D6NMoigR_eIRIG0LOjMc3r10nUUZtArXx4oZBIdUfZQrwjcQhdinnMis_0G7VEk=@willsroot.io/
Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: William Liu <will@willsroot.io>
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260525122556.973584-5-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index d97acd2f392346..17a79fe2f0911d 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -461,7 +461,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	skb->prev = NULL;
 
 	/* Random duplication */
-	if (q->duplicate && q->duplicate >= get_crandom(&q->dup_cor, &q->prng))
+	if (q->duplicate && skb->tc_depth == 0 &&
+	    q->duplicate >= get_crandom(&q->dup_cor, &q->prng))
 		++count;
 
 	/* Drop packet? */
@@ -540,11 +541,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 */
 	if (skb2) {
 		struct Qdisc *rootq = qdisc_root_bh(sch);
-		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
 
-		q->duplicate = 0;
+		skb2->tc_depth++; /* prevent duplicating a dup... */
 		rootq->enqueue(skb2, rootq, to_free);
-		q->duplicate = dupsave;
 		skb2 = NULL;
 	}
 
-- 
2.53.0



