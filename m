Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A912E3AF9;
	Tue, 15 Jul 2025 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587524; cv=none; b=cYfrY8i1rhdXTNssurwP8IFEkXfRLr3/oRHPfTQgyyKXGY/+3pb/+IpWimpki95k/ZlD6FKMdsgo2hQ0detSldF/ucsfUHYXoVSLvnrOUF963i15yI13ZOxsddIhx49JadANeVrevBK6ofNXVRR4i9O/KovQrBdQgca/z1Thl0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587524; c=relaxed/simple;
	bh=xJDFIGUR/gsKTPI0YLllTrUcI1urx4XSphu+cvlLUK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g13RSEoEFhWfApOCgKrW6sHih4cZvStl8NGwCaruUiozCgcExRjlRWcd6ZL7G2GpCVDppeUt7wERjiT2MNQlulfqnJA6GTRmJE3d5z3c3kf/QVPKx1j/vddGBl01ezIbqnrPPxiGdN0H96rqk+jamm60UwlXFflLvOFvSmX9Ttg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvFF3Urb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvFF3Urb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD43C4CEE3;
	Tue, 15 Jul 2025 13:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587524;
	bh=xJDFIGUR/gsKTPI0YLllTrUcI1urx4XSphu+cvlLUK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvFF3Urb3xkq5UPC1TDpD5YuEL8X7QBQBh/u5nyKRe+IR3YA93lXv6vbeUkMgBtEB
	 Ivc4Ah80hMVJ0jerxVl3qPime6NLFwrtKXInMakv4nI9/QCN9VmiNyb1FqopZR71Fk
	 Robd7ylKhDgTiiE0YfepjUxS57cWweljlY/O0CnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 045/208] i2c: tiny-usb: disable zero-length read messages
Date: Tue, 15 Jul 2025 15:12:34 +0200
Message-ID: <20250715130812.760296696@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


