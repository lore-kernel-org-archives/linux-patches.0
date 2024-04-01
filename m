Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64218C129;
	Mon,  1 Apr 2024 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988397; cv=none; b=U5HLlSjCedxEH5PO4gkBYJhVvxSOQrXki6ZYAPHkzuxbNRIeSVP+J4VP9IqTT4kEij7bpfKaaJoT8oy/KwEvUW4LL1oDtZxpDQzSqI6AhLcAr68xoapBxhxr3zLfB9VNg1az3q1F/5jKw5p1g+iCdXvtmef6+KNT8A5Yh933M0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988397; c=relaxed/simple;
	bh=7vOLFOo3/ZS+8qWZ6yXMTO5yLLY9P4auApIgIkZyIW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocm3iftgfjhc294/yv/p3dRewY/pezOuU9zy2/8ycI+uywU6RhVeyABfOddPYsENJn1+12Tc9Te8zTM/rJzUu8qxoRvyRf+jzwiyS+ahjL3kT/btLYLDIHuUQE6Dg3nJ8Jx3qqpKa3HMHwpdNm6GDgy3DIu3hkGGzPgiCiLHNWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKUFQ0jQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKUFQ0jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80275C433C7;
	Mon,  1 Apr 2024 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988397;
	bh=7vOLFOo3/ZS+8qWZ6yXMTO5yLLY9P4auApIgIkZyIW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKUFQ0jQvq/wHbG4qOMDWakddhzzCmjNfTFkLWaEZQFA1m/vxiuREaYj2jZm3NjQ5
	 Acvou0d0AIWNnYuesx2ZccxCPu18EQGhR2Tp0J16hBaJ+RMDYv3j7wvqVoWK1vyRVb
	 1s16uiPTA8rxewHYYejTzqUsJIcmgJixnUAWkGVU=
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
Subject: [PATCH 6.7 173/432] f2fs: mark inode dirty for FI_ATOMIC_COMMITTED flag
Date: Mon,  1 Apr 2024 17:42:40 +0200
Message-ID: <20240401152558.307013096@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunmin Jeong <s_min.jeong@samsung.com>

[ Upstream commit 4bf78322346f6320313683dc9464e5423423ad5c ]

In f2fs_update_inode, i_size of the atomic file isn't updated until
FI_ATOMIC_COMMITTED flag is set. When committing atomic write right
after the writeback of the inode, i_size of the raw inode will not be
updated. It can cause the atomicity corruption due to a mismatch between
old file size and new data.

To prevent the problem, let's mark inode dirty for FI_ATOMIC_COMMITTED

Atomic write thread                   Writeback thread
                                        __writeback_single_inode
                                          write_inode
                                            f2fs_update_inode
                                              - skip i_size update
  f2fs_ioc_commit_atomic_write
    f2fs_commit_atomic_write
      set_inode_flag(inode, FI_ATOMIC_COMMITTED)
    f2fs_do_sync_file
      f2fs_fsync_node_pages
        - skip f2fs_update_inode since the inode is clean

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
 fs/f2fs/f2fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 200e1e43ef9bb..3b6133c865a29 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3025,6 +3025,7 @@ static inline void __mark_inode_dirty_flag(struct inode *inode,
 	case FI_INLINE_DOTS:
 	case FI_PIN_FILE:
 	case FI_COMPRESS_RELEASED:
+	case FI_ATOMIC_COMMITTED:
 		f2fs_mark_inode_dirty_sync(inode, true);
 	}
 }
-- 
2.43.0



