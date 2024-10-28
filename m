Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CBF8837;
	Mon, 28 Oct 2024 06:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098388; cv=none; b=rUF3VtufbAvCgFlHsl//XXdmBwbKxk7tGTk4iqjJRJCUcYRSJ8lJJAMdZaY7mWF45Ct0uEijRnLT7iRV4f2/4KVSSgHDWEHqyM/YwG883l6DMtwswO3aN+OV08OA0hCVMmEQvBjpch8o6ofxMHnybPQtlSbgJZ+0fIH3LRTTViU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098388; c=relaxed/simple;
	bh=GR/4BtaI4GkR5hVpXhWQdaCSZ83i1z/MUI4iBJCIvzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B50TSCIAu/6xEGDrRrhzOg/+H2I/YPBkV0bztwxP86KdSng3pCKUlSRYR8IjFMEB5bw5fOrFGpgUk4zDJAY+KZ6dsscDG/WXvYatqgrluqOVCP/Fqjo0p3qeX21YzzyqF3TvdytXbQMDDT1IzalQwnJpkkZvDrEQqS7yV+IInfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lp3CtdmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lp3CtdmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D13BC4CEC3;
	Mon, 28 Oct 2024 06:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098387;
	bh=GR/4BtaI4GkR5hVpXhWQdaCSZ83i1z/MUI4iBJCIvzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lp3CtdmFGaLGMs/uUbgh+XyI5E29K5+laPLL3aILRMQy+UJ63CbKqXBez3GVH5gv4
	 4cTjQovurprGvFom4ao4fJ5X2OVpoHlY0+2YxJfTtsMU6dW8x5WU7DoFLe5vAAFInH
	 Li2G20pqSDTUmHRGEkxOjLPOUmMOi1DJqrTVaoRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 203/261] btrfs: fix passing 0 to ERR_PTR in btrfs_search_dir_index_item()
Date: Mon, 28 Oct 2024 07:25:45 +0100
Message-ID: <20241028062317.148706679@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

commit 75f49c3dc7b7423d3734f2e4dabe3dac8d064338 upstream.

The ret may be zero in btrfs_search_dir_index_item() and should not
passed to ERR_PTR(). Now btrfs_unlink_subvol() is the only caller to
this, reconstructed it to check ERR_PTR(-ENOENT) while ret >= 0.

This fixes smatch warnings:

fs/btrfs/dir-item.c:353
  btrfs_search_dir_index_item() warn: passing zero to 'ERR_PTR'

Fixes: 9dcbe16fccbb ("btrfs: use btrfs_for_each_slot in btrfs_search_dir_index_item")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dir-item.c |    4 ++--
 fs/btrfs/inode.c    |    7 ++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -347,8 +347,8 @@ btrfs_search_dir_index_item(struct btrfs
 			return di;
 	}
 	/* Adjust return code if the key was not found in the next leaf. */
-	if (ret > 0)
-		ret = 0;
+	if (ret >= 0)
+		ret = -ENOENT;
 
 	return ERR_PTR(ret);
 }
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4339,11 +4339,8 @@ static int btrfs_unlink_subvol(struct bt
 	 */
 	if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
 		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname.disk_name);
-		if (IS_ERR_OR_NULL(di)) {
-			if (!di)
-				ret = -ENOENT;
-			else
-				ret = PTR_ERR(di);
+		if (IS_ERR(di)) {
+			ret = PTR_ERR(di);
 			btrfs_abort_transaction(trans, ret);
 			goto out;
 		}


