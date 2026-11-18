Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019271;
	b=oaptSuJrDlQw7khInq4anN2NVWMIdYGlzBC/QUuCyB5aV2X1rKv5DTBHNrAgq1bedvQ6
	 sS3jK6Mid23ktC9+SoS3vFupvbztNhAoDXTBz2s+EasqrxY/Cuttcf6GEaUJkeeh7qzqf
	 5qTFlYcs/KkKiYmJwZb+AqBlWKcr2mRWDJlKzmRzNFHD3i4mO05vh2Jm8JzlvqSuR3uE1
	 slRdI8o/sq4MJ7/M54JrkRpj98BpKVpNsXiJJwAJ3YW4I3HodCg1KjnIMY151jgaIvVk9
	 KMkmYZBk2AY7dIENV+Qw+y3PUEu7TftJZ4eWx2mkwd5ILTupY+6rG6a5cudhtMEBl8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z4oZ4MH8CZPehInhmCalLgBU2iXC70AFB/4w6WjWcaY=;
	b=kf4WVM/3FIabs8CtbOW3A+HQIA5PEKq9X4ikjVULpWk45Mtxi95tQrLY7KJMtzaJRtGe
	 w7jYzuVXZBQQhjASp3+gpNUHLeWoZPUD32vkwP16Q06/MLghtIP2Np4VZbgQJIAfyXJRk
	 4GrI3+1WQGEEZ8r/nG1IkwPY0S27hjIh6FMCjYHzjqnzPsDzcrmUFg3WmO4JabQZGtj4/
	 MwfBCHTfUyFtkTVWE+OEc2mvlxxQHeVRwFAmRY//Vpt/zfz7wRoUvrbZxwzGhVErZI5S5
	 p/IqjbPlUzCeIISD/l/U9SvvcveHR4EK2dELyCi+7j+/F7sADdREQ1ZEhPVhcw84zcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XSP/EM4o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C09E60A260B;
	Wed, 18 Nov 2026 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XSP/EM4o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE281F000C4;
	Wed, 18 Nov 2026 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019270;
	bh=z4oZ4MH8CZPehInhmCalLgBU2iXC70AFB/4w6WjWcaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XSP/EM4oC2/Bhsauhcs+kESl0H43pXyIRtnGYgnEwWWMzqo6QZbqOtjb/hChckbin
	 hlArzX++1GuUOORJxKKaRPFU+vLOHJvrO4cRvLm+4om+m3+cosB2kijFC21/sfUDIY
	 iTbtGHCExeX69Oh0GyRu2F1LYNRqyamIsh+Gppbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1537/2651] nilfs2: reject non-regular inodes in dsync recovery
Date: Wed, 18 Nov 2026 15:46:17 +0100
Message-ID: <20261118150343.305642938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Jake Labelle <southampton.jake.labelle@gmail.com>

[ Upstream commit ef2ccb1554df254eb4066171ce93e6d5fb1af2e3 ]

During roll-forward recovery, nilfs_recover_dsync_blocks() obtains the
inode designated by fi_ino of a dsync log without checking its type.
If a corrupted image designates a special inode (e.g. a device node)
there, the inode's embedded bmap was never initialized:
__nilfs_read_inode() calls nilfs_bmap_read() only for regular files,
directories and symlinks.  The subsequent nilfs_get_block() then
dereferences the uninitialized bmap->b_ops and jumps through it,
crashing the kernel or worse.

Regular files, directories, and symlinks are the only inode types
with data blocks to recover; reject anything else before touching
its block mapping.

[ryusuke: conformed AI tag to guidelines]

Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Assisted-by: Claude:claude-mythos-5
Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/recovery.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index a7086a93480b1..01631a35c8ac8 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -540,6 +540,23 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 			goto failed_inode;
 		}
 
+		/*
+		 * Regular files, directories, and symlinks are the only
+		 * inode types with data blocks and an initialized bmap;
+		 * a crafted image can reference some other inode type
+		 * here, whose i_bmap_data was never set up by
+		 * __nilfs_read_inode().
+		 */
+		if (!likely(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+			    S_ISLNK(inode->i_mode))) {
+			nilfs_warn(sb,
+				   "%s: invalid inode type (ino=%lu, mode=0%o)",
+				   __func__, (unsigned long)rb->ino,
+				   inode->i_mode);
+			err = -EINVAL;
+			goto failed_inode;
+		}
+
 		pos = rb->blkoff << inode->i_blkbits;
 		err = block_write_begin(inode->i_mapping, pos, blocksize,
 					&folio, nilfs_get_block);
-- 
2.53.0



