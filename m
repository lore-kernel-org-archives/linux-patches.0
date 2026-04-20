Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E6C2E11C7;
	Mon, 20 Apr 2026 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700425; cv=none; b=ZiUIzSP7yeP4wiDETUe6kcU/ikGJIaxchXRvaBUemrgp0RsmoE9UWEGRY/4BccD0rM3OdZM3rjFsW3v69R2GyIxOYSfXCEWGDwk8LxoHakSZJJih4OHdaQsqWm3Xsz2pNdc1OWkbIlPKn+NccJdx+8z+V++SJDsgEq/AO3QvNy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700425; c=relaxed/simple;
	bh=9hvSbGue85kWPwdCayGuj7VVVgwbJYATviwHX2aS9yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKQettclqjo93XV9KKjSeMLA2MJPUKIBmUK/dpOjwiVLgD9+RgQHqf2MEWjCYkHcSViKa5PY+fwTuPBK/ZjW/zoz+Ebd8FXFAjJZ1RBXrXLoG1a8+RtX7Vuvgv3E9OWQHwkZOqI6VTwpr7oc/jJadoDonnMHv7Lu8T2PLCnpEls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFqaSQKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFqaSQKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0568BC19425;
	Mon, 20 Apr 2026 15:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700425;
	bh=9hvSbGue85kWPwdCayGuj7VVVgwbJYATviwHX2aS9yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFqaSQKbqZNMxTSnsZZMoMJv1AJBv07+TFbgCayFBYoWVCpJwyjYlal5aITGRXkTJ
	 vd355q/bESe9UyTNSGc+L75IW+xXndtvqShWEKbDAvBAmiqm99MAYfB45ACvG/lZzm
	 +M1+6rJGYO4VG4jo5pEzWkoYKvPpl786nGehnK2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>
Subject: [PATCH 6.19 167/220] usb: gadget: f_hid: dont call cdev_init while cdev in use
Date: Mon, 20 Apr 2026 17:41:48 +0200
Message-ID: <20260420153940.040532112@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Zimmermann <sigmaepsilon92@gmail.com>

commit 81ebd43cc0d6d106ce7b6ccbf7b5e40ca7f5503d upstream.

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
---
 drivers/usb/gadget/function/f_hid.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -106,7 +106,7 @@ struct f_hidg {
 	struct list_head		report_list;
 
 	struct device			dev;
-	struct cdev			cdev;
+	struct cdev			*cdev;
 	struct usb_function		func;
 
 	struct usb_ep			*in_ep;
@@ -749,8 +749,9 @@ static int f_hidg_release(struct inode *
 
 static int f_hidg_open(struct inode *inode, struct file *fd)
 {
+	struct kobject *parent = inode->i_cdev->kobj.parent;
 	struct f_hidg *hidg =
-		container_of(inode->i_cdev, struct f_hidg, cdev);
+		container_of(parent, struct f_hidg, dev.kobj);
 
 	fd->private_data = hidg;
 
@@ -1276,8 +1277,12 @@ static int hidg_bind(struct usb_configur
 	}
 
 	/* create char device */
-	cdev_init(&hidg->cdev, &f_hidg_fops);
-	status = cdev_device_add(&hidg->cdev, &hidg->dev);
+	hidg->cdev = cdev_alloc();
+	if (!hidg->cdev)
+		goto fail_free_all;
+	hidg->cdev->ops = &f_hidg_fops;
+
+	status = cdev_device_add(hidg->cdev, &hidg->dev);
 	if (status)
 		goto fail_free_all;
 
@@ -1579,7 +1584,7 @@ static void hidg_unbind(struct usb_confi
 {
 	struct f_hidg *hidg = func_to_hidg(f);
 
-	cdev_device_del(&hidg->cdev, &hidg->dev);
+	cdev_device_del(hidg->cdev, &hidg->dev);
 	destroy_workqueue(hidg->workqueue);
 	usb_free_all_descriptors(f);
 }


