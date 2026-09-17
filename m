Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712275349DD;
	Thu, 17 Sep 2026 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666282; cv=none; b=ZBkAi0c2p3rbLIg5sPjoEwCIWqAfQrTdaWyRbTxnfC7Xq6pVTNY4bhnDdzE5y4tIldH04fksZrPYWZkFZPu7axxvDyoMDWIi+5q3hi9pQDQKM+NMmBaEPGI1FdeQhpXRuNz/6bD5Eair3dGwJLNnD2a3+lxB3TpAUrDXlYB/zG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666282; c=relaxed/simple;
	bh=uWgUW/vrKhqdzjcV6jK5Uye5YrXXZyYO+8mRZHvtCcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7vBbvR/IpLXiZZW9cOpXp3upnSGGFpK/AH/xP4A1921lLnMcwiy1+O2kGNM3cmjG7jEddxpLTfQO1PltZwJG2zyvDtxYN5IQ4VzU3E6lLZtRXALePgpUGteghntZIWuqb5jZeDxtZi7AyUwIRSUYFTuZt7HHg+xSZ2p0wI2V4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLlYdrIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLlYdrIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8374C1F00893;
	Thu, 17 Sep 2026 17:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666281;
	bh=h9jzAZh61SWga/mHQ2fVrs5aaIrNDyrNC4gYhjU/3Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLlYdrILwC6PYc5Rw7CJGvKxZmv4R2GQMNtZornGpj9vhAasuObBvmU+LclC2Q/CA
	 gdsIApBJ9CgQngaixoajbVa9uQdz3d5lyZY4rn55OxGLyKKBIuO/93CC3YSYKxhl4g
	 6IT+nEURMyP4QDIqFYfxZtfQ+RLmMzmuCyM6p9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binglei Wang <l3b2w1@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0947/1250] erofs: add missing buf->off in erofs_bread()
Date: Thu, 17 Sep 2026 16:12:22 +0100
Message-ID: <20260917151617.693258163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8ca29962a3dde..3e6b512efe21c 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -46,7 +46,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 		return NULL;
 	if (!buf->base)
 		buf->base = kmap_local_page(buf->page);
-	return buf->base + (offset & ~PAGE_MASK);
+	return buf->base + ((buf->off + offset) & ~PAGE_MASK);
 }
 
 int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
-- 
2.53.0



