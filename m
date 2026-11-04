Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827023;
	b=d2tARVR9JA6J9IXPMDYIBZ2mEKVli9ZpC/lwXDdVU37+EQl2Geabc3Ve0KrkG/UqOqVr
	 VViFEwxwuaMwDDN67FWiuUr69bzGXaBNJEi2PTLlPTl2QNrrMlwSbcYtLalgNpJZbGFqe
	 e/04GOBdyyBfC8TGaLfRpgkICPXSuq9k6v/6WdDGkP1ltmShGoL8vvAACItNn75SZQB51
	 95I/DtsQjXlzxhqLhVeWiAwv5p9ENukgSoITofwfmFKD70Yvhg8cknaSybCINo0ylSEtd
	 7nnuTX4iKlAjxzmgttNJoY3v+w+45zDx8vKKRpYVAF+A6XeAV2r2kvylF/rmd6tDZzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pFVgEHLyCpgs1Mk6TOLmW6Eilu5ReYVB41pwr74+ft4=;
	b=J8VYqvTTvfyZHvv/bXNP6CfSSYuq+WJecjf+IdoVGacgGpLzHgUd4QJTJa2y281TKo/T
	 IP665CsZanTaJaV9VAOGfi+XqmKWs0E48TbcCzkNtO4+WNoX99tqGdBcLRIw20s8p0Op6
	 tYCeyE7uA2NkHVG9V1JB3PDZ2oWkh0tWjVhfHUXn9nB482B1Vd/7kMSvecVW5JN51R1NM
	 1870juPcak1xPXqLIQV7RCqe8mwWRTlWdFuyD2BlvPknA5QVI8q2Ns1SdxNi7rY3ePjnz
	 31Q46lQGw2fjaCvceZVK8BYKYCa7AwFNgC+6jnyTeI2ma7xCVZ8GmZ+R45blfbj9efw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MVap0g6C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F1D6086E71;
	Wed,  4 Nov 2026 21:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MVap0g6C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803AA1F00A02;
	Wed,  4 Nov 2026 21:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827022;
	bh=pFVgEHLyCpgs1Mk6TOLmW6Eilu5ReYVB41pwr74+ft4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVap0g6CqUE3SjSBhrJtyin6XRTeQblk9rUIoIawcPMAcDWkCRd/rG+5me9dgw8RM
	 C7Nh02XvqwXI8E6jnlBejzy+rlO/5bktgrZeBlNRajC+vq7Bl4FnJVvS98PazeulKZ
	 BDXc+IQhCtU8l3st67T+EvFcUJJz6HP/mUQfiAkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 7.3 149/547] pps: generators: fix use-after-free when closing a removed device
Date: Wed,  4 Nov 2026 16:05:33 -0500
Message-ID: <20261104211042.400348941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

commit d19552611cb2eb6329826871565e5309bec2f288 upstream.

The cdev of a PPS generator is embedded in struct pps_gen_device, but
nothing ties the lifetime of that structure to the cdev: pps_gen is
freed by the release function of its device, and an open file holds a
device reference only until pps_gen_cdev_release() drops it.

When the generator is unregistered while /dev/pps-genN is open, that
put_device() drops the last reference and frees pps_gen, and __fput()
then calls cdev_put() on the freed cdev:

  BUG: KASAN: slab-use-after-free in cdev_put+0x53/0x60
  Read of size 8 at addr ffff88801383e138 by task ppsgen64/149
  Call Trace:
   cdev_put+0x53/0x60
   __fput+0x745/0xad0
   fput_close_sync+0xd9/0x1b0
   __x64_sys_close+0x86/0xf0
  ...
  Freed by task 149:
   kfree+0x25a/0x6d0
   device_release+0xca/0x3c0
   kobject_put+0x169/0x320
   pps_gen_cdev_release+0x51/0x80
   __fput+0x36a/0xad0

