Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CFE30DEA6;
	Sat, 12 Sep 2026 12:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216897; cv=none; b=eATV0xFVFO8NHfK+6FwWEZ9rYhACApPTRaeQuoDCyhu4UsWU3lt0osyzVD1pAS0sYhbU1zK/J1jZmxMivUVCS0NjClG0ucJF8/sjdTLMvUEIpmmiLkaUpjN+DU+bGOrj9yxGDmKhOUgiCqnKAdBGux9E8V3sob6jX0oHwQvnWM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216897; c=relaxed/simple;
	bh=Ake0g7DWpThGf08PxGOfoU/GE5YdXSoFvxRZdztruTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIWUVHgno/+mx6jjbSCH1MieK1NKLJ3uHKPnrJTs2MY5mP5qUQjYsz9R8CoSNltE7AixIwMh+s2qw9NnaDiLdX4LEhweWxivCF5+6unBGJLQHfW0V16a9By7ZOTYEIoqDuNAvLvgB8otXhuFDrX2d+DHroz+youjEtS7satGUS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlnaHT8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlnaHT8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0921F00893;
	Sat, 12 Sep 2026 12:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216895;
	bh=t/TaEIxLAbhx7GGIg6F3wgO7gu6uARISYoiwZtrMl40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlnaHT8LRo9Pj4+KCY+5xAkLEKLBB7u1QFPwkHH/gk1gTxrURCbf9l6wi9sIRb/sc
	 8LnogJTkxxChghDKD9NJ/eFlm+rNTsSBD0K+xkm2YWUPS4tDMN6wZxsXwk8CstX35O
	 cgQinWLTvF+JXVLMZc5pfsipjD3BemSf8KzfRkuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0828/1376] regulator: core: use system_freezable_wq for init complete work
Date: Sat, 12 Sep 2026 08:54:14 +0200
Message-ID: <20260912065625.999035369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 264c8ab434f07..6c571edfaab97 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -27,6 +27,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/module.h>
+#include <linux/workqueue.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/regulator.h>
@@ -6467,8 +6468,9 @@ static int __init regulator_init_complete(void)
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



