Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4CB2F5479;
	Tue, 11 Nov 2025 01:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823807; cv=none; b=B0Arv0puN133Rzksg8Nx/Sbq7pgBOIXou131F3+GAEloe4ml9JPpukwSPr/Y3sIZeIOLm0XOYnYf2nlTLArFl57u0zHoVPyrG+zvSPrKJvh0m6roRPjfLnXQQGsAf6W2NX8Hh+ctsVphuhan4zR8ayGvSjdWqddRuy0LIw8hxY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823807; c=relaxed/simple;
	bh=oPk2Y+5vO8uWsDEWCTFAP/OjyRwVBjD2GbPnEg7arFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0nmQnj8dRMzmcfs/Qy0wB0+ICiz2N78f8Q+nRiul6gNGw9XlSlyYJ2RYcu2pfAPE3AJepRsfTjInjKaN10Sd5wyyZj8/aPxHgmjnEL73YT52jdXqudQSVeer8sDHSmDu5yOkiX/wgiYg+BEPq97oo58dKDCTOeP4bDMSMVuim8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPmCXCoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPmCXCoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ADAC4CEF5;
	Tue, 11 Nov 2025 01:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823806;
	bh=oPk2Y+5vO8uWsDEWCTFAP/OjyRwVBjD2GbPnEg7arFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPmCXCoT4oiHyCo3Znq6OH//CZmtGmgT4a2F5jgF1B4DV7c/WG6VYCP0A4IgQxR8y
	 eb4+RYiWIYN0A6eTvc7qh84ap4ElbvJKI1L8b5PqrSpj0kz/w1GzqvM4tB66UB3K4L
	 up1l65GDn9cXjlJMFgwanszBgbwGpSAsqGa8RFhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/565] ntfs3: pretend $Extend records as regular files
Date: Tue, 11 Nov 2025 09:43:04 +0900
Message-ID: <20251111004534.266123460@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 4e8011ffec79717e5fdac43a7e79faf811a384b7 ]

Since commit af153bb63a33 ("vfs: catch invalid modes in may_open()")
requires any inode be one of S_IFDIR/S_IFLNK/S_IFREG/S_IFCHR/S_IFBLK/
S_IFIFO/S_IFSOCK type, use S_IFREG for $Extend records.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 9077c7b627336..4e2629d020b75 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -471,6 +471,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		   fname->home.seq == cpu_to_le16(MFT_REC_EXTEND)) {
 		/* Records in $Extend are not a files or general directories. */
 		inode->i_op = &ntfs_file_inode_operations;
+		mode = S_IFREG;
 	} else {
 		err = -EINVAL;
 		goto out;
-- 
2.51.0



