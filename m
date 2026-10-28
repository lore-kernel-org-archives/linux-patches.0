Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214358;
	b=eJfAPmQwvQyizQ8trpLYqM1M8MHZVoMaHUGArlzVpBss93PjFSf77iLdgvZ+VEwBacB6
	 c+K9H0yHNYLT3tE2IEy1t+qjlMP/7Cif38XrDAN1ET9QlmSS5rVp+pIqTkn0RGZKYbAii
	 eAcOprMQoC3zKnpRicgMxROaaScE2l4H7H7BZ2C4qDqkU1TFY4KrYPTMT9916F9IR9dQT
	 KOOeWUn1cS9cRORNrPHveAyeg95eRQA3n7/0wKWyzDvWgCIBvDFmBhSLNQMbE9CLpGdb6
	 fXpS+emOsCwNgpgnc+FiMFaqOp2lOjuSpJIk10Z4zJDVb65koCKnFnCh+jyrsUnHYbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qARdbBTPxgc4NCAPxEX2RdpHTErWBPDMAlD7Rt7/2eI=;
	b=39ZFV48N2awLv+8my3sAuYY/1LhpAeAtjDpN6xettQCRdyLIJCtQkI4tuYWrOAdmPSPf
	 DVeDc6wt3OkDhEB5jiyYsdDk0RRjcxM1tO04tb6fJ+Ggq4w25pEKLa8Z9E5t9CUfIZgu2
	 ZSnl/3v3fyvVGHh7zUGm909ERsoouooDYkQzeUz32Wyzv25EkKttb86qkESEjKDu8afVu
	 TiSd3AQk1TFflDUVw7nnbankyk2x+np8YPIeYpaDh2zy+IsduKmzPgEG/NRNCgoz9ok8G
	 w3pbOOPVlUwXnWoBazPCTFOiM5dvEnOPjW8nPGywR8+FaiwQapZYoZQ8iJfBA86uurA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dsir8KSR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B412860A262B;
	Wed, 28 Oct 2026 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dsir8KSR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E311F01825;
	Wed, 28 Oct 2026 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214357;
	bh=qARdbBTPxgc4NCAPxEX2RdpHTErWBPDMAlD7Rt7/2eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dsir8KSRElipiQfrVegM/uz6cnqz94KTxCBnGcIZMZrEDWAFp3KcmcPFRIb9WrM5q
	 R6EGZZVDdkMM3Vyy3LF7J4yjUgMcJ5vDG71It5Zigb4XDJqHZB9U15+25UD7sQaUy1
	 NnOnlbvk57QynELMwhKoE5YM9zS+tWV3a7XQBYBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0830/1887] habanalabs: fix UAF in export_dmabuf()
Date: Wed, 28 Oct 2026 17:48:46 +0100
Message-ID: <20261028170518.312098439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/misc/habanalabs/common/memory.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index d18e111001844..c4334492543f1 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -1748,9 +1748,6 @@ static void hl_release_dmabuf(struct dma_buf *dmabuf)
 {
 	struct hl_dmabuf_priv *hl_dmabuf = dmabuf->priv;
 
-	if (!hl_dmabuf)
-		return;
-
 	hl_ctx_put(hl_dmabuf->ctx);
 	kfree(hl_dmabuf);
 }
@@ -1768,7 +1765,12 @@ static int export_dmabuf(struct hl_ctx *ctx,
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
@@ -1781,24 +1783,14 @@ static int export_dmabuf(struct hl_ctx *ctx,
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
 
 static int validate_export_params(struct hl_device *hdev, u64 device_addr, u64 size)
-- 
2.53.0



