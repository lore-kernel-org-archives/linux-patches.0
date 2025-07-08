Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E422E4985;
	Tue,  8 Jul 2025 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993426; cv=none; b=cOvo0WwPcxkcYZOJguGrHMeSYKvCT4zI7zyd/di1jVOMXNHw3SVf3olGsGB17GK9zlhE3HkuHea/4qj5AVJuGw7PPlHZu2G1ZuvWvAHa+AgzJFwDS7p5yqLkpkTCDxIfa2Ay+5trZNfNGvPXRhTLj+W2nZP8VRUc35FTo7TXFIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993426; c=relaxed/simple;
	bh=NoZnjwWmmnlZaO9XRjYe6qqKiGlIrbOWK3JH4TLZZoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBFnvuZj+D3jnANdmMFUpid5PjjhBcjjyrRCucUiQWL+kTOzpYj4E8YrFAB15XBSSTHjn2LRIt1xgVHmgGWNqTUQFVOSIyRTanrkWtwZUco9ANVmOB8mPnCt3AzjW6r8AAakKySuRGVTQ7YCSpwExrsckLAHg69RbhGMfmgIv4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFCp+BB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFCp+BB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A131C4CEED;
	Tue,  8 Jul 2025 16:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993425;
	bh=NoZnjwWmmnlZaO9XRjYe6qqKiGlIrbOWK3JH4TLZZoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFCp+BB2zexsvzg8ojcl/FZSz0dsXDanqfqahYGMPaWdBVR7ToYzrpy0B/oALUtcB
	 XyD9b0tQaFTzy4g83zCTlXRvDxhyW77ObovUleuMscknbIny3S9sSgGI29VVNeDDnk
	 iFmgopmoGe7yeCn84aNlPL9NEJ/yvTr2ENnjJ0cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 068/178] btrfs: record new subvolume in parent dir earlier to avoid dir logging races
Date: Tue,  8 Jul 2025 18:21:45 +0200
Message-ID: <20250708162238.451708511@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit bf5bcf9a6fa070ec8a725b08db63fb1318f77366 ]

Instead of recording that a new subvolume was created in a directory after
we add the entry do the directory, record it before adding the entry. This
is to avoid races where after creating the entry and before recording the
new subvolume in the directory (the call to btrfs_record_new_subvolume()),
another task logs the directory, so we end up with a log tree where we
logged a directory that has an entry pointing to a root that was not yet
committed, resulting in an invalid entry if the log is persisted and
replayed later due to a power failure or crash.

Also state this requirement in the function comment for
btrfs_record_new_subvolume(), similar to what we do for the
btrfs_record_unlink_dir() and btrfs_record_snapshot_destroy().

Fixes: 45c4102f0d82 ("btrfs: avoid transaction commit on any fsync after subvolume creation")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c    | 4 ++--
 fs/btrfs/tree-log.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63aeacc549457..b70ef4455610a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -666,14 +666,14 @@ static noinline int create_subvol(struct mnt_idmap *idmap,
 		goto out;
 	}
 
+	btrfs_record_new_subvolume(trans, BTRFS_I(dir));
+
 	ret = btrfs_create_new_inode(trans, &new_inode_args);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 
-	btrfs_record_new_subvolume(trans, BTRFS_I(dir));
-
 	d_instantiate_new(dentry, new_inode_args.inode);
 	new_inode_args.inode = NULL;
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f8611ec11da9d..e05140ce95be9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7444,6 +7444,8 @@ void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
  * full log sync.
  * Also we don't need to worry with renames, since btrfs_rename() marks the log
  * for full commit when renaming a subvolume.
+ *
+ * Must be called before creating the subvolume entry in its parent directory.
  */
 void btrfs_record_new_subvolume(const struct btrfs_trans_handle *trans,
 				struct btrfs_inode *dir)
-- 
2.39.5



