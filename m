Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590486;
	b=tqeZf5fM/bWYeKM99Dzq64aPp7bcDjJvxlbl+EKWH0vGvr/xbz8I529iq1lcH9lORnNL
	 ieStHS3DnssyAA5y0fQs+KqIq+rofXP2Cq8kMkDII0yEHvHvBRHizUV2yNrulZ+IZQ6tc
	 myY4QXqy1k7M8icN5trKqkCJ5otLdhhFMSmjAm3H1HAX03BJr5hyWaMPn+PzIZCWzkgYr
	 vtNWnfmUn1TajPrstSosevQ142F1KF7+tc0EyfJ5msfMyI00oXWjZvg/eejbpNC2THrdQ
	 mCOG8Z5J374gk+9bZnvNJopfMDhVL+5nlu4bApatvkP/t2732ctVVetz7yDXAzckCyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UfRT/f43VberrS9x9VukWvFCFynfMEEGxpeIQQKzaLM=;
	b=MoA0iS6WQiW2WAdLY2uQUWdRGb3xGFNti9tLx2ojfHS7L8cBJsbZNOaLsQIPcqET27hq
	 uuskaeQli0Mu0griCTwwXsTEIVLPb0+LUCYoyy+gEnH1F9iWFj21kSsen4oyssSvEszUc
	 9zHruB3kw0cmbeVsGzNGa8HqTUBpy+L3HBATSRBxNKXp/AMZPAdCTL7JmQn6w18alwU9J
	 qV9fUJrtFMYNKSsyp6y6KJrQG00Idc6PR8LJdfVHCyJH4OLwTweCiwXRSBbvd6HKOfPA7
	 s7mJGTN5D8hOLjQA+8TRr7kwrTZrKDeUkj1LqEP3CqBU2fA6h16zDeuj2wwMXFqMjbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POhavuUb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B4C606B819;
	Fri, 13 Nov 2026 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POhavuUb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4269C1F000C4;
	Fri, 13 Nov 2026 17:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590486;
	bh=UfRT/f43VberrS9x9VukWvFCFynfMEEGxpeIQQKzaLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POhavuUbUb4uUM6LXRY1C5lhj3xGrcTu0itazcw/z3liMBwV3vT1aa/eBXAZoFNN/
	 GwC/FrprzwXyQT2fpskSNotS+40uNqAg5E8DeiUuMyCHXa7CIHJ4erbIUr7V9ZExGU
	 JuR2ZnhSYt5dyuOWmMM52AVVe5PknQLrNQbsGm5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 437/686] ext2: preserve IOMAP_F_DIRTY for extending direct writes
Date: Fri, 13 Nov 2026 10:49:30 -0500
Message-ID: <20261113153835.707490009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 50d431949fd4b..12f9b1b36e056 100644
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



