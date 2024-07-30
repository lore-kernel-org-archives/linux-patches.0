Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEB229A2;
	Tue, 30 Jul 2024 15:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354991; cv=none; b=sio1ufwFgYRppXB27ieBkaLWnYzUbzCFCsGSBdDxcs+27nQaP+JhKJFiXq3pxTjCvNV0GkzsDXdLjbTkSmUZlpNj/K8IsotBGyaOp+aAc/CEq2c+ZD5vzYmTlsiYt74mdchbcEyTw/Kzy5YrWNneR1TRsN0qsXcSp20KogsCFtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354991; c=relaxed/simple;
	bh=+Jr4tzNvcQj2FlBMbJcrYENglM3HgE5q6rd1Qn+nLO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5Sq53PCmZDy6fvszyQxBsbOQHqoQlIJm8YdNQG/YWifuhZrwDFgKZbwj/LMGSLw2umJnKFK6w9qDlVbk1TAbaM1ND3QG/p3eeGQmIZ4lOj5ebf3DYSs0rL7VcMa3elAqNKMB+iANGAfAUSNl7mVDAd9w/8QpF4B5+i5NG86vNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZoS452C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZoS452C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5582FC32782;
	Tue, 30 Jul 2024 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354991;
	bh=+Jr4tzNvcQj2FlBMbJcrYENglM3HgE5q6rd1Qn+nLO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZoS452CK1A6nMlDDwEOuDXYd0Y04HYLyVENSluRFziswwOIGbFU4z1kNQGd+Crzl
	 RexR/GoJ4r6CVjhEFp2wpehNZW+HQe4DwwtFblzVE5CPGy7ehSAWbys5BVq9A6/Aej
	 5LCwnC9UJJHSs8tR+lUlLnP6e769FZzI+WpdZ5o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Tung <chineweff@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/568] hwmon: (adt7475) Fix default duty on fan is disabled
Date: Tue, 30 Jul 2024 17:42:05 +0200
Message-ID: <20240730151640.543419401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 03acadc3a6cb4..14b2547adae8d 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1862,7 +1862,7 @@ static void adt7475_read_pwm(struct i2c_client *client, int index)
 		data->pwm[CONTROL][index] &= ~0xE0;
 		data->pwm[CONTROL][index] |= (7 << 5);
 
-		i2c_smbus_write_byte_data(client, PWM_CONFIG_REG(index),
+		i2c_smbus_write_byte_data(client, PWM_REG(index),
 					  data->pwm[INPUT][index]);
 
 		i2c_smbus_write_byte_data(client, PWM_CONFIG_REG(index),
-- 
2.43.0



