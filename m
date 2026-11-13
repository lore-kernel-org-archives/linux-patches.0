Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585648;
	b=FJJvo4OQVTyGO+5AgPzuFncWBDnpTLe+xXodkHjQS3hLpZud2qSK90SHqKVvGAgTC0Ef
	 oUGE6gb8LFXjTygw/IIEGLyyK7RGx1lNFZ0O5HQbHHF93TRohw7uC+b7kYjuhLInRHEuX
	 mluNYFsURGs+4np+gMdkmBJDE/2MJ6Z4sR8qzy9BiasWOMaZMp0jgAScUI8LKiHzXF2Jy
	 25e+fjxHdFc7TTPRmOKK83EAd1wE1/jFxFe+DOvfmr6Jb0YcERN0T60g8NJr5OifRPJ70
	 e+Y4i7YB6InSQiZLD40DAYCVq1lpFRN6OYoFqGMcw6K7erzqY/09Y6KcKjpj8KdAamQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bmawQbs9yZB0kGa5QAph6N1m/y3jTU1DOILcgNXaBaM=;
	b=K+JLhkR9mcjGnBT9kv00+gK1LkPZRtbj2UQ8GT0dcui3NEQckKgYaJWTYuzVZ2Pr48TG
	 wM1qBmuqWiDgmhYB7K72lq7H4rfsqbcfkC9OsdWZ+a2y/iXrRZaOkIsv94LPNvqhVjH5v
	 Ht2rFge4ErkinlbZ63X68XzZwS7ro0p3P9TqVc/dMR5Wrk68awUQGRa/tIdbcGAoFnHCx
	 MlDTyvrL+coGj/xzXcgXrE543u4Yn2nxRxJcrxo32f9dWL8s9lKUw/yHa2YQmvJ9wsY3r
	 gFLDsBT5gYZga1GNBhl69zymJ8ycalXle+wpCMf7U3uK0yRBs8mkz4o8lnRJmqldqZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWtBZvVH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC7B606B5DD;
	Fri, 13 Nov 2026 16:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWtBZvVH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1C21F000C5;
	Fri, 13 Nov 2026 16:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585648;
	bh=bmawQbs9yZB0kGa5QAph6N1m/y3jTU1DOILcgNXaBaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWtBZvVHQwhVj+zNL7nCcolJg8+MeWqrAH2XycN2WW3slhTAOx2d1WneopGNp6aLg
	 u06Mo2Kw6VVK/ULgLkbDDaEZuGdNsiRCJtJ30LPSfkBEv/vjyHbjb10Bqsiit0sm+g
	 /AT7h9nyjREMJap0Q8obS6J93BsilB24lkQusKQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 264/507] net/sched: sch_qfq: prevent aggregate self-replacement
Date: Fri, 13 Nov 2026 10:49:28 -0500
Message-ID: <20261113153803.513147326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6f3b7273cb160..e900890e9c544 100644
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



