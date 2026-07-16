Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5A041F5E9;
	Thu, 16 Jul 2026 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211476; cv=none; b=PyIRoVxnQT593FHvwUEa6rXqqdCmZy5pamepBWuWBp9lh9bwgGYPl8WgzEu2C0iJV7m52JB6CSXvxnPQCaKLcCe62UBWLniOI4R6Rb3g0N9HZxLZD/vejgt1TuaDxnqHoWnUOyY8sjlD74VmZb3zG5Xk/WR7KtwWg99fQO1d4Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211476; c=relaxed/simple;
	bh=Oooqkdrm1Et/zPN582E/Tu2o+20/7R42mulR9Gj5ltE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSHfKGX16VtdWJZF7pgmXXV9i+6flRuuGcaz+LRTMCT47B68llk1ydsk6lDMErCcB3lJohbMarYKR/SOm+GkvdcDcr7OklIGJG/FG2Ps7iyOHm1ccnADMwrWmKWVx4wvptb/Sa8f2W9vsDqwMtcLiiw2OckRsPJb8XrV8D/Fnxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USkNqTgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USkNqTgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3FC1F000E9;
	Thu, 16 Jul 2026 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211472;
	bh=UIGYW3JtFcf/WaeMjKxaKzRd3HmYxhg72RRohki8Y50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USkNqTgnQih1mgZK6cqV8KovLWYUl9hQ8gA7tWNrDjfJ0Kv7vdXhDj8ZZUp/ksont
	 8Leds23GL/A9lwXj1EjoPr0BD0YfBL467RtPWOtgXEtNYQJ3EJZsnRFsEKiJLSyWgD
	 gjhP5OcGP3ftKxDW+ewjHToctaWPP6OA7i+ShqlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 441/480] i2c: imx-lpi2c: mark I2C adapter when hardware is powered down
Date: Thu, 16 Jul 2026 15:33:08 +0200
Message-ID: <20260716133054.358967220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1588,7 +1588,18 @@ static int __maybe_unused lpi2c_runtime_
 
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
@@ -1608,6 +1619,8 @@ static int __maybe_unused lpi2c_resume_n
 	if (lpi2c_imx->target)
 		lpi2c_imx_target_init(lpi2c_imx);
 
+	i2c_mark_adapter_resumed(&lpi2c_imx->adapter);
+
 	return 0;
 }
 


