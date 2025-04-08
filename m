Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0289F269885;
	Tue,  8 Apr 2025 11:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113460; cv=none; b=hmuumU36rl0uAQ/j9IDSaCPtqKykj0EGv/0qVR0HQuN2k98Q9tpc1QLXMQ5MgjCS+GvDcLAQIML1VMLn8no3kRPdd3fCThCikEwyN2r9WBeI75HFSxrNOvar/1/kqKQVHQHpfljYO6XiCJ2pochw/JdVw+0RsDCAmr76GAWkgbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113460; c=relaxed/simple;
	bh=6vrp2dhiWkBJA42bvN85osYUzuF4IQ6+np81/jrDekY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKg7H+SK9BwAmTKN2IcNxQX6UW4Yh326SFns+N9SpvbolVRBZv7+B3NNIivRoHiFvGPjyx77HBxNHCNp6QnoRHuz6xjbXJLDbfaQkWTktgOunpDAyJZrJOYXHHlVuy3Rlp4rHPnrgFzxgybZDp5BXjZtjo5ZySZeHW1Kej2NO1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiHaTEfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiHaTEfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842E2C4CEE5;
	Tue,  8 Apr 2025 11:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113459;
	bh=6vrp2dhiWkBJA42bvN85osYUzuF4IQ6+np81/jrDekY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiHaTEfeZVNS5xMvNA8uu5efHaXNoTMwyK1xmqDSnrMNCii0XMcmTRy1LCiXJZy+B
	 ZuSLI9UIstUWuN22oZhErdNw8C3fen6RflGMCNgF2vAciK82apc5fkvdPePPxAPx+A
	 1HaIlqgLu5zf13Sa4N3qMVsqI9sRvrAdk54Wv6N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Tatham <anakin@pobox.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/268] affs: generate OFS sequence numbers starting at 1
Date: Tue,  8 Apr 2025 12:49:39 +0200
Message-ID: <20250408104833.080249349@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Simon Tatham <anakin@pobox.com>

[ Upstream commit e4cf8ec4de4e13f156c1d61977d282d90c221085 ]

If I write a file to an OFS floppy image, and try to read it back on
an emulated Amiga running Workbench 1.3, the Amiga reports a disk
error trying to read the file. (That is, it's unable to read it _at
all_, even to copy it to the NIL: device. It isn't a matter of getting
the wrong data and being unable to parse the file format.)

This is because the 'sequence number' field in the OFS data block
header is supposed to be based at 1, but affs writes it based at 0.
All three locations changed by this patch were setting the sequence
number to a variable 'bidx' which was previously obtained by dividing
a file position by bsize, so bidx will naturally use 0 for the first
block. Therefore all three should add 1 to that value before writing
it into the sequence number field.

With this change, the Amiga successfully reads the file.

For data block reference: https://wiki.osdev.org/FFS_(Amiga)

Signed-off-by: Simon Tatham <anakin@pobox.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 04c018e196028..8fd1a7c5958a8 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -597,7 +597,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		BUG_ON(tmp > bsize);
 		AFFS_DATA_HEAD(bh)->ptype = cpu_to_be32(T_DATA);
 		AFFS_DATA_HEAD(bh)->key = cpu_to_be32(inode->i_ino);
-		AFFS_DATA_HEAD(bh)->sequence = cpu_to_be32(bidx);
+		AFFS_DATA_HEAD(bh)->sequence = cpu_to_be32(bidx + 1);
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_fix_checksum(sb, bh);
 		bh->b_state &= ~(1UL << BH_New);
@@ -748,7 +748,7 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 		if (buffer_new(bh)) {
 			AFFS_DATA_HEAD(bh)->ptype = cpu_to_be32(T_DATA);
 			AFFS_DATA_HEAD(bh)->key = cpu_to_be32(inode->i_ino);
-			AFFS_DATA_HEAD(bh)->sequence = cpu_to_be32(bidx);
+			AFFS_DATA_HEAD(bh)->sequence = cpu_to_be32(bidx + 1);
 			AFFS_DATA_HEAD(bh)->size = cpu_to_be32(bsize);
 			AFFS_DATA_HEAD(bh)->next = 0;
 			bh->b_state &= ~(1UL << BH_New);
@@ -782,7 +782,7 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 		if (buffer_new(bh)) {
 			AFFS_DATA_HEAD(bh)->ptype = cpu_to_be32(T_DATA);
 			AFFS_DATA_HEAD(bh)->key = cpu_to_be32(inode->i_ino);
-			AFFS_DATA_HEAD(bh)->sequence = cpu_to_be32(bidx);
+			AFFS_DATA_HEAD(bh)->sequence = cpu_to_be32(bidx + 1);
 			AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 			AFFS_DATA_HEAD(bh)->next = 0;
 			bh->b_state &= ~(1UL << BH_New);
-- 
2.39.5



