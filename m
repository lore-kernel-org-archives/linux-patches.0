Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E88B173351;
	Wed,  3 Jul 2024 10:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003473; cv=none; b=ghtpEbjZnuy82MGpxDjde7ZA+SmA79MOc3xysaZ1sKAv0yBgE3Y01SbAbJZ8sImH4OlPNN4riVd8WjC/p+xU26ZqU+mJUlY6LUBlCpDWRqfFuAt3KPiKUH78Uv66xB6O31RHhD5hkw2c2auL5nE/KTMoAbRHMo7IIXCigLQcxrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003473; c=relaxed/simple;
	bh=SQBYaZOICsExscVN3KcNq7FxTblhZs9seOT8ldBbwyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0BmDiyJGHGfLawDp/ogWvlm6FAlQo1yqNilO/KPqIFdd5Ruq9gWrD3ASkuJ+p7CgjkIcH0KoxEyxnjTD/xpGS92rPvRM+GJKOYNSpqcN2Ves3XGdUiy+f0MkcN4UA23o7NRmRX9QNtjVMDpDi0tSY6nT9lZ0lZvE5rjrTnFT+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjQAnSdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjQAnSdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE7FC2BD10;
	Wed,  3 Jul 2024 10:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003473;
	bh=SQBYaZOICsExscVN3KcNq7FxTblhZs9seOT8ldBbwyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjQAnSdzN6xmlxyU6f7Ub0YVeBl7yfOopwaPUeuP8K9JcNja7eVAPPpJZ9mc+Wclf
	 /QsswK6mAgy6eYOkO/nvkHl0B0qziPkn0oCB4FLMCEz0T3ENKsz0mYtG745o7s4/4x
	 Ho1bbNqEbA4xMRysgJC3/Dlc5RBRX2O43tCE50Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/139] nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors
Date: Wed,  3 Jul 2024 12:38:45 +0200
Message-ID: <20240703102831.503022125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 7373a51e7998b508af7136530f3a997b286ce81c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 22f1f75a90c1a..552234ef22fe7 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -627,7 +627,7 @@ int nilfs_empty_dir(struct inode *inode)
 
 		kaddr = nilfs_get_page(inode, i, &page);
 		if (IS_ERR(kaddr))
-			continue;
+			return 0;
 
 		de = (struct nilfs_dir_entry *)kaddr;
 		kaddr += nilfs_last_byte(inode, i) - NILFS_DIR_REC_LEN(1);
-- 
2.43.0



