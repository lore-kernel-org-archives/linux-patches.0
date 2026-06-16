Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4C147A0B0;
	Tue, 16 Jun 2026 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632770; cv=none; b=DT32N5VXLTBdjRShunPTs2PuxU2Z3uyZ5x07yc6RncRQG9ocTyjR4F+VINs1QqxU3y/C2URcomu0FTucjJLI/H8cF/YdVtUwi6P8xK63HaxoVkHoBSjXLwStOzB+Q9HbWPEmbWLPLPwBao+RuRUwLKwEvOx0mu4RZmlrzzS4low=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632770; c=relaxed/simple;
	bh=pPzWN6h0r4yndroGzhEPqP/FFJP+TGKn7rPPmETcWBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoJZMepZ7KlfDc/g3n+eoCWkssQSUNqse5D7h4Z1xMhKzOVUEVzd+o3Pun/qH6xm6PSwU1XFzK+/RyOdXZljf4HiusFyRTfCSvfqUKBEPYfxrWqpMuMeaZ///MzCSuoxoRhePJ/DvREwVrM4D3Fb99IMZExpRvb6T/h6Aah4LW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTsOB0yp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTsOB0yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BFE1F000E9;
	Tue, 16 Jun 2026 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632769;
	bh=UTPT5jYvsau9bM3u6bWtSGB5mcLhnwFSTr9fIzNE5dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTsOB0yphZiGaBgRUISklpxVHBt4h0wq0JZaQUMUUgj5XILRkTjD8+qzkYOb1nziO
	 IOZcqZEftB8ytMouDPEy6Hqjf8uKvBaSUkrH5TZBAua5g4gQ5gMIsMvNTpRJuNVUsG
	 g4/gGFvuDC9AKo2aGo73Shd8Lj+53dGgVoixCM0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 472/522] usb: gadget: f_hid: fix device reference leak in hidg_alloc()
Date: Tue, 16 Jun 2026 20:30:19 +0530
Message-ID: <20260616145147.930358659@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 4f88d65def6f3c90121601b4f62a4c967f3063a6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1278,7 +1278,7 @@ static struct usb_function *hidg_alloc(s
 	hidg->dev.devt = MKDEV(major, opts->minor);
 	ret = dev_set_name(&hidg->dev, "hidg%d", opts->minor);
 	if (ret)
-		goto err_unlock;
+		goto err_put_device;
 
 	hidg->bInterfaceSubClass = opts->subclass;
 	hidg->bInterfaceProtocol = opts->protocol;
@@ -1313,7 +1313,6 @@ static struct usb_function *hidg_alloc(s
 
 err_put_device:
 	put_device(&hidg->dev);
-err_unlock:
 	mutex_unlock(&opts->lock);
 	return ERR_PTR(ret);
 }


