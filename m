Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0902EAE6;
	Mon, 23 Dec 2024 16:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969917; cv=none; b=W4UoVUEIUmX6GUfBPhtSWr/L3h4U41Wnwg8X58kp2PuhReuzy3BBKRzn4/XbhfsNLnzwU8X+0KPryU5MrRaD91wpRbqxZi62Uxiro6BzkGXxSKw3qjvJYbzsbMB+U2/3NlcrkMkrEAgiea8P8pk9BNj0z8UfX0hoZpOqSn8TN1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969917; c=relaxed/simple;
	bh=u1xOu/mU90zsJmwLxZItSdaG/Ia4QBghzBc5CxxRqdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xds8ZfZgG+7pUt4ostSA75rbWOCi3WA1MSo0nENUU82X/IHr48bcyjIocTMRqNZMChwsl3Np5p8DRvcng7enK9Kot99OI1iUhiAO/lbMVeZQpXeyaYj9Y4FEN7FBdrD79JCo9DBF8CaKsCn79/Rvj/UB/+L27T3NbcdwzK3IH2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjFgFNR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjFgFNR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477DAC4CED3;
	Mon, 23 Dec 2024 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969916;
	bh=u1xOu/mU90zsJmwLxZItSdaG/Ia4QBghzBc5CxxRqdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjFgFNR+3WXj/wrTh28onR3uNg7yC9VBAzC8n2rgABiOArMQA3XxI2VyhbKxhkMSp
	 XmkpOhEpo3zvTjOTjOxZyLe30DKS6qjBihNdC0z+w3fziutZ1uCl12G9jS5rTJf+e+
	 riCq4/mq40T742veK0FyPFG8KkfZcDocyBhR6Xao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/160] udmabuf: fix memory leak on last export_udmabuf() error path
Date: Mon, 23 Dec 2024 16:58:22 +0100
Message-ID: <20241223155412.209251082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jann Horn <jannh@google.com>

[ Upstream commit f49856f525acd5bef52ae28b7da2e001bbe7439e ]

In export_udmabuf(), if dma_buf_fd() fails because the FD table is full, a
dma_buf owning the udmabuf has already been created; but the error handling
in udmabuf_create() will tear down the udmabuf without doing anything about
the containing dma_buf.

This leaves a dma_buf in memory that contains a dangling pointer; though
that doesn't seem to lead to anything bad except a memory leak.

Fix it by moving the dma_buf_fd() call out of export_udmabuf() so that we
can give it different error handling.

Note that the shape of this code changed a lot in commit 5e72b2b41a21
("udmabuf: convert udmabuf driver to use folios"); but the memory leak
seems to have existed since the introduction of udmabuf.

Fixes: fbb0de795078 ("Add udmabuf misc device")
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204-udmabuf-fixes-v2-3-23887289de1c@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 970e08a95dc0..614df433c451 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -276,12 +276,10 @@ static int check_memfd_seals(struct file *memfd)
 	return 0;
 }
 
-static int export_udmabuf(struct udmabuf *ubuf,
-			  struct miscdevice *device,
-			  u32 flags)
+static struct dma_buf *export_udmabuf(struct udmabuf *ubuf,
+				      struct miscdevice *device)
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
-	struct dma_buf *buf;
 
 	ubuf->device = device;
 	exp_info.ops  = &udmabuf_ops;
@@ -289,11 +287,7 @@ static int export_udmabuf(struct udmabuf *ubuf,
 	exp_info.priv = ubuf;
 	exp_info.flags = O_RDWR;
 
-	buf = dma_buf_export(&exp_info);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
-
-	return dma_buf_fd(buf, flags);
+	return dma_buf_export(&exp_info);
 }
 
 static long udmabuf_pin_folios(struct udmabuf *ubuf, struct file *memfd,
@@ -356,6 +350,7 @@ static long udmabuf_create(struct miscdevice *device,
 {
 	pgoff_t pgcnt = 0, pglimit;
 	struct udmabuf *ubuf;
+	struct dma_buf *dmabuf;
 	long ret = -EINVAL;
 	u32 i, flags;
 
@@ -413,9 +408,20 @@ static long udmabuf_create(struct miscdevice *device,
 	}
 
 	flags = head->flags & UDMABUF_FLAGS_CLOEXEC ? O_CLOEXEC : 0;
-	ret = export_udmabuf(ubuf, device, flags);
-	if (ret < 0)
+	dmabuf = export_udmabuf(ubuf, device);
+	if (IS_ERR(dmabuf)) {
+		ret = PTR_ERR(dmabuf);
 		goto err;
+	}
+	/*
+	 * Ownership of ubuf is held by the dmabuf from here.
+	 * If the following dma_buf_fd() fails, dma_buf_put() cleans up both the
+	 * dmabuf and the ubuf (through udmabuf_ops.release).
+	 */
+
+	ret = dma_buf_fd(dmabuf, flags);
+	if (ret < 0)
+		dma_buf_put(dmabuf);
 
 	return ret;
 
-- 
2.39.5



