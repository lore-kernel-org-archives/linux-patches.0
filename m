Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDD53570C0;
	Wed,  3 Dec 2025 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778705; cv=none; b=mkttd/NYdQYJ+4l9nAL0fO9TScnZitBWTPF9rrVeHf1XrSoZ4fWEHsJUexEcJ1s7/rfj2oNIk4wDL1J9itj052eV/gFmreipNvnr9g1cF7Ek9M6NCOwGSlD8Xxe6hQwaDRn065OpGNjeMNAuPRfAnt+0HoRF6yZ/VLZ4W6VqdbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778705; c=relaxed/simple;
	bh=IUET13uV5wVkWYdb61vpFWKXjWXgW92l8rDj+Bm12XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTGVhDtCzFRIBJgu3CJZI+VlYCF3hGPbN4g9MW3AgB3j9VPhRuM7/M90f2Cf/R42z2YQDnSyiEz73XzPDVY+GtfM2RKaF/K4PscYwpQ6s28MzE1pMAdBHBjapK3MqDDdzKrO4neo/l2y6kZE7hrB9MJObEhLpUcSfJLqv3OGXCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfwIA57s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfwIA57s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7229DC116C6;
	Wed,  3 Dec 2025 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778704;
	bh=IUET13uV5wVkWYdb61vpFWKXjWXgW92l8rDj+Bm12XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfwIA57sGQ+MZmly9gs8oQu55kHbcPzcj9dyiUyJL2N83XL5gB6KTcmDgLA163lJM
	 vRtgelEgTUUe7A/I+qHy6qwZUE1e6OxTMjLkBQAw4XeziB+odk5efkTEIaUPRNTyBO
	 BKPuFxYjKdltjiOj1ZlF3i5qWjpzSGhbWrIHS+UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/568] btrfs: always drop log root tree reference in btrfs_replay_log()
Date: Wed,  3 Dec 2025 16:20:09 +0100
Message-ID: <20251203152440.926366200@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 76a261cbf39d6..8576ba4aa0b7d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2413,10 +2413,10 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 
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
index e4cc287eee993..fdcf66ba318ad 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7366,7 +7366,6 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 	log_root_tree->log_root = NULL;
 	clear_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags);
-	btrfs_put_root(log_root_tree);
 
 	return 0;
 error:
-- 
2.51.0



