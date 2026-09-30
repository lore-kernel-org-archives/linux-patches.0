Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D62C4A92EF;
	Wed, 30 Sep 2026 15:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783087; cv=none; b=ulZU8DX3isHWnuciRy1opHZn2maumUOkP9VMzE+dRJPo4voKGNnuTR2Q8U+tvmh/6wa4ltzr0SnpGvMZjs5hNQlj6QQTh+ZAvhSWVDGX5uD+XEfbyw4oxLYjbcwIy8e7GDSVT7wZk0BUwtD1u2UrgCd3XnGKrDabqFoKm1CThgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783087; c=relaxed/simple;
	bh=UUT2o2dhP+s1CXTO+T9YWlJjmqVChz1QM3DHIHVsC9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnbLUOn261UBKhTaRhTPhlD00cBMGoWNgb/4NETqqCYH4YXRUdZjNesy/VL/Nvm3E5QOsp8AIqaeKeSsgdjSQoAJ4CgAzi2JqJ5QlopoGnempQLzNXxfVJ/gBJb7iVJll2uJcT0DPimV4xWAMziwWb3wM+I5aUrKZUFfuvbx2PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGTh/G0H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGTh/G0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429471F0089A;
	Wed, 30 Sep 2026 15:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783077;
	bh=r3IYzCX7LAsGbl7X9JLKJi+ody71KAQQS2bjB+U/LWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGTh/G0HgBBByw5+3DFrLjx2L8YFOJYtVKyhmMO8S0MAVo2ECzzGcHD17HvfkZYuH
	 c4ZZVzgoKLKRL7Lnqv2+yyq73M9ltNIuq6OvFurJZB3Psd3MXJZWM9DEbQWEkglnYR
	 9f5HzPLiWz8t3jI1SEi0j5UAycIk8P33eJVM+z6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/595] hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors
Date: Wed, 30 Sep 2026 17:22:46 +0200
Message-ID: <20260930152353.580844428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 09a9e1746a87845d7d8e2b4e23bb613306effdff ]

aspeed_pwm_tacho_probe() installs its reset cleanup action and configures
the
controller after an unchecked reset deassertion.

Stop probing when the reset controller rejects the transition, before the
hwmon device becomes visible.

Fixes: 18c514cc0e02 ("hwmon: (aspeed-pwm-tacho) Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830125044.97718-1-pengpeng@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aspeed-pwm-tacho.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/aspeed-pwm-tacho.c b/drivers/hwmon/aspeed-pwm-tacho.c
index 3dc97041a704c..ed100c0428374 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -922,7 +922,9 @@ static int aspeed_pwm_tacho_probe(struct platform_device *pdev)
 			"missing or invalid reset controller device tree entry");
 		return PTR_ERR(priv->rst);
 	}
-	reset_control_deassert(priv->rst);
+	ret = reset_control_deassert(priv->rst);
+	if (ret)
+		return ret;
 
 	ret = devm_add_action_or_reset(dev, aspeed_pwm_tacho_remove, priv);
 	if (ret)
-- 
2.53.0



