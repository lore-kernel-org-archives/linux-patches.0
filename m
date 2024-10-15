Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A221C07CC;
	Tue, 15 Oct 2024 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997320; cv=none; b=Ogm08xCX9zFPrys6OAplRMvmOge7eyuZDq3wsL7OTsIN/W0fVyUuz6hcqV7Pnh3DIjbIVjUBsbHPwgHmaZ2wvfaFZeSozr+92gEBKlXkBA7csjhQtuqStQYr7KS02RlZGiGBwVm6khvNCos+1jo55VsTz5aY6dIkvm+a72aMdpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997320; c=relaxed/simple;
	bh=+dFzllXCk2s+uzuamfSnUewKvJscXQ1XjG8j+Zdm1OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOAD9sz2sXCTaYC6z26XcLi/xzN2dy+zMmAWSBjW7WodTgONoM0Fulv1hK873qHkC8zt3497TFT5dPdo4Mmmzy/GvQTtxTo7MEblaWLjWravzifSZseSehuJeSqMBbrr2cbiHxDPkae8u1fLubeZjlBRAwOXEuzLL0GSXajpg9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Meeyju/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Meeyju/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BDDC4CECF;
	Tue, 15 Oct 2024 13:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997320;
	bh=+dFzllXCk2s+uzuamfSnUewKvJscXQ1XjG8j+Zdm1OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Meeyju/K7AFY43+LNRVH0GyfkzCZV3cLZLt1fu5PM11jbbFp1o0UPCPPdwKsEAYPd
	 u8N1m/eDwGwD93+WhehyH4aTThMa/U3+ZPntHw6oDPWUEsgCfN/jgr/Cpwfh2k7N6r
	 JnuHnq6+tNYiFDt2IBAT7oK7FToo2NSc7R+yj7Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/518] ext4: avoid potential buffer_head leak in __ext4_new_inode()
Date: Tue, 15 Oct 2024 14:40:54 +0200
Message-ID: <20241015123922.797634768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 227d31b9214d1b9513383cf6c7180628d4b3b61f ]

If a group is marked EXT4_GROUP_INFO_IBITMAP_CORRUPT after it's inode
bitmap buffer_head was successfully verified, then __ext4_new_inode()
will get a valid inode_bitmap_bh of a corrupted group from
ext4_read_inode_bitmap() in which case inode_bitmap_bh misses a release.
Hnadle "IS_ERR(inode_bitmap_bh)" and group corruption separately like
how ext4_free_inode() does to avoid buffer_head leak.

Fixes: 9008a58e5dce ("ext4: make the bitmap read routines return real error codes")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://patch.msgid.link/20240820132234.2759926-3-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ialloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 34def2892b838..26ebbb0388cc9 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1053,12 +1053,13 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		brelse(inode_bitmap_bh);
 		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
 		/* Skip groups with suspicious inode tables */
-		if (((!(sbi->s_mount_state & EXT4_FC_REPLAY))
-		     && EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) ||
-		    IS_ERR(inode_bitmap_bh)) {
+		if (IS_ERR(inode_bitmap_bh)) {
 			inode_bitmap_bh = NULL;
 			goto next_group;
 		}
+		if (!(sbi->s_mount_state & EXT4_FC_REPLAY) &&
+		    EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+			goto next_group;
 
 repeat_in_this_group:
 		ret2 = find_inode_bit(sb, group, inode_bitmap_bh, &ino);
-- 
2.43.0



