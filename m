Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0316F4ED1B9;
	Thu, 17 Sep 2026 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666154; cv=none; b=e3a1UOOyiglWq3h3Nhzqtc9wCNCKT9AY44xj1mCxm/5+UCTNalpYz986QZHFvZSpuywKlseTFAAuySUJ7Ml+kbsk9t+vv22X8Vp6fOCE6iSP77RAk5xQDHQ8y/RU42Y9zG0qrtCBOdxZt4543aSTfpPd0GTvY0x5G7t4UOiMqC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666154; c=relaxed/simple;
	bh=OwK3S6nO4RDbQ+pF2O65vpRkVGDuHUQDqaghsbaJ3GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8DZEmHmG5HIZF/6uukRyOPZH+ns70jwseQ4mWfXIn2fjG7b6HfEW3WkTZ588jBadtqey6c/az6G0Hv55mVgdcYac4gxv9DoH3IDOI/SYxJzIGJJ6fN5Y/B1MtnOXq4chXp66Leycem7Iu2zssFSPqmC1Mt1QHHCqu8/ZjKk1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBYYI0DK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBYYI0DK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2E11F000FF;
	Thu, 17 Sep 2026 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666152;
	bh=9cI2ZnWWWfsGrDexfgn747do4VuVEaZ17zDEwmpukGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBYYI0DKuhR+/ZEVuKU5dSp8LccA3otyjG+ByLCHQNBu+J9qvA38xELlqsH7SOuW+
	 SQEE9LQwMqiakT9i6IvXNt+AlpaXTGSzcU4a1tRKVjxedv92gY012oxxjkwKJDjr8+
	 XEXQHnHTOCfeItSbShDdfL7TjIp8V0bOxWXFPDdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0903/1250] hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors
Date: Thu, 17 Sep 2026 16:11:38 +0100
Message-ID: <20260917151616.468017263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index aa159bf158a37..4c62487336db0 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -933,7 +933,9 @@ static int aspeed_pwm_tacho_probe(struct platform_device *pdev)
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



