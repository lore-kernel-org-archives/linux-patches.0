Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C1C252915;
	Thu, 17 Apr 2025 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914721; cv=none; b=fAtQvi9vQ1Y2MY8A0nZ3kWif2seRydUjYLnVVXRuMlI28ygQEmin9N2EOoL++wFHNu+BOZEjTgf+JZUSK3OWsa/EGL9LDWK3H7lpnyCxB+aPKqOXSZavHdBSttAH5WhJcqg9idUmMOTXzkbwxEsl0Z45zWJeURXHwvr8wwXYU5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914721; c=relaxed/simple;
	bh=wakJW9kOky6N0wLwuALUWSanBiUJoS5yL3LX4lFOKnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rizdW1zOSNDKTCUlfXagz9lrgRJA4ms3iBkbSJFSAIZHzv+WAVnK+MQPiV0ZtX43BGtjrBifBammq+okYSzf5sQqBpVE4w1f+oB7C9/jMQ4OP/x+g/x2THNQOI2JQU6XxUMFASOrzQkpPihgLeobkw9VC/fqA8PZsnOkfucg/+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWlE+WVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWlE+WVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21D0C4CEE4;
	Thu, 17 Apr 2025 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914721;
	bh=wakJW9kOky6N0wLwuALUWSanBiUJoS5yL3LX4lFOKnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWlE+WVXJN7vCYypcka5MUtzQFdwvsBiLwLqU/l/ONu5dO/ZqzMQGquDmoqcpK7hN
	 2Jk3s5UNWs0rt5U7UwX7QdF64fs0LI9bk0o2kcx1k7rWs2LQqn7JOR/yzDpfIN7i8v
	 SkjOkxzJNEZeM5lsYShldW+AVqGwJSc3PouDWpFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.13 279/414] f2fs: fix to avoid atomicity corruption of atomic file
Date: Thu, 17 Apr 2025 19:50:37 +0200
Message-ID: <20250417175122.650714399@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeongjin Gil <youngjin.gil@samsung.com>

commit f098aeba04c9328571567dca45159358a250240c upstream.

In the case of the following call stack for an atomic file,
FI_DIRTY_INODE is set, but FI_ATOMIC_DIRTIED is not subsequently set.

f2fs_file_write_iter
  f2fs_map_blocks
    f2fs_reserve_new_blocks
      inc_valid_block_count
        __mark_inode_dirty(dquot)
          f2fs_dirty_inode

If FI_ATOMIC_DIRTIED is not set, atomic file can encounter corruption
due to a mismatch between old file size and new data.

To resolve this issue, I changed to set FI_ATOMIC_DIRTIED when
FI_DIRTY_INODE is set. This ensures that FI_DIRTY_INODE, which was
previously cleared by the Writeback thread during the commit atomic, is
set and i_size is updated.

Cc: <stable@vger.kernel.org>
Fixes: fccaa81de87e ("f2fs: prevent atomic file from being dirtied before commit")
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Sunmin Jeong <s_min.jeong@samsung.com>
Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    4 +---
 fs/f2fs/super.c |    4 ++++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -34,10 +34,8 @@ void f2fs_mark_inode_dirty_sync(struct i
 	if (f2fs_inode_dirtied(inode, sync))
 		return;
 
-	if (f2fs_is_atomic_file(inode)) {
-		set_inode_flag(inode, FI_ATOMIC_DIRTIED);
+	if (f2fs_is_atomic_file(inode))
 		return;
-	}
 
 	mark_inode_dirty_sync(inode);
 }
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1527,6 +1527,10 @@ int f2fs_inode_dirtied(struct inode *ino
 		inc_page_count(sbi, F2FS_DIRTY_IMETA);
 	}
 	spin_unlock(&sbi->inode_lock[DIRTY_META]);
+
+	if (!ret && f2fs_is_atomic_file(inode))
+		set_inode_flag(inode, FI_ATOMIC_DIRTIED);
+
 	return ret;
 }
 


