Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F14611720;
	Sat,  3 Feb 2024 04:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933944; cv=none; b=thfVh98tNqAyU5n6ZLgNcxsks4AHEEH1aXXgrfxTu7Un0ldCaCzHBvg2Lu50WqiGJd1l8pKfaMz/v7HBLoSyRAv3fmgGvHHeWDVbw1p2io0iFaArozoak+wlAozVVHrGtsw5S8C9IDQ7zOLs+FmpEurSHV0Hx6bxEyQtcSoHTw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933944; c=relaxed/simple;
	bh=ospwZBTkfK7pTTW2kUTq0XV6cBgTjKcrPwIah/LkTps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUcja1s3jlJiV8+u0mnZ2QoF4PJVYJL71xEIO7enn0byxpZdVF+Dpjgn8l/jHqA2qD/GpIx/C/znijrtf2GwvNDyL2wlYQoHaHmUIQqDUsR0WXz2SyfOdvq5CaOQLM2BnTBbqq9L23ol2ZKWckPkbj40wW4F2z/VgSqX9EjZPWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN+jolw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN+jolw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65614C433F1;
	Sat,  3 Feb 2024 04:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933944;
	bh=ospwZBTkfK7pTTW2kUTq0XV6cBgTjKcrPwIah/LkTps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jN+jolw1BvxEF4Fib4hcVzc9pvMBy7clvHVg3lqnJ7PQfSDkv0lA4Wo0UrqTlKEx/
	 QzGsXV9gro+YqTpAsz5qfaHUi2VWGBMN6EZHSrWzWAtHXiV8cST8XBUuTvc4fACxLE
	 I8SbSfZFj9hgoTbhYgyo7jLaTT/AfzMDyRGHLpKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Lunn <tim@feathertop.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 286/353] i2c: rk3x: Adjust mask/value offset for i2c2 on rv1126
Date: Fri,  2 Feb 2024 20:06:44 -0800
Message-ID: <20240203035412.830024667@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Lunn <tim@feathertop.org>

[ Upstream commit 92a85b7c6262f19c65a1c115cf15f411ba65a57c ]

Rockchip RV1126 is using old style i2c controller, the i2c2
bus uses a non-sequential offset in the grf register for the
mask/value bits for this bus.

This patch fixes i2c2 bus on rv1126 SoCs.

Signed-off-by: Tim Lunn <tim@feathertop.org>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rk3x.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 4362db7c5789..086fdf262e7b 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -1295,8 +1295,12 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
 			return -EINVAL;
 		}
 
-		/* 27+i: write mask, 11+i: value */
-		value = BIT(27 + bus_nr) | BIT(11 + bus_nr);
+		/* rv1126 i2c2 uses non-sequential write mask 20, value 4 */
+		if (i2c->soc_data == &rv1126_soc_data && bus_nr == 2)
+			value = BIT(20) | BIT(4);
+		else
+			/* 27+i: write mask, 11+i: value */
+			value = BIT(27 + bus_nr) | BIT(11 + bus_nr);
 
 		ret = regmap_write(grf, i2c->soc_data->grf_offset, value);
 		if (ret != 0) {
-- 
2.43.0



