Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B103D8907;
	Wed,  8 Apr 2026 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672216; cv=none; b=YuBHu5bERFhOUscyvn2SQxw3FbKTGLWa0eDD2So7xaeu2SdxJbtlPW8zHG3ijl7RWjht1arFRclcFVGUWggLdU/2O//DCySpfC6DkxvvYVN4QJcK9kKzNZLtWO1tgBlCWTfy/QxZpdsCBOUg7jTCcasa+fqf+UKEzuoXDWzR5Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672216; c=relaxed/simple;
	bh=7PXe5XEyGf96as/aRkmdNnga09Iu0PrhrudTPeoi/s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO7QyXcAb/hCHWJgjbzdcc8lpYk338xXnlLt6wS1c0qFTAuxhi5Cd3hM6d50UDFiSxtdB9TSBrvmQsT79eMy/mPpVjYxnZBRT6Itqtxe4gXhSbAjmTBEO5LfLFVEpBsfzuv+0S5dpyIlNBKiNL79jFbsU+Ek8uglP7mSHSduYaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPnkY7Tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPnkY7Tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09012C19421;
	Wed,  8 Apr 2026 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672216;
	bh=7PXe5XEyGf96as/aRkmdNnga09Iu0PrhrudTPeoi/s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPnkY7Tv7ZgoKJrsPWuEh2/ZhEFXfQ75QGvABpMyJcEYZ/Pjtp53AOk/xUDYoxlRW
	 TUradz2vkqkXUE1WwNEdceuXlNJHUQHzwhlABRDzfXfZWFWfsRnHwqROoUtODYC8Cs
	 JLic2klqDvCDqRJ3KhcVXNZr6S3mYoUwBMsf72aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/312] Revert "ext4: drop extent cache when splitting extent fails"
Date: Wed,  8 Apr 2026 20:02:32 +0200
Message-ID: <20260408175942.529389949@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

This reverts commit de8e1b17e3876a44c4537bff0bc2dfd244efe8d9.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bb27c04798d2b..30b0b25aac9ff 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3252,7 +3252,7 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 
 	err = PTR_ERR(path);
 	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
-		goto out_path;
+		return path;
 
 	/*
 	 * Get a new path to try to zeroout or fix the extent length.
@@ -3266,7 +3266,7 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
-		goto out_path;
+		return path;
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3343,10 +3343,6 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 		ext4_free_ext_path(path);
 		path = ERR_PTR(err);
 	}
-out_path:
-	if (IS_ERR(path))
-		/* Remove all remaining potentially stale extents. */
-		ext4_es_remove_extent(inode, ee_block, ee_len);
 	ext4_ext_show_leaf(inode, path);
 	return path;
 }
-- 
2.53.0



