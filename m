Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46EA35691F;
	Tue, 26 Aug 2025 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219198; cv=none; b=hc2RYo7Oi8tgMPok/ul5wOvjo6c++Z+MH23svXmwrPrcz391Ssd9N8cP875nMcraDwy0v5ubgJkDtzeCaavg9mdzC9vNeNHJxSXd9HtHhlFgnG8yxGXwqRAl2PAAkkytUEunQOBQARu/40jUpGktAc221k3S7G5/MG7MiONip6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219198; c=relaxed/simple;
	bh=8Vbl6+KyOSqg/rvZlT/a9L8UPZWERrmzGLEIrmpxLv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KylNNy0f+wiz/zoF8W/yJCEmhD0GTzGZ0SLj+GCXYnMjAXOOf3uhGJp5o8xJemXzxxjV/5npewRL9ehZt3wRK5/rOB4qWtEJoP2us6HSQC92IYWv9NkHWIiasvE4T0WL3s6JHA/dUyuuHD4sN7iZTh1EiLXoFyYkPaRfxWRI7bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuMziX8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuMziX8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67204C4CEF1;
	Tue, 26 Aug 2025 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219198;
	bh=8Vbl6+KyOSqg/rvZlT/a9L8UPZWERrmzGLEIrmpxLv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuMziX8YZf+PzF1eqU78EvV8XFokJ/4F2Pf0ANwfctPPi+t1o+cUuFao5YAXlRgI+
	 hdPGAVZ8yroAdpZvs/zIc6HKV8lYB1C+Lnmy7tJOPBajiZ4zoAfKk7ZPXUKPCYbCuw
	 r7ua/bkhpbvfAX35k2nxUn+z7jnhpbL8vqgSXeMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 250/403] media: usb: hdpvr: disable zero-length read messages
Date: Tue, 26 Aug 2025 13:09:36 +0200
Message-ID: <20250826110913.724600814@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

[ Upstream commit b5ae5a79825ba8037b0be3ef677a24de8c063abf ]

This driver passes the length of an i2c_msg directly to
usb_control_msg(). If the message is now a read and of length 0, it
violates the USB protocol and a warning will be printed. Enable the
I2C_AQ_NO_ZERO_LEN_READ quirk for this adapter thus forbidding 0-length
read messages altogether.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/hdpvr/hdpvr-i2c.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index 785c8508a46e..e6a190fe0e87 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -165,10 +165,16 @@ static const struct i2c_algorithm hdpvr_algo = {
 	.functionality = hdpvr_functionality,
 };
 
+/* prevent invalid 0-length usb_control_msg */
+static const struct i2c_adapter_quirks hdpvr_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN_READ,
+};
+
 static const struct i2c_adapter hdpvr_i2c_adapter_template = {
 	.name   = "Hauppauge HD PVR I2C",
 	.owner  = THIS_MODULE,
 	.algo   = &hdpvr_algo,
+	.quirks = &hdpvr_quirks,
 };
 
 static int hdpvr_activate_ir(struct hdpvr_device *dev)
-- 
2.39.5



