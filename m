Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0442A3EA953;
	Wed, 20 May 2026 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296296; cv=none; b=E26ulOsgQh1HRQb3HdAIwJ72dlmwR43b3apczN/PlSZO6dS7mth64rX0Rv6i5ei7ZegeNLdrl+K2hIVLIl6Zlb5V1FaFLZtcnvq9IA6xXN2erfiIm5XFOW2wv6ePS73shZEYmmaYCPJHqBQiENhUbdQN+vflQO/Et6hgHm/Breg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296296; c=relaxed/simple;
	bh=8LUZ6LYaGzomv9IDstvscQ592V5zobNbNzDjXMzXBT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNY7ABXupIrtgIh+46+XP4tENajsyrNIpnRDAoP/P0AoURFQ4+vCRsR4QLay0NEWSJJEFZbRzb9Y/0/AuPeZBsCH2BghA2ORgnfF4zngAqDJnIL/h5hx/JesNdzPwQoh7gGFqz39pwYq42XTdxx9xfnFcocGu4rIyqetp5V3aiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHQvPOsX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHQvPOsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693971F00893;
	Wed, 20 May 2026 16:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296294;
	bh=ROdkS8zPvfbf/o7g4Pbv4t/D4mXBPfxW1runvALDX8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHQvPOsXhEGUEWPhhkdihFMoCg643nx5JK0gim1xvDyN4saYKGhJPh4NsAL2iHkmK
	 Lb0B9TToPHJIWCFMTHKVKiKMBSPserZ7mZA0TpFdQ817/jO0JwgWm2YfV8XHhk1iO6
	 0V1CHc2SMbAX/FKi1kJb7ggkoNrdBTXUkhdsecec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0746/1146] erofs: fix offset truncation when shifting pgoff on 32-bit platforms
Date: Wed, 20 May 2026 18:16:36 +0200
Message-ID: <20260520162205.089914008@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 132a27deb2f3b..b2c12c5856acc 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -39,7 +39,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 	 * However, the data access range must be verified here in advance.
 	 */
 	if (buf->file) {
-		fpos = index << PAGE_SHIFT;
+		fpos = (loff_t)index << PAGE_SHIFT;
 		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
 		if (err < 0)
 			return ERR_PTR(err);
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index fe8121df9ef2f..624b83ff4ecb7 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1874,7 +1874,7 @@ static void z_erofs_pcluster_readmore(struct z_erofs_frontend *f,
 
 		if (cur < PAGE_SIZE)
 			break;
-		cur = (index << PAGE_SHIFT) - 1;
+		cur = ((loff_t)index << PAGE_SHIFT) - 1;
 	}
 }
 
-- 
2.53.0



