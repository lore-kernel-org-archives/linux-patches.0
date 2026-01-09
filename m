Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9113D1946C8;
	Fri,  9 Jan 2026 12:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960155; cv=none; b=gGKFdr3zW0Yjw3YYVpEqbxkFB+7HJOg6mzZms9Zv0/lecYTm5kL5Bdk0fdqYuOGcdU7FtC8DhEOA/sq/lV+JJx7l96PTv/g8GZv22ZAVdnDU+XYgrh7vA1Rb4RLCXrrIS3Q+rhzp4Nlo9ZNrLSOHj4rAxIjSqrzwqhXmvt+hS94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960155; c=relaxed/simple;
	bh=RA6U0ctk1Dg5I5P2MVVnvJPxxFkPyaNscnFGF1DHs+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVxIRDJqCakOvF9kjjL8oEerAc79BEQoTfj/xaSYDQs9dXbPl0HEk0L8zhZwDMwW1ma95+6uwVnqOWs2kcSobHt2Sa+EsVLbDQjcgft9HydxKLOOt++nlo5WTnzc4xswDe5Ic5XjQ8Sbb8PASRfYnqcgja7alhP4xkitO72RYPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8SbrQxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8SbrQxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1894C19422;
	Fri,  9 Jan 2026 12:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960155;
	bh=RA6U0ctk1Dg5I5P2MVVnvJPxxFkPyaNscnFGF1DHs+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8SbrQxw7or5ew1TP4AKj5FAzniVH7TM1UtOQV/X1lsd31QbGEcjFQnACG/rpiERe
	 /LatztTt+T3GJWHBpcFdEh+6L3PRCPlcA3cYZy1U8OuYqCPkJh6XYsIfc5aMpHDYfA
	 cyIvxNbPW1INYaxVMhnv7kYPuOvFxttsU9fNiv5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/737] iomap: account for unaligned end offsets when truncating read range
Date: Fri,  9 Jan 2026 12:37:23 +0100
Message-ID: <20260109112145.442068374@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 9d875e0eef8ec15b6b1da0cb9a0f8ed13efee89e ]

The end position to start truncating from may be at an offset into a
block, which under the current logic would result in overtruncation.

Adjust the calculation to account for unaligned end offsets.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Link: https://patch.msgid.link/20251111193658.3495942-3-joannelkoong@gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 13a5f4422c797..7e9480150d61e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -188,6 +188,22 @@ static void ifs_free(struct folio *folio)
 	kfree(ifs);
 }
 
+/*
+ * Calculate how many bytes to truncate based off the number of blocks to
+ * truncate and the end position to start truncating from.
+ */
+static size_t iomap_bytes_to_truncate(loff_t end_pos, unsigned block_bits,
+		unsigned blocks_truncated)
+{
+	unsigned block_size = 1 << block_bits;
+	unsigned block_offset = end_pos & (block_size - 1);
+
+	if (!block_offset)
+		return blocks_truncated << block_bits;
+
+	return ((blocks_truncated - 1) << block_bits) + block_offset;
+}
+
 /*
  * Calculate the range inside the folio that we actually need to read.
  */
@@ -233,7 +249,8 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 		/* truncate len if we find any trailing uptodate block(s) */
 		while (++i <= last) {
 			if (ifs_block_is_uptodate(ifs, i)) {
-				plen -= (last - i + 1) * block_size;
+				plen -= iomap_bytes_to_truncate(*pos + plen,
+						block_bits, last - i + 1);
 				last = i - 1;
 				break;
 			}
@@ -249,7 +266,8 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 		unsigned end = offset_in_folio(folio, isize - 1) >> block_bits;
 
 		if (first <= end && last > end)
-			plen -= (last - end) * block_size;
+			plen -= iomap_bytes_to_truncate(*pos + plen, block_bits,
+					last - end);
 	}
 
 	*offp = poff;
-- 
2.51.0



