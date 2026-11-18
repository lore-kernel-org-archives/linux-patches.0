Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037880;
	b=g9VmBAr894ovxMOvf2JT/GuLV+4mYp4HA7WPWd6L2495cWHn/AedD9bYs05FW2jUU0+2
	 gltuyGa07v7tjL7fGIKD5s9AzzjPSztddWvDqTHrXLLx4QTfmmpW5gAml+TX/VYq3Rvp9
	 bLQpZ7pZdShLXTn32JR7UOxgV7GuVp6wucnP0tLjzG8glENBk6P+f6g7T9LKoQ9ivzBoK
	 zgUKe29cFyCp2VqFv3+Q6U87GeQG1fB94fBG5YcIvgExrq40Rwcfh1XGi0OahZoIicCm5
	 soKSDcIFdYtFz7QXfAJ2jGHr3h1nIcSezAMdEf+DfikeSRh8+haldju5Ws1v18aC+4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/TnRdd6xrHnnj8Dft4eJvDYenH13vUU8l7iU5EGPimk=;
	b=RzuMmRKPvNUbuEQ/4vjd/S9cYnYazEcHvtGSRiqjiJd3pEUA17WYkFotfcxIA3F0MwWd
	 rWwwyLI0oEfBZx7EbwCkjEYcurxlBRQw59vaUTXabLPu4Bi2ZSLs5zig9omY+wP3S+1hw
	 8mOJHaxR7SigNTEWKiKpr68CNgfmGKmV4MuZyPCEVl7ED2yAm7QUuqsuiovO/voyRxwXM
	 g4b1ZEg84SzQt1SnTOahajK0JcfwWbPUtbXlujmpdhL+H4T+lNkeuYOqjDlqqYWRUlK59
	 UV9Py7vT23Lm/1oNkZOVCA/KoigSeznnushJHqaYJaleG9UPxrI1JnpfpyszyoIMraA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q35LsNFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC6D60A2607;
	Wed, 18 Nov 2026 21:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q35LsNFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D761F000C4;
	Wed, 18 Nov 2026 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037880;
	bh=/TnRdd6xrHnnj8Dft4eJvDYenH13vUU8l7iU5EGPimk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q35LsNFK0+WvAB+81y5vYWA0tf/E/5kiaJK4GPIMqYI5dS/EqBGGvQjx6KdgLvuSu
	 kHYlnohos0uQiZS8ranm2HW6CHVpaOvUK9mCGHElpBk6QRERRQinMwbS5fXaSwVsGL
	 NbcKquwX8Yf0wMcOSZ9Pidl3nhE9hivXfptyTjoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1549/3318] ext2: preserve IOMAP_F_DIRTY for extending direct writes
Date: Wed, 18 Nov 2026 15:36:11 +0100
Message-ID: <20261118150407.471500684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 4f91b042af212ca0b610e43f9a975ddc7f0d0923 ]

ext2_iomap_begin() sets IOMAP_F_DIRTY for writes that may extend i_size,
but clears the flag after ext2_get_blocks(). When the write uses an
existing mapped block, iomap can then use FUA and skip
generic_write_sync(), even though ext2_dio_write_end_io() updates the
inode size. An O_DSYNC write can therefore return without persisting
the new size.

For example, on a FUA-capable device, a 512-byte O_DIRECT|O_DSYNC write
at offset 512 into a fsynced one-byte file returns successfully and
extends the in-memory size to 1024, while an immediate read of the
on-disk inode still shows size 1. An explicit fsync persists the new
size.

Move setting of IOMAP_F_DIRTY after the initialization.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261029013616.97194-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/inode.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e93db18b14664..f4e4eb9396766 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -824,6 +824,12 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	    (first_block << blkbits) < i_size_read(inode))
 		create = 0;
 
+	ret = ext2_get_blocks(inode, first_block, max_blocks,
+			&bno, &new, &boundary, create);
+	if (ret < 0)
+		return ret;
+
+	iomap->flags = 0;
 	/*
 	 * Writes that span EOF might trigger an IO size update on completion,
 	 * so consider them to be dirty for the purposes of O_DSYNC even if
@@ -831,13 +837,6 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 */
 	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
 		iomap->flags |= IOMAP_F_DIRTY;
-
-	ret = ext2_get_blocks(inode, first_block, max_blocks,
-			&bno, &new, &boundary, create);
-	if (ret < 0)
-		return ret;
-
-	iomap->flags = 0;
 	iomap->offset = (u64)first_block << blkbits;
 	if (flags & IOMAP_DAX)
 		iomap->dax_dev = sbi->s_daxdev;
-- 
2.53.0



