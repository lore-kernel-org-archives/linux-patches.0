Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214439;
	b=WqINs/thn9TVSAeEImu8illGd5/H1S2fhyQP7rnfaqw6ozB4OLT8yRawna0j6Yq2z4MZ
	 Bx4oKX0BOhAgfUbmZteqcU43xD4yuDfCUrc3QKkI7tmnuXys/OOoEDCPz1CjrY2MuQe3Z
	 8dLHrZbjI73GM3Jh2Nd/idUkFSTB2yDPlXDodMrvzkF4PDExSU8NJ3vEN/zC1MQZCK2SB
	 p7nWFFLs5x+jFiF9sFBgffcNNg3u/oFOOlBopOeoDQP7iMmUFtKe0kb0PwXxr/95gikHc
	 NMygxeqdKMZ0Vb8wIpbnLcGe/HFTU4/hG7C5x8GTsZpdy87dgVMvCPjeLFSXbJuAR3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c8ph5Luy/BlXSTA4dofc6ZL824UbkVUcM1+hvw8qPjw=;
	b=3/ZqszK1o34oBRmYwwuhaXHFMUu584K8HbJ+6O1nf+FFJAOLqEykgImkxqSEPBXlEwDg
	 waN/k6I9PGXYwddDRnuiiATxTErC96HdBHc5OIaR+az3GUo1AYiaSmn/GcPvukmKyTyfm
	 /7b3O+Fqrt97E5fXPZ/mZqyDXw3q4+ApUAMIntlcSqDDUnad2tx6W09lCdVlo/uQ5cOXq
	 xyMkBj4NBw8Bgu0bxP601h5odzFDYUSDQqZJFQdwvgqiro+WPBEEZg8KRTe1BfkQSwkh+
	 7gUYbpS96tyMaBaIH5C44ORmAV7HA0I9yYzVqv1zO5GnQrshXhYdFVkcyQnbwlVkQNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o/HROjb9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE70606A31E;
	Wed, 28 Oct 2026 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o/HROjb9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9D11F01828;
	Wed, 28 Oct 2026 19:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214439;
	bh=c8ph5Luy/BlXSTA4dofc6ZL824UbkVUcM1+hvw8qPjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/HROjb9XWhJUyfQ/eLg5CX/xy8+lNjFi2zhxVRhIH4sw4uWnnVNXmgB/fbsUoGjC
	 hXpyIgUYXbJw76h1k1horwEeCqJBGudewUIvDUuFiyo/6MdhQJjjtTeZq4B/rjftad
	 qGG2VxnRmDXQOkIEe/6HPJRez59FnNvc25WJ+koo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0816/1887] xen: fix UAF in dmabuf_exp_from_pages()
Date: Wed, 28 Oct 2026 17:48:32 +0100
Message-ID: <20261028170517.995274352@linuxfoundation.org>
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

[ Upstream commit 532c8b51b3a8676cbf533a291f8156774f30ea87 ]

[dma_buf_fd() fixes; no preferences regarding the tree it goes through -
up to xen folks]

As soon as we'd inserted a file reference into descriptor table, another
thread could close it.  That's fine for the case when all we are doing is
returning that descriptor to userland (it's a race, but it's a userland
race and there's nothing the kernel can do about it).  However, if we
follow fd_install() with any kind of access to objects that would be
destroyed on close (be it the struct file itself or anything destroyed
by its ->release()), we have a UAF.

dma_buf_fd() is a combination of reserving a descriptor and fd_install().
gntdev dmabuf_exp_from_pages() calls it and then proceeds to access the
objects destroyed on close - starting with gntdev_dmabuf itself.

Fix that by doing reserving descriptor before anything else and do
fd_install() only when everything had been set up.

Fixes: a240d6e42e28 ("xen/gntdev: Implement dma-buf export functionality")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250712050916.GY1880847@ZenIV>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 335451309566a..7df26330af424 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -357,8 +357,12 @@ struct gntdev_dmabuf_export_args {
 static int dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
-	struct gntdev_dmabuf *gntdev_dmabuf;
-	int ret;
+	struct gntdev_dmabuf *gntdev_dmabuf __free(kfree) = NULL;
+	CLASS(get_unused_fd, ret)(O_CLOEXEC);
+	int fd;
+
+	if (ret < 0)
+		return ret;
 
 	gntdev_dmabuf = kzalloc(sizeof(*gntdev_dmabuf), GFP_KERNEL);
 	if (!gntdev_dmabuf)
@@ -383,32 +387,23 @@ static int dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
 	exp_info.priv = gntdev_dmabuf;
 
 	gntdev_dmabuf->dmabuf = dma_buf_export(&exp_info);
-	if (IS_ERR(gntdev_dmabuf->dmabuf)) {
-		ret = PTR_ERR(gntdev_dmabuf->dmabuf);
-		gntdev_dmabuf->dmabuf = NULL;
-		goto fail;
-	}
-
-	ret = dma_buf_fd(gntdev_dmabuf->dmabuf, O_CLOEXEC);
-	if (ret < 0)
-		goto fail;
+	if (IS_ERR(gntdev_dmabuf->dmabuf))
+		return PTR_ERR(gntdev_dmabuf->dmabuf);
 
 	gntdev_dmabuf->fd = ret;
 	args->fd = ret;
 
 	pr_debug("Exporting DMA buffer with fd %d\n", ret);
 
+	get_file(gntdev_dmabuf->priv->filp);
 	mutex_lock(&args->dmabuf_priv->lock);
 	list_add(&gntdev_dmabuf->next, &args->dmabuf_priv->exp_list);
 	mutex_unlock(&args->dmabuf_priv->lock);
-	get_file(gntdev_dmabuf->priv->filp);
-	return 0;
 
-fail:
-	if (gntdev_dmabuf->dmabuf)
-		dma_buf_put(gntdev_dmabuf->dmabuf);
-	kfree(gntdev_dmabuf);
-	return ret;
+	fd = ret;
+	ret = -EBADF;
+	fd_install(fd, no_free_ptr(gntdev_dmabuf)->dmabuf->file);
+	return 0;
 }
 
 static struct gntdev_grant_map *
-- 
2.53.0



