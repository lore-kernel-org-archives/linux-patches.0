Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AC73DD851;
	Tue, 16 Jun 2026 19:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636914; cv=none; b=T5GXCCJRjmqgSGZo5vBqJZySqFU15CRE0PaWl16HWnrBpT7J6zkswl38sAcMiQ34YkfEMF3hG4CoaHP7fjcJpl2DVi6bQdzJ9gwqPqACP5sgzJcuowmkETIwK1PYCpZX0a4wyGem5BKzoqyu3JGBxZFs87e+NxhqG6N4JEffz0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636914; c=relaxed/simple;
	bh=kbNPx//kKnvorTTXZ11GhmczXMpzLQ5RiHPYtRTGdrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsEwJEne/1gcAxRA7KnCThqsPfGN4D1b4LqAKNEsXBDs0//8dP1Vnp3IomVEtLNh0s/skLa+r5juhF0uvfF6Yk7t24+aAZHDV2SAXKACn019NRIvUKwZpQXGDMhzFBdoq+eBSv83Hd1yNYfpoyILYCJOMvSRziSuwjcHYJ4c0w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylVhSwRe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylVhSwRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25451F000E9;
	Tue, 16 Jun 2026 19:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636913;
	bh=maTdGr5MIISv5cTfb+R5j2zY5RfxdSEzycWPBLH7D5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylVhSwRebF0azQRfWwRAJ32tlBUXKsbuA/LoWEnxZv6IAYhJfaTuc27vs4Foa1yOx
	 VNWXxv2wxaNTDFbusvRsrCkCki3BDbd/EjtBYKV4pIzNYF9Xz89fWcEuBdddkv/gqV
	 NgXNt/YIobCtumgjhQgp9hqvfu3s5DxgFlNZ6Y/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	John Keeping <john@metanate.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/342] usb: gadget: f_hid: tidy error handling in hidg_alloc
Date: Tue, 16 Jun 2026 20:30:26 +0530
Message-ID: <20260616145103.970610358@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <john@metanate.com>

[ Upstream commit 944fe915d00d3cb1bacb1e77cabfb6dc82e6f8b8 ]

Unify error handling at the end of the function, reducing the risk of
missing something on one of the error paths.

Moving the increment of opts->refcnt later means there is no need to
decrement it on the error path and is safe as this is guarded by
opts->lock which is held for this entire section.

Tested-by: Lee Jones <lee@kernel.org>
Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20221122123523.3068034-4-john@metanate.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4f88d65def6f ("usb: gadget: f_hid: fix device reference leak in hidg_alloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1265,7 +1265,6 @@ static struct usb_function *hidg_alloc(s
 	opts = container_of(fi, struct f_hid_opts, func_inst);
 
 	mutex_lock(&opts->lock);
-	++opts->refcnt;
 
 	spin_lock_init(&hidg->write_spinlock);
 	spin_lock_init(&hidg->read_spinlock);
@@ -1278,11 +1277,8 @@ static struct usb_function *hidg_alloc(s
 	hidg->dev.class = hidg_class;
 	hidg->dev.devt = MKDEV(major, opts->minor);
 	ret = dev_set_name(&hidg->dev, "hidg%d", opts->minor);
-	if (ret) {
-		--opts->refcnt;
-		mutex_unlock(&opts->lock);
-		return ERR_PTR(ret);
-	}
+	if (ret)
+		goto err_unlock;
 
 	hidg->bInterfaceSubClass = opts->subclass;
 	hidg->bInterfaceProtocol = opts->protocol;
@@ -1293,14 +1289,13 @@ static struct usb_function *hidg_alloc(s
 					    opts->report_desc_length,
 					    GFP_KERNEL);
 		if (!hidg->report_desc) {
-			put_device(&hidg->dev);
-			--opts->refcnt;
-			mutex_unlock(&opts->lock);
-			return ERR_PTR(-ENOMEM);
+			ret = -ENOMEM;
+			goto err_put_device;
 		}
 	}
 	hidg->use_out_ep = !opts->no_out_endpoint;
 
+	++opts->refcnt;
 	mutex_unlock(&opts->lock);
 
 	hidg->func.name    = "hid";
@@ -1315,6 +1310,12 @@ static struct usb_function *hidg_alloc(s
 	hidg->qlen	   = 4;
 
 	return &hidg->func;
+
+err_put_device:
+	put_device(&hidg->dev);
+err_unlock:
+	mutex_unlock(&opts->lock);
+	return ERR_PTR(ret);
 }
 
 DECLARE_USB_FUNCTION_INIT(hid, hidg_alloc_inst, hidg_alloc);


