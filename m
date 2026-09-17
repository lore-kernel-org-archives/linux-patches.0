Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164E04ABBD0;
	Thu, 17 Sep 2026 15:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659999; cv=none; b=NLRED5OXUy9QG+ai9nb1Z3nYR7l9JhiivepvY+lwmUwXnxXNZsLWIZL6fA5iPP1Vc73AmTYZe072kdnHtSfddQIhhn/7MXI+7V7Rnypv95pWNiOZt8W/p3BYTmFmszOMHDyXGFhquQobBClym0Vdc+7wvBaVwdCcirA4RbY+mK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659999; c=relaxed/simple;
	bh=Ys/hBc8+AGk2larD2CBjU2W872iUzduIw+antJNTLDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVhtZwGieG7qBnOIRbEwh8iT4ptiOs75g+GwmwIuRjQAsKeMlNwDj6MFcHMqjI1jaGj0HWdgIrhPKiGSiDHRS3GE8lsjrAEAFPi1N8MkaEragXVBgWDbwTnFLdUJghqrwYpj+SduwBsldL1qcLgRAotaGjqey+6Uy3pzuySqXaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZ6Kj/H0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZ6Kj/H0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9212C1F00893;
	Thu, 17 Sep 2026 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659991;
	bh=O9vOR1B9MWDVm5Ci0XLe9InykCykI+Z3m1X/hLt8t3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZ6Kj/H048BzBQEm/UOGI4mgUEObgKr0nxCJ42P/ci9UNnDtMvkl2mHMCpKNCEh6S
	 ZwR2P2E50Umba+Oysve2f0VffWk++LKuz91CrpYhP68bLS1Ff0Pg7yWgkrxBp0QItG
	 raB9OaXTqPyl8JtrcGDPoSKzZYGLFN5xE2ig7+Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binglei Wang <l3b2w1@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 441/733] erofs: add missing buf->off in erofs_bread()
Date: Thu, 17 Sep 2026 16:12:29 +0100
Message-ID: <20260917151402.861027193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binglei Wang <l3b2w1@gmail.com>

[ Upstream commit 135d84c66f85426299db01a09d93a79a87af18ba ]

erofs_bread() locates the target folio with

 index = (buf->off + offset) >> PAGE_SHIFT;

but computes the in-folio offset without taking buf->off into account:

 return buf->base + (offset & ~PAGE_MASK);

If buf->off is not page-aligned, the returned pointer misses the in-page
component of buf->off, so callers end up fetching data from a wrong
offset.

buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff can
be specified via the "fsoffset=" mount option, which only requires
block-size alignment. Therefore, on an image with a sub-page block size
(e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issue,
since 512 is a multiple of the block size but not of PAGE_SIZE.

It can be reproduced by mounting an image that is placed at a
non-page-aligned offset:

 mkfs.erofs -b512 -zlz4hc sub.erofs src/
 # prepend 512 bytes of padding to the image
 mount -t erofs -o loop,fsoffset=512 padded.erofs /mnt

which fails with

 erofs (device loop0): cannot find valid erofs superblock

because the on-disk superblock (at offset 1024 within the image, i.e.
1536 within the padded file) is read from a wrong in-folio offset. With
this fixed, the very same image mounts successfully and its file contents
match those read from the unpadded image.

Fix it by including buf->off in the in-folio offset calculation, so that
it is consistent with the folio index calculation.

Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify filesystem offset")
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9aa48c8d67d12..b6cdffd0d8936 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -61,7 +61,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 		return NULL;
 	if (!buf->base)
 		buf->base = kmap_local_page(buf->page);
-	return buf->base + (offset & ~PAGE_MASK);
+	return buf->base + ((buf->off + offset) & ~PAGE_MASK);
 }
 
 int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
-- 
2.53.0



