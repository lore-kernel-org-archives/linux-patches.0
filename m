Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A30B4ABBAF;
	Thu, 17 Sep 2026 17:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664679; cv=none; b=Fc75iW8FberM7d1nn6PzKwj5/Z/H/r5v6xLBZn+znCyr3LWPPdpCPZ1wAxxu2JQA6dU1qtFcbOzkU4gxPGvUa4lLOzwODnNe06VTcHxNdEo3FscIk/IkW7yWnzbEk7NR1AwLDvXgj8W0o0ihURN84GNH5ocp2mhJoVJas6Jbo64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664679; c=relaxed/simple;
	bh=vIHKHQTVtQ0s9J98+PcWzIRqMbVGphevareaFTbux3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck3bGuL4TctGAmw3MzyUKII7+jsVqmmIJ0TfbDWwu87HX+rFMqka+/WOP9xJLIRHUqY5TsownkhPjI8DM/Ah1HRMIKHLKjhM66AOR/XG/yAli/meIWItHd9YpjZYgnA4ItDPipQdmnT1VFw1VtPi5h4/ndtbbpRDW/6m3s2NnPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvttTy+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvttTy+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BD21F00893;
	Thu, 17 Sep 2026 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664678;
	bh=iB8eKyrm1r3iGKXux6gzvHoqHcuaw8NKtxJTLNK27Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvttTy+c31sKZg02umfQA5ljWeBD7Q0enDsDAwq90MJVgSUDTQPq8E0Hm7774H1vm
	 +RbeXy0VFLGizTQWWTPBi/W/r0L3CJ1as0/ReQ7cbno+57Z/XN2u19x7LnQ5ic77Vy
	 gOoPn7BldxoydmNeTPxftDzN0JTXhLe6f4iq7Pbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xue Lei <Xue.Lei@windriver.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0452/1250] rtc: mv: add suspend/resume support for wakeup
Date: Thu, 17 Sep 2026 16:04:07 +0100
Message-ID: <20260917151604.244162871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Xue Lei <Xue.Lei@windriver.com>

[ Upstream commit 851d961ff248218f681c53cf0f7f08cf8201a117 ]

Add PM suspend/resume callbacks to enable/disable IRQ wake for the
RTC alarm interrupt. This allows the RTC alarm to wake the system
from STR (e.g. via rtcwake -m mem -s N).

Without this, the RTC IRQ is masked during suspend by the MPIC's
IRQCHIP_MASK_ON_SUSPEND behavior, preventing alarm-based wakeup.

Signed-off-by: Xue Lei <Xue.Lei@windriver.com>
Link: https://patch.msgid.link/20260611023350.1370881-1-Xue.Lei@windriver.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mv.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index c27ad626d09fc..f88976fd6d5da 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -301,6 +301,28 @@ static const struct of_device_id rtc_mv_of_match_table[] = {
 MODULE_DEVICE_TABLE(of, rtc_mv_of_match_table);
 #endif
 
+#ifdef CONFIG_PM_SLEEP
+static int mv_rtc_suspend(struct device *dev)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev) && pdata->irq >= 0)
+		enable_irq_wake(pdata->irq);
+	return 0;
+}
+
+static int mv_rtc_resume(struct device *dev)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev) && pdata->irq >= 0)
+		disable_irq_wake(pdata->irq);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(mv_rtc_pm_ops, mv_rtc_suspend, mv_rtc_resume);
+
 /*
  * mv_rtc_remove() lives in .exit.text. For drivers registered via
  * module_platform_driver_probe() this is ok because they cannot get unbound at
@@ -312,6 +334,7 @@ static struct platform_driver mv_rtc_driver __refdata = {
 	.driver		= {
 		.name	= "rtc-mv",
 		.of_match_table = of_match_ptr(rtc_mv_of_match_table),
+		.pm	= &mv_rtc_pm_ops,
 	},
 };
 
-- 
2.53.0



