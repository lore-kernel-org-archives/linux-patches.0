Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8297225417;
	Mon, 23 Jun 2025 22:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716152; cv=none; b=geBu7XmE44ZuX73pIJ3m5aBU39KNUB+5mQ3iuoQjdm/65OlxljEWS8X6ohhGyPftHDRNZO8b8r425mYLPHoloCffLrDbFDZmqvaMAM4MFBP5jPOs1d19KFjYpqQTqEL3VKRRwQNdxIiLfF7CccDuOvMvHDyh8T4zobgvs58uyYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716152; c=relaxed/simple;
	bh=ixgFxqJ5CXuXhecmxHZPr0RhNG2T+cf269rIz6BBwZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfqnwGCcZPnx7x6sSAjla/evkd1daCgoEFrHi6HwwPUCPDoULLcjBEwPAhp1r5razffa5uF/1ancfeE9QxrLDykqeRla+zpymngv8A9y38H0vnf388d67UjJXXqka9DRbpzIL8CTPW41QzmnOkotj4q4QbqKjqEFvAQsTAahYCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpHctpU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpHctpU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDF2C4CEED;
	Mon, 23 Jun 2025 22:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716151;
	bh=ixgFxqJ5CXuXhecmxHZPr0RhNG2T+cf269rIz6BBwZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpHctpU0uo4vF9sMleRZzHYnSJfTnLlp5jK8grpPd99FMljQLEramZL1i2g6ZzvCy
	 zyX97cQSLDbxBBcCkVbgdJzigMLidTkXgUy0HYQIwsa6dtLdSLB+iC2Kc/XPytqw72
	 q1C01UcHV3XSvCn5x4ECvlX6yzhhz323rIg9/5YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/290] hwmon: (occ) fix unaligned accesses
Date: Mon, 23 Jun 2025 15:08:31 +0200
Message-ID: <20250623130634.445788838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2c021b45c154958566aad0cae9f74ab26a2d5732 ]

Passing a pointer to an unaligned integer as a function argument is
undefined behavior:

drivers/hwmon/occ/common.c:492:27: warning: taking address of packed member 'accumulator' of class or structure 'power_sensor_2' may result in an unaligned pointer value [-Waddress-of-packed-member]
  492 |   val = occ_get_powr_avg(&power->accumulator,
      |                           ^~~~~~~~~~~~~~~~~~
drivers/hwmon/occ/common.c:493:13: warning: taking address of packed member 'update_tag' of class or structure 'power_sensor_2' may result in an unaligned pointer value [-Waddress-of-packed-member]
  493 |            &power->update_tag);
      |             ^~~~~~~~~~~~~~~~~

Move the get_unaligned() calls out of the function and pass these
through argument registers instead.

Fixes: c10e753d43eb ("hwmon (occ): Add sensor types and versions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20250610092553.2641094-1-arnd@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index 256cda99fdc95..483f79b394298 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -459,12 +459,10 @@ static ssize_t occ_show_power_1(struct device *dev,
 	return sysfs_emit(buf, "%llu\n", val);
 }
 
-static u64 occ_get_powr_avg(u64 *accum, u32 *samples)
+static u64 occ_get_powr_avg(u64 accum, u32 samples)
 {
-	u64 divisor = get_unaligned_be32(samples);
-
-	return (divisor == 0) ? 0 :
-		div64_u64(get_unaligned_be64(accum) * 1000000ULL, divisor);
+	return (samples == 0) ? 0 :
+		mul_u64_u32_div(accum, 1000000UL, samples);
 }
 
 static ssize_t occ_show_power_2(struct device *dev,
@@ -489,8 +487,8 @@ static ssize_t occ_show_power_2(struct device *dev,
 				  get_unaligned_be32(&power->sensor_id),
 				  power->function_id, power->apss_channel);
 	case 1:
-		val = occ_get_powr_avg(&power->accumulator,
-				       &power->update_tag);
+		val = occ_get_powr_avg(get_unaligned_be64(&power->accumulator),
+				       get_unaligned_be32(&power->update_tag));
 		break;
 	case 2:
 		val = (u64)get_unaligned_be32(&power->update_tag) *
@@ -527,8 +525,8 @@ static ssize_t occ_show_power_a0(struct device *dev,
 		return sysfs_emit(buf, "%u_system\n",
 				  get_unaligned_be32(&power->sensor_id));
 	case 1:
-		val = occ_get_powr_avg(&power->system.accumulator,
-				       &power->system.update_tag);
+		val = occ_get_powr_avg(get_unaligned_be64(&power->system.accumulator),
+				       get_unaligned_be32(&power->system.update_tag));
 		break;
 	case 2:
 		val = (u64)get_unaligned_be32(&power->system.update_tag) *
@@ -541,8 +539,8 @@ static ssize_t occ_show_power_a0(struct device *dev,
 		return sysfs_emit(buf, "%u_proc\n",
 				  get_unaligned_be32(&power->sensor_id));
 	case 5:
-		val = occ_get_powr_avg(&power->proc.accumulator,
-				       &power->proc.update_tag);
+		val = occ_get_powr_avg(get_unaligned_be64(&power->proc.accumulator),
+				       get_unaligned_be32(&power->proc.update_tag));
 		break;
 	case 6:
 		val = (u64)get_unaligned_be32(&power->proc.update_tag) *
@@ -555,8 +553,8 @@ static ssize_t occ_show_power_a0(struct device *dev,
 		return sysfs_emit(buf, "%u_vdd\n",
 				  get_unaligned_be32(&power->sensor_id));
 	case 9:
-		val = occ_get_powr_avg(&power->vdd.accumulator,
-				       &power->vdd.update_tag);
+		val = occ_get_powr_avg(get_unaligned_be64(&power->vdd.accumulator),
+				       get_unaligned_be32(&power->vdd.update_tag));
 		break;
 	case 10:
 		val = (u64)get_unaligned_be32(&power->vdd.update_tag) *
@@ -569,8 +567,8 @@ static ssize_t occ_show_power_a0(struct device *dev,
 		return sysfs_emit(buf, "%u_vdn\n",
 				  get_unaligned_be32(&power->sensor_id));
 	case 13:
-		val = occ_get_powr_avg(&power->vdn.accumulator,
-				       &power->vdn.update_tag);
+		val = occ_get_powr_avg(get_unaligned_be64(&power->vdn.accumulator),
+				       get_unaligned_be32(&power->vdn.update_tag));
 		break;
 	case 14:
 		val = (u64)get_unaligned_be32(&power->vdn.update_tag) *
-- 
2.39.5



