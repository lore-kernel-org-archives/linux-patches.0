Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C26349AE8;
	Tue,  6 Jan 2026 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719910; cv=none; b=nvDrKHD3Pxi1pzxnp8za2u2Au50Xc9XvKv/8xZw0Xw+fiutGtk0DV/WSj3cWWJhCL7gF923RAWzOv1G0IyIicsJi3TelVCNFS4BnF2pWGZdLbm2C92bM94MopX180GkgKVy9NviH8gWZnjR1iVsuwRiOLXx78+PMxCEiTMa8g5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719910; c=relaxed/simple;
	bh=cf5nt6KWWYV+IG7NgKBwktvcBr8kgw1skPIkYMsMDdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNwGglVXhgKjN0vUAWxbP6UVvWOO0XMEUokT9GFyJWc1LBqRV9FJ4FCIw7YL3oxuLN3TwbTtEN0HKX8ScwV4R+hf1yiFWsCCVDM3C4rQAaupvtkqJ18mYHv6W1dU1XDF996UInn+xRCSX8Ra5rVmlKtXSnmHKQvOB+ArUeVssUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzAgh0C5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzAgh0C5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A51C116C6;
	Tue,  6 Jan 2026 17:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719910;
	bh=cf5nt6KWWYV+IG7NgKBwktvcBr8kgw1skPIkYMsMDdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzAgh0C5b4sYYLbJuefpeQht1AAygnrSwkXZeDJYXlQ9d6uMkXOth61xuAaGdfSYp
	 defi2VxpW87Fw89ZU29sBjDgTGPYYouv734UGXsJMkiNN+/RYll8+/HLmlR1QVs3K2
	 5eGsndsVbt/BiwRrrvdcfo4P1xs/fuViRK4Wjzkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Sergeev <denserg.edu@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/567] hwmon: (dell-smm) Limit fan multiplier to avoid overflow
Date: Tue,  6 Jan 2026 17:57:40 +0100
Message-ID: <20260106170454.218295303@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f73f46193748..9df78861f5f8 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -75,6 +75,9 @@
 #define DELL_SMM_NO_TEMP	10
 #define DELL_SMM_NO_FANS	4
 
+/* limit fan multiplier to avoid overflow */
+#define DELL_SMM_MAX_FAN_MULT (INT_MAX / U16_MAX)
+
 struct smm_regs {
 	unsigned int eax;
 	unsigned int ebx;
@@ -1203,6 +1206,12 @@ static int dell_smm_init_data(struct device *dev, const struct dell_smm_ops *ops
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



