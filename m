Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600D623F417;
	Fri, 31 Oct 2025 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919591; cv=none; b=d0R1VBmtsJw6qIhb3GKC/QzFFxwEeJyfMTXjtb1cc1bWiycorr85sL5SyMonxZvnv3zoUw7t96+xEkqDq9ghdmoX3VlpgmjE/MJvJ2SFWQm/7pPxn2LPSNG2oItOQx5PVl1bntX4xykLvdT6HLrAtVxjmM/CZbz38q5kol29PIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919591; c=relaxed/simple;
	bh=2P+EJs88WxLEbNAW/jonCkuIh+Hw4EqMOXHEk7zjFZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/z8t/TP9pqOj4tCaeAjSYlf/yX9oNIt+pXkPYu45lgfU+gDIV0gJp+ILhrYtSNROfmgWebB3WQMtcA6WJt08Fveohx/1AuiX2S1axgSay22UmFhwjU9TUVhjZdx6EWVaN3twba79fkZgh8uPjmfRUq3AxCKSj16L0r0aXWTv6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyodBMoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyodBMoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F9CC4CEF8;
	Fri, 31 Oct 2025 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919591;
	bh=2P+EJs88WxLEbNAW/jonCkuIh+Hw4EqMOXHEk7zjFZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyodBMoQksxBV9opm4jD8x8Rrf6gFnAEOKhWipVMd402w8Wi3H8mPEpBQMzLpzUmp
	 v0Q8Pd6e2j670DBHjdEYbmWMiEvNCb7FY0WzIOsFCwVZsDRstAiU5ieoA5ewtN0wLZ
	 b5y2heyvq+7CFPZyA/37u9uaaOptJzw5a0AB4+p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 29/35] btrfs: always drop log root tree reference in btrfs_replay_log()
Date: Fri, 31 Oct 2025 15:01:37 +0100
Message-ID: <20251031140044.341287683@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 2f5b8095ea47b142c56c09755a8b1e14145a2d30 ]

Currently we have this odd behaviour:

1) At btrfs_replay_log() we drop the reference of the log root tree if
   the call to btrfs_recover_log_trees() failed;

2) But if the call to btrfs_recover_log_trees() did not fail, we don't
   drop the reference in btrfs_replay_log() - we expect that
   btrfs_recover_log_trees() does it in case it returns success.

Let's simplify this and make btrfs_replay_log() always drop the reference
on the log root tree, not only this simplifies code as it's what makes
sense since it's btrfs_replay_log() who grabbed the reference in the first
place.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c  | 2 +-
 fs/btrfs/tree-log.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 70fc4e7cc5a0e..0b02e36b30558 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2087,10 +2087,10 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 
 	/* returns with log_tree_root freed on success */
 	ret = btrfs_recover_log_trees(log_tree_root);
+	btrfs_put_root(log_tree_root);
 	if (ret) {
 		btrfs_handle_fs_error(fs_info, ret,
 				      "Failed to recover log tree");
-		btrfs_put_root(log_tree_root);
 		return ret;
 	}
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 50ed84cb68a69..518cd74191e77 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7469,7 +7469,6 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 	log_root_tree->log_root = NULL;
 	clear_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags);
-	btrfs_put_root(log_root_tree);
 
 	return 0;
 error:
-- 
2.51.0



