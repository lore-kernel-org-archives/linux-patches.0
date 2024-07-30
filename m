Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4DF29A2;
	Tue, 30 Jul 2024 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354963; cv=none; b=WzJw4/JvqHwIkwGaLUuArHocvNSUI+MTSMsOmaZYtMdRWsJidE769TGZQ149SbHuwQyR6t2kMFgmppSS6ofzUrMO2VP23ztc5zvbYBMPHqDkVIiLvmo0zzY2U8h6Dov7sWV8WpeLiQZr0DuWKgvFkfamb/571cjOgAmzFGd1x8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354963; c=relaxed/simple;
	bh=HqKEVi04CP+jV2P2OHe+dExWHzZ110GDxSpY637VXeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5p8Lx6TQ43trkdkKdQXgc+mEt+dYTBWLnSebj5PTwms8GQ2vLJEuvDWgzWuOeoRD0ioXmnIDh2pqCmdIBefMRMUZbVFrB+usvwEpe95n4Fx/dGh3eigDYNJvux0anEwGFa0v4Sh0TezTnWzVXNKhtCPh3Dwdvc8XA3CMRq1Src=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEVMwzKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEVMwzKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E1DC32782;
	Tue, 30 Jul 2024 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354963;
	bh=HqKEVi04CP+jV2P2OHe+dExWHzZ110GDxSpY637VXeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEVMwzKCufpE9tQhxfU+6t8GY7inyimEvnCw7SZgDPXV14fkDwduw1W0q3MozSpGX
	 hkqUfLL5jZBHUapr6Y8hml223chb5zOCigOl5aqdnAFDFJ73NH/8nblgoXf2eBs8mv
	 gLpCuUpVk/TO6/YDYlqP5TuCmMvGYuZBnjo/47yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Tung <chineweff@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/440] hwmon: (adt7475) Fix default duty on fan is disabled
Date: Tue, 30 Jul 2024 17:44:13 +0200
Message-ID: <20240730151616.554221257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6a6ebcc896b1d..3ac6744276750 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1863,7 +1863,7 @@ static void adt7475_read_pwm(struct i2c_client *client, int index)
 		data->pwm[CONTROL][index] &= ~0xE0;
 		data->pwm[CONTROL][index] |= (7 << 5);
 
-		i2c_smbus_write_byte_data(client, PWM_CONFIG_REG(index),
+		i2c_smbus_write_byte_data(client, PWM_REG(index),
 					  data->pwm[INPUT][index]);
 
 		i2c_smbus_write_byte_data(client, PWM_CONFIG_REG(index),
-- 
2.43.0



