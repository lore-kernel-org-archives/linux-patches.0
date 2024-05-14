Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711AD320F;
	Tue, 14 May 2024 10:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682659; cv=none; b=hV0n/4XrHE/z9wz4Yp4bJ9Z8cZsh40KS29/j8quKhQO+g91LrfbtZI3LmEMYhg4CfY//u8QsJbRTBZxkzIOTJeXxFjX9r7QPeVoq+6Hga1ALJQ0/ZacqOen2n0IG+e1WLq1Ka1x2jK+5mIafTlPYzDIR8g5lMoco2Y1to2+HQYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682659; c=relaxed/simple;
	bh=Er9FHRW3yZrQ956jGWxEjQixDDtaX4dnSqm56waWEec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIOl90wOmXq5U1a2ZaiHh9IphP1YZHi4B1nH6mSfX9FyU4SB5LsEtPNKuZ/L3Nm5iAywsVlVBpm2TUz/Rv+NQlXiu8QxTlQvQd057WeAqL0i5344uhjx38F9A2tqWjVfq2Zv8vNC6KdIoQs0Q2ews0B8ZLQT+gA8YZwEq5PWI8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHcrDsl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHcrDsl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F4AC32782;
	Tue, 14 May 2024 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682659;
	bh=Er9FHRW3yZrQ956jGWxEjQixDDtaX4dnSqm56waWEec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHcrDsl7o6DQeQOlvmfr2xlkLwMmHejU/VW6OQo42Y1K30++MOmjwpHoSr8UHsX31
	 VLrNXZUHKlp1KWP4zvUIr4KslXpuPcOFFO1q7EuZ1X1WNEx9PBQkxBE279DBbDrA++
	 O5mWv5JNuZ0o5HATXcbyFvBi1GxGBZhDcmJTZmII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 094/336] exfat: fix timing of synchronizing bitmap and inode
Date: Tue, 14 May 2024 12:14:58 +0200
Message-ID: <20240514101042.154695071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit d7ed5232f0f16181506373d73e711190d5e0c868 ]

Commit(f55c096f62f1 exfat: do not zero the extended part) changed
the timing of synchronizing bitmap and inode in exfat_cont_expand().
The change caused xfstests generic/013 to fail if 'dirsync' or 'sync'
is enabled. So this commit restores the timing.

Fixes: f55c096f62f1 ("exfat: do not zero the extended part")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index cc00f1a7a1e18..9adfc38ca7dac 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -51,7 +51,7 @@ static int exfat_cont_expand(struct inode *inode, loff_t size)
 	clu.flags = ei->flags;
 
 	ret = exfat_alloc_cluster(inode, new_num_clusters - num_clusters,
-			&clu, IS_DIRSYNC(inode));
+			&clu, inode_needs_sync(inode));
 	if (ret)
 		return ret;
 
@@ -77,12 +77,11 @@ static int exfat_cont_expand(struct inode *inode, loff_t size)
 	ei->i_size_aligned = round_up(size, sb->s_blocksize);
 	ei->i_size_ondisk = ei->i_size_aligned;
 	inode->i_blocks = round_up(size, sbi->cluster_size) >> 9;
+	mark_inode_dirty(inode);
 
-	if (IS_DIRSYNC(inode))
+	if (IS_SYNC(inode))
 		return write_inode_now(inode, 1);
 
-	mark_inode_dirty(inode);
-
 	return 0;
 
 free_clu:
-- 
2.43.0



