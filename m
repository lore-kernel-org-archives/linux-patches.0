Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832294DF4D5;
	Wed, 30 Sep 2026 16:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785335; cv=none; b=VNnxmO14uSVJS45qiTnUr4x2F0T3PlCIyd5L8y5BjiiqO7dPspkyanytglOjXKphldZ4uWxICv/ZERG8NL7/DEEFgPYrfUwgyKKMRotHMMA0Dh1Irp8YFW6qww+CnUFHz1xChpERkUjnyFZ+DhE2eZ1aouQbCipj7UHs2wbX8c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785335; c=relaxed/simple;
	bh=Y5qWfz8gpkB6cNnb5msvzhKAj8XCke8fzw4b3Kl2Z3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHJUffzPf2IUDQqe4IIxbP+OQkexSf408cfXq9atxAHUv3FjcqoFZJWHMjKCfoTYLiimf8eWxuu5Uhu2pcQ4grxgxycWYky/xKX0CodLrBAEnZrshhjkTIZbqDw9xOPQSUJRA/Y47H6taC/OVvdb4S08eb9Df4YrRWsvO7Zoa/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNCY7eiO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNCY7eiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206971F00893;
	Wed, 30 Sep 2026 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785330;
	bh=z5heH8f9yN/xd//xyDqE/xcatOUIgWcv9wfxzZIcHi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNCY7eiOdN0Xx/hUrHJXjYM+tEWYyl+bIT6V3bYRiaz74WB4zvodyU6ZX33gpMVs/
	 xkOaHVxAnBT05fUgFJKLJb4agGtjBflT9CN/ySahG3kRntCxGk6ZHdJq8TbV6dJpY0
	 AI2+df1ZRZGkcX5RD/U4aF2To/3pUTR5fdQzFZ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 471/982] hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors
Date: Wed, 30 Sep 2026 17:20:07 +0200
Message-ID: <20260930152426.900485308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 51f321bcd778a..133453938e9ad 100644
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



