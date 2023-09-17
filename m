Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E0F7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15895C433C8;
	Sun, 17 Sep 2023 20:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981903;
	bh=ceRQjJHz2eMEvq2zvIyNOwBhmaZ67fxhY/J9YhgFQzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w77y1torMUL74cn2ftQi8DZ9D3QtHxrFEhdrHHsg2FAWrD6g1hRpPHwSC/F0muWpz
	 +TN1LWHm9xEZLdxl0mnPbNED7TxyhPOTbq219reQG/gQNhRTkX7biTrwS4ngcjmG3l
	 qlnzNqe8JU55Fp7zFa+s04l4lJX+Vsj7vkWsk9x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/511] quota: factor out dquot_write_dquot()
Date: Sun, 17 Sep 2023 21:09:11 +0200
Message-ID: <20230917191116.865028814@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 024128477809f8073d870307c8157b8826ebfd08 ]

Refactor out dquot_write_dquot() to reduce duplicate code.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230630110822.3881712-2-libaokun1@huawei.com>
Stable-dep-of: dabc8b207566 ("quota: fix dqput() to follow the guarantees dquot_srcu should provide")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index b88f5a2f6032b..fae2dbd663020 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -628,6 +628,18 @@ int dquot_scan_active(struct super_block *sb,
 }
 EXPORT_SYMBOL(dquot_scan_active);
 
+static inline int dquot_write_dquot(struct dquot *dquot)
+{
+	int ret = dquot->dq_sb->dq_op->write_dquot(dquot);
+	if (ret < 0) {
+		quota_error(dquot->dq_sb, "Can't write quota structure "
+			    "(error %d). Quota may get out of sync!", ret);
+		/* Clear dirty bit anyway to avoid infinite loop. */
+		clear_dquot_dirty(dquot);
+	}
+	return ret;
+}
+
 /* Write all dquot structures to quota files */
 int dquot_writeback_dquots(struct super_block *sb, int type)
 {
@@ -658,16 +670,9 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 			 * use count */
 			dqgrab(dquot);
 			spin_unlock(&dq_list_lock);
-			err = sb->dq_op->write_dquot(dquot);
-			if (err) {
-				/*
-				 * Clear dirty bit anyway to avoid infinite
-				 * loop here.
-				 */
-				clear_dquot_dirty(dquot);
-				if (!ret)
-					ret = err;
-			}
+			err = dquot_write_dquot(dquot);
+			if (err && !ret)
+				ret = err;
 			dqput(dquot);
 			spin_lock(&dq_list_lock);
 		}
@@ -765,8 +770,6 @@ static struct shrinker dqcache_shrinker = {
  */
 void dqput(struct dquot *dquot)
 {
-	int ret;
-
 	if (!dquot)
 		return;
 #ifdef CONFIG_QUOTA_DEBUG
@@ -794,17 +797,7 @@ void dqput(struct dquot *dquot)
 	if (dquot_dirty(dquot)) {
 		spin_unlock(&dq_list_lock);
 		/* Commit dquot before releasing */
-		ret = dquot->dq_sb->dq_op->write_dquot(dquot);
-		if (ret < 0) {
-			quota_error(dquot->dq_sb, "Can't write quota structure"
-				    " (error %d). Quota may get out of sync!",
-				    ret);
-			/*
-			 * We clear dirty bit anyway, so that we avoid
-			 * infinite loop here
-			 */
-			clear_dquot_dirty(dquot);
-		}
+		dquot_write_dquot(dquot);
 		goto we_slept;
 	}
 	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
-- 
2.40.1



