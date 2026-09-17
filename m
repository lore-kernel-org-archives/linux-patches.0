Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1115547048;
	Thu, 17 Sep 2026 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668203; cv=none; b=a2uL/tFRb6J9MG4989AGnNcR/0kCKu7j5Ggz/q9lSZ5FVRQ2dHtuvE+AGNtyAHi+wk155odYZFKTMMPEL8slEhOpkEJwgLViPZ1JGBXRh/bzKYk4oEFWqGhMo2AJA8g/3gA/YszKCLRZMo8vxXcM07I5Vf8EfdDP4DcGfRpEPFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668203; c=relaxed/simple;
	bh=njQYNmsRPoXMjijB0AvZU027Wk7MznlrYjPk2ZFelik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6q1x5VwpFPfQk3VLNuchOk+fbF+DgFKGvjAAMM9FgVKTi+hxy9QJKzTHXK10Gpj5hlynOaYx9A5Tva05Y4IgbGqDR30mQXMcAFFVKtc8CbKlFET/btfYR2Qp3dARC22aTNfelpuai9NhUEcbPshDqqBURt4RRVzKQfDpX/pphg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpul8vj3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpul8vj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539FB1F000FF;
	Thu, 17 Sep 2026 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668201;
	bh=4z7gj1Ji4U0In27H0lLkpEq6w7thP4K6Ab/g8njsoJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hpul8vj3PkCudoTcQyb5SYcG92fxTyUSky7sMBhplHK5Tkhs6XRVjfl3ZQfUmlpuL
	 TVoKkuwpFdaane40STqQv+QkAMNXN2qS1Uc/tfIaX+p/p12vxKoCOpHJrfdfYP1noa
	 osh86ZQ+9cYzH1omAhlIINmPCKKT7Aj/GVWUHiWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xue Lei <Xue.Lei@windriver.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0347/1102] rtc: mv: add suspend/resume support for wakeup
Date: Thu, 17 Sep 2026 16:04:50 +0100
Message-ID: <20260917151548.351928053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index db31da56bfa74..55fa937f9f709 100644
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



