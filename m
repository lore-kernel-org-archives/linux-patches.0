Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FC61DE2A5;
	Tue,  8 Oct 2024 12:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391239; cv=none; b=eKBk+ooYOhY5jx7C/1FBthxKYOWGW6yQmu9/fhjPjiCJbbsFcgE1k5fMMWy789HJtb89CAsF510RGhUdu6YlfLhK/6GRMcOtrQD9KdjhnzExzyl08mGXXr1cfKgMHZhHakxgjrDXdv6cnbwAXDDS/uo1MloElD7eiBW15hbBQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391239; c=relaxed/simple;
	bh=WE5TWBchW2WYi+88TcHXaBIgarP95du5gDDegbMn2go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMgUwa29+cR7Yc1whyW8fe5AIuqcn0titR2DFHzzS6rowiHRNtE7MjMBMo9NPaCWn94HGDVD3dOkM2dg6heWtSl/4+OSKCFR4JdyoS+LBZ8DHwKOo1LvqbzTEjWupvsmXpyXxqN0uBl4tou/Oy0Eio1OnqCNb9SabF9aGvzdcfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2WKF7nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2WKF7nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F282EC4CECC;
	Tue,  8 Oct 2024 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391239;
	bh=WE5TWBchW2WYi+88TcHXaBIgarP95du5gDDegbMn2go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2WKF7nAqdOIxoIEmMInvD7MibdRv+62Q2PIeO1LKwjMV4bTnNenaV5vO4vvDDu3i
	 fmb+fET0X0Wk3eXei9uAuYdwM6zNW+TfJkqbGciWoy17QYJKje9kVG+nQ0aZFMc7Lj
	 14aVxt6NJ4pmoDNbpksTHgdbPy4SNaLIaafGnZzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 052/558] iomap: constrain the file range passed to iomap_file_unshare
Date: Tue,  8 Oct 2024 14:01:22 +0200
Message-ID: <20241008115704.269748768@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f420c53d86acc..389de94715b53 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1382,11 +1382,15 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
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



