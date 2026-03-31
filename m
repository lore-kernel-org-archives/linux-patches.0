Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C892F31714F;
	Tue, 31 Mar 2026 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975449; cv=none; b=pXcpOLRSv1HC2N+62sar0SBmtFFP4KKIupboPpiC4b7PMRkwlmS5vzreUonA7vdzOHaPVng5iJ0Oz1MS5p2JDNSQ5ZHYlsfvn33IoOg5lbgjJbC8dy7QiNPxlnnNxMZORQLqlwrIrQXZ3/aL3SfoHLV7u2IRfej0g3C49FBJmpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975449; c=relaxed/simple;
	bh=za/AlUXdta+2zD/60x2gfM89AQTzCTJfpGOkwQnvXME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X60dVunFpuqNyJgaZNOl+z2wlbzbboFCsMEDmRzjaVJZL1MaXeffDSMeLxiF5bQn/YFp7WWoSx7fQwz0AS5Br7Jl1iPdC9TiiWP3uat85AMPT28Djnrs/fZiebBY2DDFSdQCVLkG5wZHKhWsK0K++zqgB3yr8YePsvsX3fK3fuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvVJMJZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvVJMJZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBCCC19423;
	Tue, 31 Mar 2026 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975449;
	bh=za/AlUXdta+2zD/60x2gfM89AQTzCTJfpGOkwQnvXME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvVJMJZE/nbIE7OtARem5imO2xgNof5kZ62mrqA2SyXiLIyFk7RnI5m+qA+znD8co
	 FCqt+C3yqySgsfe45fQTjQWD7rrNLDuDJpBi2BgXOiseL6zHvghhmBB7i/TjBKItJI
	 agXBkbpgP9boSa8Ol+jICscORr4P/cYj5HiNwZXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 298/342] ext4: test if inodes all dirty pages are submitted to disk
Date: Tue, 31 Mar 2026 18:22:11 +0200
Message-ID: <20260331161809.898162568@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

commit 73bf12adbea10b13647864cd1c62410d19e21086 upstream.

The commit aa373cf55099 ("writeback: stop background/kupdate works from
livelocking other works") introduced an issue where unmounting a filesystem
in a multi-logical-partition scenario could lead to batch file data loss.
This problem was not fixed until the commit d92109891f21 ("fs/writeback:
bail out if there is no more inodes for IO and queued once"). It took
considerable time to identify the root cause. Additionally, in actual
production environments, we frequently encountered file data loss after
normal system reboots. Therefore, we are adding a check in the inode
release flow to verify whether all dirty pages have been flushed to disk,
in order to determine whether the data loss is caused by a logic issue in
the filesystem code.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260303012242.3206465-1-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -184,6 +184,14 @@ void ext4_evict_inode(struct inode *inod
 	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
+		/*
+		 * If there's dirty page will lead to data loss, user
+		 * could see stale data.
+		 */
+		if (unlikely(!ext4_emergency_state(inode->i_sb) &&
+		    mapping_tagged(&inode->i_data, PAGECACHE_TAG_DIRTY)))
+			ext4_warning_inode(inode, "data will be lost");
+
 		truncate_inode_pages_final(&inode->i_data);
 
 		goto no_delete;


