Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC21F346FD1;
	Tue,  6 Jan 2026 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719773; cv=none; b=T5KNp9RG1h2ULfRcsCPlYFwFwiN6omzC9S30roGKTcNrZNQHw5h1KbdedKDcvPPPU9yHWeRfjBm46NYZICihrbKoVSEHSOJLYpdIFR93/e1r4+7AvEX5WZlxCScLRl8Cm2ClCN/FSYl9tCk6pORO3ZrWmmoAbVTILetp46hJxEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719773; c=relaxed/simple;
	bh=dbWVyOiye5nsmwFz/UoBwJ2EB5XfUinehNL5UM1JdmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoTbApiAP2g6yoTLm521zg5Z2lGNJ04MGgsWEtckk8RhG5itLG87cwsKXJ1YuV8D/ZTNp3LqO5WLJMUJP3ajvDeFHTn59HLhBH9fYZ/DixA69og/P9lZQL+H5OIFxWBlmR7Rj3xitIJIwRdYaRdmd0mYbUfleKZXnNQKo8IASOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5BifPsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5BifPsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF9FC116C6;
	Tue,  6 Jan 2026 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719772;
	bh=dbWVyOiye5nsmwFz/UoBwJ2EB5XfUinehNL5UM1JdmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5BifPsa+DLtcpNOsMRXR3ZBIKE2Fv5hX9ukS1xEcPHR841oou7XzasXKDRIDNoyM
	 63hIvj1Fv/jx0CcynUe6vmvthuIS/8MYnrJA0IKZ6gn1+XivUVjHiZXWVIFGQNbdhJ
	 hN/iE6vdTgkiW2Lb2iHTlCbaYql3+Nqv2LJZO7Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/567] iomap: account for unaligned end offsets when truncating read range
Date: Tue,  6 Jan 2026 17:56:29 +0100
Message-ID: <20260106170451.614244535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index 258ac7bf658fd..397c96c25c31f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -227,6 +227,22 @@ static void ifs_free(struct folio *folio)
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
@@ -272,7 +288,8 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 		/* truncate len if we find any trailing uptodate block(s) */
 		while (++i <= last) {
 			if (ifs_block_is_uptodate(ifs, i)) {
-				plen -= (last - i + 1) * block_size;
+				plen -= iomap_bytes_to_truncate(*pos + plen,
+						block_bits, last - i + 1);
 				last = i - 1;
 				break;
 			}
@@ -288,7 +305,8 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 		unsigned end = offset_in_folio(folio, isize - 1) >> block_bits;
 
 		if (first <= end && last > end)
-			plen -= (last - end) * block_size;
+			plen -= iomap_bytes_to_truncate(*pos + plen, block_bits,
+					last - end);
 	}
 
 	*offp = poff;
-- 
2.51.0



