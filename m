Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031304;
	b=YfEF7l9jKvPtWsU+cynLzsjqq7APdzv09z9Bej/5gsj1nAhGlduGAuI9CpUY40WivnG8
	 BHu9qBoZ4iL0ViUL7hbh9WPJNgSjtWBnTS5iQZtr36sxhj+8LtgRjV9T1EgAwA7LE4QY9
	 NAU2tC7qGRZ0C3OjQMkcUOV9BR8laK845N0nYCcISuXpWaTpKRFuT7eyrgEsl8367mGC2
	 ZwzmgtDFSNasxU5SAiFGvooe+ZFe3u3z2qjJVPaFyyrt+ebnwgSJakZLX72wlkBhScAp5
	 hCMNdDXMxlRXyxf8L4BwwpbKNlYPISje/ip/zA6s/DAqMt8sD0poKNyFsZGmZmvDwWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zmjaqdPESVZmzCY8uZGrvNSjdlQuCevJi0mTHhvBT9I=;
	b=cbvgxJN0jMMz/9H16Mh1Lj7B/e/gLsTH6WUXquGCf/SswxgNSR0RhFiJSJ6ebHvqF6Of
	 RvB9UKlK0ub12FpGsPoyXfGmu0a0uMk5j3ZjviOTF17ZhJhZx/Yqp1xRc5mqARdGRjoGz
	 LOt2YyXlBPZXhJCXD3qVpyJCxAC+QbwZ4SjH9ayePaERj+REf4kuc5Jt6ax7QRR1zg2UI
	 pmeS9z06vQBq7IHf3CnC0o7/hnajOJarvmUDF7HwSl85ayexulSJJe8pD28ZG3uzhzlFA
	 fvdjJeECPfJ+oQwj4dHTK/W9w6mG8C9N9IiuDNY/Hwd1LivKqwaDmeSq1/8+qKIkWZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnqJByP9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7288D606A31C;
	Wed, 18 Nov 2026 19:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnqJByP9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30991F000C4;
	Wed, 18 Nov 2026 19:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031304;
	bh=zmjaqdPESVZmzCY8uZGrvNSjdlQuCevJi0mTHhvBT9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnqJByP96+wict4Qr3CCIQOKoLUMu1q8STyyPLw1UNhOfV2uRT5vWWBXj1gc1ghXf
	 jQU8JchE6VvJ4+OROr8+Yd3apYCgj3qruhiuhDnj7NOyP5NKcLZ/Zj7E+e8cpzWkE6
	 cZ5nxOPelxzJkeKy1lj5yw2/zu5mNAKiYQOje+xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Labelle <southampton.jake.labelle@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1009/1756] nilfs2: reject non-regular inodes in dsync recovery
Date: Wed, 18 Nov 2026 15:52:16 +0100
Message-ID: <20261118150050.313202790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e6e044f8f7b81..d0c4caa2f07ca 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -519,6 +519,23 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
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



