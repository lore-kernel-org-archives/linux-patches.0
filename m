Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214698;
	b=ARXXNUsYsAnf0uOSI5S9hfOEBIXqBEMduC0+c1+pBVYhjFKEZ9/SG+ZPWVp3yKL5ZuQX
	 hIes/t/Udn0ei88ydINaIvPxN5ni3KMYbIGfyflCJaFBPiYtvUuWGbZmTf4ZPbBgOdbm8
	 LUspK7iFv7LctULLU/fZxU0zVs7rV8ao5v0e8A9irJYe15kIS4aUiihMY2zLqcCYz0k6G
	 sPTb0jH3yZ9WDS5QoDysGwxuFQvPzj0Cp1ANivXQeb5A9ibJmJzvuhoeLo105s73bnUkN
	 V+fOpVq5sKjNQiz0HyEk7A670rJWPi9vD3FuKw9/jTOaLtyOQ9JeqKd76HgXT+5v6bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RkvVwvguM8mFEkEzZ9ExdQ6H1UaV+eYrjX8/DmiYfH8=;
	b=0KEPutM4wBkiWfP2EAgFi3pTZxigpVFhgbqFGdrJ19hrqhiZCvXxA9CIJECcHZw490dW
	 easXt2qji6W+UJL51potKfDQjd8ukkpr5ACCftFRRvXqQ1he5A4YXKbUCc1TrurMU1rMa
	 kgeV6fb7hAzy0pCw1fH3+Q7LSZMP2ZGG0xveAO304SRciIGg7BeFRkhz7MtLbX3Dqb3+r
	 8rgHNr+jjkBk4FPXSKZMuj0CTLwJPxWR0Kif8stGTmfZ1i3FbYLTJjkTkIqpPSnbLkakA
	 n0MDUDe1O04Xqz4ZuSBLZMcJWPbtNTyHFW5R+3B4cRRTgtxxV6ZA754bpwevr9qQ0vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WeEtLfMP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BDF606A337;
	Wed, 28 Oct 2026 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WeEtLfMP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38681F01825;
	Wed, 28 Oct 2026 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214697;
	bh=RkvVwvguM8mFEkEzZ9ExdQ6H1UaV+eYrjX8/DmiYfH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WeEtLfMPet9UxAGBkS4nj9v8ScJYJtZHtw0/FJB8/WFcq2DOxil3FrRxDmOBDjxkq
	 InWS3/iFXZij34ugqVZcD2F0+GBHIjZXr80RrV4g5uZwg5jBNhZMILRHU1Eh7ss99R
	 WHIl9/WKSwrfBvVu/VG4f0L/rd+b1x5czyifMyUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0906/1887] usb: gadget: functionfs: Factorize wait-for-endpoint code
Date: Wed, 28 Oct 2026 17:50:02 +0100
Message-ID: <20261028170520.033449116@linuxfoundation.org>
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

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 799970a5b15deec8bbcb098b11a73d8acc55d075 ]

This exact same code was duplicated in two different places.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20240130122340.54813-3-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e5bf5ee26663 ("functionfs: fix the open/removal races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 48 +++++++++++++++++-------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 3a1f823d71acf..e3a4d5819f004 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -952,31 +952,44 @@ static ssize_t __ffs_epfile_read_data(struct ffs_epfile *epfile,
 	return ret;
 }
 
-static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
+static struct ffs_ep *ffs_epfile_wait_ep(struct file *file)
 {
 	struct ffs_epfile *epfile = file->private_data;
-	struct usb_request *req;
 	struct ffs_ep *ep;
-	char *data = NULL;
-	ssize_t ret, data_len = -EINVAL;
-	int halt;
-
-	/* Are we still active? */
-	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
-		return -ENODEV;
+	int ret;
 
 	/* Wait for endpoint to be enabled */
 	ep = epfile->ep;
 	if (!ep) {
 		if (file->f_flags & O_NONBLOCK)
-			return -EAGAIN;
+			return ERR_PTR(-EAGAIN);
 
 		ret = wait_event_interruptible(
 				epfile->ffs->wait, (ep = epfile->ep));
 		if (ret)
-			return -EINTR;
+			return ERR_PTR(-EINTR);
 	}
 
+	return ep;
+}
+
+static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
+{
+	struct ffs_epfile *epfile = file->private_data;
+	struct usb_request *req;
+	struct ffs_ep *ep;
+	char *data = NULL;
+	ssize_t ret, data_len = -EINVAL;
+	int halt;
+
+	/* Are we still active? */
+	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
+		return -ENODEV;
+
+	ep = ffs_epfile_wait_ep(file);
+	if (IS_ERR(ep))
+		return PTR_ERR(ep);
+
 	/* Do we halt? */
 	halt = (!io_data->read == !epfile->in);
 	if (halt && epfile->isoc)
@@ -1308,16 +1321,9 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 		return -ENODEV;
 
 	/* Wait for endpoint to be enabled */
-	ep = epfile->ep;
-	if (!ep) {
-		if (file->f_flags & O_NONBLOCK)
-			return -EAGAIN;
-
-		ret = wait_event_interruptible(
-				epfile->ffs->wait, (ep = epfile->ep));
-		if (ret)
-			return -EINTR;
-	}
+	ep = ffs_epfile_wait_ep(file);
+	if (IS_ERR(ep))
+		return PTR_ERR(ep);
 
 	spin_lock_irq(&epfile->ffs->eps_lock);
 
-- 
2.53.0



