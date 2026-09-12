Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B55356742;
	Sat, 12 Sep 2026 09:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204444; cv=none; b=IazuEVg329l1pkRmKrzio0UFRv5D6VpJrfFZah6hAE+7ut2BZ9AVIiaTcnybTqqECAPPk2E+YMUpnqP7IfAkpxrdJpfBKjM1sny1vXFoh153XqNjEP4pZrsHj/D1XnvuBYuHSnKYiHh5R2CSrMi50XHcgKyspnSiOEDDOGxoAhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204444; c=relaxed/simple;
	bh=w7oSB7DGEFJ3aoXfVDYhfJzcf6qEK2cQjsN9/iQN6bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANevYPi7PgpGmhL8kWBwNgrlsbwfnDd9u+nrP0gAkqtlYTR0XWvSslLUneSvfd4pY8RolK8TTJYgEHVGoM+59YZgMNxsKuQ5myn8+U6HfQQ19pZ+6RFNK+CApkpyVbc+Nz0OResltrTSiT05XAfrDKtVz2/HintjbDTKx9GeleQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CidTVzC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CidTVzC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1441F000FF;
	Sat, 12 Sep 2026 09:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204443;
	bh=eUkvII8Mb2sSpfA73rzVS1cux/0KwWuysjqW8wWSxOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CidTVzC9J2sPJ2Wk+dh4yI/XuJgD2UmQVW8Pxql5vsZLXcr3zt82kO2Eo2MfyLtoV
	 em9swBc8NCVK/Te5+/07FL1+WZSUVQ/xO/bvj/gGN3GngwLJw0j4XwgcxmXSUFE3ai
	 z/GC4DlFnpcuInu/uhZ+ELHWsXoj7oFzRUc1jX74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1615/1815] iomap: add ->iomap_next()
Date: Sat, 12 Sep 2026 08:56:05 +0200
Message-ID: <20260912065726.904423353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 26dfed9c7a289089b76cff9ab9e4c66b6f90e872 ]

Have one ->iomap_next() callback instead of ->iomap_begin() and
->iomap_end(). ->iomap_next() finishes the previous mapping if needed,
and produces the next mapping.

Collapsing to a single callback lets a performance-critical caller
inline its iteration loop and pass its ->iomap_next() function as a
compile-time constant, so the compiler can devirtualize that callback
into a direct call instead of an indirect call through a function
pointer.

iomap_iter() uses ->iomap_next() when the filesystem provides that
callback and otherwise falls back to the ->iomap_begin()/->iomap_end()
path, so filesystems can be converted one at a time.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Link: https://patch.msgid.link/20260729192737.3190206-6-joannelkoong@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: d9e00c457d4a ("ntfs: serialize resident iomap reads with mrec_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/iter.c       | 8 ++++++--
 include/linux/iomap.h | 9 +++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index bf7d4cccc1a7e..c445a38b6285d 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -118,8 +118,12 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-			ops->iomap_begin, ops->iomap_end);
+	if (ops->iomap_next)
+		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
+	else
+		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
+				ops->iomap_begin, ops->iomap_end);
+
 	iter->status = 0;
 	if (ret > 0)
 		iomap_iter_done(iter);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 88ef1553cf012..12eb908380a2d 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -230,9 +230,18 @@ typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
 typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
 		ssize_t written, unsigned flags, struct iomap *iomap);
 
+/*
+ * Produce the next mapping (finishing the previous one if needed).
+ * Return 1 to continue iterating, 0 if the range is fully consumed, or a
+ * negative error on failure.
+ */
+typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap);
+
 struct iomap_ops {
 	iomap_iter_begin_fn iomap_begin;
 	iomap_iter_end_fn iomap_end;
+	iomap_iter_next_fn iomap_next;
 };
 
 /**
-- 
2.53.0



