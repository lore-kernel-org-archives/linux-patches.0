Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2629530DEA3;
	Sat, 12 Sep 2026 19:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243010; cv=none; b=kvX5456wbdR2Su9gyGwo6BXgmC+Wh4nPbXG8bb32dPz42HzzDEjz0pZDjNhM6nRa56HuSNAT4Tx8uMzYmktIWmfcqfbWRYR79oML20mE19fhIgI8qPk1CTvfYouXJm6sChPKqnQ788tyVfD916a7FscH2f5z7XlOsonGhz8q4YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243010; c=relaxed/simple;
	bh=+E0VgDgV8iF0ucblEo+Ahf/j9uf7CHTRWjkX4Q0QwTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRitMjhFkMZIqgmiIq81HGGFMiTutcSEKD7LPnZbjyqrJsUve9oLCS0zAHEG/lWIJg/XEc6RIVQbUVcpvE9/M//epM05mmXbvK7ycr+9ZTUpFPeHHxHV0AfNFndpgjrJ4yErVb62K3ZWApMHjnOe7YU1exOAk2poQW8Zbno5awg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J31aIl7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J31aIl7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09461F000FF;
	Sat, 12 Sep 2026 19:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243007;
	bh=MCTdQksHq1k0byVblt+eBs6TagZQl4cDPJDCVXtRwTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J31aIl7bavae3bN1skUSWCqxceNHUcdbkR8T7H4V3ssnEV9bwHqecAxWg6YCdszPY
	 Ha/mv1iSXffbhcPbg/NaKF5bPE7j1oyF4/cZPtiI6cWZRZNmhmMPB3FHdUJBEEqeJO
	 RFeKMrWDfkRNaFXLOH6lppNqiWcT007g3oCgp84Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 561/798] regulator: core: use system_freezable_wq for init complete work
Date: Sat, 12 Sep 2026 09:03:09 +0200
Message-ID: <20260912065529.985802805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 335150e777568..0cdb81a1ba316 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -26,6 +26,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/module.h>
+#include <linux/workqueue.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/regulator.h>
@@ -6081,8 +6082,9 @@ static int __init regulator_init_complete(void)
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



