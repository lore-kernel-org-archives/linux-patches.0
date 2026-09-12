Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27773B71DA;
	Sat, 12 Sep 2026 10:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209238; cv=none; b=ZZKvWwletBsEwF4RiCZMR/RqdOzPgUySP1CHuvOzk4EujAa22A1zVr0IL6PLQSc4BElz6kF2qsUINXyiSfhNHlDqiermIab/32scszo3fEtT8W9Co5oTkYsYd5biHtpgQWXHJ1kQSpbW1X+BHRi14rSWMXtVdfn8g9i/4nDqW1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209238; c=relaxed/simple;
	bh=HXip52DXAMl8Qj3i1j9ZzjmSujXQk5jxFC7we+R0PSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZfJUwssul6glVBee69STPEDArNd+Ndlr2vnrdFA7A6UH+u5xwRJiVPB/KT4CsIHZfveU2oDdOBaOD09qRa3Ns4tsChVCjX/Gd4cvBgNOedbNeD+RYTwhHLDXVh4pwsd04OZ8dO12HKNID4Q+NsCE6iYP23rCPLGnAcL16DxHbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SgiAOqY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SgiAOqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B201F000FF;
	Sat, 12 Sep 2026 10:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209236;
	bh=TW1Eu6qk+XDEDtWa2g0o1Pr+HzTYXxCbJl03QvKcGR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SgiAOqYACIk95uWw0iOgIfqmlW2WdGorJdHtIYNPzDE99x5Xfw6FjVlg2MIV7wkN
	 vpoRHKe0/+CmY3k8Tbups7ihyczu1/PJonrCkpBGDKF3IEv+gE8UlMIgn+ESdvixz7
	 QsHFvPoOJJAac2xzhp5jxhLMOYo9rsfelL1w0Gg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0778/1518] regulator: core: use system_freezable_wq for init complete work
Date: Sat, 12 Sep 2026 08:49:07 +0200
Message-ID: <20260912065641.036468133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Joy Zou <joy.zou@oss.nxp.com>

[ Upstream commit 03eab318cedd6ae34ecd34533cd986edf5237164 ]

schedule_delayed_work() uses system_wq, which is non-freezable, allowing
regulator_init_complete_work to run concurrently with system suspend. This
work fires ~30s after boot to disable unused regulators via I2C. When it
races with PM suspend, the I2C adapter may already be suspended, triggering
a -ESHUTDOWN warning in __i2c_transfer():

  WARNING: ... at __i2c_transfer+0x36c/0x3c8
  Call trace:
   __i2c_transfer
   i2c_transfer
   regmap_i2c_write
   _regmap_update_bits
   regulator_disable_regmap
   _regulator_do_disable
   regulator_late_cleanup
   regulator_init_complete_work_function
   process_one_work

Switch to system_freezable_wq so the work is frozen before any device
is suspended, eliminating the race.

Fixes: 55576cf18537 ("regulator: Defer init completion for a while after late_initcall")
Signed-off-by: Joy Zou <joy.zou@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260731-b4-regulator-pf01-v2-1-a406c8737fdb@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 019606bc36b9c..97b4ee5d29902 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -27,6 +27,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/module.h>
+#include <linux/workqueue.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/regulator.h>
@@ -6604,8 +6605,9 @@ static int __init regulator_init_complete(void)
 	 * we'd only do this on systems that need it, and a kernel
 	 * command line option might be useful.
 	 */
-	schedule_delayed_work(&regulator_init_complete_work,
-			      msecs_to_jiffies(30000));
+	queue_delayed_work(system_freezable_wq,
+			   &regulator_init_complete_work,
+			   msecs_to_jiffies(30000));
 
 	return 0;
 }
-- 
2.53.0



