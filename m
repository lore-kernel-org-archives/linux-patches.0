Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CF22DECBD;
	Tue,  8 Jul 2025 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993908; cv=none; b=RkHhs4iM5Y0TbdtH80LAegiKZwKJxKsqjJ7jJ746CPdB0hwrVdAIkDQhSoHInTNRBrf8xirz+J6r781y0yK/X0YXHZMJsudUrsx/5hZYObiaFkW+JnRB2Fsk6agYJIOAVOTiLNHrltJuxsOrHqCIGG65YaLiZsz11oRQDYUamL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993908; c=relaxed/simple;
	bh=D3TavQ9uIqTIwhWQrj1ois90ieOo4GCxheptripsoiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmKGEEQtyuEj5f/Qv3BWpIHe1xgPnGXWsjb76V+ujR+hLIVt3ARaJSKWpkFyL+/QEdOvLXnJbPA40yoYklimo2MMhlQ4lsQP9yk3tK4T09Mx5f08m5c2Zvx1DfrfcgwegNWMjViHWVEq5ZFhk0u4frBguJ3pINYF+20ZjI/otfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqbIxdxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqbIxdxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97F4C4CEED;
	Tue,  8 Jul 2025 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993908;
	bh=D3TavQ9uIqTIwhWQrj1ois90ieOo4GCxheptripsoiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqbIxdxAvCM9tc4oweTgdnYrUP7u2H6jwY78DUVThoq8dNbR94LxsZ5IUZv7XsA8i
	 7ZS90LInh+4Nt4bMvsvs4yxgNux29YwVh4cKpm8JjaNzwtvBf0+fZZDguu4VkM5UIc
	 6vW8327bgRkKa2k7vPz29wZV2o3nRU7dq5dGKi14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 059/160] i2c: robotfuzz-osif: disable zero-length read messages
Date: Tue,  8 Jul 2025 18:21:36 +0200
Message-ID: <20250708162233.185130115@linuxfoundation.org>
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

commit 56ad91c1aa9c18064348edf69308080b03c9dc48 upstream.

This driver passes the length of an i2c_msg directly to
usb_control_msg(). If the message is now a read and of length 0, it
violates the USB protocol and a warning will be printed. Enable the
I2C_AQ_NO_ZERO_LEN_READ quirk for this adapter thus forbidding 0-length
read messages altogether.

Fixes: 83e53a8f120f ("i2c: Add bus driver for for OSIF USB i2c device.")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: <stable@vger.kernel.org> # v3.14+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250522064234.3721-2-wsa+renesas@sang-engineering.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-robotfuzz-osif.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/i2c/busses/i2c-robotfuzz-osif.c
+++ b/drivers/i2c/busses/i2c-robotfuzz-osif.c
@@ -111,6 +111,11 @@ static u32 osif_func(struct i2c_adapter
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
+/* prevent invalid 0-length usb_control_msg */
+static const struct i2c_adapter_quirks osif_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN_READ,
+};
+
 static const struct i2c_algorithm osif_algorithm = {
 	.master_xfer	= osif_xfer,
 	.functionality	= osif_func,
@@ -143,6 +148,7 @@ static int osif_probe(struct usb_interfa
 
 	priv->adapter.owner = THIS_MODULE;
 	priv->adapter.class = I2C_CLASS_HWMON;
+	priv->adapter.quirks = &osif_quirks;
 	priv->adapter.algo = &osif_algorithm;
 	priv->adapter.algo_data = priv;
 	snprintf(priv->adapter.name, sizeof(priv->adapter.name),


