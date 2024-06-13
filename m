Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2811B143899;
	Thu, 13 Jun 2024 11:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279646; cv=none; b=Vq9YW6baQkSJqUg3PyrbFSsPAFs3wbJCrozFFz2DUNFBUeF4oSTd0oijS+5uh+qZZ0frOqCS5E4WRT2CcFDbfd1SKjovF09PQHdBovfSO+C/JJv1cQr+y5wAvLWuEzp4kSuLjXlsGh8pPc2bTFC4iobOWQE7wDrxK9nuDE89blE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279646; c=relaxed/simple;
	bh=UlJEJ7Tq2elXom/5H4mq02q5vQOxWXI4fPdrLRuq2ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hkk08MzwZmRsCt4rN0CU43ZYQ/c3YvisvQUYKiaIgGdJM2yaIRLXdF/DyLK//o+4/fUvKzwhVfe6iTmMuGSwB3asN7daT3uUzql5vZYJzthtnlBp7dDEatlexkZCZOEo4QlecthcquxxvSAx7oEvDBqM+bVW3DOAiJSPll4dW9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsYLs+m6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsYLs+m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF5BC2BBFC;
	Thu, 13 Jun 2024 11:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279646;
	bh=UlJEJ7Tq2elXom/5H4mq02q5vQOxWXI4fPdrLRuq2ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsYLs+m6UyCMeDikf8rAVKA0jTW5J9ZJzD7CA+jzKam3GJF18IIW93ddRWAFvpe4P
	 EgAQ1VwZ5EYK0Js1y/MmfeqU1GRUemy9XLJRY3HBFJbSg1CrBdcy/KoXZVuPlCRv2a
	 CK8bY+ltJla66Wzpa6vFO2isGccFW7wOuQ/Cq2PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.9 146/157] btrfs: qgroup: fix qgroup id collision across mounts
Date: Thu, 13 Jun 2024 13:34:31 +0200
Message-ID: <20240613113233.051661347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 2b8aa78cf1279ec5e418baa26bfed5df682568d8 upstream.

If we delete subvolumes whose ID is the largest in the filesystem, then
unmount and mount again, then btrfs_init_root_free_objectid on the
tree_root will select a subvolid smaller than that one and thus allow
reusing it.

If we are also using qgroups (and particularly squotas) it is possible
to delete the subvol without deleting the qgroup. In that case, we will
be able to create a new subvol whose id already has a level 0 qgroup.
This will result in re-using that qgroup which would then lead to
incorrect accounting.

Fixes: 6ed05643ddb1 ("btrfs: create qgroup earlier in snapshot creation")
CC: stable@vger.kernel.org # 6.7+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -468,6 +468,7 @@ int btrfs_read_qgroup_config(struct btrf
 		}
 		if (!qgroup) {
 			struct btrfs_qgroup *prealloc;
+			struct btrfs_root *tree_root = fs_info->tree_root;
 
 			prealloc = kzalloc(sizeof(*prealloc), GFP_KERNEL);
 			if (!prealloc) {
@@ -475,6 +476,25 @@ int btrfs_read_qgroup_config(struct btrf
 				goto out;
 			}
 			qgroup = add_qgroup_rb(fs_info, prealloc, found_key.offset);
+			/*
+			 * If a qgroup exists for a subvolume ID, it is possible
+			 * that subvolume has been deleted, in which case
+			 * re-using that ID would lead to incorrect accounting.
+			 *
+			 * Ensure that we skip any such subvol ids.
+			 *
+			 * We don't need to lock because this is only called
+			 * during mount before we start doing things like creating
+			 * subvolumes.
+			 */
+			if (is_fstree(qgroup->qgroupid) &&
+			    qgroup->qgroupid > tree_root->free_objectid)
+				/*
+				 * Don't need to check against BTRFS_LAST_FREE_OBJECTID,
+				 * as it will get checked on the next call to
+				 * btrfs_get_free_objectid.
+				 */
+				tree_root->free_objectid = qgroup->qgroupid + 1;
 		}
 		ret = btrfs_sysfs_add_one_qgroup(fs_info, qgroup);
 		if (ret < 0)


