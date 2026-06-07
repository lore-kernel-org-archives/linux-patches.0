Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D28C2EB87F;
	Sun,  7 Jun 2026 10:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827630; cv=none; b=iaz+4cjcz8CdEqQ+yMdxWJ29WC4YwhHL5z7NGcYtV4OzPlRN0HklFI//4uFh+fi7l2IzOTrkmtwFCUz0DQ0qsuJtsqReh1V6hdwRexQRxaDDrl52Era6wTV+liFYRi6+5lojPfPxMse6LSRqSlzoBrn9AiT+qhWXTqTHNh39e3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827630; c=relaxed/simple;
	bh=mFiFUUhrdTUfVzD6H0mr3IGkVg8uHo6t88ZzTCqdj+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DitjmaFzdiOCwxMdqctYP7qMNuuWMqzESz9N0cuVA3tRd3+eZkGF3QHg/ISIjYZLL0EoqhjXyxvnkNDXCgW6olrM/kKvRO506fpfVaBiDamppPide5/NRuJFmRyxRJfBp1qIZ1DQxaMr5QKI9t9C1gL+YGBPInuc9mVdHuDUNUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWbSrVb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWbSrVb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83A31F00893;
	Sun,  7 Jun 2026 10:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827629;
	bh=QFdFqSJKhqzo83ll3291rcxA0rwKDKkf0yHd4oev+pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWbSrVb3ywGdidSPSG9Me1hE8i/8+/h2p3GRPc6OzBoG/9xbAJJtsb1lfM3x6s61i
	 oDOeQ002lOtGpkZhdedjX9GYs5Ie+2UGdm5nlEHecdIHpYzEd4jJOkZOoGUoWPAZ3U
	 fme7GUhtjFS9DX8LVbaN9VT3/Ul70UNEP/OJu6QE=
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
Subject: [PATCH 6.12 074/307] net/sched: fix packet loop on netem when duplicate is on
Date: Sun,  7 Jun 2026 11:57:51 +0200
Message-ID: <20260607095730.481390690@linuxfoundation.org>
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
index 1fdebf2ab7ee46..136b7d81296eff 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -459,7 +459,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	skb->prev = NULL;
 
 	/* Random duplication */
-	if (q->duplicate && q->duplicate >= get_crandom(&q->dup_cor, &q->prng))
+	if (q->duplicate && skb->tc_depth == 0 &&
+	    q->duplicate >= get_crandom(&q->dup_cor, &q->prng))
 		++count;
 
 	/* Drop packet? */
@@ -538,11 +539,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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



