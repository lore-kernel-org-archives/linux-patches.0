Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590363;
	b=mEGCR+gtkhUxxel3bOlYs4BP8snDenLrPLNmL1ZjH4wmfz3NPdOaIqYQnZzz368/BVxW
	 uKqLzAxakKz6uHnyArfTlOKO6rkjJPJzbMhL5HMOCgcMbj73lLQa8Tol8ab1vI0Mvl+Rl
	 01jiAVtGaeCjzmopCmyjy0IkVXGy5m7UaR4S8GpgqxE0McUdAwTK7oHgnBMgZfLGqmg7T
	 tJNUodLnMWwp9+8ATh9QS3etvhSFAITeX/uINj2rBS0Ot2BC4uSiirD7Uw/nY/2IpD6sJ
	 LvzrLhYtHkoOBBjLciYvB1bwBYY6xlLgDuSkRfKj86KEwSGXt7366eitbzixTrajuzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPDXCXRwAxz3ChTmH5c+XxWdfIhFtRlJofGmwzt9zDE=;
	b=VXxOdyHxQQ80ir3xx5Vi6HaoruisG1oF6hwbPclygLeCXqNZPvM9PPjR2V4gcCzaEFUD
	 Lym5qeZ4y62Be5iTzWq+3OsLqs3BHECEuzvnYXjv9mpLRzq1SERcmAYpbA/j6+Izoh1vW
	 onUxSZsrz97Fcq0iPnfHw+H3IY8SgFr4zef73s+p3IGueiV0PpKYvOR3ZwpU83fHP48eu
	 uOwHrkpjeZcm2XGbU3jh9UQt+2C6lFvM7jpN7CtUg66g5I2nsHuJAaxz/UUrhNQvrWwnc
	 uX6HlDyaH0dx2a/LqvXTMZ4/6fc3toWLp2UokIpAsMULmi9ejfFjJvAWLoouIurc8Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqEW5RgX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96976608316B;
	Fri, 13 Nov 2026 17:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqEW5RgX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427D71F000C7;
	Fri, 13 Nov 2026 17:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590363;
	bh=JPDXCXRwAxz3ChTmH5c+XxWdfIhFtRlJofGmwzt9zDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqEW5RgX7f/mjripSu+1wd+6ksQOpoAX30ak7HqrQYUe7oNAnwQxiNaKU8M1RDwtd
	 ILtQJg9+o9XKIsSUJSfCFiOYhmaxi6DyKZIGFd0Zh3XUCoKUd4OWxjtiGP9MI/nqXx
	 1Kk93ohZi8k84YAOxzm8aoAwfdpvhwbFLRpr/EUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 338/686] net/sched: sch_qfq: prevent aggregate self-replacement
Date: Fri, 13 Nov 2026 10:47:51 -0500
Message-ID: <20261113153832.391428011@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 2e54b3e187300893688c2c7517894f5d96732e05 ]

qfq_change_class() snapshots the current aggregate settings while
holding the qdisc tree lock, but drops the lock before selecting the
destination aggregate. During that gap, qfq_enqueue() can move the
class to an aggregate matching the requested settings.

When qfq_change_class() resumes, qfq_find_agg() then returns cl->agg.
If it is a singleton, qfq_deact_rm_from_agg() frees the aggregate
before qfq_add_to_agg() immediately accesses the same pointer, causing
a use-after-free.

While holding the tree lock, skip the replacement when the destination
is already the current aggregate. Any estimator replacement has already
completed, so the class change can finish normally.

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Link: https://lore.kernel.org/netdev/20260731140533.566493-1-david.lee@trailofbits.com/
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Link: https://patch.msgid.link/20261029180957.43015-1-david.lee@trailofbits.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 7d93690cb4360..d82b04827c2c4 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -517,11 +517,14 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 		sch_tree_lock(sch);
 		qfq_init_agg(q, new_agg, lmax, weight);
 	}
+	if (existing && new_agg == cl->agg)
+		goto unlock;
 	if (existing)
 		qfq_deact_rm_from_agg(q, cl);
 	else
 		qdisc_class_hash_insert(&q->clhash, &cl->common);
 	qfq_add_to_agg(q, new_agg, cl);
+unlock:
 	sch_tree_unlock(sch);
 	qdisc_class_hash_grow(sch, &q->clhash);
 
-- 
2.53.0



