Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869064071DD;
	Sun,  7 Jun 2026 10:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829527; cv=none; b=dydKYO224f0ncTRMSfXt84gJCOQVBAXDmgA58HQsPK/BvF9CNZC9obmeYphiG6lhe/CedMraBAGlXpqTbkZV9aiUWMzOFKtugyIQ9KUdNXvPWsj/c/xtahwAk1A5Ccb5MMScwvyYuOqJEH8e5NrFeNAAvddhnjt8rj3a3kjW2cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829527; c=relaxed/simple;
	bh=lud6B+IhxQ0zALudTu/BrOFMFFXcCBBO07PGDvcl+3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ym+2HgtF+6HW5nzNgK61Kx9dxm834zqV3Fq0iFbly6D6qeZI/3QgApNV7Ol68c70ZDk8z+UWmH2pvFB+N8jfvjhkv0O7DY9p+Rab4zVyeAd1B69zbuzYvvORU4clVYgRZ5RLMWZ63wNSgraoWCYkS3UC24zaaVFIh3aSwvepZ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j76C6doW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j76C6doW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEC71F00893;
	Sun,  7 Jun 2026 10:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829526;
	bh=gVtUz1UDeOqFHoLfdtmkI4vG7AvRYB7nQXUTkyGV6C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j76C6doWDtK12zE7jXRhh9kP1BrcIs8pPGj/65YJRaV684OtHWI6PSSLPJC/JYvJL
	 iihRbh7vRrvoUphJDFS+KXY5Kv5c+yNGZCXqWqp7kX4EsZnyU+xjmzc8WcLTzwZDP5
	 6PHWKzgvN7/h+CbDj+DSdcHgB9elOGFg1GqoEtrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 6.12 232/307] usb: gadget: f_hid: fix device reference leak in hidg_alloc()
Date: Sun,  7 Jun 2026 12:00:29 +0200
Message-ID: <20260607095736.223985698@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 4f88d65def6f3c90121601b4f62a4c967f3063a6 upstream.

hidg_alloc() initializes hidg->dev with device_initialize() before
calling dev_set_name(). If dev_set_name() fails, the function currently
jumps to err_unlock and returns without calling put_device().

This leaves the device reference unbalanced and prevents hidg_release()
from being called. Calling put_device() here is also safe, since
hidg_release() only frees resources owned by hidg.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Route the dev_set_name() failure path through err_put_device so the
device reference is dropped properly.

Fixes: 89ff3dfac604 ("usb: gadget: f_hid: fix f_hidg lifetime vs cdev")
Cc: stable <stable@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Johan Hovold johan@kernel.org
Link: https://patch.msgid.link/20260413142119.2977716-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1562,7 +1562,7 @@ static struct usb_function *hidg_alloc(s
 	hidg->dev.devt = MKDEV(major, opts->minor);
 	ret = dev_set_name(&hidg->dev, "hidg%d", opts->minor);
 	if (ret)
-		goto err_unlock;
+		goto err_put_device;
 
 	hidg->bInterfaceSubClass = opts->subclass;
 	hidg->bInterfaceProtocol = opts->protocol;
@@ -1597,7 +1597,6 @@ static struct usb_function *hidg_alloc(s
 
 err_put_device:
 	put_device(&hidg->dev);
-err_unlock:
 	mutex_unlock(&opts->lock);
 	return ERR_PTR(ret);
 }


