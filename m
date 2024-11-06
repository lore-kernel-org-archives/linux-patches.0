Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA8B1F76AD;
	Wed,  6 Nov 2024 12:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897032; cv=none; b=sBNUWCmUJM9hdk8GxzJQn06/OTvjw5JdVGDFVGAnIkroGNIlm9jYIxKJjfoh6iSCqLHdRO8F4tWLxTuc4oJlYHW/i8Yc1fcHx07OHgiFbDD/lCv/3VbWMSQDqyN78ODk64MuG4jvp8u2BP2vimYgaln+ngLyEK3ZVMZrC/hhfjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897032; c=relaxed/simple;
	bh=bolEM6u1OYbYW7F7uY4lLki8qDACiQ5UqOza+fQiBVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K4P5NME6k078zi5t5LMuOg/4cf9PVScqHCNCurEQMR0IoXcc2840ywF21e5BM++8ou8wdUigdz3BPg6M+M4y0h5q65JW0bo+Eb6XCF0tJCo2upqDf6DmqLYz4GUYEFYpKKoCNDsxIgXdQ/bA43cIdP/2dGDHAC7iBuj7i4t7WPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xThr3np; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xThr3np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31208C4CECD;
	Wed,  6 Nov 2024 12:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897032;
	bh=bolEM6u1OYbYW7F7uY4lLki8qDACiQ5UqOza+fQiBVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xThr3np4Yg0udjmzObzAzB5TDI4NR8M5ChWbZNNekp4j8Hi2BCysW83TPiR/Lc1a
	 YJOshvtDmuRQhqGXtzKZg1j5F7M9NrUeEDW0ZgdY3TuZQF/LGWXKcu//XwOe4kPXin
	 8q6CNlul4tPnXBhPIX26Smxz2AGU76Q5TCjbB2Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/126] iomap: turn iomap_want_unshare_iter into an inline function
Date: Wed,  6 Nov 2024 13:04:05 +0100
Message-ID: <20241106120307.299570471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6db388585e486c0261aeef55f8bc63a9b45756c0 ]

iomap_want_unshare_iter currently sits in fs/iomap/buffered-io.c, which
depends on CONFIG_BLOCK.  It is also in used in fs/dax.c whіch has no
such dependency.  Given that it is a trivial check turn it into an inline
in include/linux/iomap.h to fix the DAX && !BLOCK build.

Fixes: 6ef6a0e821d3 ("iomap: share iomap_unshare_iter predicate code with fsdax")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241015041350.118403-1-hch@lst.de
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 17 -----------------
 include/linux/iomap.h  | 20 +++++++++++++++++++-
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 876273db711d1..47f44b02c17de 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1084,23 +1084,6 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
 
-bool iomap_want_unshare_iter(const struct iomap_iter *iter)
-{
-	/*
-	 * Don't bother with blocks that are not shared to start with; or
-	 * mappings that cannot be shared, such as inline data, delalloc
-	 * reservations, holes or unwritten extents.
-	 *
-	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
-	 * unsharing requires providing a separate source map, and the presence
-	 * of one is a good indicator that unsharing is needed, unlike
-	 * IOMAP_F_SHARED which can be set for any data that goes into the COW
-	 * fork for XFS.
-	 */
-	return (iter->iomap.flags & IOMAP_F_SHARED) &&
-		iter->srcmap.type == IOMAP_MAPPED;
-}
-
 static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0a37b54e24926..1de65d5d79d4d 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -251,6 +251,25 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 	return &i->iomap;
 }
 
+/*
+ * Check if the range needs to be unshared for a FALLOC_FL_UNSHARE_RANGE
+ * operation.
+ *
+ * Don't bother with blocks that are not shared to start with; or mappings that
+ * cannot be shared, such as inline data, delalloc reservations, holes or
+ * unwritten extents.
+ *
+ * Note that we use srcmap directly instead of iomap_iter_srcmap as unsharing
+ * requires providing a separate source map, and the presence of one is a good
+ * indicator that unsharing is needed, unlike IOMAP_F_SHARED which can be set
+ * for any data that goes into the COW fork for XFS.
+ */
+static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
+{
+	return (iter->iomap.flags & IOMAP_F_SHARED) &&
+		iter->srcmap.type == IOMAP_MAPPED;
+}
+
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
 int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
@@ -264,7 +283,6 @@ bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
 void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
-bool iomap_want_unshare_iter(const struct iomap_iter *iter);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 		bool *did_zero, const struct iomap_ops *ops);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-- 
2.43.0



