Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4666F32AAB5;
	Fri,  9 Jan 2026 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961039; cv=none; b=BGJ6IU4dsT2VBPiHwiczyIbG3hNL0U0uiRl7y/wY6RBzVghCSuK8NVsQJtDYodDRfxQIV5UwOsq7KDkgGtWDaq1rYrOAfvQBq8Qd+vscXLo/85ai4zyy183PpMWFTQ+21M0u/yxZIglQXyf+prq/YcYSS5rJwqZFoK35btD8g4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961039; c=relaxed/simple;
	bh=/wzGTg27sYYozicl1aDBP4XQOWnI4CaovDOYUDk9T5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eb3kIULGGq/6NKYjPn8ZXuHxTXNCu7DjleFIWm31EmrojxsP3mwPUCiQnfT6iRbQ8lnXLZ48If47A+2kPPuvFEkkJG8Vaa+wQhiAXBQSuQt7QxiElQLViFhfjdbRenQwHyS3Jo3kdtiUsUUonTST9AIh6MRaOGwFfc4aEmsOtBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcJuhKvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcJuhKvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD126C4CEF1;
	Fri,  9 Jan 2026 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961039;
	bh=/wzGTg27sYYozicl1aDBP4XQOWnI4CaovDOYUDk9T5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcJuhKvukWxh1K9bEZbfGkljppWqL/GKLPCVVNOM66/yTgvyjhW4S4WHFsO3V7NOX
	 1Gu5N/TQQ0CRDj/FxEjLIL1TWxQTELeSVCz1Amg/5TGApfWKwkD5yL3gZa/UFrJR3u
	 PICFzbJLx+VIz00EHIyiyRE3HJDaugq9G48rBsFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 614/737] net: usb: sr9700: fix incorrect command used to write single register
Date: Fri,  9 Jan 2026 12:42:33 +0100
Message-ID: <20260109112157.102842148@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


