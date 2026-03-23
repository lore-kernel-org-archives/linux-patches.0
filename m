Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833CD3B5847;
	Mon, 23 Mar 2026 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278964; cv=none; b=RcWmAPkJHCWi+YL/u05wv0r7LshnxxfkzWwK/l94ej2hmw3DEpwpXBWI8ZXiiEQW42xwwwxo9HBCdMol0T3G8ZU50bKZzkQ62ChBk/nEosaMWlwaLCdyRZMd08q/3u8S7wH06DIBiLdlDU4l4I8Se6be5ZbVen9OYCtr1EAPdSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278964; c=relaxed/simple;
	bh=WvEAk4iMXnuBCvZFESXh2uA8SgvGGmmRZ7HvG3MIe2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1mOTR9gt4Qoq+hz4sSJicKNV7xs3NO9aQ8H8F+imzNGGTAA3CgCUuTqx3ZCe2ai9DI5LM4zLWjolvBWG1hQ+65ooZeC6ioyASqeetbzORJa8YOA5aPNNdFCbdfD+JKgNzhI38GjV0jCkU64klF+vklx105FYDfOqEw0oo2dAtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLRSw3R0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLRSw3R0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066ABC2BC9E;
	Mon, 23 Mar 2026 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278964;
	bh=WvEAk4iMXnuBCvZFESXh2uA8SgvGGmmRZ7HvG3MIe2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLRSw3R0Btwo1Fmgo+yBd2FrKXe1UnYnDn51rHcpti0r7xxRz3B/y1vFCWIpONT1+
	 zTV1ezhviiFN8Cgbk8QRHbXLl+KaHAl45wHjz9p6pzFwd0D6YhIGf+v2Upj8wkUI4R
	 pgp29H4Gx0qRo3kYBlYPNsx+n+Bqiu5SXJRse/U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 476/567] pmdomain: bcm: bcm2835-power: Increase ASB control timeout
Date: Mon, 23 Mar 2026 14:46:36 +0100
Message-ID: <20260323134545.760172299@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit b826d2c0b0ecb844c84431ba6b502e744f5d919a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/bcm/bcm2835-power.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/pmdomain/bcm/bcm2835-power.c
+++ b/drivers/pmdomain/bcm/bcm2835-power.c
@@ -9,6 +9,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/mfd/bcm2835-pm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -152,7 +153,6 @@ struct bcm2835_power {
 static int bcm2835_asb_control(struct bcm2835_power *power, u32 reg, bool enable)
 {
 	void __iomem *base = power->asb;
-	u64 start;
 	u32 val;
 
 	switch (reg) {
@@ -165,8 +165,6 @@ static int bcm2835_asb_control(struct bc
 		break;
 	}
 
-	start = ktime_get_ns();
-
 	/* Enable the module's async AXI bridges. */
 	if (enable) {
 		val = readl(base + reg) & ~ASB_REQ_STOP;
@@ -175,11 +173,9 @@ static int bcm2835_asb_control(struct bc
 	}
 	writel(PM_PASSWORD | val, base + reg);
 
-	while (!!(readl(base + reg) & ASB_ACK) == enable) {
-		cpu_relax();
-		if (ktime_get_ns() - start >= 1000)
-			return -ETIMEDOUT;
-	}
+	if (readl_poll_timeout_atomic(base + reg, val,
+				      !!(val & ASB_ACK) != enable, 0, 5))
+		return -ETIMEDOUT;
 
 	return 0;
 }


