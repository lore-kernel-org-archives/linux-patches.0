Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C583168EE;
	Mon, 13 Apr 2026 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099039; cv=none; b=mLGK9SH0Sfzqxeym93AeSjxrC+uFM0iJXiUOeP699ubHpcDCe+fVZZIax2cV4/q95+iMA5T0oSyemRuG4zU956xgixADLs3NjN6xyNItvR4wQYRQHIM26+IJ0FleVrDJU49EI+5EdPOpFRSe7YKHHAE8j6gvNZHDm8iTiSs2Tqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099039; c=relaxed/simple;
	bh=n6BAesx4Wr4h9SJx9CW3TWTbAv6O1eUPyAVLoTGqS18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcYcNu43Wc6LxA1VFHgkoJcNIvK+0+dqva0314gy7uJpQQHAzR+hwPBVwLfGxAnF0g8ItIDfszgahTRW8qG0jgIPw+18SaJJFF5SmMri1OP8Er7T6clee/h/xGkKpCeKslI7ienPci5r8H0qtZ0he6B4SlWtWHltZdpQbn0jshE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mawFyBDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mawFyBDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD69C2BCAF;
	Mon, 13 Apr 2026 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099039;
	bh=n6BAesx4Wr4h9SJx9CW3TWTbAv6O1eUPyAVLoTGqS18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mawFyBDL389xtZaXevTWaidHk73EXOBt6XUp+zay1/43ewAcBTcXX6S3/NNOIb4ig
	 YYLk+gw22cZbF0eazjuOeYOYoRE/dJuhPK8vGun5dT2o8HNTy6F+X3I7/jHzyV8lYo
	 hngZeR1f89shUqB9C4ny4L9vOrtJxBa8UG3QfxZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/491] pmdomain: bcm: bcm2835-power: Increase ASB control timeout
Date: Mon, 13 Apr 2026 17:57:12 +0200
Message-ID: <20260413155826.067143052@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit b826d2c0b0ecb844c84431ba6b502e744f5d919a ]

The bcm2835_asb_control() function uses a tight polling loop to wait
for the ASB bridge to acknowledge a request. During intensive workloads,
this handshake intermittently fails for V3D's master ASB on BCM2711,
resulting in "Failed to disable ASB master for v3d" errors during
runtime PM suspend. As a consequence, the failed power-off leaves V3D in
a broken state, leading to bus faults or system hangs on later accesses.

As the timeout is insufficient in some scenarios, increase the polling
timeout from 1us to 5us, which is still negligible in the context of a
power domain transition. Also, replace the open-coded ktime_get_ns()/
cpu_relax() polling loop with readl_poll_timeout_atomic().

Cc: stable@vger.kernel.org
Fixes: 670c672608a1 ("soc: bcm: bcm2835-pm: Add support for power domains under a new binding.")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ adapted unified bcm2835_asb_control() function changes to separate bcm2835_asb_enable() and bcm2835_asb_disable() functions ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/bcm/bcm2835-power.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/drivers/soc/bcm/bcm2835-power.c
+++ b/drivers/soc/bcm/bcm2835-power.c
@@ -9,6 +9,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/mfd/bcm2835-pm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -150,40 +151,34 @@ struct bcm2835_power {
 
 static int bcm2835_asb_enable(struct bcm2835_power *power, u32 reg)
 {
-	u64 start;
+	u32 val;
 
 	if (!reg)
 		return 0;
 
-	start = ktime_get_ns();
-
 	/* Enable the module's async AXI bridges. */
 	ASB_WRITE(reg, ASB_READ(reg) & ~ASB_REQ_STOP);
-	while (ASB_READ(reg) & ASB_ACK) {
-		cpu_relax();
-		if (ktime_get_ns() - start >= 1000)
-			return -ETIMEDOUT;
-	}
+
+	if (readl_poll_timeout_atomic(power->asb + reg, val,
+				      !(val & ASB_ACK), 0, 5))
+		return -ETIMEDOUT;
 
 	return 0;
 }
 
 static int bcm2835_asb_disable(struct bcm2835_power *power, u32 reg)
 {
-	u64 start;
+	u32 val;
 
 	if (!reg)
 		return 0;
 
-	start = ktime_get_ns();
-
 	/* Enable the module's async AXI bridges. */
 	ASB_WRITE(reg, ASB_READ(reg) | ASB_REQ_STOP);
-	while (!(ASB_READ(reg) & ASB_ACK)) {
-		cpu_relax();
-		if (ktime_get_ns() - start >= 1000)
-			return -ETIMEDOUT;
-	}
+
+	if (readl_poll_timeout_atomic(power->asb + reg, val,
+				      !!(val & ASB_ACK), 0, 5))
+		return -ETIMEDOUT;
 
 	return 0;
 }


