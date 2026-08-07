Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6716E474274;
	Fri,  7 Aug 2026 15:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117684; cv=none; b=dJGiqXky2+iH6SF2M7lKiljJJtjrpWMAtDlSRaLp+drD/Sr4flIaDVJJeaqW2aHsjSFUB0jKNve6F3vi7FlOI/ibno0JKdkcN0+TxxI/G+WhLn7B1kTsYhi0yuMG5uaA/Gxob9RfNdRgNq+9Xv+2Tn1FOFKFxAzFYs/wa9HIY2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117684; c=relaxed/simple;
	bh=tkYcu8/1KF2U2mdfk/2eChwcOLMwWs2YuNDJ63DfoE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ3ppTVlIyzPSpv6b8RhFOWzaNgu4F4d5G58sGjlB4LZB+I3pJq9HMhrrwMh0jkks/KUOvF1o7/JVZbO50H36GdlAM4dAS63lyrmDLIb64J/23tpQfUSbS2mMLAlOdX/NnP1btW8R+gUSQO431heovDJ9Fq7eFCHJbRFirQMaNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTLQDc5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTLQDc5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAEB1F000E9;
	Fri,  7 Aug 2026 15:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117683;
	bh=7HaA85Yyrv1aGS8kBZS1aenvJzWPeQoMbSX2OurrnMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTLQDc5i3exXT3Ofc+t11uKQ3nlDqgEdz/vKcjx4Qp1hDR1mhZRyF9xzI+jehs4fz
	 +NX31lp7LZtApArLcmAbSJeGwKi86IbVOEfePapOYWibePFhdTmbkmBbnqwo2OSl8m
	 ZQhlM6LlzzwJ8qOKd/D+Hidm0gxxB0zzBDAsYpKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 360/438] i2c: imx: mark I2C adapter when hardware is powered down
Date: Fri,  7 Aug 2026 16:39:16 +0200
Message-ID: <20260807143435.649048691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


