Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E4D4A07;
	Thu, 13 Jun 2024 12:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282407; cv=none; b=JUh2caABNMg7CkwklE8XKKGmvOxtkSR8so5ol+idQVX1Z4HfAydPRfmXZh4xil77xxsEAEm0xgBeev99uPoQedx6zHgQf24tee+quJms+sKLxFT6dfxXVXDxNkWSJBUphQtR5hHU14BtKM/FrPwx7M9df3KLNZ8/8R660wfsDNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282407; c=relaxed/simple;
	bh=uQPPMbbYTgHd24TOUPbyz6kJoPet/jJvLRQntqyruw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssnuX2cFYhsN3YIaQSLKm8UrDK/XlCmlOVCc0LN4FsWLAv8AZ9WRSXB4uhE585YcWbQUbO2WHdFbFmMDQao5qfDomSugXpPHkx+9/xI6BkJi49tJhPCtYzeSJdyhkmICGu0krS9kQOqD6IfeEnKUYCEZtks1/bO/VqgTilM7V5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAEry+pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAEry+pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0BBC2BBFC;
	Thu, 13 Jun 2024 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282407;
	bh=uQPPMbbYTgHd24TOUPbyz6kJoPet/jJvLRQntqyruw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAEry+pzp0zDCMkoqEjWiTHO1sfC+x/9Eh822IhCfmS4i5UHzZ6D7NPfQRYUJFHZI
	 +57FU94Zev6qPDRmq+gdEmmZ1GCjhPtt77xgB19TklrN3oHqRCAS8IIDtvDWT9JfG3
	 cFqXaT92FHnxKMCrjweNgKBwNFVpAo9TOhnLhv20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/402] media: flexcop-usb: clean up endpoint sanity checks
Date: Thu, 13 Jun 2024 13:33:44 +0200
Message-ID: <20240613113312.567873494@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 3de50478b5cc2e0c2479a5f2b967f331f7597d23 ]

Add a temporary variable to make the endpoint sanity checks a bit more
readable.

While at it, fix a typo in the usb_set_interface() comment.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20220822151456.27178-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f62dc8f6bf82 ("media: flexcop-usb: fix sanity check of bNumEndpoints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 8ab1be03e7319..0b5c2f3a54ab4 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -501,17 +501,21 @@ static int flexcop_usb_transfer_init(struct flexcop_usb *fc_usb)
 
 static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 {
-	/* use the alternate setting with the larges buffer */
-	int ret = usb_set_interface(fc_usb->udev, 0, 1);
+	struct usb_host_interface *alt;
+	int ret;
 
+	/* use the alternate setting with the largest buffer */
+	ret = usb_set_interface(fc_usb->udev, 0, 1);
 	if (ret) {
 		err("set interface failed.");
 		return ret;
 	}
 
-	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
+	alt = fc_usb->uintf->cur_altsetting;
+
+	if (alt->desc.bNumEndpoints < 1)
 		return -ENODEV;
-	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[0].desc))
+	if (!usb_endpoint_is_isoc_in(&alt->endpoint[0].desc))
 		return -ENODEV;
 
 	switch (fc_usb->udev->speed) {
-- 
2.43.0



