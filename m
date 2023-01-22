Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F212590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C28C433D2;
	Sun, 22 Jan 2023 15:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401038;
	bh=1s7zHPXd5oRvyw4A38we3ufP+2PUKcqxaNe0KiMTC+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unNmOqd/q13sBxtJMroKDMZUb6afaW1l1fRjXHasH6yV5AimhEpYqMcAhBvEj9Q0/
	 hzWFlu0gtZKiP1ey62k0/3Asz38CSTHNscQQKy0iHLYkJHKxsRICKMD2Q5LlUJt3jA
	 tAZVJ/1CSlfMrbBLhCHNMdbc6aEQaWUACwu0Sh4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 086/193] btrfs: do not abort transaction on failure to update log root
Date: Sun, 22 Jan 2023 16:03:35 +0100
Message-Id: <20230122150250.322613248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

commit 09e44868f1e03c7825ca4283256abedc95e249a3 upstream.

When syncing a log, if we fail to update a log root in the log root tree,
we are aborting the transaction if the failure was not -ENOSPC. This is
excessive because there is a chance that a transaction commit can succeed,
and therefore avoid to turn the filesystem into RO mode. All we need to be
careful about is to mark the log for a full commit, which we already do,
to make sure no one commits a super block pointing to an outdated log root
tree.

So don't abort the transaction if we fail to update a log root in the log
root tree, and log an error if the failure is not -ENOSPC, so that it does
not go completely unnoticed.

CC: stable@vger.kernel.org # 6.0+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3075,15 +3075,12 @@ int btrfs_sync_log(struct btrfs_trans_ha
 
 		blk_finish_plug(&plug);
 		btrfs_set_log_full_commit(trans);
-
-		if (ret != -ENOSPC) {
-			btrfs_abort_transaction(trans, ret);
-			mutex_unlock(&log_root_tree->log_mutex);
-			goto out;
-		}
+		if (ret != -ENOSPC)
+			btrfs_err(fs_info,
+				  "failed to update log for root %llu ret %d",
+				  root->root_key.objectid, ret);
 		btrfs_wait_tree_log_extents(log, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
-		ret = BTRFS_LOG_FORCE_COMMIT;
 		goto out;
 	}
 


