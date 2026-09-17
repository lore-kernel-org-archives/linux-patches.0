Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DE3515965;
	Thu, 17 Sep 2026 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664103; cv=none; b=Ftm7M6jKzJZBlXcMqJhO3j5zy0YmGOA3RolDEDdysQkG5xYb6HycC1Uf18xeCN59aFp3fq6/GO3pUyTG4nSJtELUZIFvD3l/5ftJJ4+5EVezvRVCv71+Buz5h5KGHuANa5MOiNMeyHsdgN2G5zPYJ1MKvCZTtIlAIv+AIiacoks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664103; c=relaxed/simple;
	bh=qXD+FltMyVj6cw77eBFpSfj4kCyDG7myEBeHqL7k7xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+Qq6cB/ayxktLTzW2GeiNc5kiDWlCdc2qyHcg2FxTqcA40rniVd2sCr1uoRn3hiPPYxEbbDqNZEDmPSjoCLNEsSU1SpN2+25HgL2UqYuWEvB1dd9vOiijDAF0N6Z2CO2PFFMGPPyBxm8fQeox4FsIBoL3/6CPECbmn2VZrrUhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQHU81Up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQHU81Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1971F000FF;
	Thu, 17 Sep 2026 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664102;
	bh=XOlv4oFnknXTr/toX2rNGMuzUlLWI7ctQ7Om1eygS6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQHU81UpaTTBddar4y+XFGK7bdkX4VRjkVzsSNvAhp/TM5vFqGKB5DZlpnwNEqr/K
	 JXKFDumvUsY/RAPUZSSyYRMHqdOpv0gGwKS0sApLutHwYWpreei3slUpGBuyPgJwJI
	 04SHmuWadPeYKW7eTJM3n/kOGjqJUFdDNen0nt30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0261/1250] gfs2: page poisoning fix
Date: Thu, 17 Sep 2026 16:00:56 +0100
Message-ID: <20260917151559.225764431@linuxfoundation.org>
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
index fdcac8e3f2ba2..836e260099c39 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1321,6 +1321,19 @@ static int gfs2_block_zero_range(struct inode *inode, loff_t from, loff_t length
 			&gfs2_iomap_write_ops, NULL);
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
@@ -2096,6 +2109,12 @@ static int do_grow(struct inode *inode, u64 size)
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
index 6cdc72dd55a3f..e3d6efdfd8903 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -58,6 +58,7 @@ int gfs2_get_extent(struct inode *inode, u64 lblock, u64 *dblock,
 		    unsigned int *extlen);
 int gfs2_alloc_extent(struct inode *inode, u64 lblock, u64 *dblock,
 		      unsigned *extlen, bool *new);
+int gfs2_clear_beyond_eof(struct inode *inode, loff_t end);
 int gfs2_setattr_size(struct inode *inode, u64 size);
 int gfs2_truncatei_resume(struct gfs2_inode *ip);
 int gfs2_file_dealloc(struct gfs2_inode *ip);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index bc67fa058c845..ef57d6aa42ebb 100644
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
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops,
 			&gfs2_iomap_write_ops, NULL);
@@ -1266,6 +1270,12 @@ static long __gfs2_fallocate(struct file *file, int mode, loff_t offset, loff_t
 
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



