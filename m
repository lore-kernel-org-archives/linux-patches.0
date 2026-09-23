Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B441053FD5E;
	Wed, 23 Sep 2026 14:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174829; cv=none; b=G8d65UJwyVMMRfRlLZzUXctjDInXDxa8Kq5hujG+bLO7tUTI3FndniSA0doRS/aiOEqZNPhdAAKtQFJXrinMJQ/W7wM8BOYcMQTAc7xvmc57g1PK1O18fAwdaytbU3lEhm25Sj2RErsPtjsqnic8xJQ/KMYcyLUAGeJgh5gqjwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174829; c=relaxed/simple;
	bh=JiahXcPY5LKWxYq+EWTDCkKVK2FeMKhV7buCWfVAKKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQsjXORrgyDvE5WyHUoFtM30koMgFp2Yw3073yor0LttP+tKNIO+5jYbu6gQ1iX5SN805qHfzRNDQU7KnHMZtR3aoImy4M/L06exl+7EFREKpcdH92w2OJx5V/tNxBQ++bX7uDiJj2sWF03XBVoG1M+2EcHQto4GqqUyqwYD5GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsVG7Z1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsVG7Z1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068161F000FF;
	Wed, 23 Sep 2026 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174828;
	bh=mZDyRGoOD/XEXXvgL6diuDpEw6wj1RmgU7VdLbs571g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsVG7Z1Lhm8+78SO5PXAqWB4vUQrJMWKHtmJH92lyYX1N5Og67Qz43qtHnOUngsRv
	 kR5IiiHnEQeNOnwE0J/5pUwotTRsGzcRUee7K8f5cw8sWL62NDowFsFuNyaPpNWDoh
	 K7CMAbSlFpeAO4U1Sp4U4vDD10EL7oF7isGgvmSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.18 238/398] btrfs: clear free space tree creation state on rebuild failure
Date: Wed, 23 Sep 2026 16:05:12 +0200
Message-ID: <20260923140649.586046614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

commit 3565893cc72cdf6b795cf6a33e7ff9605322334d upstream.

btrfs_rebuild_free_space_tree() sets BTRFS_FS_CREATING_FREE_SPACE_TREE
before rebuilding the free space tree.  Several error paths return
without clearing this flag.

The transaction restart failure path can leave the flag set on a live
filesystem, causing delayed reference processing to be skipped. Clear it
on all free space tree rebuild failure paths. Keep
BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED set, since a failed rebuild leaves
the free space tree untrusted. Callers must fall back to extent-tree
caching.

Fixes: 882af9f13e83 ("btrfs: handle free space tree rebuild in multiple transactions")
CC: stable@vger.kernel.org # 6.14+
Assisted-by: LLM
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-tree.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1346,7 +1346,7 @@ int btrfs_rebuild_free_space_tree(struct
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
-		return ret;
+		goto out_clear;
 	}
 
 	node = rb_first_cached(&fs_info->block_group_cache_tree);
@@ -1364,14 +1364,16 @@ int btrfs_rebuild_free_space_tree(struct
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			btrfs_end_transaction(trans);
-			return ret;
+			goto out_clear;
 		}
 next:
 		if (btrfs_should_end_transaction(trans)) {
 			btrfs_end_transaction(trans);
 			trans = btrfs_start_transaction(free_space_root, 1);
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto out_clear;
+			}
 		}
 		node = rb_next(node);
 	}
@@ -1383,6 +1385,10 @@ next:
 	ret = btrfs_commit_transaction(trans);
 	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	return ret;
+
+out_clear:
+	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	return ret;
 }
 
 static int __add_block_group_free_space(struct btrfs_trans_handle *trans,


