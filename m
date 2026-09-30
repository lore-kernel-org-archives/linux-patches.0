Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD3D38DC66;
	Wed, 30 Sep 2026 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791563; cv=none; b=qIaUi7vLuhHqnT/SQwPEUs3whjncMQH5oGNWV6ymPF174V3xZL4bhkd+HhA3YB/4+49qDgEg+eTf1vqUsUDBLBU+QtBasQXsbTxpgp+bRgj52LVyuWco8n5j+kBXzXEfczM+BQVM9L+YyksphwaI7HQ+1FY4wyxX069fmyQG9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791563; c=relaxed/simple;
	bh=gBeW798wTAkCVaiVQFHgK6E3Nsre/9x0LBYyrtp0UXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US8qXj2KtrlvIcM52RGkmud0SeCFCKdpwUGvkYWkm0olwKUXZJHbS4pYtCagrV60uH4awZBHvm9GIdB/NYN7/7fccZFRwJ1TnfzI88ylMrw04VE6Ch98xEm2xitObfVXBcPy1eBaWNq9+gGsWxPHIkrhltSwzKAa7yauMu76nzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uckQXtrQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uckQXtrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E204E1F000FF;
	Wed, 30 Sep 2026 18:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791562;
	bh=qLzToy6r9qC8HXTyh4by1RuusHbTdZqkMcrzew9g1WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uckQXtrQ9B8SBZ7WYKsHAo59EZyK8/PJ/Nzj6bWryx74hjRmDJTlSQw1zp9MdC1Cp
	 BarxRCKoGIExqg98SgBywVGnWj2e4rY61xydsTpzSphmbH1A4eb3vTyOciRkJo6bsD
	 ULnfeqTps66/O10GK6wK4/MQA6e5yi7TYxUg0+Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/752] hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors
Date: Wed, 30 Sep 2026 17:23:36 +0200
Message-ID: <20260930152405.777933469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 424613e5b14f5..1fbc2da7a1ae6 100644
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