pps.c had the same bug, fixed in commit c79a39dc8d06 ("pps: Fix a
use-after-free").

Fix it the usual way: embed the struct device in pps_gen_device and
register both with cdev_device_add(). This makes the device the parent
of the cdev, so the cdev holds a device reference until the last file
is closed.

Fixes: 86b525bed275 ("drivers pps: add PPS generators support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://patch.msgid.link/20260929124937.51114-2-danishkhateeb03@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pps/generators/pps_gen.c |   63 +++++++++++++++++++--------------------
 include/linux/pps_gen_kernel.h   |    2 -
 2 files changed, 32 insertions(+), 33 deletions(-)

--- a/drivers/pps/generators/pps_gen.c
+++ b/drivers/pps/generators/pps_gen.c
@@ -63,7 +63,7 @@ static long pps_gen_cdev_ioctl(struct fi
 
 	switch (cmd) {
 	case PPS_GEN_SETENABLE:
-		dev_dbg(pps_gen->dev, "PPS_GEN_SETENABLE\n");
+		dev_dbg(&pps_gen->dev, "PPS_GEN_SETENABLE\n");
 
 		ret = get_user(status, uiuarg);
 		if (ret)
@@ -77,7 +77,7 @@ static long pps_gen_cdev_ioctl(struct fi
 		break;
 
 	case PPS_GEN_USESYSTEMCLOCK:
-		dev_dbg(pps_gen->dev, "PPS_GEN_USESYSTEMCLOCK\n");
+		dev_dbg(&pps_gen->dev, "PPS_GEN_USESYSTEMCLOCK\n");
 
 		ret = put_user(pps_gen->info->use_system_clock, uiuarg);
 		if (ret)
@@ -89,12 +89,12 @@ static long pps_gen_cdev_ioctl(struct fi
 		struct pps_gen_event info;
 		unsigned int ev = pps_gen->last_ev;
 
-		dev_dbg(pps_gen->dev, "PPS_GEN_FETCHEVENT\n");
+		dev_dbg(&pps_gen->dev, "PPS_GEN_FETCHEVENT\n");
 
 		ret = wait_event_interruptible(pps_gen->queue,
 				ev != pps_gen->last_ev);
 		if (ret == -ERESTARTSYS) {
-			dev_dbg(pps_gen->dev, "pending signal caught\n");
+			dev_dbg(&pps_gen->dev, "pending signal caught\n");
 			return -EINTR;
 		}
 
@@ -121,7 +121,7 @@ static int pps_gen_cdev_open(struct inod
 	struct pps_gen_device *pps_gen = container_of(inode->i_cdev,
 				struct pps_gen_device, cdev);
 
-	get_device(pps_gen->dev);
+	get_device(&pps_gen->dev);
 	file->private_data = pps_gen;
 	return 0;
 }
@@ -130,7 +130,7 @@ static int pps_gen_cdev_release(struct i
 {
 	struct pps_gen_device *pps_gen = file->private_data;
 
-	put_device(pps_gen->dev);
+	put_device(&pps_gen->dev);
 	return 0;
 }
 
@@ -151,19 +151,15 @@ static void pps_gen_device_destruct(stru
 {
 	struct pps_gen_device *pps_gen = dev_get_drvdata(dev);
 
-	cdev_del(&pps_gen->cdev);
-
 	pr_debug("deallocating pps-gen%d\n", pps_gen->id);
 	ida_free(&pps_gen_ida, pps_gen->id);
 
-	kfree(dev);
 	kfree(pps_gen);
 }
 
 static int pps_gen_register_cdev(struct pps_gen_device *pps_gen)
 {
 	int err;
-	dev_t devt;
 
 	err = ida_alloc_max(&pps_gen_ida, PPS_GEN_MAX_SOURCES - 1, GFP_KERNEL);
 	if (err < 0) {
@@ -171,46 +167,52 @@ static int pps_gen_register_cdev(struct
 			pr_err("too many PPS sources in the system\n");
 			err = -EBUSY;
 		}
+		kfree(pps_gen);
 		return err;
 	}
 	pps_gen->id = err;
 
-	devt = MKDEV(MAJOR(pps_gen_devt), pps_gen->id);
+	/*
+	 * From here on pps_gen belongs to its device and is freed by
+	 * pps_gen_device_destruct(). The cdev holds a reference to the
+	 * device, so pps_gen stays around until the last file is closed.
+	 */
+	device_initialize(&pps_gen->dev);
+	pps_gen->dev.class = &pps_gen_class;
+	pps_gen->dev.parent = pps_gen->info->parent;
+	pps_gen->dev.devt = MKDEV(MAJOR(pps_gen_devt), pps_gen->id);
+	pps_gen->dev.release = pps_gen_device_destruct;
+	dev_set_drvdata(&pps_gen->dev, pps_gen);
 
 	cdev_init(&pps_gen->cdev, &pps_gen_cdev_fops);
 	pps_gen->cdev.owner = pps_gen->info->owner;
 
-	err = cdev_add(&pps_gen->cdev, devt, 1);
+	err = dev_set_name(&pps_gen->dev, "pps-gen%d", pps_gen->id);
+	if (err)
+		goto put_dev;
+
+	err = cdev_device_add(&pps_gen->cdev, &pps_gen->dev);
 	if (err) {
 		pr_err("failed to add char device %d:%d\n",
 				MAJOR(pps_gen_devt), pps_gen->id);
-		goto free_ida;
+		goto put_dev;
 	}
-	pps_gen->dev = device_create(&pps_gen_class, pps_gen->info->parent, devt,
-				     pps_gen, "pps-gen%d", pps_gen->id);
-	if (IS_ERR(pps_gen->dev)) {
-		err = PTR_ERR(pps_gen->dev);
-		goto del_cdev;
-	}
-	pps_gen->dev->release = pps_gen_device_destruct;
-	dev_set_drvdata(pps_gen->dev, pps_gen);
 
 	pr_debug("generator got cdev (%d:%d)\n",
 			MAJOR(pps_gen_devt), pps_gen->id);
 
 	return 0;
 
-del_cdev:
-	cdev_del(&pps_gen->cdev);
-free_ida:
-	ida_free(&pps_gen_ida, pps_gen->id);
+put_dev:
+	put_device(&pps_gen->dev);
 	return err;
 }
 
 static void pps_gen_unregister_cdev(struct pps_gen_device *pps_gen)
 {
 	pr_debug("unregistering pps-gen%d\n", pps_gen->id);
-	device_destroy(&pps_gen_class, pps_gen->dev->devt);
+	cdev_device_del(&pps_gen->cdev, &pps_gen->dev);
+	put_device(&pps_gen->dev);
 }
 
 /*
@@ -244,18 +246,15 @@ struct pps_gen_device *pps_gen_register_
 	init_waitqueue_head(&pps_gen->queue);
 	spin_lock_init(&pps_gen->lock);
 
-	/* Create the char device */
+	/* Create the char device, this frees pps_gen on failure */
 	err = pps_gen_register_cdev(pps_gen);
 	if (err < 0) {
 		pr_err(" unable to create char device\n");
-		goto kfree_pps_gen;
+		goto pps_gen_register_source_exit;
 	}
 
 	return pps_gen;
 
-kfree_pps_gen:
-	kfree(pps_gen);
-
 pps_gen_register_source_exit:
 	pr_err("unable to register generator\n");
 
@@ -289,7 +288,7 @@ void pps_gen_event(struct pps_gen_device
 {
 	unsigned long flags;
 
-	dev_dbg(pps_gen->dev, "PPS generator event %u\n", event);
+	dev_dbg(&pps_gen->dev, "PPS generator event %u\n", event);
 
 	spin_lock_irqsave(&pps_gen->lock, flags);
 
--- a/include/linux/pps_gen_kernel.h
+++ b/include/linux/pps_gen_kernel.h
@@ -54,7 +54,7 @@ struct pps_gen_device {
 
 	unsigned int id;			/* PPS generator unique ID */
 	struct cdev cdev;
-	struct device *dev;
+	struct device dev;
 	struct fasync_struct *async_queue;	/* fasync method */
 	spinlock_t lock;
 };


