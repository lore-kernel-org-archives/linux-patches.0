Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB7B257851;
	Mon, 23 Mar 2026 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282216; cv=none; b=j1KVEHVbYEvuLhVP0IaLY/4GX0Gj1pkPdbRUucts4sgIci09jvphOXLq1LBFg7kbRUZ+Ht+geKjk3Wb92v0Ao9+45sh6KLDvC00xMAm5iOq8zB+cQGIOuxlOjPbQqYjvwSB+jYtmo+7V1lzxfuSIPo4+0EA8owiTHZGmHr7Ftps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282216; c=relaxed/simple;
	bh=IKxjvbQqaJfirJUQ9m9djcF99aSHBGYJi2PTIO4PL6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3ONyPhHgBAJmU3NX0BeL2/EjYFHng5iGRqyDG1+KHSr/WFmg/rfb/BDePCyvmSePQNoBl+Ir6sZFvK80m24JFYCrZYPv1vtX3U8KdAF1imJmhwe2v+GNl1iAPDm9SQMj2D785H+LUv8zB9RYOY8TMTYFVBc9sY1EDcTt0wbQ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VadKHdgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VadKHdgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E63DC2BCB0;
	Mon, 23 Mar 2026 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282216;
	bh=IKxjvbQqaJfirJUQ9m9djcF99aSHBGYJi2PTIO4PL6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VadKHdgVe1S8A1n65F5HK6LacCQgQnV5KM1nHFiGuGUFR4XJmiA50Db8afSjjCw4i
	 pIexPrefzE9fHadyevvfCKUbIuz2HCm0jPnQZXbVKB3e2S3NFo7K3/YLJYR2N/312n
	 HxRPkagRlNjPexK/yEu9UFoA0IqcjLd1LwWnab0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/481] ext4: drop extent cache when splitting extent fails
Date: Mon, 23 Mar 2026 14:40:29 +0100
Message-ID: <20260323134526.377959844@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 79b592e8f1b435796cbc2722190368e3e8ffd7a1 ]

When the split extent fails, we might leave some extents still being
processed and return an error directly, which will result in stale
extent entries remaining in the extent status tree. So drop all of the
remaining potentially stale extents if the splitting fails.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Message-ID: <20251129103247.686136-8-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 30b0b25aac9ff..bb27c04798d2b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3252,7 +3252,7 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 
 	err = PTR_ERR(path);
 	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
-		return path;
+		goto out_path;
 
 	/*
 	 * Get a new path to try to zeroout or fix the extent length.
@@ -3266,7 +3266,7 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
-		return path;
+		goto out_path;
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3343,6 +3343,10 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 		ext4_free_ext_path(path);
 		path = ERR_PTR(err);
 	}
+out_path:
+	if (IS_ERR(path))
+		/* Remove all remaining potentially stale extents. */
+		ext4_es_remove_extent(inode, ee_block, ee_len);
 	ext4_ext_show_leaf(inode, path);
 	return path;
 }
-- 
2.51.0



