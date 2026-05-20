Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02353A383C;
	Wed, 20 May 2026 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294367; cv=none; b=JWteKztBm1tXOqgYv6cKzvgmA4tIw8O4oANJxOPxuTdVUyQGRnRZe+XglY4HffuFWWpv6mkpyJw6idl7TiO0bn/3IMA5vFqhc7qNPWTu7mW3WqnknhFmwM+uobXkJjchKYWNl5zIxzNfX8Lx36fceNZrHNtmfPuK+zJ8CVdWFQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294367; c=relaxed/simple;
	bh=is/LTVo5fK/BVDwcEBRxAAl3EjOuawpih4zjJK3pVlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2BOgf9PlPxap66Y+ggEMysxPCvamt13PqOFT+TeEFsQt8/tgetsUqgER/v9tJzp7bIszr5NY4IFyHLoYDYTIt1bIzbsbkWONJsTmvmU+cf1QJkp+T+3MyEQcxM5VnP/aPeyLnQStzp1grZYv7QlFOKSFkL+KR1NozlaFDHw4t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcX8TbWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcX8TbWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BF01F000E9;
	Wed, 20 May 2026 16:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294365;
	bh=DwD4cQ0aE1QdxKeynCvJCOImWOEvydL9e15R2Sv5fe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcX8TbWxC8glUq+6Fz7/hdXI0UQSQkhZUyDwZtWR+to6QRGcPjlUKE9fU3JZ7q7K/
	 jbzqF4rQw53iBJKeW89ZrSLz2WlxWyUeDVgky496+o/BrklM8qrk9i1HfXnMBH5rdV
	 MpdMlcsLSgnYzbsaLPR2BKWiC9JOja+Q9q+AQQpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0013/1146] erofs: verify metadata accesses for file-backed mounts
Date: Wed, 20 May 2026 18:04:23 +0200
Message-ID: <20260520162148.691068692@linuxfoundation.org>
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

[ Upstream commit 307210c262a29f41d7177851295ea1703bd04175 ]

For file-backed mounts, metadata is fetched via the page cache of
backing inodes to avoid double caching and redundant copy ops out
of RO uptodate folios, which is used by Android APEXes, ComposeFS,
containerd.  However, rw_verify_area() was missing prior to
metadata accesses.

Similar to vfs_iocb_iter_read(), fix this by:
 - Enabling fanotify pre-content hooks on metadata accesses;
 - security_file_permission() for security modules.

Verified that fanotify pre-content hooks now works correctly.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Acked-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index f79ee80627d95..132a27deb2f3b 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -30,6 +30,20 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 {
 	pgoff_t index = (buf->off + offset) >> PAGE_SHIFT;
 	struct folio *folio = NULL;
+	loff_t fpos;
+	int err;
+
+	/*
+	 * Metadata access for file-backed mounts reuses page cache of backing
+	 * fs inodes (only folio data will be needed) to prevent double caching.
+	 * However, the data access range must be verified here in advance.
+	 */
+	if (buf->file) {
+		fpos = index << PAGE_SHIFT;
+		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
+		if (err < 0)
+			return ERR_PTR(err);
+	}
 
 	if (buf->page) {
 		folio = page_folio(buf->page);
-- 
2.53.0



