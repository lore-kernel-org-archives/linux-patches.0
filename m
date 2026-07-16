Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDB83D9DB3;
	Thu, 16 Jul 2026 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210210; cv=none; b=FYTMMVl7VAwTu3qpaItOxTgn4ZxAB0k7YsOaBAdRGseHrp3uVqRVJggGsovVJsR5kpyd7aWzP+1YzmeKwixc1zoVXRM+PbCsn4giQ/FVc52cR045enbF4INSzELuTjhT58ZKJ3prz29RHdns518IyxuT3tBijlY8xtSkkvojc34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210210; c=relaxed/simple;
	bh=YOQgrSD8gDio/8NHbcL/DXoyY278c5CyK6xy6GY69/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJ2Z7UhsisQO7eH2EosisWINSh7dpIVzNgcnwLPQn50gibBamij/AByZArkuFMxxRPwAeWfZmT9moLqp/0JX8QTbbNPDusFf6pnjPK2UOuKK+mn5mEcG4EJrcewNMuGRTJ8MGkyB7ObrLlSGJv/rL1UncDVljxuQY36C9JBT3qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAxbWnEF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAxbWnEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E301F000E9;
	Thu, 16 Jul 2026 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210208;
	bh=OKVBfXy4dBWNhDRDLb5QdnEuC0T1ikm6OgN1vGmK76c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAxbWnEF6xwo2BT2eQjvJXg6MI32M/BJ6aosetDY/w+eYDz41Nj9/FS/9YPeKV9vU
	 SgX6bvjIw+1Ga6HxRG+1goYXh2rEBdlHE1YlPu3G9afc8ekrP8KXNXztWDANKzzjbw
	 YE351yJrdXm/fCbIG6/P2NJdcIwMrRegG5O1bl70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 478/518] i2c: imx-lpi2c: mark I2C adapter when hardware is powered down
Date: Thu, 16 Jul 2026 15:32:26 +0200
Message-ID: <20260716133058.305303784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

commit 218cfe364b55b2768221629bd4a69ad190b7fbbc upstream.

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

Fixes: 1ee867e465c1 ("i2c: imx-lpi2c: add target mode support")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Cc: <stable@vger.kernel.org> # v6.14+
Acked-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260525031450.3183421-1-carlos.song@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -1646,7 +1646,18 @@ static int __maybe_unused lpi2c_runtime_
 
 static int __maybe_unused lpi2c_suspend_noirq(struct device *dev)
 {
-	return pm_runtime_force_suspend(dev);
+	struct lpi2c_imx_struct *lpi2c_imx = dev_get_drvdata(dev);
+	int ret;
+
+	i2c_mark_adapter_suspended(&lpi2c_imx->adapter);
+
+	ret = pm_runtime_force_suspend(dev);
+	if (ret) {
+		i2c_mark_adapter_resumed(&lpi2c_imx->adapter);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int __maybe_unused lpi2c_resume_noirq(struct device *dev)
@@ -1666,6 +1677,8 @@ static int __maybe_unused lpi2c_resume_n
 	if (lpi2c_imx->target)
 		lpi2c_imx_target_init(lpi2c_imx);
 
+	i2c_mark_adapter_resumed(&lpi2c_imx->adapter);
+
 	return 0;
 }
 


