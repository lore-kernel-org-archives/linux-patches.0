Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FA24654F;
	Mon,  1 Apr 2024 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989883; cv=none; b=M0lB1QsDbR58uCq/M6nxwdT9OM1ErPwrkzjRgDErTK50dInXmrPJkSFqKnAx3B65hYAndz62LrelaIGnKrAsVsqOHUrVgEiGMF6EespHxxVGBej1bgC6Dh3MheJeL6cRZ5pQSF/KmKw3uqX23Ro9j3gtpUgMmOZ6RQ8dipp7WP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989883; c=relaxed/simple;
	bh=jsCMF4SiWQ4U0SGd1Pzw2jLhQ7RWMM03BbYokbEUQn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8Kzd3jJB+xa6+iUDVFxRi7TYvq2Dabt74ZUYqszRxP8QA9faok7iFv2/R3zRorIpBsi3is3/WDKNbheaUfj1xO5qVY3YS/Ql5X37OqfTBS8Ake7pQcV06jg2aC5zXOhgre/ge7NNcdaPbNogWg2gCZCDrh38yDJg2CRxJi3NIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwO8zHzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwO8zHzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F68C43390;
	Mon,  1 Apr 2024 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989883;
	bh=jsCMF4SiWQ4U0SGd1Pzw2jLhQ7RWMM03BbYokbEUQn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwO8zHzh3op8S42Vlt1wHeLzOzZRI8R1YZiPzogzwO/PMwEMW9klqPOHLz2LZNOs4
	 6nqWHKi2XmQQbCfYf/oAC6ADlV0Ak38llqDy4piUP489iFzqmrtQQeIY+rF1ua54DZ
	 LEUdwfsnZ1PPZhqnJdVC5uZ4XW+DABTqApvjDULw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/396] f2fs: truncate page cache before clearing flags when aborting atomic write
Date: Mon,  1 Apr 2024 17:43:22 +0200
Message-ID: <20240401152552.507208851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunmin Jeong <s_min.jeong@samsung.com>

[ Upstream commit 74b0ebcbdde4c7fe23c979e4cfc2fdbf349c39a3 ]

In f2fs_do_write_data_page, FI_ATOMIC_FILE flag selects the target inode
between the original inode and COW inode. When aborting atomic write and
writeback occur simultaneously, invalid data can be written to original
inode if the FI_ATOMIC_FILE flag is cleared meanwhile.

To prevent the problem, let's truncate all pages before clearing the flag

Atomic write thread              Writeback thread
  f2fs_abort_atomic_write
    clear_inode_flag(inode, FI_ATOMIC_FILE)
                                  __writeback_single_inode
                                    do_writepages
                                      f2fs_do_write_data_page
                                        - use dn of original inode
    truncate_inode_pages_final

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Cc: stable@vger.kernel.org #v5.19+
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Yeongjin Gil <youngjin.gil@samsung.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0edd9feff6185..4549964819731 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -192,6 +192,9 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 	if (!f2fs_is_atomic_file(inode))
 		return;
 
+	if (clean)
+		truncate_inode_pages_final(inode->i_mapping);
+
 	release_atomic_write_cnt(inode);
 	clear_inode_flag(inode, FI_ATOMIC_COMMITTED);
 	clear_inode_flag(inode, FI_ATOMIC_REPLACE);
@@ -201,7 +204,6 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 	F2FS_I(inode)->atomic_write_task = NULL;
 
 	if (clean) {
-		truncate_inode_pages_final(inode->i_mapping);
 		f2fs_i_size_write(inode, fi->original_i_size);
 		fi->original_i_size = 0;
 	}
-- 
2.43.0



