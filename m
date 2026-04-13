Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2851A22A7F0;
	Mon, 13 Apr 2026 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097718; cv=none; b=fjHzB7wBQwd29N8IimT8681EawwQ2WXgnIZb3tFU1SAZyWlSnafKIqUiTxwDXl9us1w1i6a3JzaFa4++jFO9PFHTQ3wTgpqFKNuPj2IfudbdwIAzimRU//QveSkdjMVVHGOCAbPXA3ox7NHpOti6ZZq20JpFvbOuZ7xMWioOieg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097718; c=relaxed/simple;
	bh=RMSNirOS41rUIZXQ2YuGs0HMUujq6ikxG8O0zogmwyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqkhdS52V7DSfREy+FjqdjL+ha6XcvIsuJW6VCF8QacrXQYf/FpU+jSpnPdjNekG5ko64uZbfp/2+CAOp3t82bqcy+X/j1q+5WZgfvzu9hR8Wg70Y3RmaqxjG7T6af2RR8fIzI9PuSVMxZ6GDC4PyO69iEZv0kOT5SQl98wwIyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NG4caC/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NG4caC/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33E9C2BCAF;
	Mon, 13 Apr 2026 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097718;
	bh=RMSNirOS41rUIZXQ2YuGs0HMUujq6ikxG8O0zogmwyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NG4caC/hYrJ7wniYNx4vNgMM1hJLHb1tZxPyDv9iNjDUc/JLlQs8FwpixMJ+v4opO
	 3FDRPVdbqT3lL+EXvTmlyFszoOhAg4c2qAHE/XJKE4CqnN07uD8EXHE2U8sk1BBk3x
	 kdQ1VEvxDXXnbIfPKDVN/eJq4uyk2C+7Fx9h6bTA=
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
Subject: [PATCH 5.15 228/570] ext4: drop extent cache when splitting extent fails
Date: Mon, 13 Apr 2026 17:55:59 +0200
Message-ID: <20260413155838.997669315@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
@@ -3236,7 +3236,9 @@ static int ext4_split_extent_at(handle_t
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
+	if (err && err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
+		goto out_err;
+	if (!err)
 		goto out;
 
 	/*
@@ -3252,7 +3254,8 @@ static int ext4_split_extent_at(handle_t
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
-		return PTR_ERR(path);
+		err = PTR_ERR(path);
+		goto out_err;
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3308,6 +3311,9 @@ fix_extent_len:
 	 */
 	ext4_ext_dirty(handle, inode, path + path->p_depth);
 	return err;
+out_err:
+	/* Remove all remaining potentially stale extents. */
+	ext4_es_remove_extent(inode, ee_block, ee_len);
 out:
 	ext4_ext_show_leaf(inode, *ppath);
 	return err;


