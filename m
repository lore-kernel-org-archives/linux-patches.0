Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24B31DEFD9;
	Tue,  8 Oct 2024 12:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389622; cv=none; b=mTFo0+02eVoXDBqqp7HafbfQbV7OY8kiftBKojf80ruuPTCb4vc9WXEbaYNZpL3TdB/S0MBF9JdNROIZmaqQcVNH8Q9DjfOf3g/orHNceKKTcNXNu9rrmh1Q1D2h9pun+ttjidNlRpu0sHgUa64o/O61dW7mBkmrK9BBEbONnc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389622; c=relaxed/simple;
	bh=bYRiSNW5GJL/gVf51417p6TeTsEIlNpMRaof6Mc+lHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL1P6+MWo/rSOHBne0mmZfHf4ub01JP8rNb0bdNxxzYaoTPGfJKa6g/wXYgX5u4hlIKKyr+latIUyrUfPGgAOJuMnXzOGIYPwFG6ltgp1RjcS8mvQ05YQzcxmNfVAaigguwHEXVAJU8WU5ro1xbCURxvv9Ej+PMfcPLLXQkwACA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqxxNmLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqxxNmLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57F3C4CEC7;
	Tue,  8 Oct 2024 12:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389622;
	bh=bYRiSNW5GJL/gVf51417p6TeTsEIlNpMRaof6Mc+lHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqxxNmLHzoTzW/w5E3E/pyp1TL0Jwivbfdss3f0RPztgEoww7zoRUwdunORga7YGH
	 CJvuI0uedGS7nHWMcW4zW89tDBGw0fL8tJH00gtRnok9fY6VOrIveM8/zg9Xu9uS8m
	 X/Fxj8uDtwScjaMaTMWR1OVxBwR4JImqsXXV1yPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 047/482] iomap: constrain the file range passed to iomap_file_unshare
Date: Tue,  8 Oct 2024 14:01:50 +0200
Message-ID: <20241008115650.156302052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit a311a08a4237241fb5b9d219d3e33346de6e83e0 ]

File contents can only be shared (i.e. reflinked) below EOF, so it makes
no sense to try to unshare ranges beyond EOF.  Constrain the file range
parameters here so that we don't have to do that in the callers.

Fixes: 5f4e5752a8a3 ("fs: add iomap_file_dirty")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20241002150213.GC21853@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c               | 6 +++++-
 fs/iomap/buffered-io.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index becb4a6920c6a..c62acd2812f8d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1305,11 +1305,15 @@ int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 	struct iomap_iter iter = {
 		.inode		= inode,
 		.pos		= pos,
-		.len		= len,
 		.flags		= IOMAP_WRITE | IOMAP_UNSHARE | IOMAP_DAX,
 	};
+	loff_t size = i_size_read(inode);
 	int ret;
 
+	if (pos < 0 || pos >= size)
+		return 0;
+
+	iter.len = min(len, size - pos);
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = dax_unshare_iter(&iter);
 	return ret;
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d465589902790..e817564e80e01 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1366,11 +1366,15 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 	struct iomap_iter iter = {
 		.inode		= inode,
 		.pos		= pos,
-		.len		= len,
 		.flags		= IOMAP_WRITE | IOMAP_UNSHARE,
 	};
+	loff_t size = i_size_read(inode);
 	int ret;
 
+	if (pos < 0 || pos >= size)
+		return 0;
+
+	iter.len = min(len, size - pos);
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_unshare_iter(&iter);
 	return ret;
-- 
2.43.0



