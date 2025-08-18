Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D655330DD34;
	Mon, 18 Aug 2025 13:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523046; cv=none; b=a3fyUjFQbe20XUg7UetOgMYtZHQGY/+Osi+s+l6VKbXvg00Db/rR/tCgxfnpjzw6t7b1CgGICdcy0/QA1W3TBRqKZ2XfeN2SXQPULI7PAy/fE1eZalCFN3mJaXcMZo9Nb4Tgrjt+NRko4glwUj0PJJmFSYHV7PY7WOBOZy0WSUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523046; c=relaxed/simple;
	bh=xLI0gX5JJe53qYyPd6fZ7pCVtgk4APXXTTq4QNbVkJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FubR3lXNLmXQuwZvnLCXEKp0ZKcwHdwUdYhfRcHQAUMCAGuHnJ2W4eHCqq8iwTvFrJgl+WLc7rPZQol7sSPYaJ0mRx5PzXa5Xabw7Ch8Ngm0sLH5mgZjhaD2xzMCQ8spjafhWczsBiCZtBbt6qELjWSEDLXTV+DEMOLGgCSDSac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVfqh+So; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVfqh+So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4634EC4CEEB;
	Mon, 18 Aug 2025 13:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523046;
	bh=xLI0gX5JJe53qYyPd6fZ7pCVtgk4APXXTTq4QNbVkJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVfqh+Soupis7vvQFJv8VmLOxbUfv8cUWSLDaDXWVDyVt5fX4dLoEmtSPk02ZO1qO
	 3cnzGRjUmcMfSP61UuEqEp0Tf7M45ZyXNIGfEnG3p08TgDYunlC56XKSnaewkw4KWB
	 JerrZPoo4YZQ2GFguVEIokbNJ9WKNZPcwLxqz55I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 055/515] habanalabs: fix UAF in export_dmabuf()
Date: Mon, 18 Aug 2025 14:40:41 +0200
Message-ID: <20250818124500.535773250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/accel/habanalabs/common/memory.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 601fdbe70179..61472a381904 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -1829,9 +1829,6 @@ static void hl_release_dmabuf(struct dma_buf *dmabuf)
 	struct hl_dmabuf_priv *hl_dmabuf = dmabuf->priv;
 	struct hl_ctx *ctx;
 
-	if (!hl_dmabuf)
-		return;
-
 	ctx = hl_dmabuf->ctx;
 
 	if (hl_dmabuf->memhash_hnode)
@@ -1859,7 +1856,12 @@ static int export_dmabuf(struct hl_ctx *ctx,
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
@@ -1872,13 +1874,6 @@ static int export_dmabuf(struct hl_ctx *ctx,
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
@@ -1890,13 +1885,9 @@ static int export_dmabuf(struct hl_ctx *ctx,
 	get_file(ctx->hpriv->file_priv->filp);
 
 	*dmabuf_fd = fd;
+	fd_install(take_fd(fd), hl_dmabuf->dmabuf->file);
 
 	return 0;
-
-err_dma_buf_put:
-	hl_dmabuf->dmabuf->priv = NULL;
-	dma_buf_put(hl_dmabuf->dmabuf);
-	return rc;
 }
 
 static int validate_export_params_common(struct hl_device *hdev, u64 addr, u64 size, u64 offset)
-- 
2.50.1



