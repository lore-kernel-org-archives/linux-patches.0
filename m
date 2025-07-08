Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF092E0411;
	Tue,  8 Jul 2025 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992710; cv=none; b=pG3Pwhgj9e4U8BJkEi2LTLse2Dz2XvU7PUzWdUFNRCtlfN/pMgXuyNqBYmdqptiu3H/XTmFBdD160Eg5zEYJ/ya8qoCP8J4IWGzOUuInGcgxThlwd5G6YGMoLsZ0NEbOFqXfEFveiwAr6d+pGsaeOZDMSmkQwlWDaLwtP07StwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992710; c=relaxed/simple;
	bh=dXTc3t/ujWx45+Y/IJd6IDkz7GLzG2TqDiyF3XxHbZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myXNBJjf34DhjoScY0nJFM2gGggMBEVOgGujdaXK43txnuFJbEG698kTQ128AzCVMWuOFleQNVUUUSE5drDnC0sHBeiuVMLUDVkOY+zB+mWl9LWNN/nr7k/DCYjttcY7d6kYwAH51Ml7wiWQpaM4siUjl6OQlW6qisGaI2ZlfOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hatGG3l0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hatGG3l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D79C4CEED;
	Tue,  8 Jul 2025 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992709;
	bh=dXTc3t/ujWx45+Y/IJd6IDkz7GLzG2TqDiyF3XxHbZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hatGG3l0qeFQq4iTpcv+6nU9KZRTudCpTt14HEFF3wMIozn+VxqtbiW7+EEfZ8tR4
	 eIF8jHtI+IOCEH1AaiRkfma0EXKa69xNx2UAUYvvdbVbGQJVrSQohZYHflgYVoX7mT
	 Eyt9yTKGSy2GtiODl4vC+4AyPdMbEsYS0jkfZxHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/232] btrfs: record new subvolume in parent dir earlier to avoid dir logging races
Date: Tue,  8 Jul 2025 18:20:49 +0200
Message-ID: <20250708162242.852288334@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3e3722a732393..1706f6d9b12e6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -758,14 +758,14 @@ static noinline int create_subvol(struct mnt_idmap *idmap,
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
index 97c5dc0ebd9d6..16b4474ded4bc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7463,6 +7463,8 @@ void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
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



