Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1D84E5333;
	Thu, 17 Sep 2026 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667713; cv=none; b=HfARmz7K5O309Y/AwLE9k50t1Sb/F7e3dYgNK+Yvp7azu7Yj/N6Jfw/3ibP5VlIDt2yx5ZKg7Ad7a3pcp0vMX1JKQu4w1wC34f+TvkW61xuczqHbSoBy3le0nTQAZNetpfVqC34JTa4a4ZCb5ikbr6Q2UrfN9iZymnLEc6szICs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667713; c=relaxed/simple;
	bh=fxtEJrazzLTyrxHPR0s8qEXz7zUEjZppvcjiUy7TYr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDeTkNxzvMmQkqgeRaBnO/lYIcptL2AXMBC8eRUOxG7i0GspEiU9QyU5CAWwlHrAaAmrDy/OBVCppJWn/lrhU+aRnexyTB2Sh/H3plngaHU7ZaN4CjWTN0/m1eNgYCvh/Aky8kp39SP0DVSnvs0Ol7KnY7qHN7AGiDMLXainbAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6dyrmjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6dyrmjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3A31F000FF;
	Thu, 17 Sep 2026 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667712;
	bh=WNFXz0hfsqtR0pDXR3zcQiXNogEuaujcZQnN1blkJVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6dyrmjGOauamxASA7s0+zfzJzMmCRNLUs2zumxnKxInBWzzOJPq3BsZkOH4m5SP4
	 BW2YHCOVTWvpKG8J4GCMOKCERv8IM8EpJE7nBGMEjBQ3JLybN5J/WK0IFrZRVazRns
	 ljUlZLHCUspyRFD0tQLPnumd/n/nPHoi+NI/5AIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0185/1102] gfs2: page poisoning fix
Date: Thu, 17 Sep 2026 16:02:08 +0100
Message-ID: <20260917151544.208052230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 4982e58669b11c43644efb5fb7435975848b716e ]

Processes can write to the last page of a file using mmap, and when the file
size is not a multiple of the page size, this can be used to write beyond the
end of the file.  This is sometimes referred to as page poisoning, and it is
not a problem in itself because the data beyond eof will be ignored.  However,
we currently fail to clear out any space beyond the end of the file that we
skip over when the file size is increased, so that "poison" can end up getting
exposed.  Fix that.

Fixes xfstest generic/363.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 19 +++++++++++++++++++
 fs/gfs2/bmap.h |  1 +
 fs/gfs2/file.c | 10 ++++++++++
 3 files changed, 30 insertions(+)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 776090fbc9aa5..c87ce7d10bd18 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1315,6 +1315,19 @@ static int gfs2_block_zero_range(struct inode *inode, loff_t from,
 	return iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops);
 }
 
+int gfs2_clear_beyond_eof(struct inode *inode, loff_t end)
+{
+	loff_t isize = i_size_read(inode);
+	unsigned int len = isize & ~PAGE_MASK;
+
+	if (!len || isize >= end)
+		return 0;
+	len = PAGE_SIZE - len;
+	if (end - isize < len)
+		len = end - isize;
+	return gfs2_block_zero_range(inode, isize, len);
+}
+
 #define GFS2_JTRUNC_REVOKES 8192
 
 /**
@@ -2090,6 +2103,12 @@ static int do_grow(struct inode *inode, u64 size)
 		unstuff = 1;
 	}
 
+	if (!unstuff) {
+		error = gfs2_clear_beyond_eof(inode, size);
+		if (error)
+			goto do_grow_qunlock;
+	}
+
 	error = gfs2_trans_begin(sdp, RES_DINODE + RES_STATFS + RES_RG_BIT +
 				 (unstuff &&
 				  gfs2_is_jdata(ip) ? RES_JDATA : 0) +
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index 4e8b1e8ebdf39..12cd9dc68deb8 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -57,6 +57,7 @@ int gfs2_get_extent(struct inode *inode, u64 lblock, u64 *dblock,
 		    unsigned int *extlen);
 int gfs2_alloc_extent(struct inode *inode, u64 lblock, u64 *dblock,
 		      unsigned *extlen, bool *new);
+int gfs2_clear_beyond_eof(struct inode *inode, loff_t end);
 int gfs2_setattr_size(struct inode *inode, u64 size);
 int gfs2_truncatei_resume(struct gfs2_inode *ip);
 int gfs2_file_dealloc(struct gfs2_inode *ip);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index ac6f50167076d..0b5be4ad3a961 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1057,6 +1057,10 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 			goto out_unlock;
 	}
 
+	ret = gfs2_clear_beyond_eof(inode, iocb->ki_pos);
+	if (ret)
+		goto out_unlock;
+
 	pagefault_disable();
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops, NULL);
 	pagefault_enable();
@@ -1265,6 +1269,12 @@ static long __gfs2_fallocate(struct file *file, int mode, loff_t offset, loff_t
 
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
+	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
+		error = gfs2_clear_beyond_eof(inode, offset + len);
+		if (error)
+			return error;
+	}
+
 	offset &= bsize_mask;
 
 	len = next - offset;
-- 
2.53.0



