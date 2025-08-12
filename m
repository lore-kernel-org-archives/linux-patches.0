Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA2320409A;
	Tue, 12 Aug 2025 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022384; cv=none; b=WRiSgXwr7ty5vFCCI9O4Y8mjbNu+j5ddu/rhSUizcOPXQWrDE3ppSbWoLWLSrqQER3DNof354qt5Xo8BY5UTebAN7yD2xDOYq3xr8lcZf8Dc/YjNP75U0wgAxsvPUQQd/3r49S9Or7VQ/TgNDW3bow9rJ7tWxRKMmUyPZflWiN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022384; c=relaxed/simple;
	bh=LpLgUCbse8F1nPsGg6CqxlCHfwWWEOikKvETC/tJVOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCelRFJyHqZkUScrZhtpV6HmGldK29KiBn+SzJNl8fZRGPubIhnDwhlFKEVZN5RZvSwOoTotFRk2SSmcKDt4Uk8u8GFrm5WUojSF1MCqXoiwuHfRAseW8M81rc1gvH1QslZ2l8V/U8WFXK0fx7yZ2m0Li2HeK/H5k+VjpB4s88Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUYzMut3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUYzMut3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8A0C4CEF0;
	Tue, 12 Aug 2025 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022384;
	bh=LpLgUCbse8F1nPsGg6CqxlCHfwWWEOikKvETC/tJVOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUYzMut3FeD+zhyU9dJh7Uk1geTorSeFB3GkGXo1TtSRYTuQPVRUGoORBXEwiipqT
	 0xxlp2UsKU4d5U6uL9rBLXQ+JJ4au9zMJCRgLPBeW5QuVP6M+yn0vZ1N4m7edx0s88
	 dMIezg6P5lkDoO4IEB++u3ubqu88V/duGuDQIkSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/369] xen: fix UAF in dmabuf_exp_from_pages()
Date: Tue, 12 Aug 2025 19:26:43 +0200
Message-ID: <20250812173018.767367734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/xen/gntdev-dmabuf.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 42adc2c1e06b..5ab973627d18 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -357,8 +357,11 @@ struct gntdev_dmabuf_export_args {
 static int dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
-	struct gntdev_dmabuf *gntdev_dmabuf;
-	int ret;
+	struct gntdev_dmabuf *gntdev_dmabuf __free(kfree) = NULL;
+	CLASS(get_unused_fd, ret)(O_CLOEXEC);
+
+	if (ret < 0)
+		return ret;
 
 	gntdev_dmabuf = kzalloc(sizeof(*gntdev_dmabuf), GFP_KERNEL);
 	if (!gntdev_dmabuf)
@@ -383,32 +386,21 @@ static int dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
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
+	fd_install(take_fd(ret), no_free_ptr(gntdev_dmabuf)->dmabuf->file);
+	return 0;
 }
 
 static struct gntdev_grant_map *
-- 
2.39.5



