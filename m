Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0BC22F01;
	Wed, 20 May 2026 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295549; cv=none; b=UxAFtaB1FiFGxCIh85zKCzXbJbXfSCQm5+T89OGWdTVHH1vAlNzPw/Dw7bBpB+4dKmU3Pnm9km/NKVilEEfLEA+UyzMei7MEfKlk4dGEBv0S8sdovhPJ1fsXbiNXs/X/T3h4LVDoU13Xmkkv1MkZ0bBM34eChVxMXfgK/uCydCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295549; c=relaxed/simple;
	bh=HbS8IsuBdUNuNXm/+CMLeG09TFiDS+ffxaNkC9PZsB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io5oJuUA7SMT2Gv/75CUjr0zT+2MLeHmLjZX7AQgOiHe15wuXE3kM9h+7in7MLmg8CrsI3AlKV4UkaKVqwfn+VERKnb3CvTCb27GREZ/Wowp5kKAO8XeuziWsEJzwMPXWwxJD37SSO+1qNGptbmWv+FCfqHRgA9S5svjCbJZVD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKgor1te; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKgor1te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD091F000E9;
	Wed, 20 May 2026 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295547;
	bh=hoqHT35Wi8GQ2zNvKeVVpNuTksByKEO8nhf0D7pDGF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKgor1te2t8itvDyPSgWIuD6zYwQGYjqNuzQo5NG0aBUJLl7CbsdoAP5RfeBVr9fh
	 Drmo4PUBw8cClmAZ0+gV+zYoFxNlliRYq6Dy/5nTmYdvxx6+hXQnlWaf48sM7exEO0
	 7n1kdhdTQH74cESH0B9ezw2qDTDYY/nuEwz4+whA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0460/1146] quota: Fix race of dquot_scan_active() with quota deactivation
Date: Wed, 20 May 2026 18:11:50 +0200
Message-ID: <20260520162158.607994679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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
index 376739f6420ed..64cf427214965 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -363,6 +363,31 @@ static inline int dquot_active(struct dquot *dquot)
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
@@ -641,15 +666,14 @@ int dquot_scan_active(struct super_block *sb,
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
@@ -717,7 +741,7 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 			/* Now we have active dquot from which someone is
  			 * holding reference so we can safely just increase
 			 * use count */
-			dqgrab(dquot);
+			__dqgrab(dquot);
 			spin_unlock(&dq_list_lock);
 			err = dquot_write_dquot(dquot);
 			if (err && !ret)
@@ -963,9 +987,7 @@ struct dquot *dqget(struct super_block *sb, struct kqid qid)
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
index c334f82ed385a..f9c0f9d7c9d93 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -44,14 +44,7 @@ int dquot_initialize(struct inode *inode);
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



