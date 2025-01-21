Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659611F55FA;
	Tue, 21 Jan 2025 17:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482335; cv=none; b=XkX01cFEBjVQND2Edo9EIJLg/k6NcZeZZNFXBuCWvUjRtOXuysBmOoz920YdjN/hsaJiYKo7ORx6GybXe7MbE0h9WJN1F5QIPowZe4kOCvMwNjZcDHWWRj7sxPzj1YknL9dnw4i0aNQgxJRITc24F/GZlybVHd88Zm0kcRNaOO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482335; c=relaxed/simple;
	bh=8roqt6+uL2ovENah1bIfHFCCRxkyEq52CyEkuH5n36w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRDCDoQQiMNHXuwgiWLZp1lyUiD6B/O+v3dvaXpy5264RZDQpfMqxispPNZTFGMVOJYca+1j/BKS3AteKM+lhajMt8GVJCAMQm2rM6xy+Uwlrfe5jiX0+g459pgZ0ZPYmm4+RuAW5XXrYVTTXqmvdFcTgpGXwRFSWJi2OaS01qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbfKB8ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbfKB8ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04F1C4CEDF;
	Tue, 21 Jan 2025 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482335;
	bh=8roqt6+uL2ovENah1bIfHFCCRxkyEq52CyEkuH5n36w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbfKB8tyh6guWz8IerzW8xu1g3bg/sIs3qVEJHuvrO6bIm7WNmSPaNeZlmA6tKpQu
	 0UgPYq7dD+jVTprSyDeRU5j5ltWhWV1EFWBmMAEN9i17F+69hvqFQH+ne47XIs11CS
	 fLDasM5E+8p3I5ZfK39qGTXhWoSDqO01NDVY0GJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/122] hwmon: (tmp513) Fix division of negative numbers
Date: Tue, 21 Jan 2025 18:51:30 +0100
Message-ID: <20250121174534.601384925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit e2c68cea431d65292b592c9f8446c918d45fcf78 ]

Fix several issues with division of negative numbers in the tmp513
driver.

The docs on the DIV_ROUND_CLOSEST macro explain that dividing a negative
value by an unsigned type is undefined behavior. The driver was doing
this in several places, i.e. data->shunt_uohms has type of u32. The
actual "undefined" behavior is that it converts both values to unsigned
before doing the division, for example:

    int ret = DIV_ROUND_CLOSEST(-100, 3U);

results in ret == 1431655732 instead of -33.

Furthermore the MILLI macro has a type of unsigned long. Multiplying a
signed long by an unsigned long results in an unsigned long.

So, we need to cast both MILLI and data data->shunt_uohms to long when
using the DIV_ROUND_CLOSEST macro.

Fixes: f07f9d2467f4 ("hwmon: (tmp513) Use SI constants from units.h")
Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20250114-fix-si-prefix-macro-sign-bugs-v1-1-696fd8d10f00@baylibre.com
[groeck: Drop some continuation lines]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 1c2cb12071b80..5acbfd7d088dd 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -207,7 +207,8 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 		*val = sign_extend32(regval,
 				     reg == TMP51X_SHUNT_CURRENT_RESULT ?
 				     16 - tmp51x_get_pga_shift(data) : 15);
-		*val = DIV_ROUND_CLOSEST(*val * 10 * MILLI, data->shunt_uohms);
+		*val = DIV_ROUND_CLOSEST(*val * 10 * (long)MILLI, (long)data->shunt_uohms);
+
 		break;
 	case TMP51X_BUS_VOLTAGE_RESULT:
 	case TMP51X_BUS_VOLTAGE_H_LIMIT:
@@ -223,7 +224,7 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 	case TMP51X_BUS_CURRENT_RESULT:
 		// Current = (ShuntVoltage * CalibrationRegister) / 4096
 		*val = sign_extend32(regval, 15) * (long)data->curr_lsb_ua;
-		*val = DIV_ROUND_CLOSEST(*val, MILLI);
+		*val = DIV_ROUND_CLOSEST(*val, (long)MILLI);
 		break;
 	case TMP51X_LOCAL_TEMP_RESULT:
 	case TMP51X_REMOTE_TEMP_RESULT_1:
@@ -263,7 +264,7 @@ static int tmp51x_set_value(struct tmp51x_data *data, u8 reg, long val)
 		 * The user enter current value and we convert it to
 		 * voltage. 1lsb = 10uV
 		 */
-		val = DIV_ROUND_CLOSEST(val * data->shunt_uohms, 10 * MILLI);
+		val = DIV_ROUND_CLOSEST(val * (long)data->shunt_uohms, 10 * (long)MILLI);
 		max_val = U16_MAX >> tmp51x_get_pga_shift(data);
 		regval = clamp_val(val, -max_val, max_val);
 		break;
-- 
2.39.5



