Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BA8359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302465; cv=none; b=PSjUeDIH/aQR5HAV6l0ezw1suMnNdnXggiuzYqmfQKvCSiirzAJ88IiMSo0J8Fte23d+6MgABh92ykfPRxrzHsiT8uPVFjTRK9KmIsg+mDR8gW2bNsVW3tdhXxHvG0yOtIEQYIb0Acaszn8pPFcHYri0exc1Zrtd3iHlqsRLeQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302465; c=relaxed/simple;
	bh=RE4VgUnMgZjtPP/cSJkYFCzjYqHkGbbwVSrri+WsfY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/SeYtC16X7vnMUo0Kr0ODfYo+tOd3vdztpcPT0G5XN3CBIEBxi3hb3Mqbbn2/EJ9+Lwh2BHB9VZ3jjZhRaT1ChLcOPEugCoJbjVpBZhc+gG0Xt5pJ7TNFBACLzpS4plms6z98L0tcHGhNosAEg5um18u8+PfXQXTd//R2Xr2jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FO0ROkyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FO0ROkyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E22C19425;
	Sat, 28 Feb 2026 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302464;
	bh=RE4VgUnMgZjtPP/cSJkYFCzjYqHkGbbwVSrri+WsfY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FO0ROkyF8MJ7mxcdVeFrJliURjlAO2FHhuRxVeo2xp1Q4LtXlT4Cn/zMavH8X7mTE
	 VnzKMGMgi62aQaYvKvrk0JZEg0CncqlwxDP/1qEtiBYJUCSDWa9+pSkZVf7SDuXy6x
	 rtfpDrgjjXz2A/ywp5EO0OgQ9faKTVmUl5G9FiNH7o04mUeO9hKgn+uqWr5SbtwSm+
	 pCBFEmnQC+Sg9fnektK6U/vMtLKM7Y8F+bl2NAPbyACH33mpKQFUNjvbrlHjRI9iuv
	 In8DEwJI6s6nRMf9f1OllaO0cNnCDZZvQOXif2UglkiPwOtPgZvBUM0nEXg9qbMRQR
	 9kLUrHl/HCveg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Edward Adam Davis <eadavis@qq.com>,
	syzbot+bcf9e1868c1a0c7e04f1@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/232] fs/ntfs3: prevent infinite loops caused by the next valid being the same
Date: Sat, 28 Feb 2026 13:11:01 -0500
Message-ID: <20260228181127.1592657-208-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 27b75ca4e51e3e4554dc85dbf1a0246c66106fd3 ]

When processing valid within the range [valid : pos), if valid cannot
be retrieved correctly, for example, if the retrieved valid value is
always the same, this can trigger a potential infinite loop, similar
to the hung problem reported by syzbot [1].

Adding a check for the valid value within the loop body, and terminating
the loop and returning -EINVAL if the value is the same as the current
value, can prevent this.

[1]
INFO: task syz.4.21:6056 blocked for more than 143 seconds.
Call Trace:
 rwbase_write_lock+0x14f/0x750 kernel/locking/rwbase_rt.c:244
 inode_lock include/linux/fs.h:1027 [inline]
 ntfs_file_write_iter+0xe6/0x870 fs/ntfs3/file.c:1284

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: syzbot+bcf9e1868c1a0c7e04f1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bcf9e1868c1a0c7e04f1
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 6d9c1dfe9b1b6..f2d1df2c988a9 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -870,8 +870,12 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 			goto out;
 
 		if (lcn == SPARSE_LCN) {
-			ni->i_valid = valid =
-				frame_vbo + ((u64)clen << sbi->cluster_bits);
+			valid = frame_vbo + ((u64)clen << sbi->cluster_bits);
+			if (ni->i_valid == valid) {
+				err = -EINVAL;
+				goto out;
+			}
+			ni->i_valid = valid;
 			continue;
 		}
 
-- 
2.51.0

