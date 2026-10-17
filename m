Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A3E35E93B;
	Sat, 17 Oct 2026 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260454; cv=none; b=jigPNbP/s1Sd30cLwFw3KSfOJfqLiuO4oP2m9N+ThlcQcqEqou/yohDUfFfJzivU9TPbOo97+E6WGqgWlh1SPMAurNk/5tku9RMt43d1bwLVo1//2qAELJDouMjRdWfAmqXhKo8DC/6QO75mR2Ppos7FGCxAxBoFFd8nADIj7ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260454; c=relaxed/simple;
	bh=H7H21ixcUA4iE7J7ACnT9U3GYyvc4deTpyxtHpngXPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKD55UbNGVITSedcYnuNzlGtkamJBdP44+hbRDpL/WjhXNGZIP5tV5xDrVQtz6v45m0geQIVUC3Veu/kbItzfhdyZFX1bgb9rm7IPLsnMQzG9pIt67Ljbw23P7A1gcZDSGGYc0/+MCxURGLIBKSAizoWYF4SLo2lcBTKwrtGzfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixiWtu2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixiWtu2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F79E1F000C4;
	Sat, 17 Oct 2026 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260453;
	bh=MDP5t5WoQL8/xh9bgsEsVkixgJGJQjIRC680YoU775c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixiWtu2xpB5SuXKe3+wVRSAdyNEjOtSxfUiLF50LXXakauds/TTSnO+TMqz+bCZW7
	 kZ8YM/Xy/6WHr9BkVmO97uWk8pxnFWzq5GmSFUg4Ev+VMSG3p0zCFYVTlgj1mikPCX
	 ycJMfPrGJKTlXFlH3vuXHHMA8/5Laph4gHbFf9yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1551/1674] xen: fix UAF in dmabuf_exp_from_pages()
Date: Sat, 17 Oct 2026 18:03:43 +0200
Message-ID: <20261017160510.915669583@linuxfoundation.org>
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
index 42adc2c1e06b3..d7b56466bec5d 100644
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



