Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591207;
	b=EYXN4OpZvk6Ryhc+rRwRp45iQkByJqSdnk+yeUdDCjFhPQkUGQquhL8FtbW8Ma9TXXZl
	 OlHFsczH7o+boxLcQB9GCHceHEUQjFMoBsYoYaZSy8mqE4YhoFt1zMFRGuCOOsDW41Uki
	 gfrlNBfv5DeXCljHPtoRhTSvstz3sW3dqeTQ6eSoVrYCXg668n3aSU3UZJDCh55QO5IdZ
	 SS+A6+zXcx38HlMpsbLwbzV2yp5OvYxiujH0J7Iy/nKYUkC00rNPvaddSTn3iuVkrRNfz
	 bxiaq4Fi6e6I0/nVsdA0xlQi6UFkFlKq9BuWSJzApx2v9dLDjGNTLZDYKTf17ZC7tIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b6/QS5fi6SbTkzREzAVwXMOyKfLvi9N91rGyXYPthDQ=;
	b=Ilptcp5jObuon9GWaYbm0QiV85UN6pYYg4wcYx8I9gKsR87wCkxZHN/vl6KtG5vOfSK5
	 lrRrjaGiZ+BgfxIemXeLz1gTJa27332urSua9XI+MM4/YIPpIEostdwS9NCatg5pkn5R8
	 hzuWrmj/O2R0O2rC5c4f/9tlDXDMr1htTQbcoBaxL/7Kels+IYCU/+Tqf596o5VpoQUDU
	 u3QzgzK80PJ32JWWoVL8FlGAR9VXA5TOnXQZVnNo+vICPTP9WR+bP/0nXWEptn4sjzU+8
	 rRB0xLqin4jWNQtzzgCANk6fiYs0qeek23BFMFZ1khePVOOHUgZm8HXHrOpBXSJC2/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTRt7ew3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9EF6075854;
	Fri, 13 Nov 2026 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTRt7ew3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2081F000C5;
	Fri, 13 Nov 2026 17:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591207;
	bh=b6/QS5fi6SbTkzREzAVwXMOyKfLvi9N91rGyXYPthDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTRt7ew3zgy3DhjXePjbO5VpR9IhX59QNTnZsMLNeoWuwXCP+ix0NFbLHRx4vGs8o
	 sC/iJvd9MXWHo0HsbFRQFzWfkFbcNmwq9tjxL6iEMXwFQ6WmGngMuR6AInolZtbqze
	 zwjy4jCnJWTPVvIYkns1fYRZRhBaKir8cOGq3oAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/670] net/sched: sch_qfq: prevent aggregate self-replacement
Date: Fri, 13 Nov 2026 10:47:43 -0500
Message-ID: <20261113153822.060984366@linuxfoundation.org>
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
index 70a08f1950100..b0a9966cc6ab8 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -520,11 +520,14 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
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



