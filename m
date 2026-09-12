Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C25335201F;
	Sat, 12 Sep 2026 11:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212746; cv=none; b=puGrUSGaUrlDJxTbbmNSboRM4rEl+3Jp81+LG4kd9w9gbMpTdqExpkXenjheXJxFtjFAq/CfC0TiQd0CuZ33JDmPih6fDEavgZgWCXR9NykVhUHV2XNthLAXQNwWsEuNZ3ZH3HOu1+rgJplkFHctx9NH4CDDRdPnZeUfT4E66Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212746; c=relaxed/simple;
	bh=lw8ZoMZKBpR4KYy8A3UVTcshf4jiJQZ6xSI13LC74K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGgNzIkoHWmaCNSfoJrdPXlovF8DkYCkqkgvPyHBx9TtPZXF8mWMc4oFxgCRSXmCtuQGgUtgSPhWvK1qKsITJynPDqALzYNAFe++EJ1HV/oAjQCUoe5ObQ+uuDuxyeSuikHTcYSPDsEVBDCmtYZuNa1Yz3n17rUh4WylrEYRX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3eNWFsI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3eNWFsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC5F1F000FF;
	Sat, 12 Sep 2026 11:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212745;
	bh=w3lj1rSgbbMIIRAWFR8vUWNWnTgLKRAI6zi0+SUqqbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3eNWFsIzL4hCcMHGvYXHMXSBJC0Fd42juhclSuUoGX9zIT5QqqROE+Cr9ZOupAmr
	 w5iyjCerwiZCq2vgqWJwcQV0ARLkrwyesrv3B0ClAjiSJrQVEAaXk4hjrFHH3zOS/B
	 cQSrkS65YVlI5zEfzcBhuNxxyUWT8g96armHc2Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1498/1518] erofs: fix EFSCORRUPTED on multi-algorithm images in z_erofs_map_sanity_check()
Date: Sat, 12 Sep 2026 09:01:07 +0200
Message-ID: <20260912065657.449250692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

[ Upstream commit 27f2d085bd72abe4235689d34d8654cfc876d568 ]

Commit a5242d37c83a ("erofs: error out obviously illegal extents in
advance") changed the per-extent algorithm presence check from "is the
bit set" to "is the only bit set":
  -		     !(sbi->available_compr_algs & (1 << map->m_algorithmformat))
  +		(sbi->available_compr_algs ^ BIT(map->m_algorithmformat))

`available_compr_algs` is a bitmap of every compression algorithm
available in the image (z_erofs_parse_cfgs() iterates it with
for_each_set_bit()), so an image that enables more than one algorithm
has multiple bits set.  XOR is zero only when the bitmap is exactly
BIT(map->m_algorithmformat); for any image with two or more algorithms
the test is non-zero for every extent and the read fails with
-EFSCORRUPTED ("inconsistent algorithmtype %u").

Reproducer (mkfs.erofs from erofs-utils 1.7.1):
  $ mkdir src
  $ yes A | head -c 100K > src/a
  $ head -c 64K /dev/zero > src/b
  $ mkfs.erofs -zlz4:deflate multi.erofs src
  $ mount -t erofs -o loop multi.erofs /mnt
  $ cat /mnt/a >/dev/null
  cat: /mnt/a: Structure needs cleaning
  $ dmesg | tail
    erofs (device loop0): inconsistent algorithmtype 0 for nid 46
    erofs (device loop0): read error -117 @ 0 of nid 46

The erofs on-disk format (Z_EROFS_COMPRESSION_MAX = 4 with LZ4, LZMA,
DEFLATE, ZSTD) and the kernel parser explicitly support
multi-algorithm images, and erofs-utils 1.7.1 generates them via the
"-z X:Y" syntax.

Restore the original per-bit presence check.

Fixes: a5242d37c83a ("erofs: error out obviously illegal extents in advance")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 28d99f9e23bfa..b5d888883213c 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -724,7 +724,7 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 
 	DBG_BUGON(map->m_algorithmformat >= Z_EROFS_COMPRESSION_RUNTIME_MAX);
 	if (map->m_algorithmformat < Z_EROFS_COMPRESSION_MAX) {
-		if (sbi->available_compr_algs ^ BIT(map->m_algorithmformat)) {
+		if (!(sbi->available_compr_algs & BIT(map->m_algorithmformat))) {
 			erofs_err(inode->i_sb, "inconsistent algorithmtype %u for nid %llu",
 				  map->m_algorithmformat, EROFS_I(inode)->nid);
 			return -EFSCORRUPTED;
-- 
2.53.0



