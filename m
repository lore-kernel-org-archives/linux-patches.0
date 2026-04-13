Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F335E313298;
	Mon, 13 Apr 2026 16:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098965; cv=none; b=aBM9CkuYkgPCHAVe1J3X4i1QWCkGOvT3446sAx+L6l1/qyoWYeJsnyNHmz/QbeSYGU+XsIUOrS+Mj6dhcCRRx0l91qMC7VBzw+sX3LC1dlHRD9+uzwo3vAaamFXSV0jKzWZfW1buKy3eN1mx1jFRZWEbTXpDvRZNd9H09xyamuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098965; c=relaxed/simple;
	bh=3QY3Q5dgvoAKS39q5ubfV1uaz/vJY0huJzNVwuSgzmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyQGWFNzw2Xq+Wfy/c0fpgjhdLZOBupMydkQ+1wY2fHzbaeBR/c760YwKBM6nMpwVtnbcSt7ZFabQllmi4Jz1Ja5xBim5N2anh9A1ROQn/Q9AP8/gKSYFy++80484xpUr01HnXweSu9CQr+elb64TpwL4UO+UEYaZop1Qe5TaCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwCUZgyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwCUZgyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC9CC2BCAF;
	Mon, 13 Apr 2026 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098964;
	bh=3QY3Q5dgvoAKS39q5ubfV1uaz/vJY0huJzNVwuSgzmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwCUZgyMfqWe0uVq51t+ZTsDg7nQI9NKcP+BvDty6tmUQHk0T6eZn5Ui/tL54h6x+
	 KR6ANJMtLH4FqKYRUh906fLLz6+f5yAeqhUzxcqyzogxvrK4oxOMYjqcSSb/SkX7l8
	 uIzS1GskJIngliuyRx90xW4EJKuEYrpmUH9FGyVY=
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
Subject: [PATCH 5.10 158/491] ext4: drop extent cache when splitting extent fails
Date: Mon, 13 Apr 2026 17:56:43 +0200
Message-ID: <20260413155824.948481298@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
[ bring error handling pattern closer to upstream ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3231,7 +3231,9 @@ static int ext4_split_extent_at(handle_t
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
+	if (err && err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
+		goto out_err;
+	if (!err)
 		goto out;
 
 	/*
@@ -3247,7 +3249,8 @@ static int ext4_split_extent_at(handle_t
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
-		return PTR_ERR(path);
+		err = PTR_ERR(path);
+		goto out_err;
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3303,6 +3306,9 @@ fix_extent_len:
 	 */
 	ext4_ext_dirty(handle, inode, path + path->p_depth);
 	return err;
+out_err:
+	/* Remove all remaining potentially stale extents. */
+	ext4_es_remove_extent(inode, ee_block, ee_len);
 out:
 	ext4_ext_show_leaf(inode, *ppath);
 	return err;


