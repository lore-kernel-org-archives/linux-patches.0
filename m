Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D304B1CA8F;
	Mon,  1 Apr 2024 16:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987549; cv=none; b=qZmf2urgOQ2FpF3cKK/5OyxdQBujyHMRxpLiDr7ZoSUsA1pCRJoO5LByGO38TuMAVG4KG5WkWLbm3LBRJ+ucb1b2qChPdMGhocbaBtx2+M6QW+4mhjyHcIIjeaN4BqAnbzyOwWuAP+DNLCs7qrSxUs9W7mLui+JM5XX7jJ4uIyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987549; c=relaxed/simple;
	bh=XTTOxpTy+qr8Ncai0XKpRGBslqtYHtC1okXrojl+58g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aG1N57h07wcZ39i3Zj0bBL18R2ghP0sKm7ny2oqQ9a/7LGnlh0PwKWmUTuwqextTOn3W4esI9PacMBuIa/Lf0LfngnjmKjHPPc9CTvjuMAdSd6HenTx0xzuZB+n1bEJXcbfXOnhSU5X8RzAGmP3sAejcd45BKdJHGlm49sd94+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8sSrQFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8sSrQFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1279EC433C7;
	Mon,  1 Apr 2024 16:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987549;
	bh=XTTOxpTy+qr8Ncai0XKpRGBslqtYHtC1okXrojl+58g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8sSrQFtcZnf+GX+eDbQcqZKmLmdCCdQu05IE5L6EhX+PwhCLniJx9KRoJHA6z4PH
	 RxAfCliNHuPMaWtja5QxTdlrq4jL4MJnyBn+G5QY2trM4Do4UywG9kK8AMiuK9/4DY
	 z4RVFYatuyItT7jaaq0u7sTrxsLrR6Z3TcjD+GcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Ubisectech Sirius <bugreport@ubisectech.com>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 293/399] tmpfs: fix race on handling dquot rbtree
Date: Mon,  1 Apr 2024 17:44:19 +0200
Message-ID: <20240401152557.932698807@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Maiolino <cem@kernel.org>

commit 0a69b6b3a026543bc215ccc866d0aea5579e6ce2 upstream.

A syzkaller reproducer found a race while attempting to remove dquot
information from the rb tree.

Fetching the rb_tree root node must also be protected by the
dqopt->dqio_sem, otherwise, giving the right timing, shmem_release_dquot()
will trigger a warning because it couldn't find a node in the tree, when
the real reason was the root node changing before the search starts:

Thread 1				Thread 2
- shmem_release_dquot()			- shmem_{acquire,release}_dquot()

- fetch ROOT				- Fetch ROOT

					- acquire dqio_sem
- wait dqio_sem

					- do something, triger a tree rebalance
					- release dqio_sem

- acquire dqio_sem
- start searching for the node, but
  from the wrong location, missing
  the node, and triggering a warning.

Link: https://lkml.kernel.org/r/20240320124011.398847-1-cem@kernel.org
Fixes: eafc474e2029 ("shmem: prepare shmem quota infrastructure")
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reported-by: Ubisectech Sirius <bugreport@ubisectech.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem_quota.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -116,7 +116,7 @@ static int shmem_free_file_info(struct s
 static int shmem_get_next_id(struct super_block *sb, struct kqid *qid)
 {
 	struct mem_dqinfo *info = sb_dqinfo(sb, qid->type);
-	struct rb_node *node = ((struct rb_root *)info->dqi_priv)->rb_node;
+	struct rb_node *node;
 	qid_t id = from_kqid(&init_user_ns, *qid);
 	struct quota_info *dqopt = sb_dqopt(sb);
 	struct quota_id *entry = NULL;
@@ -126,6 +126,7 @@ static int shmem_get_next_id(struct supe
 		return -ESRCH;
 
 	down_read(&dqopt->dqio_sem);
+	node = ((struct rb_root *)info->dqi_priv)->rb_node;
 	while (node) {
 		entry = rb_entry(node, struct quota_id, node);
 
@@ -165,7 +166,7 @@ out_unlock:
 static int shmem_acquire_dquot(struct dquot *dquot)
 {
 	struct mem_dqinfo *info = sb_dqinfo(dquot->dq_sb, dquot->dq_id.type);
-	struct rb_node **n = &((struct rb_root *)info->dqi_priv)->rb_node;
+	struct rb_node **n;
 	struct shmem_sb_info *sbinfo = dquot->dq_sb->s_fs_info;
 	struct rb_node *parent = NULL, *new_node = NULL;
 	struct quota_id *new_entry, *entry;
@@ -176,6 +177,8 @@ static int shmem_acquire_dquot(struct dq
 	mutex_lock(&dquot->dq_lock);
 
 	down_write(&dqopt->dqio_sem);
+	n = &((struct rb_root *)info->dqi_priv)->rb_node;
+
 	while (*n) {
 		parent = *n;
 		entry = rb_entry(parent, struct quota_id, node);
@@ -264,7 +267,7 @@ static bool shmem_is_empty_dquot(struct
 static int shmem_release_dquot(struct dquot *dquot)
 {
 	struct mem_dqinfo *info = sb_dqinfo(dquot->dq_sb, dquot->dq_id.type);
-	struct rb_node *node = ((struct rb_root *)info->dqi_priv)->rb_node;
+	struct rb_node *node;
 	qid_t id = from_kqid(&init_user_ns, dquot->dq_id);
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 	struct quota_id *entry = NULL;
@@ -275,6 +278,7 @@ static int shmem_release_dquot(struct dq
 		goto out_dqlock;
 
 	down_write(&dqopt->dqio_sem);
+	node = ((struct rb_root *)info->dqi_priv)->rb_node;
 	while (node) {
 		entry = rb_entry(node, struct quota_id, node);
 


