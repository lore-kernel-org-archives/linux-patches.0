Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104DA3D3337;
	Tue, 21 Jul 2026 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653442; cv=none; b=Zx/JhkJXYf44y8nI8Bnd75DvqRzv1WfzdnJe7ttZREnIKmW2w/0Jx9fFfQLYiFQ56DyFQ8Ikcmx0YYTO2V5HAcotooeEhHlckywKL95f7tK2uc8ZoEtKCW2pxkQkb30ipMDPb9soRW+lgBRNwDckVE5ixIR8jXHRz5gZNEciRMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653442; c=relaxed/simple;
	bh=ZzPrjRcbvzVJ2/gE/kmaAtyWI+ML/F9fh8zFaDv7mlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot1YwiGg0gFTPR3ingnRI0YtXN7sC+wCUAwsyyLQqVGFsDim4jc/Yp9DsmU5JCN8b2jnFKfCgmb45tNu0iw+arnwxCjDEA/3qR4Nljpm+JRxYCsxcq5h7EHFNY7FL/xNDGhdmCLfXsOKx9jo2W+fQKjQQQpBdA0wuvYdTAYvvpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ine/2LpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ine/2LpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5051F000E9;
	Tue, 21 Jul 2026 17:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653441;
	bh=Jr80BJ9Q/P7vzuj+RTmyrR5bCEX8k+qZ2eGnQPb+9N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ine/2LpKPkj41O+/kVGiEkownsax0Fb1ePWRdXvOw8d2J5asg1QKaFcP2atQfx8Nd
	 HHvbYKZZ8Y7zYEGEx4b5GUUBIAKjCXdrrszz/+hEGcYe+WTv/1Zlg0m2GWMVYhfmbe
	 aBXR/83g6lovAwMSbMiGc8+jHxs24yngdXOKjkBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1327/2077] hwmon: (aspeed-g6-pwm-tach) Guard fan RPM calculation against divide-by-zero
Date: Tue, 21 Jul 2026 17:16:40 +0200
Message-ID: <20260721152624.115471070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit fe87b8dc67f1b2c64e76a66e78468c533d3c44ca ]

Sashiko reports:

In the aspeed-g6-pwm-tacho driver, the aspeed_tach_val_to_rpm() function
calculates the fan RPM using the tachometer value. However, it does not
check if the tachometer value is zero before performing the division.

If the hardware reports a tachometer value of 0 (which can happen due to
an extremely fast pulse, a stuck edge, or a hardware glitch), the
calculated tach_div evaluates to 0. The subsequent call to do_div() with
tach_div as the divisor triggers a divide-by-zero exception, leading to
a kernel panic.

Check the divisor against zero to fix the problem.

Fixes: 7e1449cd15d1 ("hwmon: (aspeed-g6-pwm-tacho): Support for ASPEED g6 PWM/Fan tach")
Cc: Billy Tsai <billy_tsai@aspeedtech.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aspeed-g6-pwm-tach.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/aspeed-g6-pwm-tach.c b/drivers/hwmon/aspeed-g6-pwm-tach.c
index 4f6e6d440dd405..5d611a8e526908 100644
--- a/drivers/hwmon/aspeed-g6-pwm-tach.c
+++ b/drivers/hwmon/aspeed-g6-pwm-tach.c
@@ -293,7 +293,10 @@ static int aspeed_tach_val_to_rpm(struct aspeed_pwm_tach_data *priv, u32 tach_va
 		priv->clk_rate, tach_val, tach_div);
 
 	rpm = (u64)priv->clk_rate * 60;
-	do_div(rpm, tach_div);
+	if (tach_div)
+		do_div(rpm, tach_div);
+	else
+		rpm = 0;
 
 	return (int)rpm;
 }
-- 
2.53.0



