Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272F614A095;
	Mon,  6 Jan 2025 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178720; cv=none; b=kP6LitAQhSuLk2qU4rO0uQeaergzJJW/DUum3Z3AI7V+0ASczTU3WLSW5VI6Z3GUcNbN7BiJlrEPJnG/Uc37VdYNB/dLRqJs9k1GB0OUVRObLQxr0XzkTP9m9D1zAk8j0mxLF0hO3ROqi7xkQYwXgD1CJ8P93i8CF0WPbk+0Nt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178720; c=relaxed/simple;
	bh=+WkQzi/TLkevnoCtmRmUUS9PTCdT4slMC21qc+0n3NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tymg5uDn5gWkRx6Xkz+lbSiFlckAeSa59sBdiClZH0y1YrdKiMpb5pZdG6l+nEizt3Z/Gc5A5+QyxM+CqmF934puuUol7jKB67I2relkzc2kCDVXVX7O4IEhRyQZMRD8hvPmcVuJFUem2A7rHzC/zEShaXKX3HdYWukjL6ELZ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmG4oBqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmG4oBqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C465C4CED2;
	Mon,  6 Jan 2025 15:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178720;
	bh=+WkQzi/TLkevnoCtmRmUUS9PTCdT4slMC21qc+0n3NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmG4oBqPBqIEF31HIUOtqLdVYQvC8ZwWEU+g6JOAnFOc7bVnDvH4QgvAJpgEEfBz6
	 zI1a6SwtP9SvWINf9qc/+yEuU0XEpbme6iKZ2LAbQbKGibZT9rK1Z+G/QnsEMlhZk0
	 t9FN+sqR2Xs8kCfKVOe0suHcACUMJUJOM3GgW10I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/168] hwmon: (tmp513) Fix Current Register value interpretation
Date: Mon,  6 Jan 2025 16:15:46 +0100
Message-ID: <20250106151139.901766216@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit da1d0e6ba211baf6747db74c07700caddfd8a179 ]

The value returned by the driver after processing the contents of the
Current Register does not correspond to the TMP512/TMP513 specifications.
A raw register value is converted to a signed integer value by a sign
extension in accordance with the algorithm provided in the specification,
but due to the off-by-one error in the sign bit index, the result is
incorrect. Moreover, negative values will be reported as large positive
due to missing sign extension from u32 to long.

According to the TMP512 and TMP513 datasheets, the Current Register (07h)
is a 16-bit two's complement integer value. E.g., if regval = 1000 0011
0000 0000, then the value must be (-32000 * lsb), but the driver will
return (33536 * lsb).

Fix off-by-one bug, and also cast data->curr_lsb_ua (which is of type u32)
to long to prevent incorrect cast for negative values.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Link: https://lore.kernel.org/r/20241216173648.526-3-m.masimov@maxima.ru
[groeck: Fixed description line length]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 23f7fb7fab8c..4ab06852efd9 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -218,7 +218,7 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 		break;
 	case TMP51X_BUS_CURRENT_RESULT:
 		// Current = (ShuntVoltage * CalibrationRegister) / 4096
-		*val = sign_extend32(regval, 16) * data->curr_lsb_ua;
+		*val = sign_extend32(regval, 15) * (long)data->curr_lsb_ua;
 		*val = DIV_ROUND_CLOSEST(*val, MILLI);
 		break;
 	case TMP51X_LOCAL_TEMP_RESULT:
-- 
2.39.5



