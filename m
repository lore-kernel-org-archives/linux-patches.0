Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA83146586;
	Thu, 11 Apr 2024 10:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830472; cv=none; b=BjFZk5JdvcARQhawbybsZIT8kzwCAuWecVSWhNwjlWW+HHQWEdXpDDYbf8Uvnen3Kpxi552bz4gI41/+ZfDIMPZshljqemsWJQ9ONCXl7rZSVAc0Bg4xP02DLjUigOnCKoApe9265oOg/snXfFvNUeEAli/TkDb8j5hEI+9tCbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830472; c=relaxed/simple;
	bh=TDarKECVdbG/3qUUiWn4q4/fSFrLpla96WAzvNnlyt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVBD7bHm926+xqp73sDG0wFo3eyywTFg3N5bzYtLGRYIlfQ83T+qhOtEUdGFSHAl2rzzPCIWKm9FhM+lHsR6AwjNQypt7ZTejr4tmOabhitSRKEa05fDzhMglwHycNsLJcSAm4Qn1LmZ02fBmVVol38pGoQHvplOuJ1m6qNTgXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRLzmzy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRLzmzy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061CDC433F1;
	Thu, 11 Apr 2024 10:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830472;
	bh=TDarKECVdbG/3qUUiWn4q4/fSFrLpla96WAzvNnlyt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRLzmzy+wqLrWVnunD2EdMPrz1sQkbFRrPCm191wsX4zBMjCgaN3Mttclj5up/qwk
	 cah4d5ZYpbyD9TvfHw+C2BXQg3G1l6iFdiaL0Z1QK+Pi138aXZf71mXh2/baL13I5Y
	 97+p6khDVY+laDH5bVeRo9hCvJ7BmKmApj7nREcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/215] serial: max310x: fix NULL pointer dereference in I2C instantiation
Date: Thu, 11 Apr 2024 11:53:43 +0200
Message-ID: <20240411095425.311309741@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 0d27056c24efd3d63a03f3edfbcfc4827086b110 ]

When trying to instantiate a max14830 device from userspace:

    echo max14830 0x60 > /sys/bus/i2c/devices/i2c-2/new_device

we get the following error:

    Unable to handle kernel NULL pointer dereference at virtual address...
    ...
    Call trace:
        max310x_i2c_probe+0x48/0x170 [max310x]
        i2c_device_probe+0x150/0x2a0
    ...

Add check for validity of devtype to prevent the error, and abort probe
with a meaningful error message.

Fixes: 2e1f2d9a9bdb ("serial: max310x: implement I2C support")
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 5570fd3b84e15..363b68555fe62 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1636,13 +1636,16 @@ static unsigned short max310x_i2c_slave_addr(unsigned short addr,
 
 static int max310x_i2c_probe(struct i2c_client *client)
 {
-	const struct max310x_devtype *devtype =
-			device_get_match_data(&client->dev);
+	const struct max310x_devtype *devtype;
 	struct i2c_client *port_client;
 	struct regmap *regmaps[4];
 	unsigned int i;
 	u8 port_addr;
 
+	devtype = device_get_match_data(&client->dev);
+	if (!devtype)
+		return dev_err_probe(&client->dev, -ENODEV, "Failed to match device\n");
+
 	if (client->addr < devtype->slave_addr.min ||
 		client->addr > devtype->slave_addr.max)
 		return dev_err_probe(&client->dev, -EINVAL,
-- 
2.43.0



