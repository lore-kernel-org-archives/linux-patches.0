Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925FA4EB847;
	Thu, 17 Sep 2026 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666934; cv=none; b=DAM6gD5wLga+TZn5v0x/dSE7twCPNrA2SECtwqgzIVU99Er3eZbzTNd1fVYU93FJyx0VmJorsngbwxyDr+h1hARiUMFuZq//DFSPTojzUytwz2oURfpqaJmjmHCB5V1D0ExPnKN6L4j5qhMKhfvuHXYgQz+nE6867vA0f+C3sCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666934; c=relaxed/simple;
	bh=1WWtO9BbpMaPi5TMbasgzGYx69Wo5qaDE3l6BXKx19U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJVYUdRbSHSqYOIbkCGAj4gw69wiKWeD+5wQ64E/As7FzLxmwv/f362nW0j9JUMHyq96hFyhv4pHqXZQsAHL0sxASDNfxKKqO6Ftwf+X61xaRxasC4SaXVg0dQLT+HnP8mvj3V0pjdGgR84qrbGYn6DxRRMLofjQF+usRb9gUv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ4v/59q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ4v/59q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B8D1F000FF;
	Thu, 17 Sep 2026 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666933;
	bh=ln7xfepYlGPuI8BYitmPJ6jsI/QTAJBgtmel+P6yubQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJ4v/59q32uer+h8yNECIexxQ87NCldLPT0NMVwc8ypC23LFCHOshJgEqZ9RIGadg
	 /OSR0G/eernPphiY07aKqGnz7h3Nf5tzWSi+Nh6gQhdcbK9r7yA1zQBJKdUopvEMsX
	 vU3r4Vm4mHrKHM7p98Hl7UGp9tJZB3szVOtv1Jpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1173/1250] f2fs: validate MOVE_RANGE destination size
Date: Thu, 17 Sep 2026 16:16:08 +0100
Message-ID: <20260917151624.080476730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit e533889fc26aea0cd83c90327063f272061dd820 ]

F2FS_IOC_MOVE_RANGE checks the source range, but not the destination end
before updating i_size. A source hole can expose this: __clone_blkaddrs()
skips NULL_ADDR entries and returns success, so the caller can still extend
the destination inode with unchecked pos_out + len.

Reject destination overflow and use inode_newsize_ok() before extending
the destination inode.

Fixes: 4dd6f977fc77 ("f2fs: support an ioctl to move a range of data blocks")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ adjusted declaration context due to missing struct f2fs_lock_context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3175,8 +3175,9 @@ static int f2fs_move_file_range(struct f
 	struct inode *src = file_inode(file_in);
 	struct inode *dst = file_inode(file_out);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(src);
-	size_t olen = len, dst_max_i_size = 0;
-	size_t dst_osize;
+	size_t olen = len;
+	loff_t dst_max_i_size = 0;
+	loff_t dst_osize, dst_end;
 	int ret;
 
 	if (file_in->f_path.mnt != file_out->f_path.mnt ||
@@ -3234,8 +3235,15 @@ static int f2fs_move_file_range(struct f
 	}
 
 	dst_osize = dst->i_size;
-	if (pos_out + olen > dst->i_size)
-		dst_max_i_size = pos_out + olen;
+	if (olen > LLONG_MAX - pos_out)
+		goto out_unlock;
+	dst_end = pos_out + olen;
+	if (dst_end > dst->i_size) {
+		ret = inode_newsize_ok(dst, dst_end);
+		if (ret)
+			goto out_unlock;
+		dst_max_i_size = dst_end;
+	}
 
 	/* verify the end result is block aligned */
 	if (!IS_ALIGNED(pos_in, F2FS_BLKSIZE) ||


