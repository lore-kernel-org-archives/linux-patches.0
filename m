Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CBB847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D663CC433EF;
	Fri, 10 Mar 2023 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456496;
	bh=JYLGSRr9NLFwU9P0AuYicAmBCu048ngrs4sW4ZSIg/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAeKuc18dhcCPhh0+aW3WyV1JO/9W2YVwMU7cJK8XUKrLNYZOpoXYFbNG/va9mH1J
	 EY1jqmRO3uXpx30gTouliNw1Aj+hfj7DG1GT/ge/qJITxA6F2H2q2G3Go6lNtlrS8I
	 hHeWZPHdVhTBTRl/yDbPsB6FfjP+K7jn0XjfbJHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 023/211] f2fs: fix to abort atomic write only during do_exist()
Date: Fri, 10 Mar 2023 14:36:43 +0100
Message-Id: <20230310133719.433795601@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit ae267fc1cfe9f941afcb90dc963ee6448dae73cf ]

Commit 7a10f0177e11 ("f2fs: don't give partially written atomic data
from process crash") attempted to drop atomic write data after process
crash, however, f2fs_abort_atomic_write() may be called from noncrash
case, fix it by adding missed PF_EXITING check condition
f2fs_file_flush().

- application crashs
 - do_exit
  - exit_signals -- sets PF_EXITING
  - exit_files
   - put_files_struct
    - close_files
     - filp_close
      - flush (f2fs_file_flush)
       - check atomic_write_task && PF_EXITING
       - f2fs_abort_atomic_write

Fixes: 7a10f0177e11 ("f2fs: don't give partially written atomic data from process crash")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 78e6015ce3a6f..1aa21160a0614 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1880,7 +1880,8 @@ static int f2fs_file_flush(struct file *file, fl_owner_t id)
 	 * until all the writers close its file. Since this should be done
 	 * before dropping file lock, it needs to do in ->flush.
 	 */
-	if (F2FS_I(inode)->atomic_write_task == current)
+	if (F2FS_I(inode)->atomic_write_task == current &&
+				(current->flags & PF_EXITING))
 		f2fs_abort_atomic_write(inode, true);
 	return 0;
 }
-- 
2.39.2



