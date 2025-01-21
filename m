Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A151F3FFE;
	Tue, 21 Jan 2025 18:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483031; cv=none; b=hAGGGO+edVznAArM59FCqsR9CwmVKXnL35aE9RJ4BNOgWJ1v98DEGe3wXymJsxi5UPBYqoUG7Loc+sPeUPuW3i2jzufg6SUQ/y6td+RyL/+xpdGedpWTJNZzxeGwff4d8IySsGcfxxMPEElIypTnY8KSjZ8dz9XNoIr/AwZH9Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483031; c=relaxed/simple;
	bh=YM/ihpTmu+9UnwIWKLCxNRSmG58rex/N9FRorgE1n9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqqBQW0XCE3pcCglVLeGVRdBwfutsE8Q1Co2OpznzM9y59lhdmWckuI0mgfj9gow9hHu+culesuZLGMZ91g5avv77YHXfwCJpJITRWQvXYZRIdgn1YHeZAgIcOCE1vOiIor27xHclQfbOXuBhgAM7aaMKwF5I+hK4u8R+RNnrkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSfFl5nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSfFl5nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334FAC4CEDF;
	Tue, 21 Jan 2025 18:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483031;
	bh=YM/ihpTmu+9UnwIWKLCxNRSmG58rex/N9FRorgE1n9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSfFl5nBw814Tv8Fq1008xRy1CjLWS5ZGovbjJkms3OPdw2EfmLYS9wfANLPAVvhE
	 GOfonF3zPNaYKn4rgF8/hbF7ov+iiMxH9/IhEd35e29uOr9Xk/1er8r3TFdvdXaNuX
	 TQYWibxSO0WPhyzE/7cJK6G9N6VwwX/+TJFmeS0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/127] hwmon: (tmp513) Fix division of negative numbers
Date: Tue, 21 Jan 2025 18:52:44 +0100
Message-ID: <20250121174533.194377922@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



