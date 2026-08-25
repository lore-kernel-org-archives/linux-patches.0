Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F032ED843;
	Tue, 25 Aug 2026 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666277; cv=none; b=Vt30an7GKYOSxRDXb/T5Mce6J4ntSN9rcL8Ij5CmCJ6dSA/MhEcyqlAovinpnQWRyARBkhw2g8/eiRcpEYePboKtPvxMEr8VpXKzjrlfdfKoQiUmnziNSR0ibzu7uKGIIB7pnkjyD7H4F+OQKvxTLfqaV+s6DpNC71LdtiY07wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666277; c=relaxed/simple;
	bh=PsIWC4iouxs6ys8yAt4f3qAKfaPexdvh0tuv71kbmVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyykfSfWb7o4LrSvGIHpnziPVUDq5aF8BYQd7JOlNTCzJgBGLZA4BnVvdZl1Ww7LubcbCYCPzzN1wskYhzREXaZk3hPR7Ra7jqNDXgJqSa6JohfVGOZmT4lWmKJuuVr2hNQYr+ts0Vto+gE1UL2+N2gfaTeAwNwjTYIvus9/TKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVR7RdM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVR7RdM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BA11F000E9;
	Tue, 25 Aug 2026 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666276;
	bh=PIgVLr0eSZBc4zr1iAlmQ3G7LrzXrJLoDnnrmRvcRD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVR7RdM/VJ7Zw58bWFnGpz2O1QQZDNcwulmfHjg5H5IMdF06d91XL7YQUQIJJxw7s
	 N38v1gxCosUtPSs5geZpaBZSwhNJYfTj64ZRZD3/WeaKZoW3tm3C2tRJjWLkqyV9Z7
	 BhW1R4PWUHrMKRqEewGZbh4X5sr9FPg32BpJgMOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	syzbot@syzkaller.appspotmail.com,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.15 64/76] iomap: adjust read range correctly for non-block-aligned positions
Date: Tue, 25 Aug 2026 15:26:57 +0200
Message-ID: <20260825132544.078364078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 7aa6bc3e8766990824f66ca76c19596ce10daf3e ]

iomap_adjust_read_range() assumes that the position and length passed in
are block-aligned. This is not always the case however, as shown in the
syzbot generated case for erofs. This causes too many bytes to be
skipped for uptodate blocks, which results in returning the incorrect
position and length to read in. If all the blocks are uptodate, this
underflows length and returns a position beyond the folio.

Fix the calculation to also take into account the block offset when
calculating how many bytes can be skipped for uptodate blocks.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 87a4f5a2ded0e..6c76dba0a61c9 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -103,17 +103,24 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 	 * to avoid reading in already uptodate ranges.
 	 */
 	if (iop) {
-		unsigned int i;
+		unsigned int i, blocks_skipped;
 
 		/* move forward for each leading block marked uptodate */
-		for (i = first; i <= last; i++) {
+		for (i = first; i <= last; i++)
 			if (!test_bit(i, iop->uptodate))
 				break;
-			*pos += block_size;
-			poff += block_size;
-			plen -= block_size;
-			first++;
+
+		blocks_skipped = i - first;
+		if (blocks_skipped) {
+			unsigned long block_offset = *pos & (block_size - 1);
+			unsigned bytes_skipped =
+				(blocks_skipped << block_bits) - block_offset;
+
+			*pos += bytes_skipped;
+			poff += bytes_skipped;
+			plen -= bytes_skipped;
 		}
+		first = i;
 
 		/* truncate len if we find any trailing uptodate block(s) */
 		for ( ; i <= last; i++) {
-- 
2.53.0



