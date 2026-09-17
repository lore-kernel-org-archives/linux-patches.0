Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B553A4FE2D5;
	Thu, 17 Sep 2026 17:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667299; cv=none; b=cPB8STpa5yCoQOga4FRRrXfzQNi4YX0uFaw8cqCwPQiAm+KaMqnl4OAPFEFFdcy96S11zhSeZDbjiUsN/jc9N3HEeHDKfHskTN/Za/soT02fZO2MdaOsTlGJbE789XEzJtiWffEFBXyVixaQjP1vu+bpmIv/d6CmsysRDTFGtAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667299; c=relaxed/simple;
	bh=3RK4h70u6wsgL6D5ujbRHcZai24LgN5VQWLRhAB49aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGmpB5OO8uZEvjjcJ0SJ+NX5GZj9H14pxpCLKdLw7jQglyTyVQdBJePtyHBWFpFg7n4WqCY0JhwqyFxGpZ7xHNc7pAnnjibDfGELzRIlnbo0V6BT8krzT6bTC1udfKNea/vzHfVkG6b1MPwZ5JTvIa5f++4gQvcOXBzEg/17Hik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uni2IToG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uni2IToG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AF21F000FF;
	Thu, 17 Sep 2026 17:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667298;
	bh=Jg0HMLponssJyUVRcphC7nqJzhlYg+KMuOusLh0JLUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uni2IToGJt+o5mA9jhZ5XwmfLqab26MPDF5cRcixAlnZKmHdDFmHcH3B+trI6Gopf
	 IT0Y884u4E9rDVwRDKhZ4o5vCefN76zHNgYIMfwBOFOObbeCBh3XQiE/Nd7QvrFfQX
	 y2XDiBY9cIRAXg5YAyGGoIgdjJyjQ2caoHdERDMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+642d0561f78362d67d3f@syzkaller.appspotmail.com,
	Jie Wang <jie.wang@intel.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0008/1102] gfs2: fix quota init duplicate scan
Date: Thu, 17 Sep 2026 15:59:11 +0100
Message-ID: <20260917151539.630886030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jie Wang <jie.wang@intel.com>

[ Upstream commit b99a1f0f18ee50445907f55069e88bcfd8947383 ]

gfs2_quota_init() checks for duplicate quota_change IDs while holding
qd_lock and the quota hash bucket bitlock. That path used
gfs2_qd_search_bucket(), which takes a lockref reference via
lockref_get_not_dead().

On PREEMPT_RT this may sleep, which is not allowed under the bucket
bitlock, triggering "sleeping function called from invalid context".

Use a no-ref bucket lookup in this path, then continue duplicate
handling without taking a lockref there.

Refactor gfs2_qd_search_bucket() to build on top of the no-ref helper
so lookup traversal stays in one place.

This patch fixes a bug reported by syzbot.

Reported-by: syzbot+642d0561f78362d67d3f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=642d0561f78362d67d3f
Tested-by: syzbot+642d0561f78362d67d3f@syzkaller.appspotmail.com
Signed-off-by: Jie Wang <jie.wang@intel.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 95b20e6a3fbc6..da62e0c5ee388 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -255,9 +255,13 @@ static struct gfs2_quota_data *qd_alloc(unsigned hash, struct gfs2_sbd *sdp, str
 	return NULL;
 }
 
-static struct gfs2_quota_data *gfs2_qd_search_bucket(unsigned int hash,
-						     const struct gfs2_sbd *sdp,
-						     struct kqid qid)
+/*
+ * Lookup variant for callers which already hold qd_lock + bucket lock.
+ */
+static struct gfs2_quota_data *
+gfs2_qd_search_bucket_noref(unsigned int hash,
+			    const struct gfs2_sbd *sdp,
+			    struct kqid qid)
 {
 	struct gfs2_quota_data *qd;
 	struct hlist_bl_node *h;
@@ -265,12 +269,22 @@ static struct gfs2_quota_data *gfs2_qd_search_bucket(unsigned int hash,
 	hlist_bl_for_each_entry_rcu(qd, h, &qd_hash_table[hash], qd_hlist) {
 		if (!qid_eq(qd->qd_id, qid))
 			continue;
-		if (qd->qd_sbd != sdp)
-			continue;
-		if (lockref_get_not_dead(&qd->qd_lockref)) {
-			list_lru_del_obj(&gfs2_qd_lru, &qd->qd_lru);
+		if (qd->qd_sbd == sdp)
 			return qd;
-		}
+	}
+
+	return NULL;
+}
+
+static struct gfs2_quota_data *
+gfs2_qd_search_bucket(unsigned int hash, const struct gfs2_sbd *sdp, struct kqid qid)
+{
+	struct gfs2_quota_data *qd;
+
+	qd = gfs2_qd_search_bucket_noref(hash, sdp, qid);
+	if (qd && lockref_get_not_dead(&qd->qd_lockref)) {
+		list_lru_del_obj(&gfs2_qd_lru, &qd->qd_lru);
+		return qd;
 	}
 
 	return NULL;
@@ -1459,7 +1473,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 
 			spin_lock(&qd_lock);
 			spin_lock_bucket(hash);
-			old_qd = gfs2_qd_search_bucket(hash, sdp, qc_id);
+			old_qd = gfs2_qd_search_bucket_noref(hash, sdp, qc_id);
 			if (old_qd) {
 				fs_err(sdp, "Corruption found in quota_change%u"
 					    "file: duplicate identifier in "
@@ -1468,7 +1482,6 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 
 				spin_unlock_bucket(hash);
 				spin_unlock(&qd_lock);
-				qd_put(old_qd);
 
 				gfs2_glock_put(qd->qd_gl);
 				kmem_cache_free(gfs2_quotad_cachep, qd);
-- 
2.53.0



