Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022107;
	b=cUMC0+s1TGk/zy1/o3vXZ2wjA0YoGMdixmJtZBYoHFXHHlDUz1t98uubcuDqYCmdwz4l
	 hPsvmbRDVxXdKRTNQdgIvbyVO0vCCYQtvGpqHj7WtwQiw7Ytcx+ute4SNTNHxk8o/Befd
	 GNb358ozRqbaUgIPCzO6nuMfxmAnk9PFkPnkTuApGo6BVrWvhoaEacbsvd3a1g8kgM+21
	 6HtCt+EaIsUdWfd8rAvfCJg6HFbPmKFyUv49oJtQ1rF8Wmwk1LVsAqy78h93jj+k9sXsS
	 kHcCUANUYOm8KaSfwpDUAgDaPdBSBED2iEjv1I+XTJtdxXf2DU6hY6u45NcBJuyGb3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ope5CiyhPhTS7f2oZ5cM6oa59VdzMoLmbiZxrMXOzzU=;
	b=pYFQcBPPLZkTEV9qeB2RrHnkI65MLRV+/D87FAyVsly9yhLoEw6vfA21cnUA9pf8x1zH
	 ShQQsjJ4e6r4jXt0pntxe2Ybt6U1AoxA5Su/AaqTCw/OOvjp9V98Hpzkg7kv7i8ni8I/p
	 ppShAGrE1oVthFnv1cLqcyguKhf2g0rhnGN4of0+zim3xzhw1RjJviY/sHc2DLzd9Ioua
	 jnBO3lo8Xy3vKFzt8s+oRQMzQRjZh22JnHUXMzuVwiAhMFCWpJNmmP7tjjWIXvNgUy/EW
	 DpG1rNd6cflI8v74trwTd+PywL2gR7aY3pldOR+BFRwfphTWxaoVJkK681o0NFn7ZOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftWbXN03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F3260A2601;
	Wed, 18 Nov 2026 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftWbXN03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E1C1F000C7;
	Wed, 18 Nov 2026 17:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022106;
	bh=Ope5CiyhPhTS7f2oZ5cM6oa59VdzMoLmbiZxrMXOzzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftWbXN03aqmUchnjYFlA39OUg/0zg0zrWOH82GAiOjAubhByhM0g6VeQVwVUDvrRv
	 4BKepX60Q0msVNtD++vdOoEiRPVLJGodwWIl82mYjO1l55tYg06pmrkgNyYZmQbNrf
	 5xuu4o71KpxFq5XMIBJ7gozfnz6+dSwY1E+kgnso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2545/2651] blk-cgroup: keep the old blkg while reassociating a bio
Date: Wed, 18 Nov 2026 16:03:05 +0100
Message-ID: <20261118150416.152746684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 0e1daaf9b20df2125452846f768a68d8ea280adf ]

bio_associate_blkg_from_css() drops the bio's old blkg before it looks up
the new one through the css. The css is pinned by the blkg, not by the
bio, so if the cgroup is gone the bio may hold the last reference and the
blkcg can be freed under blkg_tryget_closest(). The rcu_read_lock()
around the whole thing used to cover that, until commit 457d3c4f0fdd
dropped it.

Put the old blkg after the new one has been looked up.

Fixes: 457d3c4f0fdd ("blk-cgroup: don't nest queue_lock under rcu in bio_associate_blkg()")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-2-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b56db1cc6778f..a39167228501d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2132,8 +2132,7 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css)
 {
-	if (bio->bi_blkg)
-		blkg_put(bio->bi_blkg);
+	struct blkcg_gq *old_blkg = bio->bi_blkg;
 
 	if (css && css->parent) {
 		bio->bi_blkg = blkg_tryget_closest(bio, css);
@@ -2141,6 +2140,10 @@ void bio_associate_blkg_from_css(struct bio *bio,
 		blkg_get(bdev_get_queue(bio->bi_bdev)->root_blkg);
 		bio->bi_blkg = bdev_get_queue(bio->bi_bdev)->root_blkg;
 	}
+
+	/* @old_blkg may be the only thing which pins @css */
+	if (old_blkg)
+		blkg_put(old_blkg);
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
 
-- 
2.53.0



