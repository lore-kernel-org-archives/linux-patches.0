Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4504233375D;
	Fri,  9 Jan 2026 12:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960152; cv=none; b=rKfBJ0z0GbbQJ+wYTjMKPV6FkPi3UqSeJjXu/q09rbvRIRDWtvfVV2h9ippQQkE1LD0m3COgmSnuATCHGts2X3M12np2CmpKHvvAHEXvnt5CBJ1cxJQ6lncxjcZuhOG09An1TvlefwOcBvwU/0vcWMe5k44qRt9LwZjlcYdaY1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960152; c=relaxed/simple;
	bh=Li9cNUEdhozLQZV3HklRIP/pJc3rkMj7meJCKzK0l+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aI5m3oZpnauB5zA82kA5USzFhLZJwxwWYv3y6auZYnxsNJMAoXXo88rkUjI8pEBTqAUhifuo8CdaVBeUVK/5qN9ZmCVKsESjbne7O2SPq7cVwaTws1jmL5GOARiKJ5Us0D6aa/q2RkM++wB+sKRneCkqi3SVXhNyon4xUEaLcf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEI/V0Tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEI/V0Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1382C4CEF1;
	Fri,  9 Jan 2026 12:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960152;
	bh=Li9cNUEdhozLQZV3HklRIP/pJc3rkMj7meJCKzK0l+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEI/V0TpyPwOYGij+LA2afoOdHNKtZLJPykcknnBYBKrjkwPyPMvw2eo5NfrlR3if
	 7dCu0fYIgtepl7bNHxd2kEtUqr5Ud/aD/RF5sqFFZr+Wqurk0ckrS3jcCozkIAO57I
	 urCd0Sm0+Znm3rTKQAOLmOa2SGNLr8DBF4X7tkAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	syzbot@syzkaller.appspotmail.com,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/737] iomap: adjust read range correctly for non-block-aligned positions
Date: Fri,  9 Jan 2026 12:37:22 +0100
Message-ID: <20260109112145.404813465@linuxfoundation.org>
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
---
 fs/iomap/buffered-io.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7ffdf0d037fae..13a5f4422c797 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -211,17 +211,24 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	 * to avoid reading in already uptodate ranges.
 	 */
 	if (ifs) {
-		unsigned int i;
+		unsigned int i, blocks_skipped;
 
 		/* move forward for each leading block marked uptodate */
-		for (i = first; i <= last; i++) {
+		for (i = first; i <= last; i++)
 			if (!ifs_block_is_uptodate(ifs, i))
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
 		while (++i <= last) {
-- 
2.51.0



