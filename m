Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089753C4166;
	Fri, 15 May 2026 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861193; cv=none; b=L7gkgs8vP/r3LKMGyhD0t804m4NwJ2gcr8M+yk8qd8z8wYuXwUQIU2M1YybeywoPlPpsqAtV3B8ltLeLjofokafOY0g/L/YHEzEf8ee2jUpFBeJboTpAI9RkNJtYY+jRhIoZeXKUaqQUIW/CGacfkfXA0OawQSqk5AEbaKqlY/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861193; c=relaxed/simple;
	bh=3v0SoDQZmy/6LmtDlBSI2k+KGAwOpq1L2lBPvE+KUco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZBMH40ox2U8BpLLSYy+YZY9UrIRirnkEMEks5/IKL67CixKsbG3+n21hnd6zJEJp+GYTg/MZQq+BOIC1jP8yPC+5ygk+/ZvIEO3BJxflU4ZhKwYf4D/Y5vNitMrurp32O5SaMusyW936QhrQiXtVA7j0hXkChCuDdgNfQgDY3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npN4dilD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npN4dilD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939FBC2BCB0;
	Fri, 15 May 2026 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861192;
	bh=3v0SoDQZmy/6LmtDlBSI2k+KGAwOpq1L2lBPvE+KUco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npN4dilDKyi4XLwDW1T1uDJI7MxepW0oAbDPyz7+iqcT/VvsSly/NDPz0QaMv65EJ
	 C2ANVThWBl3Bl9tVpfNciIh45aCFDqaDpYCagZha+tq5yka7QbIqCghdQnKxCL7Nva
	 FVwNgYO9aiJhvA4JyqPZV6ISqnn2sxDaUSOk50Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.6 233/474] extcon: ptn5150: handle pending IRQ events during system resume
Date: Fri, 15 May 2026 17:45:42 +0200
Message-ID: <20260515154720.046180511@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 	.probe		= ptn5150_i2c_probe,


