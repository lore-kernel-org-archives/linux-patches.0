Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DB03BB67F;
	Sat, 17 Oct 2026 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258308; cv=none; b=JFK1iBZKznVeLIfbiz3wQfGydSEcllzs66aeU7AEjL2w6kgDK4swlb4GiX/4e10U0pPhlAerG9S/Q5j+CV0a5pOiGsdWDtxk6wM6st0/xnas3wqVIJmtkh6Wnbxq40QbPyZmfs11bJisVfwJEcW+hNxz3gCIyI4KA2oXR0ViEPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258308; c=relaxed/simple;
	bh=YCJ/bhINO1TloNZETBdqDo7W9VsIpw8KaKxSQGwMKsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXLp8xjv/eOPo2yRhDpsUN/ZbKNNKEaxCH2MOikyNvemGvl3hLIWIVd+qKfEAQSc8/EC1647tS8UjtIqMIUjNQZpcB6E3wMsloGbBBm9xo6VNM0zocdCMYAbxKK5IyvEoaNfQhMvX7R4YjfQXW/nqiUuXh7nxwnHGYwx82Dn2pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfoZ856E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfoZ856E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA741F000C5;
	Sat, 17 Oct 2026 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258307;
	bh=eEmGT5x6exy+gOg4J5jl+KvZf3J+uj60IV09QrmyeBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfoZ856EwPeljyFuuaC3QoDnM10YdL6qCVISqoW0IxuqaG0kbRvAADIxlgAM5p13o
	 xVwOYG/BbXI2FOvt5HaY9FvAnkXSWFF1oFyRLRnQLK1rMSpnr71Z/PgehNvFFKE4Bk
	 xIfH6f67Q+dSRE5oNj8g40TndCLtDFaaLTgEnVPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0839/1674] usb: gadget: functionfs: Factorize wait-for-endpoint code
Date: Sat, 17 Oct 2026 17:51:51 +0200
Message-ID: <20261017160452.665603670@linuxfoundation.org>
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
index 47aaa33d091fa..f2705e22ed732 100644
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



