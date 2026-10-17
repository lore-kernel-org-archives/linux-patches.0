Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CEB387373;
	Sat, 17 Oct 2026 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258079; cv=none; b=rDTmJU1FUfo5c83z3TyihPLGo4ASzl6kM18FfNJwKqYCwyfftpm4YDfRn41Nefjor57fnFMTTQgxKCtzcJ5nP6EzaisK20BR1lQ20/cUawPQO3uXXWUPau//1VClnDPGvqRQjKTeJM/+jcFspX2VqhnSaCc33fNko8IGHAtyAfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258079; c=relaxed/simple;
	bh=wfYnuVPGJ8SxA/sA5mD9FifxslPQMozX7LvokYyjF4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkM/JzYNRlJR6ctf3bO/Q5ds5lUB9ju5q2s8xnyItl/252S4P4VAgE4sCiMRFELB97oFrJOui+L5MejolKX12desz4WQC3hWA6OKm6SDQQquBKw4BUUMWDJtMxB9fv3PqGkYAsivfWgOylQF01kSrJ1qe+qtfsCx1LAxuvOy3sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/sj6lTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/sj6lTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093BD1F000C4;
	Sat, 17 Oct 2026 17:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258078;
	bh=VZzsdbvGQHqszD2gCBzVqF9W9USLC6hiF17zBB2fU8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/sj6lTJ4V0Nb7xCEw8pWQizrnM1g8q37arrYZhooa8GTfxoC6QoHTNMzPJpeUOsr
	 D9A5W/RofoJ+BWa6QVCSoYZHYqiT2jTQsk2vHNyuWsxYs12NI8AUXPtOTomnjKJJko
	 bHtSc00dA/PlwFPaWJ6hV+wWwXNCI2K1yTaasMFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0766/1674] habanalabs: fix UAF in export_dmabuf()
Date: Sat, 17 Oct 2026 17:50:38 +0200
Message-ID: <20261017160450.764198323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 33927f3d0ecdcff06326d6e4edb6166aed42811c ]

As soon as we'd inserted a file reference into descriptor table, another
thread could close it.  That's fine for the case when all we are doing is
returning that descriptor to userland (it's a race, but it's a userland
race and there's nothing the kernel can do about it).  However, if we
follow fd_install() with any kind of access to objects that would be
destroyed on close (be it the struct file itself or anything destroyed
by its ->release()), we have a UAF.

dma_buf_fd() is a combination of reserving a descriptor and fd_install().
habanalabs export_dmabuf() calls it and then proceeds to access the
objects destroyed on close.  In particular, it grabs an extra reference to
another struct file that will be dropped as part of ->release() for ours;
that "will be" is actually "might have already been".

Fix that by reserving descriptor before anything else and do fd_install()
only when everything had been set up.  As a side benefit, we no longer
have the failure exit with file already created, but reference to
underlying file (as well as ->dmabuf_export_cnt, etc.) not grabbed yet;
unlike dma_buf_fd(), fd_install() can't fail.

Fixes: db1a8dd916aa ("habanalabs: add support for dma-buf exporter")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/memory.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 33a4246dd7358..16516e007873b 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -1806,9 +1806,6 @@ static void hl_release_dmabuf(struct dma_buf *dmabuf)
 	struct hl_dmabuf_priv *hl_dmabuf = dmabuf->priv;
 	struct hl_ctx *ctx;
 
-	if (!hl_dmabuf)
-		return;
-
 	ctx = hl_dmabuf->ctx;
 
 	if (hl_dmabuf->memhash_hnode)
@@ -1836,7 +1833,12 @@ static int export_dmabuf(struct hl_ctx *ctx,
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct hl_device *hdev = ctx->hdev;
-	int rc, fd;
+	CLASS(get_unused_fd, fd)(flags);
+
+	if (fd < 0) {
+		dev_err(hdev->dev, "failed to get a file descriptor for a dma-buf, %d\n", fd);
+		return fd;
+	}
 
 	exp_info.ops = &habanalabs_dmabuf_ops;
 	exp_info.size = total_size;
@@ -1849,13 +1851,6 @@ static int export_dmabuf(struct hl_ctx *ctx,
 		return PTR_ERR(hl_dmabuf->dmabuf);
 	}
 
-	fd = dma_buf_fd(hl_dmabuf->dmabuf, flags);
-	if (fd < 0) {
-		dev_err(hdev->dev, "failed to get a file descriptor for a dma-buf, %d\n", fd);
-		rc = fd;
-		goto err_dma_buf_put;
-	}
-
 	hl_dmabuf->ctx = ctx;
 	hl_ctx_get(hl_dmabuf->ctx);
 	atomic_inc(&ctx->hdev->dmabuf_export_cnt);
@@ -1867,13 +1862,10 @@ static int export_dmabuf(struct hl_ctx *ctx,
 	get_file(ctx->hpriv->filp);
 
 	*dmabuf_fd = fd;
+	fd_install(fd, hl_dmabuf->dmabuf->file);
+	fd = -EBADF;
 
 	return 0;
-
-err_dma_buf_put:
-	hl_dmabuf->dmabuf->priv = NULL;
-	dma_buf_put(hl_dmabuf->dmabuf);
-	return rc;
 }
 
 static int validate_export_params_common(struct hl_device *hdev, u64 device_addr, u64 size)
-- 
2.53.0



