Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AF6331233;
	Mon, 29 Dec 2025 16:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025164; cv=none; b=hweyjecJyRHTpQNRv3fKUzjb2pTUAxL4MDHdOeuQD74kWXxHOQRL6k3OAPWf8ZaZRUDIUSwlM793PJoeax/LSreT4XYWOGPRUnfaRQucU3lQNvVySEfff6kGquh0iqQfIvzrsUQ31AxCwHQSTdppZgjeLcX2DYq2XmfCuAXeWBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025164; c=relaxed/simple;
	bh=+kNc5J0OfNhNWafIrugCTYW/lP69iVa83QO0SFRpaBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmPMX840r+2gd5YOLCLp0h4P5I2Qds3xpUEW9fyus00ZcX8whJAWRczDg0F26D/e5rOcFYfz+hIYrps9npN4ZzxMS5nIftFVSdOxbweu78wVK2d9TAszBEjB0p8f2Hsy7l0+MDz/TZ/Fh/yCDH6n/fKz4AxZhK5RISopDQpZ/Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5Kk/lB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5Kk/lB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEE0C4CEF7;
	Mon, 29 Dec 2025 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025163;
	bh=+kNc5J0OfNhNWafIrugCTYW/lP69iVa83QO0SFRpaBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5Kk/lB8UWLIlmFcIWEvpcUHK8UnjSwynUXRGIovB/hld1lwiycpkhMTKXy3r7xff
	 19jBnVWVy72Zlx1GYuh86B9sx5ycGjfvA1xv2VuHXoi8ZJqK+hLipl7pB2fcJUIRJZ
	 oikty9idRMRHeS0pOKsHCORS3PQ8Hp17Veae4KRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Sergeev <denserg.edu@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/430] hwmon: (dell-smm) Limit fan multiplier to avoid overflow
Date: Mon, 29 Dec 2025 17:08:38 +0100
Message-ID: <20251229160728.636512730@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Sergeev <denserg.edu@gmail.com>

[ Upstream commit 46c28bbbb150b80827e4bcbea231560af9d16854 ]

The fan nominal speed returned by SMM is limited to 16 bits, but the
driver allows the fan multiplier to be set via a module parameter.

Clamp the computed fan multiplier so that fan_nominal_speed *
i8k_fan_mult always fits into a signed 32-bit integer and refuse to
initialize the driver if the value is too large.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 20bdeebc88269 ("hwmon: (dell-smm) Introduce helper function for data init")
Signed-off-by: Denis Sergeev <denserg.edu@gmail.com>
Link: https://lore.kernel.org/r/20251209063706.49008-1-denserg.edu@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index cbe1a74a3dee..f0e8a9bc0d0e 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -76,6 +76,9 @@
 #define DELL_SMM_NO_TEMP	10
 #define DELL_SMM_NO_FANS	4
 
+/* limit fan multiplier to avoid overflow */
+#define DELL_SMM_MAX_FAN_MULT (INT_MAX / U16_MAX)
+
 struct smm_regs {
 	unsigned int eax;
 	unsigned int ebx;
@@ -1253,6 +1256,12 @@ static int dell_smm_init_data(struct device *dev, const struct dell_smm_ops *ops
 	data->ops = ops;
 	/* All options must not be 0 */
 	data->i8k_fan_mult = fan_mult ? : I8K_FAN_MULT;
+	if (data->i8k_fan_mult > DELL_SMM_MAX_FAN_MULT) {
+		dev_err(dev,
+			"fan multiplier %u is too large (max %u)\n",
+			data->i8k_fan_mult, DELL_SMM_MAX_FAN_MULT);
+		return -EINVAL;
+	}
 	data->i8k_fan_max = fan_max ? : I8K_FAN_HIGH;
 	data->i8k_pwm_mult = DIV_ROUND_UP(255, data->i8k_fan_max);
 
-- 
2.51.0



