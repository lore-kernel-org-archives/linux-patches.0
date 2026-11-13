Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585924;
	b=iz8vh9QNuasvMFVPA7CsnLxvZ+dIX91/0k71vF8ogHykctIzaQTiIcopyHlHzJpgOg/8
	 k+DPY5yTnjcq7Yd1Qz4eUpEqU9SvUDjjxpbx075Smqi5jMySqRJfy7cU76sKCsc/Ny5Jd
	 vXiLc0rlgEK8yd4I4z5Ic7Wb48Qwzqom8EzNBwnOB+HmTEYAEVcmIG304pUI2bi8M9db5
	 MjueJshW2z3CMbLnBSNC/Z81fourS332X6iInCi8ZD+g1bra3NZaki/Ej0IfSj7GC61an
	 PoY9nV2VGmNy0ay1ypJN+WO4mXpoJqSfgwRRTWC814b3duL9t/0tgR872YOrgRLgygw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iOebsqWZ4LElLWMmKqYgNWLys8hBGpSb0qzZdzWUZ1A=;
	b=eZLCE4BBQNBi1iIRkf7M4ytOiSr8hzdFZD3xku3unfFSSUjNMTOGnxMauTOd5uNqjR4y
	 hrvARhutYAABqv1R/L0Kh8azrzx/25BkUoOHYYvqX2m1xsbNig0RDkAAYcfGr9NaU3C08
	 T2QVitaUo7pq17tvD68hFNAv4YXeSFaBRk5fg6o0J/2HjIUIOQz+5D9nVwauG2jyOw9dO
	 1y7wxUveWe50W9nhcV8BwfyxLNipTnLejXzwjAFS3WkQtkJovqX5QoC28YmuloFZM7nwS
	 Y9hVDDPnk49XvEsGGNB7i72WSFspNJCTG41ZKLO9uoOXDcUK155qCa7UG0f5DyfYBeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTf9ygsS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172E36070230;
	Fri, 13 Nov 2026 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTf9ygsS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A261F000C4;
	Fri, 13 Nov 2026 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585923;
	bh=iOebsqWZ4LElLWMmKqYgNWLys8hBGpSb0qzZdzWUZ1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTf9ygsSAvQE5OGsWHEQzL/u+KbkiYK41w4ovp/SL5Cli9Swg+gNwD3DPitfg29Od
	 xQy1iK4iO8YNyHYjaNuncD1dq8eBta0KO1QNmnKU8dCPoP4sVZ2JXspUHDKDew0MMI
	 270gGZkeOsLHC6AqS2fg9y4MFIwClhU11nc9KY1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 484/507] erofs: fix metadata reads at the end of file-backed images
Date: Fri, 13 Nov 2026 10:53:08 -0500
Message-ID: <20261113153813.485955506@linuxfoundation.org>
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

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit 52dceb88082b4c7983d1c8c7de1c181f018055ac ]

Commit e587a984d332 ("erofs: use dedicated meta inodes for file-backed
mounts") made erofs_read_meta_folio() read the metadata of a
file-backed mount one whole folio at a time.

However, an image only has to be a multiple of its block size. With a
block size below the page size, it can end in the middle of a page. The
read of that last page is then short, and erofs_fileio_ki_complete()
fails it with -EIO. As of now, inodes in the last page of such an image
cannot be read, and an image smaller than a page cannot be mounted.

The issue can be reproduced with util-linux 2.41, whose mount uses the
image file directly:

    mkdir src
    for i in $(seq 50); do echo $i > src/$i; done
    mkfs.erofs -b512 test.erofs src
    mount -t erofs test.erofs /mnt
    ls -l /mnt

Before that commit, ls -l lists all 50 files. After it, ls -l reports
"Input/output error" for 24 of them.

This patch reads the folio only up to the end of the backing file and
zeroes the rest, as the page cache of the backing file did before. A
folio that lies wholly past the end is zeroed without a read.

Fixes: e587a984d332 ("erofs: use dedicated meta inodes for file-backed mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
[ sashal: adjusted context to retain the older metadata I/O allocation and completion mechanism ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fileio.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index ebb81a7ffd4cb..ac846cfbc5633 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -201,17 +201,29 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
 		.dev = { .m_pa = folio_pos(folio), },
 	};
 	struct inode *inode = folio_inode(folio);
+	size_t len = folio_size(folio);
+	loff_t pos, isize;
 	int err;
 
 	err = erofs_map_dev(inode->i_sb, &io.dev);
 	if (err)
 		return err;
 
+	pos = io.dev.m_dif->fsoff + io.dev.m_pa;
+	isize = i_size_read(file_inode(io.dev.m_dif->file));
+	if (pos + folio_size(folio) > isize) {
+		len = isize > pos ? isize - pos : 0;
+		folio_zero_segment(folio, len, folio_size(folio));
+		if (!len) {
+			folio_end_read(folio, true);
+			return 0;
+		}
+	}
+
 	io.rq = erofs_fileio_rq_alloc(&io.dev);
-	io.rq->bio.bi_iter.bi_sector =
-		(io.dev.m_dif->fsoff + io.dev.m_pa) >> 9;
+	io.rq->bio.bi_iter.bi_sector = pos >> 9;
 	erofs_onlinefolio_init(folio);
-	bio_add_folio_nofail(&io.rq->bio, folio, folio_size(folio), 0);
+	bio_add_folio_nofail(&io.rq->bio, folio, len, 0);
 	erofs_fileio_rq_submit(io.rq);
 	return 0;
 }
-- 
2.53.0



