Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28F32E7BBF;
	Thu,  3 Jul 2025 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554950; cv=none; b=Kmu4MYSpcxQRYfGOQlwjskBZgJCu/EUtkxaq0Kcp0giDjaHWzhhBHtADicq1oj6R3l7Hthc2KEvw8ITdjx9kNhAWitA3wxCPi0hwDYkB3UZgPZocZfPl2fHp5rzc2NvC5WFlIJ8dnYGNREdFDa2KbFfrOK1ze4kA+NMNSvAAsCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554950; c=relaxed/simple;
	bh=1HVOWS5vMzCEXhMq7KAQ9uyA1mMPb5t/ny4n0SaWxag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PudY3niT/VpLvUJEwpQDl8xyK2yJY0XP+qrQLZxZISm6ZaApnT4fzqWcKp8N5Dvjs922lfpisfiOktrK2xPv2/PLcWogSs//Iv0rwZ0YMaAapvgfafI1falkP5bkkZm6HyNSFCi3pYUIzBD30doUhpZCX3wrGiWTeH8SOOtXRzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2ddk5HC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2ddk5HC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1AFC4CEE3;
	Thu,  3 Jul 2025 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554950;
	bh=1HVOWS5vMzCEXhMq7KAQ9uyA1mMPb5t/ny4n0SaWxag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2ddk5HCD0MpIGOPHc9YPRQKNgcJF2KnnrvA9cQiyqt7LPN2MRNXpkdO9sh2bs3dX
	 XRJ7poJcWLlRvBFRlASPe8WnSpbpd/dixKuUGmoF8xCuR8PbVaBCqZcdjja+ffcGiS
	 Lr0rs2Mj7PDBzMy4MrsKubhNQNi+XkcDsxIeOozk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 099/263] i2c: tiny-usb: disable zero-length read messages
Date: Thu,  3 Jul 2025 16:40:19 +0200
Message-ID: <20250703144008.270893198@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,6 +138,11 @@ out:
 	return ret;
 }
 
+/* prevent invalid 0-length usb_control_msg */
+static const struct i2c_adapter_quirks usb_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN_READ,
+};
+
 /* This is the actual algorithm we define */
 static const struct i2c_algorithm usb_algorithm = {
 	.xfer = usb_xfer,
@@ -246,6 +251,7 @@ static int i2c_tiny_usb_probe(struct usb
 	/* setup i2c adapter description */
 	dev->adapter.owner = THIS_MODULE;
 	dev->adapter.class = I2C_CLASS_HWMON;
+	dev->adapter.quirks = &usb_quirks;
 	dev->adapter.algo = &usb_algorithm;
 	dev->adapter.algo_data = dev;
 	snprintf(dev->adapter.name, sizeof(dev->adapter.name),


