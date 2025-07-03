Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9E96F53E;
	Thu,  3 Jul 2025 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554854; cv=none; b=tLgebi6B9pZ6objUs8yu/9vH+9aepbXExkzGcO1Kr7L8wqiII9vWRBBViEKRSRXX/Znv0dCnrilUvLjJpy9sTEIoSEPOqK9ClMaYjUwgboMWW0RK5dOACcznz+g2i4NXRe403LLpqOSqQxaLYl0mnLs0TJAzFHLKURAj9IZLkUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554854; c=relaxed/simple;
	bh=y1BrGBw2PSc/KJlXHCI2+Bm6Gz0Bu7Ry9FKKOpMIAa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0EIfy+tIlYsUv0Em1pdGsZL/Xd5YHKwVYSr+86Wj3wq1QXvehhQFlIP/xnMQ2x/DvydmgHf8TI8GHMTr6XaHhCvcjAK8S7lrYO3+Mr07aWp5NuAmJst9vJxhLu1C/AsVWGYKKdrusQdZFp6fmk+LmN6q782KSQftoe7AeixFvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MO/6k1Vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MO/6k1Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA09C4CEE3;
	Thu,  3 Jul 2025 15:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554853;
	bh=y1BrGBw2PSc/KJlXHCI2+Bm6Gz0Bu7Ry9FKKOpMIAa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MO/6k1VpSm5kDnztG3/RhoqkTGy+s4zQGWzq8e1uxKeGxKzJqPYURmECaaax9GrwY
	 IiJmPeKl8cruNnVfoBxiNW6hxh6/MPbl21RCCL1MsMfcvwqk2K4FDuTJ/m6bHVhaUT
	 Oqhh92lmI7I8fnMKlAhsMmAZ8yv8sFmTaUPAGOuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 100/263] i2c: robotfuzz-osif: disable zero-length read messages
Date: Thu,  3 Jul 2025 16:40:20 +0200
Message-ID: <20250703144008.316941981@linuxfoundation.org>
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
 	.xfer = osif_xfer,
 	.functionality = osif_func,
@@ -143,6 +148,7 @@ static int osif_probe(struct usb_interfa
 
 	priv->adapter.owner = THIS_MODULE;
 	priv->adapter.class = I2C_CLASS_HWMON;
+	priv->adapter.quirks = &osif_quirks;
 	priv->adapter.algo = &osif_algorithm;
 	priv->adapter.algo_data = priv;
 	snprintf(priv->adapter.name, sizeof(priv->adapter.name),


