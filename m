Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0123B54BD4;
	Tue, 27 Feb 2024 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041772; cv=none; b=Ag8Wy9Vp5FNAbuwJaxFrXmPcjyV5y4WTvmmXx807xl+SVTdoWzWEUsfnyh70f+5au6wka9xSkfk/3FnjgrRwws7OrlixS4PfJIixTPJn/7KxVz4M2IbV5PFBufNULPODqPriE3VX0mI7HEuNdG+3bJH/Ughgnku1cir7LoQlJq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041772; c=relaxed/simple;
	bh=wd+IrRLgHUtXvoilkidR3+MbUrA74ggK+qbU9jxqKcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBHUIPaMAgbjCSd9MbDkipsuudsaaOFzA8q+5yYNyLhd+QJazJPl0voHXBxUxQNN5nmPB+pYtpw9PVMbl5XrosGNTg9lFeJQcFd3IlEUy0f9+3uQ1Yk+jkCypNo/uyIal8/HHub0z+WoavIvoxhkqgAccy+3JE5jFqQq4ZgQW/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPQN9WJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPQN9WJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8623EC433C7;
	Tue, 27 Feb 2024 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041771;
	bh=wd+IrRLgHUtXvoilkidR3+MbUrA74ggK+qbU9jxqKcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPQN9WJd1OAfxYDHVN8vGrQQtZgxFP9Z6qoWQS9bUQiG/SndtuJGOIx59426H9fYh
	 a6z2/ckfWzHy9nY3DEjzw6IhehbZl42Z/oYM2fYQYA5S2WxiRD2JKh44s3IIPpA8/j
	 r5jP6+ETqOZgb/cvg4DvAIJL6yrURh1JRf2UVtKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/299] ext4: avoid allocating blocks from corrupted group in ext4_mb_find_by_goal()
Date: Tue, 27 Feb 2024 14:22:26 +0100
Message-ID: <20240227131626.949940488@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 832698373a25950942c04a512daa652c18a9b513 ]

Places the logic for checking if the group's block bitmap is corrupt under
the protection of the group lock to avoid allocating blocks from the group
with a corrupted block bitmap.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-8-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bc9630f4c09cb..ea5ac2636632b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2341,12 +2341,10 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	if (err)
 		return err;
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))) {
-		ext4_mb_unload_buddy(e4b);
-		return 0;
-	}
-
 	ext4_lock_group(ac->ac_sb, group);
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		goto out;
+
 	max = mb_find_extent(e4b, ac->ac_g_ex.fe_start,
 			     ac->ac_g_ex.fe_len, &ex);
 	ex.fe_logical = 0xDEADFA11; /* debug value */
@@ -2379,6 +2377,7 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 		ac->ac_b_ex = ex;
 		ext4_mb_use_best_found(ac, e4b);
 	}
+out:
 	ext4_unlock_group(ac->ac_sb, group);
 	ext4_mb_unload_buddy(e4b);
 
-- 
2.43.0



