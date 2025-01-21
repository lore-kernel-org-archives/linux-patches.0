Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA1D1F0E36;
	Tue, 21 Jan 2025 18:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482613; cv=none; b=U3ndk4Lc3C/1SFD7aWS8CEKiyqL9Nn+47ESzSPqF59iRoc3j9+ynfSDpXfzjYe3y0oKt8YDvy85NpNrXc0edI0iKipCTTswdsCFO1uR5HwY8gIXqRd390JDbrP4w4QD6SFf4VGb0KGOdPzEwbz8em6+/0ZfU7h72v6spsaK5ytk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482613; c=relaxed/simple;
	bh=4aFw9mjgp4X+It1S9GWN4jVUttdzJrOcB1vpivnU44Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYl7ooHv0Og4Ec9VBK00LHZqbmc7+Zu5vBH7jWXCjKhpSk1uudNmjLongx4ZCKXWTw48J67tlS+AA5M4A0D4/IGeqVHgai5hMTaK8zAH11wX37Wvmv24iiTBaaIGoo7W7C0y9Xz9qkf8YW0MolszKI+kq0YwSr8SKc1uY0Aypps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrF9SthD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrF9SthD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C73C4CEDF;
	Tue, 21 Jan 2025 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482612;
	bh=4aFw9mjgp4X+It1S9GWN4jVUttdzJrOcB1vpivnU44Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrF9SthDTzz7UYu9tK9WhaHzS0mDlQ6tNezx7pUIx41Zq+YeGR76xyhTPGWvZuNNF
	 ruQlN2Lb+773WLKD4W+fj41270LRIhKzL1qlcXZRXyI7rquZhSYbDvO2+AS5iD6X8F
	 N1lY7l2x9NpvEcELQ06tF5AGSuVQWJhtxZB1cR4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/64] hwmon: (tmp513) Fix division of negative numbers
Date: Tue, 21 Jan 2025 18:52:13 +0100
Message-ID: <20250121174522.104940039@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aaba9521ebefe..cbe29c8a9b18d 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -203,7 +203,8 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 		*val = sign_extend32(regval,
 				     reg == TMP51X_SHUNT_CURRENT_RESULT ?
 				     16 - tmp51x_get_pga_shift(data) : 15);
-		*val = DIV_ROUND_CLOSEST(*val * 10 * MILLI, data->shunt_uohms);
+		*val = DIV_ROUND_CLOSEST(*val * 10 * (long)MILLI, (long)data->shunt_uohms);
+
 		break;
 	case TMP51X_BUS_VOLTAGE_RESULT:
 	case TMP51X_BUS_VOLTAGE_H_LIMIT:
@@ -219,7 +220,7 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 	case TMP51X_BUS_CURRENT_RESULT:
 		// Current = (ShuntVoltage * CalibrationRegister) / 4096
 		*val = sign_extend32(regval, 15) * (long)data->curr_lsb_ua;
-		*val = DIV_ROUND_CLOSEST(*val, MILLI);
+		*val = DIV_ROUND_CLOSEST(*val, (long)MILLI);
 		break;
 	case TMP51X_LOCAL_TEMP_RESULT:
 	case TMP51X_REMOTE_TEMP_RESULT_1:
@@ -259,7 +260,7 @@ static int tmp51x_set_value(struct tmp51x_data *data, u8 reg, long val)
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



