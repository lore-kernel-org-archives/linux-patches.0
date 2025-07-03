Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E152DE6F1;
	Thu,  3 Jul 2025 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556090; cv=none; b=gqL3UKuVScVw8LtO8ycDWhh4pfcJUDyfLwuOk6lvApRiqDEOYsn1vMXEKlV26Pm0ovBAVtE4rQ/7CUCyzravEXiMohSbhskyvlxU2D1ul7ZxbBUZhxCGy+xrERGAV0StDfpS8FQoOGzBK7DTBJ83k+oq1hBOFQjiFU8mr84l64E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556090; c=relaxed/simple;
	bh=IrP+r+A25sVOqcCFMgWJD6/ETb1Az5mH2pebFkDVJGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=It3u0Ta6ePtTMn7HDPX3pl1zio7ysrLAMEFnFx5tv7/8PkdJcVZ8t8F+urEnCAUE0UB06v/NBs/SkdEjV2wFLUj3jykE1EMmnqzFFmzuBmsiKwEFoCQFj+rFsmxCevq5PwcL/fdfnwBHIBYEZmdLcmBtGklWxAK9NCMXew8NIL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yas3A1Yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yas3A1Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B28CC4CEE3;
	Thu,  3 Jul 2025 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556090;
	bh=IrP+r+A25sVOqcCFMgWJD6/ETb1Az5mH2pebFkDVJGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yas3A1YpVmoZcGlvz1qW5wi0VvcTIVB+kVCMydkNUsn3gG2/TccesLGcS41lqMUjO
	 5WhlItDTdJAxWnApgw5NMGxO3ESZIe1gKea3SZiUYJRhV0tDrfu769bxk8cZpxZKS6
	 fMC1xH6EI/gMhSr9xyk8x95of7K0RxDGDBq5g4Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 072/132] i2c: robotfuzz-osif: disable zero-length read messages
Date: Thu,  3 Jul 2025 16:42:41 +0200
Message-ID: <20250703143942.244891432@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


