Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC1C143C5F;
	Thu, 13 Jun 2024 11:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279703; cv=none; b=F4AOznqNmz3+bI9YVUJzRaZrdbqBgNA8zxJPgCCVNIexqjHFXCtVJakuUUu8EnMYEFSo7UvLyVXkNh0wj2/goMhCrbMN7C0H6gVNyY2BLo22rsYAR14rvFlWszF0mqro9SG1A4uljqCYlhlr2OCwFOeCc8KgpdS4thnhoY4IkiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279703; c=relaxed/simple;
	bh=DQcS/5g4i2U6PpzU3L+T5sWd1D67w9SNooxpj56vfxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RK2wZtsE/IwVMYEElnsaCuzM6xCboY/aokMl4yukciRbB9RdI0DzEl8NMjN/Mf56RySXuHbAlWdM8+wFGdlmnUyDd14VBgIVQChhmsOfKDuUX3VzNA9fed/5+bnpni50pRRsSbKZLFoUjnaWBpgY7ClxORdStrw7RmvDjJZLq6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQ97Y93D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQ97Y93D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748EDC2BBFC;
	Thu, 13 Jun 2024 11:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279702;
	bh=DQcS/5g4i2U6PpzU3L+T5sWd1D67w9SNooxpj56vfxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQ97Y93DIYlSUz+lhPT9wdbxJWmsl8yCU/JHk0aUv/CVlTRcQf0YbpBIapGY4cio6
	 rumZYZ2VszT7Fn3WyYfJBRNGnEkFfaaxo1a8QC5W4etyNjm4oIr+p+kWKa8y+aTD33
	 XBeUPTeRD976EnFZk6tnbWwZ2Y41Q6Lqcmcm5l/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 156/157] nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors
Date: Thu, 13 Jun 2024 13:34:41 +0200
Message-ID: <20240613113233.443210804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 7373a51e7998b508af7136530f3a997b286ce81c upstream.

The error handling in nilfs_empty_dir() when a directory folio/page read
fails is incorrect, as in the old ext2 implementation, and if the
folio/page cannot be read or nilfs_check_folio() fails, it will falsely
determine the directory as empty and corrupt the file system.

In addition, since nilfs_empty_dir() does not immediately return on a
failed folio/page read, but continues to loop, this can cause a long loop
with I/O if i_size of the directory's inode is also corrupted, causing the
log writer thread to wait and hang, as reported by syzbot.

Fix these issues by making nilfs_empty_dir() immediately return a false
value (0) if it fails to get a directory folio/page.

Link: https://lkml.kernel.org/r/20240604134255.7165-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c8166c541d3971bf6c87
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -608,7 +608,7 @@ int nilfs_empty_dir(struct inode *inode)
 
 		kaddr = nilfs_get_folio(inode, i, &folio);
 		if (IS_ERR(kaddr))
-			continue;
+			return 0;
 
 		de = (struct nilfs_dir_entry *)kaddr;
 		kaddr += nilfs_last_byte(inode, i) - NILFS_DIR_REC_LEN(1);


