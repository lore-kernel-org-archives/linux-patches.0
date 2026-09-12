Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C12344DB5;
	Sat, 12 Sep 2026 08:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202978; cv=none; b=IL5ZbA+rLX9Iz3rE0/ujtqPl4x1JxWjPQQRFjh8QzVhGQVye7EM6xB2LVlhD0TuQgf5OaJbO3NFV2Bvt6WX88Tlzyh7tvxz0vHwvxtc0IZs30pLSHrs4XCJeqzEQ+j3nxJdCiWGpPkSQlE7bE4PRDgtkXatD+Ktb/MfJybGndbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202978; c=relaxed/simple;
	bh=I070RhAngmxvNu64gUpaofGmsF4kQ36X34E5IF68uNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJL0S9QNZeiUHN9uy7oXLIa5ub1buXZTBrAkk3tOINSsW07KfkTdW7uzALzAXcikXOjJqUs8ts/2LTgiZU/YxoHfWS9eszkl8gEtdlbbZTZOMWZdpeWDRLHfL7T2P2ELqoJKjlmVxLHmnk7DmflAouRceOBRuLW8eq3wqtWez20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRUWTALM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRUWTALM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DCA1F000FF;
	Sat, 12 Sep 2026 08:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202977;
	bh=u8qrdODkwKVUx4ZTvzW918vXbc4JOX1z9iYPg0Rifdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRUWTALM9YjFAxbcst7QNJxFm0ziL0pqqJFEwgiNdqGkbclFVbLDerdeef2qkRNRb
	 zRl9H53FaR6jk6OPx58q1/elUK4ibQGuRD7ny7+yZCLfZ3Jggd2OpmYYzOaUD6o4e9
	 lbTgIZh8lqHJj4o/HtmZwFtozeD1i+TgeRwaq/os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1313/1815] hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks
Date: Sat, 12 Sep 2026 08:51:03 +0200
Message-ID: <20260912065719.843596825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 26db273640887276a24ca2546b06e334508871f8 ]

To guarantee consistency for the read-modify-write access in
cros_ec_hwmon_cooling_set_cur_state(), locking is necessary.

Use the existing hwmon device lock to do so.

Fixes: 5798b62867b4 ("hwmon: (cros_ec) register fans into thermal framework cooling devices")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20260711-cros_ec-hwmon-locking-v1-3-cb6d0fdbb2d3@weissschuh.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/cros_ec_hwmon.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/cros_ec_hwmon.c b/drivers/hwmon/cros_ec_hwmon.c
index 12d0f1bb2a0d3..b65518fa7c9cc 100644
--- a/drivers/hwmon/cros_ec_hwmon.c
+++ b/drivers/hwmon/cros_ec_hwmon.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 2024 Thomas Weißschuh <linux@weissschuh.net>
  */
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/hwmon.h>
 #include <linux/math.h>
@@ -402,6 +403,8 @@ static int cros_ec_hwmon_cooling_get_cur_state(struct thermal_cooling_device *cd
 	u8 read_val;
 	int ret;
 
+	guard(hwmon_lock)(priv->hwmon_priv->hwmon_dev);
+
 	ret = cros_ec_hwmon_read_pwm_value(priv->hwmon_priv->cros_ec, priv->index, &read_val);
 	if (ret)
 		return ret;
@@ -415,6 +418,8 @@ static int cros_ec_hwmon_cooling_set_cur_state(struct thermal_cooling_device *cd
 {
 	const struct cros_ec_hwmon_cooling_priv *priv = cdev->devdata;
 
+	guard(hwmon_lock)(priv->hwmon_priv->hwmon_dev);
+
 	return cros_ec_hwmon_write_pwm_input(priv->hwmon_priv->cros_ec, priv->index, val);
 }
 
-- 
2.53.0



