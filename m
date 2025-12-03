Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEA3338597;
	Wed,  3 Dec 2025 15:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777396; cv=none; b=PSD9ebD0b3L9bByGoo6k0m7pnzj2CIzjcG9qxs9c87CkknxMCufbQ+d2Vnyolhw+AOBGo/TZcLFvPpNVrdNht6D5u/bi76JV9Nu9jIlmeipDU6Fvd+03bOS/qcs+on4APH1go81171X1BaNIvFlbTV/FF2k1/wBJmQa+21XSu1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777396; c=relaxed/simple;
	bh=lHPKFxlYS8iA/nElpmY00iFRyCM72zXY6GukvNpXIyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9cw2fBLiTfrIP9DTTDozV8vU9C14K/ladfDaxWUTtC8ERcbe9m3QBx2PtA7mYnC0n08DCx/1Ryb5JyF6dvVNPHWCaK/rc6I/+cZkAXZ3l7UAKNlwWshg+yuijHnzebT1CPgPqMHxoweVuBR4qlPlG2Xuyrdd+sof7XP4cUjRGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9U/TL+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9U/TL+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE734C4CEF5;
	Wed,  3 Dec 2025 15:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777396;
	bh=lHPKFxlYS8iA/nElpmY00iFRyCM72zXY6GukvNpXIyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9U/TL+sJDw3mu1If4EkrNU6AQUIObj+Mry+BI2Jp1qIZRqv3mXfohQ6yUJJ4QU0Y
	 IClFjd2Jnh1W3ehXTkCFEbvRJv6qaiBGsw1V5YsyaLYgJWtkwNwPfcxOv7NLAD/fLT
	 9oNHmnoU895x8aYjpmkHaKQRfBluo3hYuUyt849I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/392] btrfs: always drop log root tree reference in btrfs_replay_log()
Date: Wed,  3 Dec 2025 16:22:34 +0100
Message-ID: <20251203152414.253071647@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9c2d6f96f46da..136902f27e441 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2387,10 +2387,10 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
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
index 34fedac4e1864..445c7a5641b62 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6513,7 +6513,6 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 	log_root_tree->log_root = NULL;
 	clear_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags);
-	btrfs_put_root(log_root_tree);
 
 	return 0;
 error:
-- 
2.51.0



