Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70488248F6A;
	Tue, 11 Nov 2025 01:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824438; cv=none; b=u8ymC1xNx4ry4Nop8nbDUPSgmoFZRDisozI0lyLYVvYK/x4uCbOQ4CDV1VI68ML8y+Ig9XbhFVKhMeXpL8ZoSkx1ifHEArRhiGHlgTQF3sMRnOv7Zm+hp6+ZbGtBNXJcGPdI8aWzU7qh/40espYvf7FEo4L7mEIXbV5sTGHjVmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824438; c=relaxed/simple;
	bh=w4QWRcr+FfgFEOE32GzeHEf4UoJBYGuObOZ0yKa0Sjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltSKA2y3E1IYLd8Td3w9wFVAs2k8/m0i0hQseSLTbb4Dl38bH2NEzYPqCzs/JZQ/E3wgpFJfVv8mhOZUyA12t0A1Bjrmw4zQaywLpMwni65RoBBMWzySLf6juPT/Zo2/4KVkDdw0zYC4ashg2kKAy4hm0nSww868QWFdPDw3SDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhURnPjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhURnPjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A17C19425;
	Tue, 11 Nov 2025 01:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824438;
	bh=w4QWRcr+FfgFEOE32GzeHEf4UoJBYGuObOZ0yKa0Sjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhURnPjmG8KCjeUU+GvVDoW+go9cs4TV2HidMMGRMVOkPs85w3AV7dCnnQyCvOTOL
	 SpBwtFT2dsoNks3CxyJHVxU3cATKfspuwR9SKXaSeqcvmjdnGruD2zP0PGwCHKJzzk
	 iUzLNXYOnp4bDopMPwz6yVFqeOKZ6NmLqPY22E3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 500/849] ntfs3: pretend $Extend records as regular files
Date: Tue, 11 Nov 2025 09:41:10 +0900
Message-ID: <20251111004548.521889722@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 37cbbee7fa580..b08b009121653 100644
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



