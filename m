Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F1D2DFF04;
	Sun,  7 Jun 2026 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829390; cv=none; b=ipwZVRgptV6y7HeTM/QtOyaJkOYWT/RY4O8lgkkFLg4YAO+jKkevGd/cFCz5mel5hqfV539OCsunRMIvw6bd0ORjjTZfABgUWtbCdCyeOwpIX5np6nBUcL/79yHBUSfs0QmNqMkSvstuxc4L/xtjDBOJemfYEBxvsYoUXOq+MPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829390; c=relaxed/simple;
	bh=mPnKbLh5bXQnS7O8xbYqVz5uB4A7rxuTS/YzYFIGAwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQV9emYFuENx/qz/T/enoWC5dzKGTcrE6ajFE4/Py4SVCmBOsTqOTIeBwdKaJ3jebn42EUoI0Xpvi/g/KNTqPiERbnSAW5tyUC+9vI742QdIXD3Gf0gI56hTCJLSnKl6aTS13uz+t5kFI9KX8Dgc3N/pdbL4SJ/osd30D53F/HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fYwR5Ye; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fYwR5Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECBA1F00893;
	Sun,  7 Jun 2026 10:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829389;
	bh=ff2MNLvD1ZY5b3smaIsvt8M6WtIxufWzunk2P2axQn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fYwR5YeMM9TvHdUomRt9HZbgo8nrXVkx0lepYF5bLR29Y2fclRdFKKJ85drCrOSQ
	 AE21TlV/mCkki6x2qUWwjk6qC9B7Pisb+4Zx2C54lEqxcN7L/lubW5V3BocWW00gbj
	 Hn0D0L6rHJtr23A9K6hZ6INa5Ae4iKDB/GhP4vLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 6.18 243/315] usb: gadget: f_hid: fix device reference leak in hidg_alloc()
Date: Sun,  7 Jun 2026 12:00:30 +0200
Message-ID: <20260607095736.487151128@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1621,7 +1621,7 @@ static struct usb_function *hidg_alloc(s
 	hidg->dev.devt = MKDEV(major, opts->minor);
 	ret = dev_set_name(&hidg->dev, "hidg%d", opts->minor);
 	if (ret)
-		goto err_unlock;
+		goto err_put_device;
 
 	hidg->bInterfaceSubClass = opts->subclass;
 	hidg->bInterfaceProtocol = opts->protocol;
@@ -1658,7 +1658,6 @@ static struct usb_function *hidg_alloc(s
 
 err_put_device:
 	put_device(&hidg->dev);
-err_unlock:
 	mutex_unlock(&opts->lock);
 	return ERR_PTR(ret);
 }


