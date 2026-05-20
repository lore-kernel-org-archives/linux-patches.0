Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9DB3F39C9;
	Wed, 20 May 2026 17:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299678; cv=none; b=OHp+9223yFMm/miqHwybO1XxbLty9qcrSDzdFFlxe4Ocqp9H0I/5S2wDvqNK7Qsqdur5iHapIYye0mDX0Vk4XoGAcAdN06c05WisMVrAg6Mset91iymv2TEe87l8UTvgSb6bv4vwsaGy/6LQHKhbO4oaeD5R3Y/DG35N6L65B0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299678; c=relaxed/simple;
	bh=pgeBajgwko9YJ8aooNthGAARFu1trpbG4JC2IOtatvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aw0ZvAw3RDR4d37RlPjQdq6KssGNw1kqx7R9v0Yr4nT4tew5L3dTogK3oBtAqPj+Ku4qFI0y9EdWCv1kwk6pebIIPL2HfnH4jjfw8p4XxpAICQhOckf37hC7aj05NsR2QYnh/qsqnVxupEtqLdHJ4dRX+q0+3hsK6TL/oQDrVVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uphp0pV4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uphp0pV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A311F000E9;
	Wed, 20 May 2026 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299677;
	bh=vczTOpyEeisYkzrPdiCPOmMm/e+0Xz/vZBMYR8O3cKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uphp0pV4dELq7x+NGE/D8h6PMDDrfcTzksqKcTUZa2txdM4KT/g/bwdSdmSKbcgmR
	 ocMEt0pt/kJIfUik+RPjWCAR12xtY2rnZnAz0Rv/iP/psMe8LKr2CD/9GVAwXxpA0M
	 1JtAOEE4uhPjaWUzo/6AAAzAt3uIUlyHdC2nIrME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 863/957] erofs: fix offset truncation when shifting pgoff on 32-bit platforms
Date: Wed, 20 May 2026 18:22:26 +0200
Message-ID: <20260520162153.281388122@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit c99493ce409c3b98fec1616dbcf24c102e006deb ]

On 32-bit platforms, pgoff_t is 32 bits wide, so left-shifting
large arbitrary pgoff_t values by PAGE_SHIFT performs 32-bit arithmetic
and silently truncates the result for pages beyond the 4 GiB boundary.

Cast the page index to loff_t before shifting to produce a correct
64-bit byte offset.

Fixes: 386292919c25 ("erofs: introduce readmore decompression strategy")
Fixes: 307210c262a2 ("erofs: verify metadata accesses for file-backed mounts")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c  | 2 +-
 fs/erofs/zdata.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 58aea2b48580c..d685ee1d9c554 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -38,7 +38,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 	 * However, the data access range must be verified here in advance.
 	 */
 	if (buf->file) {
-		fpos = index << PAGE_SHIFT;
+		fpos = (loff_t)index << PAGE_SHIFT;
 		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
 		if (err < 0)
 			return ERR_PTR(err);
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 71f01f0a07435..0f09f3ba32149 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1869,7 +1869,7 @@ static void z_erofs_pcluster_readmore(struct z_erofs_frontend *f,
 
 		if (cur < PAGE_SIZE)
 			break;
-		cur = (index << PAGE_SHIFT) - 1;
+		cur = ((loff_t)index << PAGE_SHIFT) - 1;
 	}
 }
 
-- 
2.53.0



