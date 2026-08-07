Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F72038E8A9;
	Fri,  7 Aug 2026 15:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115482; cv=none; b=jcQcYtjoLLjN4aO8r1lYUk6PJNnc8idk/XFkkjMckcQzYQ1hMUPB7D3trFxn+Pyf2w0ZCv5USNFN0p1c7sGHp75o2i15tuGXIuDfD3aXUS9sK2ztQByvmGPRbITZ/36o7/jkp0oIThiRCi8BN/xOTZrh+mEPUNyM6ABvJpFSvx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115482; c=relaxed/simple;
	bh=0KUZg2gG9jW/U8E8YgCu07/FCO3c+8jMGjMtF5g5gq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZ6OtYxKJNvaeCxaT6Y8NqvH4DakcmwTci560RI4X7fuLee5a2qMI8EIvJ+LYgfxYdQ2g8rai63FAtnfULInMJfvcT34HCnvmj0wd5GyMlYGx/2FI3eyTfQXq+yRyNRCEN/rA9wy2pfwszG4oPHL0Ihbd+LtHUbkQ/78/ql/x/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApC9gmiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApC9gmiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0145C1F000E9;
	Fri,  7 Aug 2026 15:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115479;
	bh=tLWKXIxQ1b+rQDA2aVeCGdPRcLh1Ti3iyXcx+wtroCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApC9gmiW3BZqxY3fL4ypiX+Q+gs3/6h/M7QbZcjg1RJfEQDnLNykvt80pyngjYvbu
	 UpXQRbkaJeuPIUYQtHhpFe9kTcGNS6XQjsg6ZKvfcAIb0WxM9w1wAWrdY6bdP7G3DZ
	 V5lwo5+pQTDhH1lDre5EXScKb7o1eITWF6PIWyCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 292/396] i2c: imx: mark I2C adapter when hardware is powered down
Date: Fri,  7 Aug 2026 16:37:32 +0200
Message-ID: <20260807143430.568847709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

commit 00d86dd5c2034e0e139e4806137b3b43e07ddd83 upstream.

On some i.MX platforms, certain I2C client drivers keep a periodic
workqueue which continues to trigger I2C transfers.

During system suspend/resume, there exists a time window between:
  - suspend_noirq and the system entering suspend
  - the system starting to resume and resume_noirq

In this window, the I2C controller resources such as clock and pinctrl
may already be disabled or not yet restored.

If a workqueue triggers an I2C transfer in this period, the driver
attempts to access I2C registers while the hardware resources are
unavailable, which may lead to system hang.

Mark the I2C adapter as suspended during noirq suspend and block new
transfers until resume, ensuring that I2C transfers are only issued
when hardware resources are available.

Fixes: 358025ac091e ("i2c: imx: make controller available until system suspend_noirq() and from resume_noirq()")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Cc: <stable@vger.kernel.org> # v6.14+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260525030400.3182911-1-carlos.song@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |   45 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1952,6 +1952,47 @@ static int i2c_imx_runtime_resume(struct
 	return 0;
 }
 
+static int __maybe_unused i2c_imx_suspend_noirq(struct device *dev)
+{
+	struct imx_i2c_struct *i2c_imx = dev_get_drvdata(dev);
+	int ret;
+
+	i2c_mark_adapter_suspended(&i2c_imx->adapter);
+
+	/*
+	 * Cancel the slave timer before powering down to prevent
+	 * i2c_imx_slave_timeout() from accessing hardware registers
+	 * while the clock is disabled.
+	 */
+	hrtimer_cancel(&i2c_imx->slave_timer);
+
+	ret = pm_runtime_force_suspend(dev);
+	if (ret) {
+		i2c_mark_adapter_resumed(&i2c_imx->adapter);
+		if (i2c_imx->slave) {
+			hrtimer_forward_now(&i2c_imx->slave_timer, I2C_IMX_CHECK_DELAY);
+			hrtimer_restart(&i2c_imx->slave_timer);
+		}
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __maybe_unused i2c_imx_resume_noirq(struct device *dev)
+{
+	struct imx_i2c_struct *i2c_imx = dev_get_drvdata(dev);
+	int ret;
+
+	ret = pm_runtime_force_resume(dev);
+	if (ret)
+		return ret;
+
+	i2c_mark_adapter_resumed(&i2c_imx->adapter);
+
+	return 0;
+}
+
 static int i2c_imx_suspend(struct device *dev)
 {
 	/*
@@ -1985,8 +2026,8 @@ static int i2c_imx_resume(struct device
 }
 
 static const struct dev_pm_ops i2c_imx_pm_ops = {
-	NOIRQ_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				  pm_runtime_force_resume)
+	NOIRQ_SYSTEM_SLEEP_PM_OPS(i2c_imx_suspend_noirq,
+				  i2c_imx_resume_noirq)
 	SYSTEM_SLEEP_PM_OPS(i2c_imx_suspend, i2c_imx_resume)
 	RUNTIME_PM_OPS(i2c_imx_runtime_suspend, i2c_imx_runtime_resume, NULL)
 };


