Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFABD1849D3;
	Wed,  3 Jul 2024 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005060; cv=none; b=NRnCLd2ort9uopi57dh2P28jA2Ihdc26PvChE6QcFeOeRLzXYfiHgwAvpvR7vva5D7tjlVtsK8b//fC1eJnUJMgsLOyIeetf19rJAqJsEevK2xYUlK82xDdk9ioASE/4DWmXVS1WvjPNU9GdKjrKH2+vbAEf/dlCt0Ha3u3okcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005060; c=relaxed/simple;
	bh=EKlSH+r1eYzzKCS3oCi/dVaHJ/m95aqS5QEwexxVvOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOhqzilESyCt91hhcLxNk/fXYJkkaXjppVoQhhp7agJd1Nwat8jCooVLNIJwZ/uQa9PgdFFq+HDgv3eo0ZgJrqEENPolzJtHfYpvSoFKqkbBI+w2c2HHEeOSYgflFJQdvP7jsT/wrVQnnowBfn+METYv9SRXgzqZgAdMNaVwHNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fR82XTki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fR82XTki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4479FC2BD10;
	Wed,  3 Jul 2024 11:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005060;
	bh=EKlSH+r1eYzzKCS3oCi/dVaHJ/m95aqS5QEwexxVvOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fR82XTkieZkJcOLloJgOD2aH3EY72ip/mDl7BeQ00Ji+j0aGMobue3qrWNSG7c/jU
	 L8W6Z2Gg88io0UyKi2r3Ee8lr0j/7ymtXeoeq5wPMWV+oF+ZhVlZLfD4ebhZYr1Xu8
	 fs4jymEyDUDLC8npwKdA8pMcLtPcT3NSupyi1Rs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	David Lechner <dlechner@baylibre.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/290] counter: ti-eqep: enable clock at probe
Date: Wed,  3 Jul 2024 12:40:28 +0200
Message-ID: <20240703102913.481513901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 0cf81c73e4c6a4861128a8f27861176ec312af4e ]

The TI eQEP clock is both a functional and interface clock. Since it is
required for the device to function, we should be enabling it at probe.

Up to now, we've just been lucky that the clock was enabled by something
else on the system already.

Fixes: f213729f6796 ("counter: new TI eQEP driver")
Reviewed-by: Judith Mendez <jm@ti.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240621-ti-eqep-enable-clock-v2-1-edd3421b54d4@baylibre.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/ti-eqep.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/counter/ti-eqep.c b/drivers/counter/ti-eqep.c
index 65df9ef5b5bc0..6343998819296 100644
--- a/drivers/counter/ti-eqep.c
+++ b/drivers/counter/ti-eqep.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/clk.h>
 #include <linux/counter.h>
 #include <linux/kernel.h>
 #include <linux/mod_devicetable.h>
@@ -349,6 +350,7 @@ static int ti_eqep_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ti_eqep_cnt *priv;
 	void __iomem *base;
+	struct clk *clk;
 	int err;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -388,6 +390,10 @@ static int ti_eqep_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
+	clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "failed to enable clock\n");
+
 	err = counter_register(&priv->counter);
 	if (err < 0) {
 		pm_runtime_put_sync(dev);
-- 
2.43.0



