Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3909330E853;
	Sat, 30 May 2026 17:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160422; cv=none; b=avYHIkp4kFZDkMbHv+O1cLvXNr4OSXA0v2YKsJBNjC8thQ3ecw3CKIA+17sYV5SK8zAn9wfez4LLnRlwyXJWlqpq7w25FFQ6/+mYFFoYzlludsPvMlRG+dAJCDbj4vMfWeFxDuvRBt48tcLbtY6HALqNaqEOAS1OQak3NQmKY1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160422; c=relaxed/simple;
	bh=N43d8DGrPX0fwdjgocG35L7dBAzJKk/Xsi0wc+S8x9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxZxgH0JJUQpyi7gupdcYE1YqcnahgEm3VPJoEEp46J8jWDO/WMabJolKvei8z7JtRFYghn0V6v2PJa4eZDYj8CbX9HBZZkO8uyJgaR+tEMkAyGVbW9BoAm9lwjo6LAI1oMU6fwOK1NN+NBZ5BGIPe+sOFUNH2CPl14cmNmLpP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gBdAktM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gBdAktM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DBB1F00893;
	Sat, 30 May 2026 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160421;
	bh=hfev8xv0+1rFF1XHOLCwQ2gYgr1Btv2VMd0EjuoG1B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gBdAktMWikzZ6VDDPNGdbSEhlho0Sz5z2Vp46cFodWvcx2Vf71Ee3s1lJluawq7B
	 bGO94G8WFD85Cj0PDr/+32eSQ4HFvXDyIWvu3lgqU50ODuSaIQIKGWdVVDcWZEJMHK
	 7ERokPpVGmGkBo3WNw5OFZvpe0BqSRMEY9Ehy5bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.1 333/969] extcon: ptn5150: handle pending IRQ events during system resume
Date: Sat, 30 May 2026 17:57:37 +0200
Message-ID: <20260530160309.571170188@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 4652fefcda3c604c83d1ae28ede94544e2142f06 upstream.

When the system is suspended and ptn5150 wakeup interrupt is disabled,
any changes on ptn5150 will only be record in interrupt status
registers and won't fire an IRQ since its trigger type is falling
edge. So the HW interrupt line will keep at low state and any further
changes won't trigger IRQ anymore. To fix it, this will schedule a
work to check whether any IRQ are pending and handle it accordingly.

Fixes: 4ed754de2d66 ("extcon: Add support for ptn5150 extcon driver")
Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://lore.kernel.org/lkml/20251115025905.1395347-1-xu.yang_2@nxp.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-ptn5150.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/extcon/extcon-ptn5150.c
+++ b/drivers/extcon/extcon-ptn5150.c
@@ -331,6 +331,19 @@ static int ptn5150_i2c_probe(struct i2c_
 	return 0;
 }
 
+static int ptn5150_resume(struct device *dev)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+	struct ptn5150_info *info = i2c_get_clientdata(i2c);
+
+	/* Need to check possible pending interrupt events */
+	schedule_work(&info->irq_work);
+
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(ptn5150_pm_ops, NULL, ptn5150_resume);
+
 static const struct of_device_id ptn5150_dt_match[] = {
 	{ .compatible = "nxp,ptn5150" },
 	{ },
@@ -346,6 +359,7 @@ MODULE_DEVICE_TABLE(i2c, ptn5150_i2c_id)
 static struct i2c_driver ptn5150_i2c_driver = {
 	.driver		= {
 		.name	= "ptn5150",
+		.pm = pm_sleep_ptr(&ptn5150_pm_ops),
 		.of_match_table = ptn5150_dt_match,
 	},
 	.probe_new	= ptn5150_i2c_probe,


