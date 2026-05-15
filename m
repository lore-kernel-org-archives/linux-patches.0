Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43C43E00AD;
	Fri, 15 May 2026 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861106; cv=none; b=kPcW1d1ORcaZ/dfTjoM5cyn+Y482LI0mcv1bn1XOIom0ScWX5x0vCQry7XTVh7MOEk5rD2PIg6WRNK4Mjdhlc73//pkGMQMpwZB3aXHtUIZlRHY3l2d/v4cgyHeCSVlcg+GYjtvvLRgGeCLnDuAIpd7NJzeyyB+FaaLg7SnMndo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861106; c=relaxed/simple;
	bh=+91482usW+z7QkpnCTP8HvX052f+sTFaati/l29sy94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPMWbKBxazt8uasx47Ft4niVVwiVf0Zxyke20N4DDG7vQ9MgXl3HIrGw2P9kRpKGJ4K7hjA+GmX1vlIOv3j6dLEqHim3sbZQ+84WeO6tvSNpk8umpGxa1XTuO+HGU4F4O/K3omCKYYI3B5MnupP1sFBnGTo1BtZu1+ziaI30rok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYS+h6KY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYS+h6KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C36FC2BCB0;
	Fri, 15 May 2026 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861106;
	bh=+91482usW+z7QkpnCTP8HvX052f+sTFaati/l29sy94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYS+h6KY5CgZyexL2JJ95WzwJHx3xbecKcJONjIz0FoA8Oohjtxw9cULI7vbx6TpL
	 kpj57d76mt5HExT99Icu97gENkCMGbfGIskQzUlctBKNPuhL04mPBYLnS+OeZalN5Z
	 h8w0XseHUpZcTM8ZwyyEIZy5xTgyBr45phvyskbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com,
	Tejas Bharambe <tejas.bharambe@outlook.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Jianqiang kang <jianqkang@sina.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/474] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Fri, 15 May 2026 17:44:29 +0200
Message-ID: <20260515154718.487213349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Bharambe <tejas.bharambe@outlook.com>

[ Upstream commit 2acb5c12ebd860f30e4faf67e6cc8c44ddfe5fe8 ]

ext4_ext_correct_indexes() walks up the extent tree correcting
index entries when the first extent in a leaf is modified. Before
accessing path[k].p_idx->ei_block, there is no validation that
p_idx falls within the valid range of index entries for that
level.

If the on-disk extent header contains a corrupted or crafted
eh_entries value, p_idx can point past the end of the allocated
buffer, causing a slab-out-of-bounds read.

Fix this by validating path[k].p_idx against EXT_LAST_INDEX() at
both access sites: before the while loop and inside it. Return
-EFSCORRUPTED if the index pointer is out of range, consistent
with how other bounds violations are handled in the ext4 extent
tree code.

Reported-by: syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=04c4e65cab786a2e5b7e
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
Link: https://patch.msgid.link/JH0PR06MB66326016F9B6AD24097D232B897CA@JH0PR06MB6632.apcprd06.prod.outlook.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7626cf2b07f1c..a94798e23c1af 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1743,6 +1743,13 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 	err = ext4_ext_get_access(handle, inode, path + k);
 	if (err)
 		return err;
+	if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
+		EXT4_ERROR_INODE(inode,
+				 "path[%d].p_idx %p > EXT_LAST_INDEX %p",
+				 k, path[k].p_idx,
+				 EXT_LAST_INDEX(path[k].p_hdr));
+		return -EFSCORRUPTED;
+	}
 	path[k].p_idx->ei_block = border;
 	err = ext4_ext_dirty(handle, inode, path + k);
 	if (err)
@@ -1755,6 +1762,14 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 		err = ext4_ext_get_access(handle, inode, path + k);
 		if (err)
 			break;
+		if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
+			EXT4_ERROR_INODE(inode,
+					 "path[%d].p_idx %p > EXT_LAST_INDEX %p",
+					 k, path[k].p_idx,
+					 EXT_LAST_INDEX(path[k].p_hdr));
+			err = -EFSCORRUPTED;
+			break;
+		}
 		path[k].p_idx->ei_block = border;
 		err = ext4_ext_dirty(handle, inode, path + k);
 		if (err)
-- 
2.53.0



