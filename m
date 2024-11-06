Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930561CC89D;
	Wed,  6 Nov 2024 12:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897132; cv=none; b=FkQ2AFixtN3BqjtDlalAeVgmeLXyeeg9MUdsII0yiSeYZcmI2jxyAbAVL6uW9B2VPH1vZWOm4ecnlPxxgM0uoGYFChUKsKSnE8KZJj88+En40jq3YycUaVmZAKN8Dq3mab3mTDvHKEWpNNrlmE3Hla8t/3EZsJF6BfEWjciRMzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897132; c=relaxed/simple;
	bh=dqTHc+J7x5ljHQrFYP3Ymnw0zxV8drvXollovbOGY5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQLKNlm4djz1NKx064tYq0oR3ztNvZPVpi67o8NDBw04PP+ED/d0+CjXvO/0v/l274G+tW/5VY7Eg3Puc7n0qrjD4VrVoNlKMXAgJJ/Nk89Fvn0yxwvQisy/qHLN0TUwlwUURVGRKblYOet7xZg9bMUnfPodXbnd8S9lU6iN+M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZDaE2Rd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZDaE2Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1863DC4CED4;
	Wed,  6 Nov 2024 12:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897132;
	bh=dqTHc+J7x5ljHQrFYP3Ymnw0zxV8drvXollovbOGY5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZDaE2RdhkyYw4we95tuHRGHJ3kOT1lO3GbgFo+PBCbEOPx3vtpCWgyX/rcHfclJZ
	 8Lj+5qlymD5BnKHzezRTNZLQKT8lfYKo+GFQNye84zKS60ZghAxC+kL5fDG8QUtzqT
	 BqM69uFCavXoOUs50yCVgP5uqmzVSAZl76MObOkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/126] iomap: share iomap_unshare_iter predicate code with fsdax
Date: Wed,  6 Nov 2024 13:04:02 +0100
Message-ID: <20241106120307.221577799@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 6ef6a0e821d3dad6bf8a5d5508762dba9042c84b ]

The predicate code that iomap_unshare_iter uses to decide if it's really
needs to unshare a file range mapping should be shared with the fsdax
version, because right now they're opencoded and inconsistent.

Note that we simplify the predicate logic a bit -- we no longer allow
unsharing of inline data mappings, but there aren't any filesystems that
allow shared inline data currently.

This is a fix in the sense that it should have been ported to fsdax.

Fixes: b53fdb215d13 ("iomap: improve shared block detection in iomap_unshare_iter")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/172796813294.1131942.15762084021076932620.stgit@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 50793801fc7f ("fsdax: dax_unshare_iter needs to copy entire blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c               |  3 +--
 fs/iomap/buffered-io.c | 30 ++++++++++++++++--------------
 include/linux/iomap.h  |  1 +
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 72a437892b4a4..74f9a14565f59 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1231,8 +1231,7 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 	s64 ret = 0;
 	void *daddr = NULL, *saddr = NULL;
 
-	/* don't bother with blocks that are not shared to start with */
-	if (!(iomap->flags & IOMAP_F_SHARED))
+	if (!iomap_want_unshare_iter(iter))
 		return length;
 
 	id = dax_read_lock();
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index b1af9001e6db0..876273db711d1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1084,19 +1084,12 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
 
-static loff_t iomap_unshare_iter(struct iomap_iter *iter)
+bool iomap_want_unshare_iter(const struct iomap_iter *iter)
 {
-	struct iomap *iomap = &iter->iomap;
-	loff_t pos = iter->pos;
-	loff_t length = iomap_length(iter);
-	loff_t written = 0;
-
-	/* Don't bother with blocks that are not shared to start with. */
-	if (!(iomap->flags & IOMAP_F_SHARED))
-		return length;
-
 	/*
-	 * Don't bother with delalloc reservations, holes or unwritten extents.
+	 * Don't bother with blocks that are not shared to start with; or
+	 * mappings that cannot be shared, such as inline data, delalloc
+	 * reservations, holes or unwritten extents.
 	 *
 	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
 	 * unsharing requires providing a separate source map, and the presence
@@ -1104,9 +1097,18 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 	 * IOMAP_F_SHARED which can be set for any data that goes into the COW
 	 * fork for XFS.
 	 */
-	if (iter->srcmap.type == IOMAP_HOLE ||
-	    iter->srcmap.type == IOMAP_DELALLOC ||
-	    iter->srcmap.type == IOMAP_UNWRITTEN)
+	return (iter->iomap.flags & IOMAP_F_SHARED) &&
+		iter->srcmap.type == IOMAP_MAPPED;
+}
+
+static loff_t iomap_unshare_iter(struct iomap_iter *iter)
+{
+	struct iomap *iomap = &iter->iomap;
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
+	loff_t written = 0;
+
+	if (!iomap_want_unshare_iter(iter))
 		return length;
 
 	do {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0983dfc9a203c..0a37b54e24926 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -264,6 +264,7 @@ bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
 void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
+bool iomap_want_unshare_iter(const struct iomap_iter *iter);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 		bool *did_zero, const struct iomap_ops *ops);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-- 
2.43.0



