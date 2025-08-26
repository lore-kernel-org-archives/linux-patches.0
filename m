Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13F11A5BBC;
	Tue, 26 Aug 2025 12:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213135; cv=none; b=UNqWCLTmHoYabzweS671gGPa9dv85i0osdNDzjCIOFZZb9WPb6p677RvlxEaEyVBPL3hXxLG9w3YZdsZCIvvVAz7KC5sypYuxzbKLO6/gAP60UtyAY5vgtrd9Fbd9wrh6ZvwG9sOQP8LtMvugEHKFU1qhfou77cAICZDoLcbfzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213135; c=relaxed/simple;
	bh=c2zv+YD1gV8Y2i2b5hfqWBadwhwqmVcCpo11t3W9OyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLfjX+inQ9b4sBg6f4046rmvuHo9DLmTt6n8FI8ekf21byM5C75Hh8X89f+EH5h2jjavOEXGMK7fMdvECYKjNBlahy5xwzo0JHuxmhQV/I7odw2TtegjRL6V2B/g5aw9agOV6Ba7vdQVyldx4WbbH17DL+jkdRTTKllOPvS3kCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GS2rKMg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GS2rKMg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35D0C4CEF1;
	Tue, 26 Aug 2025 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213135;
	bh=c2zv+YD1gV8Y2i2b5hfqWBadwhwqmVcCpo11t3W9OyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GS2rKMg8HJbOyRaeQLFeKEZ/mPw7UMcA8gpPvDgi9pEq1t0AceA2uuc2KsG5j2gY0
	 tPWwQDlxYtbo1ZNgDo7Yc2kxYtnQqbj1hd6N0q9uupaMiH/Nei2rBsO+XYLIXunoO5
	 DodnZbS45kYSOCVSY2OMrBvS1oDRIdbamMlJOg58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/587] jfs: truncate good inode pages when hard link is 0
Date: Tue, 26 Aug 2025 13:06:24 +0200
Message-ID: <20250826110958.912213301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 2d91b3765cd05016335cd5df5e5c6a29708ec058 ]

The fileset value of the inode copy from the disk by the reproducer is
AGGR_RESERVED_I. When executing evict, its hard link number is 0, so its
inode pages are not truncated. This causes the bugon to be triggered when
executing clear_inode() because nrpages is greater than 0.

Reported-by: syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6e516bb515d93230bc7b
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 920d58a1566b..66c38ef5e571 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -145,9 +145,9 @@ void jfs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink && !is_bad_inode(inode)) {
 		dquot_initialize(inode);
 
+		truncate_inode_pages_final(&inode->i_data);
 		if (JFS_IP(inode)->fileset == FILESYSTEM_I) {
 			struct inode *ipimap = JFS_SBI(inode->i_sb)->ipimap;
-			truncate_inode_pages_final(&inode->i_data);
 
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
-- 
2.39.5



