Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2926B22B8AB;
	Thu,  3 Jul 2025 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555724; cv=none; b=sqkiu6X/OvaTrB44cGedDuXr/kWaLYrdq+WI6mf0/C/hTdeLinNzOpY4scxaujnZ7OEcZ7kyRxaJLkS+RviIWKzi2E152f267+zQikE/K+gXzKV3pySVv+3j/PU3iYuyht0y+XA0LIrzq4FGunzEsB4WBSNjWfzhtHg8YtShNjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555724; c=relaxed/simple;
	bh=SzNGxaeP8K9II1wOsRr1FqE0TSJwxefxd4fQXnOAd4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gofcUxB9M6Ookb5yhhVBJZrHX0QnUi8B8esyczKGPLRytFlGHYjryc0ojd+dbw8ybqDMNlgs75ns9OPEMN0c0xpf8Mz3uNqOTidBSO2h0S2RpddDY2FGbKZD7UnaVSn5NAp2hhs5q3fqmPcLoMDK6u8Wm7VL0DMjNHjCSfGnG8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeuPQm+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeuPQm+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA2CC4CEE3;
	Thu,  3 Jul 2025 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555724;
	bh=SzNGxaeP8K9II1wOsRr1FqE0TSJwxefxd4fQXnOAd4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeuPQm+eSHwFe0KGrdO2vfbDhI6szWEg/5EjO2oWuUbqqDdZ1NvvKd6UbQL1Q5CJE
	 o7VCnjCiyeeOx0ViRz/FyA5dwAtHmkAWLc08PrgCYyw3xaMEL9ipCxIWvny3ctkEly
	 Q3BJgftLTtb6gM1zorYs5SvzYm3int+cyka6wz/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 071/139] i2c: tiny-usb: disable zero-length read messages
Date: Thu,  3 Jul 2025 16:42:14 +0200
Message-ID: <20250703143943.944171332@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -248,6 +253,7 @@ static int i2c_tiny_usb_probe(struct usb
 	/* setup i2c adapter description */
 	dev->adapter.owner = THIS_MODULE;
 	dev->adapter.class = I2C_CLASS_HWMON;
+	dev->adapter.quirks = &usb_quirks;
 	dev->adapter.algo = &usb_algorithm;
 	dev->adapter.algo_data = dev;
 	snprintf(dev->adapter.name, sizeof(dev->adapter.name),


