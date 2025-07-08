Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490091DB127;
	Tue,  8 Jul 2025 16:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993905; cv=none; b=RpuBwL79pjxmZDl7UAW7hZwfCdyJQpQeOp0Tc9tHrHdNC+1KoEmeqEdAG0mpj8XRqSPQRHnTNEVZ3lIXESLSVaZAGFcHM++G5xhf7iaY8zzctxc/LgkPaySpRxFLhC3gusTv5cFF2dCJtuwBQLWr2zgif2exQ81BfQFuijUs+2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993905; c=relaxed/simple;
	bh=v7XUCaex+V14iL5yTfbXSc3r5U6dbkfcGHDnGybxSGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMUYrTa4rzPuGJDnqVgvvz1oQnGs1w6Q/DMzn2cKEGqE2pGR2gpbnvY970EZBjr8sFzG7A+bBgPX/xn4sDT3BTSA6smz0qV5f1yPN1B0OwWhcZgTZfgGwC241kD2QOefe25owDrFIY6131Sk40OgtaqWh5gzoGpMcp/7QQwsNck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lt6jlSGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lt6jlSGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41D3C4CEED;
	Tue,  8 Jul 2025 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993905;
	bh=v7XUCaex+V14iL5yTfbXSc3r5U6dbkfcGHDnGybxSGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt6jlSGTzbq8Dh4hpvf4FvOR52Y8WnisklJtSvAviE64wC1VGe/yA1m76zGav+r6D
	 OsQ0qLw4my+cpkpN5cvLPd8RG7a2cGFrB+/nVneceIZN/SWxez63VztRVuBbaJ9Eyw
	 J5PVONWG6K0E9SRI4kLu1FVzufbtfAlAun5wV3bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 058/160] i2c: tiny-usb: disable zero-length read messages
Date: Tue,  8 Jul 2025 18:21:35 +0200
Message-ID: <20250708162233.158101317@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit cbdb25ccf7566eee0c2b945e35cb98baf9ed0aa6 upstream.

This driver passes the length of an i2c_msg directly to
usb_control_msg(). If the message is now a read and of length 0, it
violates the USB protocol and a warning will be printed. Enable the
I2C_AQ_NO_ZERO_LEN_READ quirk for this adapter thus forbidding 0-length
read messages altogether.

Fixes: e8c76eed2ecd ("i2c: New i2c-tiny-usb bus driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: <stable@vger.kernel.org> # v2.6.22+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250522064349.3823-2-wsa+renesas@sang-engineering.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-tiny-usb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -140,6 +140,11 @@ out:
 	return ret;
 }
 
+/* prevent invalid 0-length usb_control_msg */
+static const struct i2c_adapter_quirks usb_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN_READ,
+};
+
 /* This is the actual algorithm we define */
 static const struct i2c_algorithm usb_algorithm = {
 	.master_xfer	= usb_xfer,
@@ -244,6 +249,7 @@ static int i2c_tiny_usb_probe(struct usb
 	/* setup i2c adapter description */
 	dev->adapter.owner = THIS_MODULE;
 	dev->adapter.class = I2C_CLASS_HWMON;
+	dev->adapter.quirks = &usb_quirks;
 	dev->adapter.algo = &usb_algorithm;
 	dev->adapter.algo_data = dev;
 	snprintf(dev->adapter.name, sizeof(dev->adapter.name),


