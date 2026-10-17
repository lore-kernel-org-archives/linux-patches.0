Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575D8324B32;
	Sat, 17 Oct 2026 17:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259617; cv=none; b=RKWbU8OVTcdYea7KFN97xTxdwhJ2sxS1YBgqqMT4ILLIno38uTP9cOmDxCzNx/CYEtE1GISr8aRDcgo4nC92lT8zHpIzWfGBbDQHmmTVuX+gESNKP0xhTWZ1iRM5jFq7XzKiiKGuxnGbOBUQNqQV+jozX8a5aNEBg/+vmebi128=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259617; c=relaxed/simple;
	bh=DQAmyXnSwajN7+D28Nav0x52p+8WvGnkWbmRFfDx2Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVx8/VNr4BsbMnB1D1CLnCcfApsBT57DzVbzaumLkAYFVal2v+xR/6p/qSlbBCtUtV/e6rDh0AeAMN+bsmOAc7Dsx8QNmHvJbZcEu/lCtTwxT7R7w5ZkahPkyekR7QsjDeZ69t4MbP5L+3P0BIJg8UAbnpggPra+tnQGV8RAsGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qG+8v1s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qG+8v1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F1E1F000C4;
	Sat, 17 Oct 2026 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259616;
	bh=H2ULVTZJRGrp2oMpnKj9YzT9731eFqs4Uo3D4ev2ht0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qG+8v1sjCD/ibgucMtTzHiYzdKgC3Yviy6X29lQtE3TX7Vo0alBuI292OjQ+cg7W
	 OOB752c/BNZZNEEW88gX4Zv35JPrSF3EhzINzaF7YzgnIDJP9l+q94VwIYm7WfHJQ9
	 x+xV15g7RxffvNuXCM1PFyIXxp/295WbiNrY5UaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1236/1674] hwmon: (sht3x) Fix unaligned accesses
Date: Sat, 17 Oct 2026 17:58:28 +0200
Message-ID: <20261017160502.864448704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d8a86e60cf8c1..0f757ef4bbe99 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
+#include <asm/unaligned.h>
 
 /* commands (high repeatability mode) */
 static const unsigned char sht3x_cmd_measure_single_hpm[] = { 0x24, 0x00 };
@@ -273,9 +274,9 @@ static struct sht3x_data *sht3x_update_client(struct device *dev)
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
@@ -333,7 +334,7 @@ static int limits_update(struct sht3x_data *data)
 		if (ret)
 			return ret;
 
-		raw = be16_to_cpup((__be16 *)buffer);
+		raw = get_unaligned_be16(buffer);
 		temperature = sht3x_extract_temperature((raw & 0x01ff) << 7);
 		humidity = sht3x_extract_humidity(raw & 0xfe00);
 		data->temperature_limits[index] = temperature;
@@ -386,7 +387,7 @@ static size_t limit_write(struct device *dev,
 	raw = ((u32)(temperature + 45000) * 24543) >> (16 + 7);
 	raw |= ((humidity * 42950) >> 16) & 0xfe00;
 
-	*((__be16 *)position) = cpu_to_be16(raw);
+	put_unaligned_be16(raw, position);
 	position += SHT3X_WORD_LEN;
 	*position = crc8(sht3x_crc8_table,
 			 position - SHT3X_WORD_LEN,
-- 
2.53.0



