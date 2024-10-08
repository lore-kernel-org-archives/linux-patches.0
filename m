Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F3B1DE89F;
	Tue,  8 Oct 2024 13:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393043; cv=none; b=SaS99SPXCzbOaMaDV3fySRCgizz8KwhjMhzW6ZWTjlbN5LS/M5W7LQjiMesh96f+JnX0OkAVqDxNW6jP/yt/pJoFYFvnspH767MfrbEZXmPjFm9w8OevO82GnLxBtpLimKnqsx7ayDE2NULXCS4EGAzXk7q4q6mS+c+UIZf2cDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393043; c=relaxed/simple;
	bh=xpufS9yN+SMtNmWd9+Wlg9qYehzXNI0G2sZF2xuraEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0u6RIiBcSE6+xnJvyognh1IZdAQzlhTYm5mFX5iGzlHPK/xO1SMsQhwXIV/TsEwcjaqbmvoLIjnQ13AA+4a5KI2EXgMWprYpejUj8LsFBJUQWOdk3+2AIGZkKumqomqPset0V4Z09iLMgW2KYMqTsRW4XLAwvTQWSrA7yZaPAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZs59c+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZs59c+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30719C4CEC7;
	Tue,  8 Oct 2024 13:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393043;
	bh=xpufS9yN+SMtNmWd9+Wlg9qYehzXNI0G2sZF2xuraEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZs59c+6XD89mrO+x0HAAeRB/vgmuJ6jqrx9VfWO1+D5LbEp4/bn6Lll60SbKheha
	 A3f6JwPkF4uJnJZseIIuLTqGFQwXCYWGLwPU6RrH7jhzJr6ndCokPf/lvGbN9Jm6B1
	 HCfUqBUd3SO9j9Gq7NCVgB4xLMaIv32IMNYmUtak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/386] iomap: constrain the file range passed to iomap_file_unshare
Date: Tue,  8 Oct 2024 14:04:41 +0200
Message-ID: <20241008115630.897625438@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 3380b43cb6bbb..d48b4fc7a4838 100644
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
index 975fd88c1f0f4..5371b16341fff 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1316,11 +1316,15 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
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



