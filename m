Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6930F552;
	Wed,  3 Dec 2025 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775915; cv=none; b=Zr6cQBmlhqyJrlLFkyjqbOFcGGEmzgiCyOxuCqW/+up4ZIbr0WfPrx57/Jc2hMikmzK8CuZNVnSpfmcKXO2mXGxNMzGYCsddYC6qbJkmOEcY0z/801CIUE7LdaRIRdKmvl8WWYwOvSGsLHPQqZFzhRZPfHlVKFs/vertO68D3tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775915; c=relaxed/simple;
	bh=0eznp9j2jri5r3xhNQCfDKuUccv1n7fxmUKwV2tTRcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CR1hpiJQwlo0JqoHQ6qkwiRGqIRPidEVYvbdoaxyuIoLgzN3kFnrMlE8ZN0oOws2vrXC55U4yPNn913YPsKnT1F+alBQ7Mc9N+vLcqMBdZJ9XilgVka2PxhCuroCPv5m0bQ+oXIJLTgvktctd0QgKRr2ZjX7vRENTAAdW84Ll+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=he0R8+i0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="he0R8+i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8821BC4CEF5;
	Wed,  3 Dec 2025 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775914;
	bh=0eznp9j2jri5r3xhNQCfDKuUccv1n7fxmUKwV2tTRcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=he0R8+i0huy2XaByc0f4vd37V00hfiZkXS669mar8eN+698xc4gmzRCuSwiWRxSdw
	 jIuZfgIlDTdEZeb6byZTNRdFV/Oc3U2sZ/HqZ2/opQjSRiFhrzD92fW695y6oEIuwl
	 0gMboMpkKUZdY6/mGc00Z9p4PWh0jma06nQDPmlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/300] btrfs: always drop log root tree reference in btrfs_replay_log()
Date: Wed,  3 Dec 2025 16:23:27 +0100
Message-ID: <20251203152400.584563083@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
index 91475cb7d568b..29f0ba4adfbce 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2309,10 +2309,10 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	}
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
index 6d715bb773643..cdb5a2770faf3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6432,7 +6432,6 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 	log_root_tree->log_root = NULL;
 	clear_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags);
-	btrfs_put_root(log_root_tree);
 
 	return 0;
 error:
-- 
2.51.0



