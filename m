Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5903081D4;
	Mon,  1 Dec 2025 11:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588367; cv=none; b=AVDJRn9GfcVkQA0GayVuTSLjic3k5Ow7ZIuQDPRhiDffN1EZptmJF8eESIqU6t0ew1ecKk4yX99Kfpmbpbej5z69O0X8suU8dmGH2w9yFPs81Un3rdm/lKVDp+TdMOWKUWIwa0bBelBCkPEYuA4Dk3wsHv4p8ejWFcJRFWzJB4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588367; c=relaxed/simple;
	bh=RD5Y4DJ+0EmTu2lFz3W5yxKvhI2VpK9hUuiJ6KBqT2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xjs6dbWoQA1lnoqC+6fzgtP4JsswHAlaKBg5/yGYS5tma0avs84TlOhs1vZAeM8waI59bx67qEFdkKd8ee7c1YKH6XvOSVxELHaeTC54X3Ggw7MsUjuKDQ37yjp+8xJJ5L8hmvFg9RP6p78ZhPeqzhR4czlLuzEvoUhTKXIj2KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTXSHbSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTXSHbSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8C9C4CEF1;
	Mon,  1 Dec 2025 11:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588366;
	bh=RD5Y4DJ+0EmTu2lFz3W5yxKvhI2VpK9hUuiJ6KBqT2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTXSHbSaQhFlKtbPAOfbSV0XtCxoTtv1QTtXFhZwP9QSINg4eFw2eEpN52ossVKut
	 HfefjeBnqDhAxsTmjDM9Bi+QCBmouS2ZCQngO6mye8mbx67zP0XFGvZowaLPyvo5/V
	 nHhantnRJbfkxgrdx1U7gsDZP2GDW93yAx2BG3ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Owen Gu <guhuinan@xiaomi.com>
Subject: [PATCH 5.4 024/187] usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
Date: Mon,  1 Dec 2025 12:22:12 +0100
Message-ID: <20251201112242.128969340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Owen Gu <guhuinan@xiaomi.com>

commit cfd6f1a7b42f62523c96d9703ef32b0dbc495ba4 upstream.

A race condition occurs when ffs_func_eps_enable() runs concurrently
with ffs_data_reset(). The ffs_data_clear() called in ffs_data_reset()
sets ffs->epfiles to NULL before resetting ffs->eps_count to 0, leading
to a NULL pointer dereference when accessing epfile->ep in
ffs_func_eps_enable() after successful usb_ep_enable().

The ffs->epfiles pointer is set to NULL in both ffs_data_clear() and
ffs_data_close() functions, and its modification is protected by the
spinlock ffs->eps_lock. And the whole ffs_func_eps_enable() function
is also protected by ffs->eps_lock.

Thus, add NULL pointer handling for ffs->epfiles in the
ffs_func_eps_enable() function to fix issues

Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Link: https://lore.kernel.org/r/20250915092907.17802-1-guhuinan@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2012,7 +2012,12 @@ static int ffs_func_eps_enable(struct ff
 	ep = func->eps;
 	epfile = ffs->epfiles;
 	count = ffs->eps_count;
-	while(count--) {
+	if (!epfile) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	while (count--) {
 		ep->ep->driver_data = ep;
 
 		ret = config_ep_by_speed(func->gadget, &func->function, ep->ep);
@@ -2036,6 +2041,7 @@ static int ffs_func_eps_enable(struct ff
 	}
 
 	wake_up_interruptible(&ffs->wait);
+done:
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 
 	return ret;


