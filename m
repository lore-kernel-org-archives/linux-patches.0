Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C6F1F76D7;
	Tue,  3 Dec 2024 16:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241916; cv=none; b=g8gPVp5mxManhaGlsnOdAYZK4Rp53wyMRj7mDi7f2rJTRYmTAF26hVDzLpnGFTKEYEuaR6WUBIr8qPG2KyTSmlZkxlmWgycO2MDz+PjN+54GvW8jcM+/2OU0juTBA+SG4/MbPcTpMgjSGIQzidf8rym3hsc3lXhkrEw+KZfAlg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241916; c=relaxed/simple;
	bh=FnuyJTtBRQOtmzXdswAv2DgSA724ndbaLQGki8MBQ/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4YYPC2FbhJ4IYUKa5rZmjqYI9N5FCwuAMolUwkkivkT6CCI53pDeAquNx6LEcJ7ZtRU4vO11avRnMzjXKQKpc9swjI8p4nX09Gpsy+ojm8AqgXnPpsUg3WRGVFUIiyYcfvu9uUr/1MMd7lOy/0sc08buD956j0BDk8ffUv3wYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfdY1the; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfdY1the"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71522C4CEDE;
	Tue,  3 Dec 2024 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241915;
	bh=FnuyJTtBRQOtmzXdswAv2DgSA724ndbaLQGki8MBQ/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfdY1theglrByuhcgatO8VllMxFHFa1NAA2Y8Ggum+ed07ET6NxvPJ7Wf1/3698Mv
	 uBBPIlbOSoRBjxB1RX9HxHgtd/uT8xiCvIHg/+91oQT2I4fGLLRPylCEiGda92+bFP
	 d6UUKAxyfzNHaE96gqcjxAhIRG8ewUcvLOHLzOlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Efstathiades <john.efstathiades@pebblebay.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 554/826] net: usb: lan78xx: Fix double free issue with interrupt buffer allocation
Date: Tue,  3 Dec 2024 15:44:41 +0100
Message-ID: <20241203144805.358784028@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 03819abbeb11117dcbba40bfe322b88c0c88a6b6 ]

In lan78xx_probe(), the buffer `buf` was being freed twice: once
implicitly through `usb_free_urb(dev->urb_intr)` with the
`URB_FREE_BUFFER` flag and again explicitly by `kfree(buf)`. This caused
a double free issue.

To resolve this, reordered `kmalloc()` and `usb_alloc_urb()` calls to
simplify the initialization sequence and removed the redundant
`kfree(buf)`.  Now, `buf` is allocated after `usb_alloc_urb()`, ensuring
it is correctly managed by  `usb_fill_int_urb()` and freed by
`usb_free_urb()` as intended.

Fixes: a6df95cae40b ("lan78xx: Fix memory allocation bug")
Cc: John Efstathiades <john.efstathiades@pebblebay.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20241116130558.1352230-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 8adf77e3557e7..094a47b8b97eb 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4414,29 +4414,30 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	period = ep_intr->desc.bInterval;
 	maxp = usb_maxpacket(dev->udev, dev->pipe_intr);
-	buf = kmalloc(maxp, GFP_KERNEL);
-	if (!buf) {
+
+	dev->urb_intr = usb_alloc_urb(0, GFP_KERNEL);
+	if (!dev->urb_intr) {
 		ret = -ENOMEM;
 		goto out5;
 	}
 
-	dev->urb_intr = usb_alloc_urb(0, GFP_KERNEL);
-	if (!dev->urb_intr) {
+	buf = kmalloc(maxp, GFP_KERNEL);
+	if (!buf) {
 		ret = -ENOMEM;
-		goto out6;
-	} else {
-		usb_fill_int_urb(dev->urb_intr, dev->udev,
-				 dev->pipe_intr, buf, maxp,
-				 intr_complete, dev, period);
-		dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
+		goto free_urbs;
 	}
 
+	usb_fill_int_urb(dev->urb_intr, dev->udev,
+			 dev->pipe_intr, buf, maxp,
+			 intr_complete, dev, period);
+	dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
+
 	dev->maxpacket = usb_maxpacket(dev->udev, dev->pipe_out);
 
 	/* Reject broken descriptors. */
 	if (dev->maxpacket == 0) {
 		ret = -ENODEV;
-		goto out6;
+		goto free_urbs;
 	}
 
 	/* driver requires remote-wakeup capability during autosuspend. */
@@ -4444,7 +4445,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_phy_init(dev);
 	if (ret < 0)
-		goto out7;
+		goto free_urbs;
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
@@ -4466,10 +4467,8 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 out8:
 	phy_disconnect(netdev->phydev);
-out7:
+free_urbs:
 	usb_free_urb(dev->urb_intr);
-out6:
-	kfree(buf);
 out5:
 	lan78xx_unbind(dev, intf);
 out4:
-- 
2.43.0



