Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D13224B04;
	Tue,  6 Jan 2026 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721162; cv=none; b=mlMkaqKorFMnxOue6YRKGCnGpeBvTqvWm+E/hVCBp7EzuOaQQzw5xp/EX6tqkCs/cYbs3kT+JidVW6OJHEt4ciXPsVvDSbUmlSoFxBrnoGU2zpRpB5trje7pBgJCmQPLzpyeeZNNJ6v3Z2wamiA5Hyd6wWZ+CgHPQBiLN2UQ6D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721162; c=relaxed/simple;
	bh=zGsXY3E5mVLl4v8yjYLSZRUOUrA4BqjjhtwBz85+6DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icB3f0+ACQNnT+D5Hc4Du0h0RZNoD8SNJq3n6dboteQTtH5f3HhTkGbmrDXF7WPqmplS7zfBUiEbmfCnbOeOWPOvKCKa8gZWlj/lgB9BQKiR9K6+3D4FL0nLkd89T3r6QMU1YesGal4zoRDT4jLeNOjsIzha60JtsXMzLIADbjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzD98qHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzD98qHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93382C116C6;
	Tue,  6 Jan 2026 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721162;
	bh=zGsXY3E5mVLl4v8yjYLSZRUOUrA4BqjjhtwBz85+6DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzD98qHTSRGdSB3DniZPJMqYJ5pDq6XQ6GmphwFvItu72JhFQ+g2zNaclRKT2QlFy
	 23FaU9jKFRms/r86N97Hr7ZhJFwc2XGAVcZrRe6GuT6F2j9/eb31DcBtx8ZUbX0bDu
	 Vopla7HruN3B/HIcJaewb1eIcPXpsX3KXpY/AEA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 453/567] net: usb: sr9700: fix incorrect command used to write single register
Date: Tue,  6 Jan 2026 18:03:55 +0100
Message-ID: <20260106170508.104608776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit fa0b198be1c6775bc7804731a43be5d899d19e7a upstream.

This fixes the device failing to initialize with "error reading MAC
address" for me, probably because the incorrect write of NCR_RST to
SR_NCR is not actually resetting the device.

Fixes: c9b37458e95629b1d1171457afdcc1bf1eb7881d ("USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Link: https://patch.msgid.link/20251221082400.50688-1-enelsonmoore@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/sr9700.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -52,7 +52,7 @@ static int sr_read_reg(struct usbnet *de
 
 static int sr_write_reg(struct usbnet *dev, u8 reg, u8 value)
 {
-	return usbnet_write_cmd(dev, SR_WR_REGS, SR_REQ_WR_REG,
+	return usbnet_write_cmd(dev, SR_WR_REG, SR_REQ_WR_REG,
 				value, reg, NULL, 0);
 }
 
@@ -65,7 +65,7 @@ static void sr_write_async(struct usbnet
 
 static void sr_write_reg_async(struct usbnet *dev, u8 reg, u8 value)
 {
-	usbnet_write_cmd_async(dev, SR_WR_REGS, SR_REQ_WR_REG,
+	usbnet_write_cmd_async(dev, SR_WR_REG, SR_REQ_WR_REG,
 			       value, reg, NULL, 0);
 }
 


