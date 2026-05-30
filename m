Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6F2351C2F;
	Sat, 30 May 2026 18:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166480; cv=none; b=WT/GngNYXO1W8+mgJFwQ1iENKM78jBsf3bjYMh1YJZcWzy6e25x9zxByOpvtVdyLFKyj6QLTie0MhKzFhGIluMzVgY3VxdhuBWscuG9zcwDF7+DB85KljK1O/ggETV5XkT8M4iBuOjp6aiiSOQ7rmVJOfOYsziUr+DgtHSOQIS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166480; c=relaxed/simple;
	bh=7tKtsMtvgiFZ+JnBvh5B9eRoZW9ql2zJHNkxLMuXW9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT+fgHs2daKsBxz3bnnmBfC2BoqXQFVMhOLniDjlPTRnPD0Yl1TM06BAyTrsp387VSmljRE+bN+E9O/SToS5LIfMb7aEk8DJLgmPC433ZjdxRHC5+NnUHADMnSDR/UvjTN7BPF7VUBWTD+ctozJiG/0E8rjccfoToM6w1Zf1MDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJpABtt5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJpABtt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643F01F00893;
	Sat, 30 May 2026 18:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166478;
	bh=oYlB/B2OdaOR7romx5RwekrrI7ErA+Mmo4XFvC9QVcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJpABtt5oiEWyGrUxObTHK+PVGH/YcdcTEtQ7vePWDVT1LNrR/76COwuhkWj0eu1D
	 j1EIRe6QF+50AYpqO/xYu+6sR1eBfLIfk3NLF71hwT24zVFWqNQKfi8r7KwuLZgp04
	 G8KkmlQpitBMFVuqIN3A38gP1Rh/9lQy+D4XIz58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/589] quota: Fix race of dquot_scan_active() with quota deactivation
Date: Sat, 30 May 2026 18:03:59 +0200
Message-ID: <20260530160234.260051911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit e93ab401da4b2e2c1b8ef2424de2f238d51c8b2d ]

dquot_scan_active() can race with quota deactivation in
quota_release_workfn() like:

  CPU0 (quota_release_workfn)         CPU1 (dquot_scan_active)
  ==============================      ==============================
  spin_lock(&dq_list_lock);
  list_replace_init(
    &releasing_dquots, &rls_head);
    /* dquot X on rls_head,
       dq_count == 0,
       DQ_ACTIVE_B still set */
  spin_unlock(&dq_list_lock);
  synchronize_srcu(&dquot_srcu);
                                      spin_lock(&dq_list_lock);
                                      list_for_each_entry(dquot,
                                          &inuse_list, dq_inuse) {
                                        /* finds dquot X */
                                        dquot_active(X) -> true
                                        atomic_inc(&X->dq_count);
                                      }
                                      spin_unlock(&dq_list_lock);
  spin_lock(&dq_list_lock);
  dquot = list_first_entry(&rls_head);
  WARN_ON_ONCE(atomic_read(&dquot->dq_count));

The problem is not only a cosmetic one as under memory pressure the
caller of dquot_scan_active() can end up working on freed dquot.

Fix the problem by making sure the dquot is removed from releasing list
when we acquire a reference to it.

Fixes: 869b6ea1609f ("quota: Fix slow quotaoff")
Reported-by: Sam Sun <samsun1006219@gmail.com>
Link: https://lore.kernel.org/all/CAEkJfYPTt3uP1vAYnQ5V2ZWn5O9PLhhGi5HbOcAzyP9vbXyjeg@mail.gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c         | 38 ++++++++++++++++++++++++++++++--------
 include/linux/quotaops.h |  9 +--------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 525ae0f11818c..b4326fc1d90fd 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -364,6 +364,31 @@ static inline int dquot_active(struct dquot *dquot)
 	return test_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 }
 
+static struct dquot *__dqgrab(struct dquot *dquot)
+{
+	lockdep_assert_held(&dq_list_lock);
+	if (!atomic_read(&dquot->dq_count))
+		remove_free_dquot(dquot);
+	atomic_inc(&dquot->dq_count);
+	return dquot;
+}
+
+/*
+ * Get reference to dquot when we got pointer to it by some other means. The
+ * dquot has to be active and the caller has to make sure it cannot get
+ * deactivated under our hands.
+ */
+struct dquot *dqgrab(struct dquot *dquot)
+{
+	spin_lock(&dq_list_lock);
+	WARN_ON_ONCE(!dquot_active(dquot));
+	dquot = __dqgrab(dquot);
+	spin_unlock(&dq_list_lock);
+
+	return dquot;
+}
+EXPORT_SYMBOL_GPL(dqgrab);
+
 static inline int dquot_dirty(struct dquot *dquot)
 {
 	return test_bit(DQ_MOD_B, &dquot->dq_flags);
@@ -642,15 +667,14 @@ int dquot_scan_active(struct super_block *sb,
 			continue;
 		if (dquot->dq_sb != sb)
 			continue;
-		/* Now we have active dquot so we can just increase use count */
-		atomic_inc(&dquot->dq_count);
+		__dqgrab(dquot);
 		spin_unlock(&dq_list_lock);
 		dqput(old_dquot);
 		old_dquot = dquot;
 		/*
 		 * ->release_dquot() can be racing with us. Our reference
-		 * protects us from new calls to it so just wait for any
-		 * outstanding call and recheck the DQ_ACTIVE_B after that.
+		 * protects us from dquot_release() proceeding so just wait for
+		 * any outstanding call and recheck the DQ_ACTIVE_B after that.
 		 */
 		wait_on_dquot(dquot);
 		if (dquot_active(dquot)) {
@@ -718,7 +742,7 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 			/* Now we have active dquot from which someone is
  			 * holding reference so we can safely just increase
 			 * use count */
-			dqgrab(dquot);
+			__dqgrab(dquot);
 			spin_unlock(&dq_list_lock);
 			err = dquot_write_dquot(dquot);
 			if (err && !ret)
@@ -973,9 +997,7 @@ struct dquot *dqget(struct super_block *sb, struct kqid qid)
 		spin_unlock(&dq_list_lock);
 		dqstats_inc(DQST_LOOKUPS);
 	} else {
-		if (!atomic_read(&dquot->dq_count))
-			remove_free_dquot(dquot);
-		atomic_inc(&dquot->dq_count);
+		__dqgrab(dquot);
 		spin_unlock(&dq_list_lock);
 		dqstats_inc(DQST_CACHE_HITS);
 		dqstats_inc(DQST_LOOKUPS);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 4bc8ff2a66143..8a1ad23da3a11 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -43,14 +43,7 @@ int dquot_initialize(struct inode *inode);
 bool dquot_initialize_needed(struct inode *inode);
 void dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, struct kqid qid);
-static inline struct dquot *dqgrab(struct dquot *dquot)
-{
-	/* Make sure someone else has active reference to dquot */
-	WARN_ON_ONCE(!atomic_read(&dquot->dq_count));
-	WARN_ON_ONCE(!test_bit(DQ_ACTIVE_B, &dquot->dq_flags));
-	atomic_inc(&dquot->dq_count);
-	return dquot;
-}
+struct dquot *dqgrab(struct dquot *dquot);
 
 static inline bool dquot_is_busy(struct dquot *dquot)
 {
-- 
2.53.0



