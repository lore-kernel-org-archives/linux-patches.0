Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AF319EED0;
	Thu, 15 Aug 2024 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728484; cv=none; b=Xzp0kzmHLAN7hDL8DD5uv4RYEBkCy+xZbrSmzONRlOte9alL37Nw7ArlrQLzlHkZYXZ6nOqrorsNo/UQ+/pKwGH9btt/xQkYgEcZ3EW+36rkA3ILwwHM9gnc4V9h31tpVKyviyxHH6+Ys3KZgGKujYE2tY0iTIfsIlEUub/LTiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728484; c=relaxed/simple;
	bh=r0135Qg9ScdRlZzVooAylpYulHfDRz1ZnNhuKvEwlA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XghGtD8qMhtHNIJgViDLJ6A4auKrcKm5wt2liYncy8QhYDvYRDbVQrrVHEu/4LtgrArdFZ9QoBPXQiYeHC/83kQ+nXM1eNCZs3tIOuBO+CYKIIizzlueT21ovg65VwzGpnDRFWWaaiix+1JpVelIkwjMYucZY7NNRx1vJQdl4+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ww+YlU2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ww+YlU2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19795C4AF0E;
	Thu, 15 Aug 2024 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728483;
	bh=r0135Qg9ScdRlZzVooAylpYulHfDRz1ZnNhuKvEwlA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ww+YlU2jMD62ipkSbgMpxodcoEZBhn3cDrgFeCnTjpiSWB/I3UychZJCR4fav/bDw
	 6JYNvmX9Pe7jH3OjkBiUASRB351nLUQg7795mDUGFoQytYmZnak7Ww49Fdk+Y3uIe6
	 b+2X9Uu/WZYeBra9gCSOKADMTVXSOc79WLPOseSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Tung <chineweff@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/196] hwmon: (adt7475) Fix default duty on fan is disabled
Date: Thu, 15 Aug 2024 15:22:04 +0200
Message-ID: <20240815131852.354705667@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Tung <chineweff@gmail.com>

[ Upstream commit 39b24cced70fdc336dbc0070f8b3bde61d8513a8 ]

According to the comments on fan is disabled, we change to manual mode
and set the duty cycle to 0.
For setting the duty cycle part, the register is wrong. Fix it.

Fixes: 1c301fc5394f ("hwmon: Add a driver for the ADT7475 hardware monitoring chip")
Signed-off-by: Wayne Tung <chineweff@gmail.com>
Link: https://lore.kernel.org/r/20240701073252.317397-1-chineweff@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7475.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 2db2665dcd4dc..6406520f39150 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1785,7 +1785,7 @@ static void adt7475_read_pwm(struct i2c_client *client, int index)
 		data->pwm[CONTROL][index] &= ~0xE0;
 		data->pwm[CONTROL][index] |= (7 << 5);
 
-		i2c_smbus_write_byte_data(client, PWM_CONFIG_REG(index),
+		i2c_smbus_write_byte_data(client, PWM_REG(index),
 					  data->pwm[INPUT][index]);
 
 		i2c_smbus_write_byte_data(client, PWM_CONFIG_REG(index),
-- 
2.43.0



