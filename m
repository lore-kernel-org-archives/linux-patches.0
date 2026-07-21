Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283AE4028F7;
	Tue, 21 Jul 2026 18:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657972; cv=none; b=DZrfaHRdr5kFyyXh5/tnsRUD1OOvtx0PZgs32awYOqMMJ4GpyfdcwO7orQSDf28MWgQyNWEh39l1yc6/R80TBZrk2xnt2EfOrm7/CKgInRYDxvfU6EeM/KKdolI/hxs9wbbb5GuFm5ZNqA0qRnbR2SwGZXf/4P7y2m4vWbvs57A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657972; c=relaxed/simple;
	bh=eJ4hw6DRC2xcdAXGJFI3TK6X9WZzetO4F9aQCFSy8Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEO9jzDQyGVQ2sXvJI8Lex4QPhit/n0JP0lQ2WqFV6D++XU2CvcE3ZLcZ5zhEyx3cnwxnFJH0764r4hCCw+CQCVN5zicPCwW8q2Q7VNH86JZmUk9WSg1jGprS7Ce+n4Sgns5pQhvwjNtSQgxULuCfsI+2jJkQ6rL9O216zZQI7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+AfyOAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+AfyOAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6561F000E9;
	Tue, 21 Jul 2026 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657971;
	bh=GXfHT2xveic6L8uy/wkZqcssN0sMky2MyHecjkwFuos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+AfyOAsEwUD5Ci9g3c7D702FxjtInpHbRayFYQdKPB1ap9ISe4mUPssxelqkhRiw
	 oBm8f1dDxgX5incyrJhZvLcFIz7HIU5eLj4Ci2MMXvR9B2CyW41NSaijWWmOx78Cgy
	 UzlNLoqvzY3cxQAIj6n/KZYgAuQ/Nutztg8Sl858=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0966/1611] hwmon: (aspeed-g6-pwm-tach) Guard fan RPM calculation against divide-by-zero
Date: Tue, 21 Jul 2026 17:18:02 +0200
Message-ID: <20260721152537.124376016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index d1f7f439748245..3be59654412320 100644
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



