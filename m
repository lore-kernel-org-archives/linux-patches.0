Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDAD4418FF;
	Mon, 17 Aug 2026 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979906; cv=none; b=DJG8Ut3vV3Wfeq3Cof4CnzaScR3Bf+8F0X7WLCS2wmJDjzpWGuPvrNkAuI/I1UVnwR5Fs2ezlcJQlIkv3pZnXJwAqNJLqfLJdY8xsAbcUpzzJixOf1SrpfzLHqTawRUL9Ijpqqj2qPI15nqol/lXe/torgi/5hu3GBkI+eU90Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979906; c=relaxed/simple;
	bh=2pRskpz9ZFHqktziPOIDln5+4KGHNCG5TrEV4C0GzfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2hniKpKSNXB8gefLA5jAZCFMcYjtp2H6apd1ysdtCISxCAMC9Mv5MUku6qOPMDafehm+Hda1tPjlNB7YS4d0reZpl5KTljLZB6BesO/F+qq7DX0fnXu25kjGzIZMp4gV7zeJ4fCbUbiir2KcGezANQ5IG+LcbxwPuyPDXo70Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udVEUUQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udVEUUQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973621F00A3A;
	Mon, 17 Aug 2026 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979905;
	bh=gVrqLhIJjkavSM/MU/8vnnPx17xiguPtvE4OJA9Vxfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udVEUUQlUHfHdSD8A6y9gTQSA2eO4TBCJ0fA4r4SkFTN0YejJY0OjlyFmjT5/oVPl
	 zWa5798XXkqpfrE8YwPkhjEBraNpmNs55jeiJ7oXev1FCgkqS+bvVHYtWETrs1HBRG
	 apzYFnfHfhEk+5yT8QNUImuvzO3GuIavqV5ykZlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 361/609] hwmon: (adt7470) Fix PWM auto temp state array and bounds check
Date: Mon, 17 Aug 2026 15:30:57 +0200
Message-ID: <20260817132556.365610316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 92413f439d1ec5e55b73ede8d66a7b971cbd1ced ]

In pwm_auto_temp_store(), the parsed user input was missing bounds
checks, allowing values > 0xF to overflow into the adjacent channel's
bits. Furthermore, the value was being incorrectly written to the
pwm_automatic state array instead of pwm_auto_temp.

Fix this by rejecting values > 0xF with -EINVAL, and assigning the
value to the correct array only after a successful I2C write.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260727034932.0B7C41F000E9@smtp.kernel.org/#t
Fixes: 6f9703d0be16 ("hwmon: add support for adt7470")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-8-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 8010ed6f86a18..9783593a1de76 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1057,8 +1057,10 @@ static ssize_t pwm_auto_temp_store(struct device *dev,
 	if (temp < 0)
 		return temp;
 
+	if (temp > 0xF)
+		return -EINVAL;
+
 	mutex_lock(&data->lock);
-	data->pwm_automatic[attr->index] = temp;
 
 	if (!(attr->index % 2)) {
 		mask = 0xF0;
@@ -1069,6 +1071,9 @@ static ssize_t pwm_auto_temp_store(struct device *dev,
 	}
 
 	err = regmap_update_bits(data->regmap, pwm_auto_reg, mask, val);
+	if (!err)
+		data->pwm_auto_temp[attr->index] = temp;
+
 	mutex_unlock(&data->lock);
 
 	return err < 0 ? err : count;
-- 
2.53.0



