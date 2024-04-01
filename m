Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82CA208D1;
	Mon,  1 Apr 2024 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987069; cv=none; b=KYayQIt0aHALV1jWspK7AY49WmjEceE61OnHxCPSo/dB3OfBVRButARDTFet7LjStT8qCumDIAr1ZqBrSLfAQJOtcP+G4/aFRAgr1TatKEKbWFi+1e4m3Z23gk714DvEcSnZWEcNGlrnKoz6dOS/P6aK23bk78ICARl+MT5Lw1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987069; c=relaxed/simple;
	bh=rEHOFSoZROZYUXGIqXdd56PL98WvV3m2n580YqnCXI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTrS5kM7xDvXDbTJHQD2y0Vjav+EVBSRbr3XbG9fJICoxy+DvQEFyarrhEVtxj6eXCVpsUEEUYXYJFk4LUnVEfXQxTnAt9dhqMO1C6TcZi6aubcK/+Wc0L23oS6xa4Q5+tPUXbDVBocOL9EYBjfYbtp8QFX05xNRuc9ZX6/RtJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4/CanCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4/CanCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A2DC433C7;
	Mon,  1 Apr 2024 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987069;
	bh=rEHOFSoZROZYUXGIqXdd56PL98WvV3m2n580YqnCXI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4/CanCyEm+mFttAYEWY6Kf2NGMahSEfk1+X5MG1VZyIugQVPyQn1LYha2KZqNQd5
	 ARRb43lLZJ95FYdPkJ8YRkgmBrzcHi646kY1DSOJsb54DlfFelj6Lhno8zKGEruhHE
	 Qopuha6OUCBzZr4uldb3ZIv7ydDHkF0lctjKXG/U=
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
Subject: [PATCH 6.8 175/399] f2fs: mark inode dirty for FI_ATOMIC_COMMITTED flag
Date: Mon,  1 Apr 2024 17:42:21 +0200
Message-ID: <20240401152554.400879598@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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
index 5a6c35d70c7ad..6610ff6d7e6cc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3032,6 +3032,7 @@ static inline void __mark_inode_dirty_flag(struct inode *inode,
 	case FI_INLINE_DOTS:
 	case FI_PIN_FILE:
 	case FI_COMPRESS_RELEASED:
+	case FI_ATOMIC_COMMITTED:
 		f2fs_mark_inode_dirty_sync(inode, true);
 	}
 }
-- 
2.43.0



