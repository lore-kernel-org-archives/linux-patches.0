Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F458263F52;
	Tue, 15 Jul 2025 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586444; cv=none; b=iOo3N++XbmFba3MiQnXT+ZbjI73VSXbHq+dNnk6k59gAJcMsBnfvAkkAiWlon2M7IF51t/uSo9kJrOfdONCp95Yc5AsjwLVfXmeD+bxjfP/OVYZArIejyXC81OCmdnhLtZarmEEa8rTFTHdkaEPbiUy1XOxm9jyFgx5h3fY9Uso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586444; c=relaxed/simple;
	bh=eMTpvC7zePaSRkrTxNWBuKY/oWoexqymR+N0vZ8UkBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZ5PNl2Y03Gj8YgEcqyjSfRhl2zkMLzC273R0L0dX3UJUvh1mVKs17ltDDgufY8pwndI2AZAW8v+Fo4oLhiuxBKPnE9CowPrd6oz5UT4C6VJzmdlRVstkH7KWPPZr7NjTiZ4twMmy/72dsR83vR2JrhGaNTfBg9eM/2kFfLm/1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uORZBTwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uORZBTwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EDBC4CEE3;
	Tue, 15 Jul 2025 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586444;
	bh=eMTpvC7zePaSRkrTxNWBuKY/oWoexqymR+N0vZ8UkBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uORZBTwtuP1TV7t7EFa2AIb14xkgRuH0PokdDCyjn9jy0e5PwgJ2Y3DIwJ28SxOyG
	 D/5Lu7hxXis9iU4yhkN1LuEUzUEacZxgArr9YMwVrWxmntQB8OTwcrEsA/S8F6ul5k
	 2umF9kEkFqhoHNJaHPdq555CTtWODeO9Ep6zgxj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.4 036/148] i2c: robotfuzz-osif: disable zero-length read messages
Date: Tue, 15 Jul 2025 15:12:38 +0200
Message-ID: <20250715130801.759943812@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


