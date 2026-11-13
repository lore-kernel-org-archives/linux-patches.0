Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585822;
	b=TDbeZIqbPq3826WMPSTjnr9+vkrRRvLrlYQs/13bGQtBS13ZRNRTlbdDZYu+qLxSkLfj
	 gMRVw5EfhD8gZwZxq+1yngM2H3G99evMGYWMt+cT1+taAiPa/GRcEm0jE+WKDPziMG9KY
	 Ih/FyWF6gHF0ZLsJnpKgzU0j34iritfAdrytyLs++/1sz9XxTs/tZaQd3iZWPI8G3C6FE
	 6vX0fAgX6rBjzt+Bpvq4Enq2ixWYnwjfJr3oMi0Xsvg3J5gfCQ7VI69F1xXnsmuI4hXlI
	 v998rL3ET44aTOon6pAgpbxO9K+pn9TqRZ7JPmvHgWRQ/VlbYJuMYaFmI4gZnPeUE3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dggJ2Nr+DGNMc+4yoGC8gvmvmuSgH3DJk+ZFlUebF3U=;
	b=soCRnyYFJkAxua9tgtNJCSJH21R7Y23qAypcsvYeBHAp1KE4rzSJgo3lFoP0TiqnnHUJ
	 Ax6SEjsBbFobAPK0QiA/90+GP2Lg7npmVv/rMjKHfV8CHudTzvDHWfb//u8D72UKh/fUw
	 WoKqScSNn4Kgakc0HsbJahqaK5nOkwN1DsT0q4FP12EJuQZ8G2IAnXdxUusfhEbiB9QE8
	 KeY9+3xbiBxaS3JkBkgRfoF9Rsm8CmYgKyu1xjCpE9v8NTeCCSFAJ04WosF+myWHCxdA8
	 20ZNXMERyanFfwm34IDW2y0fZFnzwQ2mnL4fE36oaB1EnkiXh70Mboy5R6SxPsesQ4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zGoRs/9X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D587E606C56D;
	Fri, 13 Nov 2026 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGoRs/9X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CC41F000C9;
	Fri, 13 Nov 2026 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585822;
	bh=dggJ2Nr+DGNMc+4yoGC8gvmvmuSgH3DJk+ZFlUebF3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGoRs/9X+BRB51Q4gxDkNR5+y3FgR0gWnt1cS71nGtcpCkOoqnbCCgTplQjvVJSPt
	 B2LQReNMXRzgXPt80UWGvlbjFS7MMSp5LSDfPKOdxIkNBtyD8KsTlwLbFsd9ecph6v
	 V4g8yZkY2yI1lweVfjyuVSTGPRUQNg+B+6x0s1rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 403/507] ext2: preserve IOMAP_F_DIRTY for extending direct writes
Date: Fri, 13 Nov 2026 10:51:47 -0500
Message-ID: <20261113153810.403858070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a9245f0cda4d4..53edda7217f33 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -801,6 +801,12 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
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
@@ -808,13 +814,6 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
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
 	iomap->bdev = inode->i_sb->s_bdev;
 
-- 
2.53.0



