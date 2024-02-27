Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF452F2D;
	Tue, 27 Feb 2024 13:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040832; cv=none; b=QVN3bjqw5kk3OIB7grZGFC3cA287QZ08Kqm7pe1skdHlXPlZzk4YlA4+uNZSb+5Bm75b97HXv6T5/A+z3uT8kQpuo644ZKLOOxwF7mrUlMmOlbhUfzP4sStzUXslf45q//y3mnpq2OZN50GFuuxNqzenSNcO3bhBCu+HQCq8pg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040832; c=relaxed/simple;
	bh=QXDdmCkpFPXFNPH5UR0ZjO7wTAHIO+/XpI/vSwRhIzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCFCUu+MkorBoIXFbgV9rH+psroPEC/YiRH+DmxUpJ8VXa+/WPa9inkRjF38vpL5jjhec+IYJ8ZdgRZtmhNdAZLwdHdQ1ePORIPpgrp4cLltTmwRUdmnk2fgYkDprOHElUQqip1euC9zMkS6bnFORxJLeS7OrYpsboIWJ5GLDsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOHNUctW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOHNUctW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E4AC433C7;
	Tue, 27 Feb 2024 13:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040832;
	bh=QXDdmCkpFPXFNPH5UR0ZjO7wTAHIO+/XpI/vSwRhIzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOHNUctWRzpX6YkIOmAH/fyQ0oR/yptb51ROB7DOYYUVXfi1HvDqrCqdDZMY+8a5H
	 EwD73vPRoIQU9oIBW/tL8ENmPCsU84RQl+X1pTx1dMn8uXiopOBCJ9ti9UIWzeF92N
	 XZralcyfm5Yym1a5e8Rwy1IPaY2PUImWt7ndSDvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 085/334] fs/ntfs3: Add file_modified
Date: Tue, 27 Feb 2024 14:19:03 +0100
Message-ID: <20240227131633.270369212@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 4dea9cd522424d3002894c20b729c6fbfb6fc22b ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 5691f04e6751a..bb80ce2eec2f7 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -632,11 +632,17 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 					    &ni->file.run, i_size, &ni->i_valid,
 					    true, NULL);
 			ni_unlock(ni);
+			if (err)
+				goto out;
 		} else if (new_size > i_size) {
 			inode->i_size = new_size;
 		}
 	}
 
+	err = file_modified(file);
+	if (err)
+		goto out;
+
 out:
 	if (map_locked)
 		filemap_invalidate_unlock(mapping);
@@ -1040,6 +1046,7 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	ssize_t ret;
+	int err;
 	struct ntfs_inode *ni = ntfs_i(inode);
 
 	if (is_encrypted(ni)) {
@@ -1067,6 +1074,12 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret <= 0)
 		goto out;
 
+	err = file_modified(iocb->ki_filp);
+	if (err) {
+		ret = err;
+		goto out;
+	}
+
 	if (WARN_ON(ni->ni_flags & NI_FLAG_COMPRESSED_MASK)) {
 		/* Should never be here, see ntfs_file_open(). */
 		ret = -EOPNOTSUPP;
-- 
2.43.0



