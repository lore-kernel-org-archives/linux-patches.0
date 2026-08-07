Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE9C38947F;
	Fri,  7 Aug 2026 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113898; cv=none; b=PvugaHDJkI2U4hrqlIBDdV0lJ3+ZtwrTR5bT6kh7xTVjStjvVeKdvYR/gsG+uztU3K8BlFZ8DaLuSHTZD1oazM/NitmNPUbCKleTw5XWxgFXqrDsMQPNBL58EczNSTQu5gfowRVw4mPV8l1dGLpVdYtkN6gndTTvRENWuYG41NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113898; c=relaxed/simple;
	bh=LghAJt8bTtRxdO2kTTv3oJ8ev/mQtSGvPHZLvkiVulM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6ZKrR2cP4EFzXzsy+1d3FHSiLc+GUfSP0T51o2wDYpNtpAodpHEMwqqbhSVy2xp5g9Odf5+c7H06r74nEyOysdNkVEtQU9YoujVS95kQhtQiuXL+veoHHJ5hE/nrrPzf1HqL3xX8bYhGClof2J9apIYPs9uHYXME46ymlBkQu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mALZ75W9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mALZ75W9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27841F00A3E;
	Fri,  7 Aug 2026 14:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113891;
	bh=1SENbf2Fp9RL3cYe9pkjiSfqg+rJQi+oQzGcyJtLyG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mALZ75W9F/LreDYUmW24H073oV3XTL1Z/rU73wDAVA/9bOhLls4nuyvoMg7f44ui0
	 zbcGKAF0RLBzeogqJEXghJuTDEc/A+14+j/j7hwLmNmgtQV9lylWuWkrr71Ul6O6Ox
	 6GWKQY/1czU3KVyb6WBDXsPIqKyqD/O4j4gjbT6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/337] hwmon: (sht3x) Fix unaligned accesses
Date: Fri,  7 Aug 2026 16:34:32 +0200
Message-ID: <20260807143420.010165735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f46d5ab43a572b84773015a76966f5da56fc1748 ]

Sashiko reports:

In sht3x_update_client(), the 16-bit temperature and humidity values are
extracted from a stack-allocated byte array using be16_to_cpup(). The
pointers passed to this function are calculated as buf and buf + 3. Since
the difference between the two pointers is an odd number of bytes, at
least one of them is guaranteed to be at an unaligned offset.

This will trigger an alignment fault on strict-alignment architectures
such as ARMv5 or SPARC, resulting in a kernel panic.

Fix the problem by using get_unaligned_be16() instead of be16_to_cpup(),
and put_unaligned_be16() instead of cpu_to_be16().

Fixes: 7c84f7f80d6f ("hwmon: add support for Sensirion SHT3x sensors")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht3x.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/sht3x.c b/drivers/hwmon/sht3x.c
index 94466e28dc56f..1f63c07cfb085 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
+#include <linux/unaligned.h>
 
 /* commands (high repeatability mode) */
 static const unsigned char sht3x_cmd_measure_single_hpm[] = { 0x24, 0x00 };
@@ -279,9 +280,9 @@ static struct sht3x_data *sht3x_update_client(struct device *dev)
 		if (ret)
 			goto out;
 
-		val = be16_to_cpup((__be16 *)buf);
+		val = get_unaligned_be16(buf);
 		data->temperature = sht3x_extract_temperature(val);
-		val = be16_to_cpup((__be16 *)(buf + 3));
+		val = get_unaligned_be16(buf + 3);
 		data->humidity = sht3x_extract_humidity(val);
 		data->last_update = jiffies;
 	}
@@ -339,7 +340,7 @@ static int limits_update(struct sht3x_data *data)
 		if (ret)
 			return ret;
 
-		raw = be16_to_cpup((__be16 *)buffer);
+		raw = get_unaligned_be16(buffer);
 		temperature = sht3x_extract_temperature((raw & 0x01ff) << 7);
 		humidity = sht3x_extract_humidity(raw & 0xfe00);
 		data->temperature_limits[index] = temperature;
@@ -392,7 +393,7 @@ static size_t limit_write(struct device *dev,
 	raw = ((u32)(temperature + 45000) * 24543) >> (16 + 7);
 	raw |= ((humidity * 42950) >> 16) & 0xfe00;
 
-	*((__be16 *)position) = cpu_to_be16(raw);
+	put_unaligned_be16(raw, position);
 	position += SHT3X_WORD_LEN;
 	*position = crc8(sht3x_crc8_table,
 			 position - SHT3X_WORD_LEN,
-- 
2.53.0



