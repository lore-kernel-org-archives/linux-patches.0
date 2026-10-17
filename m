Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092D23CF202;
	Sat, 17 Oct 2026 17:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258438; cv=none; b=fwJL8xZlPk+wjabDBjAL3lSyRZYkfdjD2B72coyXmvZh8cWFJ8oEA0/UO1WF4i1txhJkcW3AkortidYXFUp3d57gKzI6z/X/qjQNkXim/PCtTR5rl1S58ukvTYVqwDnaUBGHSKlFyXztd1cwb3/H85Ku6UK3endenL7StfgmhJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258438; c=relaxed/simple;
	bh=PRvqsg0ybG4rNlzS+k+uBAfjNRXI4TGz601aepIiFjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3jWsWLOXjbgq8rkb7t6EKVmkxYA3z1oe5m0yIg6uNWIsw78bLllhMX7jBr8F5jkUx5VcocieZwf0b/x48jwsyjN9pU/BBkBaSVP10VAPxY1ooS48hMaYgzcLVXdVZPqVboRPJb+UShIRgU88bvP78LF4ySW1zHl1/aptKHLH0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ch8bwtiL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ch8bwtiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96B31F000C5;
	Sat, 17 Oct 2026 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258436;
	bh=EmbiS3yRnn5RxeNrExibPMfyklZPcL8meVUXIbo5K/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ch8bwtiLKirp0tSwH72xSiO/GFdKWrTpEyws9TgidUxjHpaelRWHluNeQIFK+NAE1
	 31MJnUYb5CT6EytZ5z+i1cKPxOCk+RetfYHEPHezggWaPJPRc3oc9dxHcoC97hFIeq
	 q3ky/X6M2yPP1OPZNJX1UWeNXvB/lu26+zW/mbg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0882/1674] usb: gadget: f_hid: dont call cdev_init while cdev in use
Date: Sat, 17 Oct 2026 17:52:34 +0200
Message-ID: <20261017160453.755828044@linuxfoundation.org>
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

From: Michael Zimmermann <sigmaepsilon92@gmail.com>

[ Upstream commit 81ebd43cc0d6d106ce7b6ccbf7b5e40ca7f5503d ]

When calling unbind, then bind again, cdev_init reinitialized the cdev,
even though there may still be references to it. That's the case when
the /dev/hidg* device is still opened. This obviously unsafe behavior
like oopes.

This fixes this by using cdev_alloc to put the cdev on the heap. That
way, we can simply allocate a new one in hidg_bind.

Closes: https://lore.kernel.org/linux-usb/CAN9vWDKZn0Ts5JyV2_xcAmbnBEi0znMLg_USMFrShRryXrgWGQ@mail.gmail.com/T/#m2cb0dba3633b67b2a679c98499508267d1508881
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Zimmermann <sigmaepsilon92@gmail.com>
Link: https://patch.msgid.link/20260327192209.59945-1-sigmaepsilon92@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 1246964790987..d7bc83b5f1a91 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -76,7 +76,7 @@ struct f_hidg {
 	struct usb_request		*req;
 
 	struct device			dev;
-	struct cdev			cdev;
+	struct cdev			*cdev;
 	struct usb_function		func;
 
 	struct usb_ep			*in_ep;
@@ -558,8 +558,9 @@ static int f_hidg_release(struct inode *inode, struct file *fd)
 
 static int f_hidg_open(struct inode *inode, struct file *fd)
 {
+	struct kobject *parent = inode->i_cdev->kobj.parent;
 	struct f_hidg *hidg =
-		container_of(inode->i_cdev, struct f_hidg, cdev);
+		container_of(parent, struct f_hidg, dev.kobj);
 
 	fd->private_data = hidg;
 
@@ -1004,8 +1005,14 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 	hidg->req = NULL;
 
 	/* create char device */
-	cdev_init(&hidg->cdev, &f_hidg_fops);
-	status = cdev_device_add(&hidg->cdev, &hidg->dev);
+	hidg->cdev = cdev_alloc();
+	if (!hidg->cdev) {
+		status = -ENOMEM;
+		goto fail_free_descs;
+	}
+	hidg->cdev->ops = &f_hidg_fops;
+
+	status = cdev_device_add(hidg->cdev, &hidg->dev);
 	if (status)
 		goto fail_free_descs;
 
@@ -1250,7 +1257,7 @@ static void hidg_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_hidg *hidg = func_to_hidg(f);
 
-	cdev_device_del(&hidg->cdev, &hidg->dev);
+	cdev_device_del(hidg->cdev, &hidg->dev);
 
 	usb_free_all_descriptors(f);
 }
-- 
2.53.0



