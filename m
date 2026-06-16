Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9184534B9;
	Tue, 16 Jun 2026 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625873; cv=none; b=DH2/BNv/oMGQ82jK6MuJ6wRF/T/HvM6fWN5GNWWhStIKGgaRS1OxsJnWlbFsHdjIhNz47gIJg7OdfHdAxFM81Jhf7iGU3/91hKa6iXb8kuD68kKiePQh1l7vamlz95mYyfxd1RpdO9CnEM8w243XIw8xrqG/OIDZArNmL2OpL7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625873; c=relaxed/simple;
	bh=0ITwaXi8MCODg8lgQXJMpnlD6Zwj8FuLXr5Allni0qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzkrybUyOaprZyHseysxsQ2uj+vm8coZNUY0oIsCAVJjnbeSZnaAX+sxqDcVRFPcyIbEMWOF934O/o0qPNi2h4P7JsE0hOu9wiN1TshaiBinFQJzV5hTeXiN+VyK3voTJ91t8p6im9h+v+C33S/4oEtYZqll2u0tWT/1Wgmw+k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCocvc8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCocvc8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E251F000E9;
	Tue, 16 Jun 2026 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625872;
	bh=5G5+zJDPtSz+/pWaWNceA+CCJS+GseyCv49QstabHd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCocvc8zR33f3XQbIIWbEC2EOrTutLM6UU8RHbtuAGw6xFf7luZiZg01SmvTAcQMH
	 g14CAPJNCRwT9yEVi9K+F8h5ZqGzIN6GD+GhhPIv8tg6YMRXVe6ZvTDEHPKkT9lAWU
	 pKQCYDsIuV4ho6GRVPgPThHhKx2F1USEngtYd5KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 224/325] i2c: tegra: Fix NOIRQ suspend/resume
Date: Tue, 16 Jun 2026 20:30:20 +0530
Message-ID: <20260616145109.509331410@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Akhil R <akhilrajeev@nvidia.com>

commit 656646b3847ac6a21b074a813223feef2aadd6e2 upstream.

The Tegra I2C driver relies on runtime PM to wake up the controller before
each transfer. However, runtime PM is disabled between the system suspend
and NOIRQ suspend. If an I2C device initiates a transfer during this
window, the I2C controller fails to wake up and the transfer fails. To
handle this, the controller must be kept available for this period to
allow transfers.

Rework the I2C controller's system PM callbacks such that the controller
is resumed from runtime suspend during system suspend and it stays
RPM_ACTIVE throughout the suspend-resume cycle until it is runtime
suspended back in the system resume. The clocks are disabled in NOIRQ
suspend and enabled back in NOIRQ resume by calling the controller's
runtime PM functions directly.

Fixes: 8ebf15e9c869 ("i2c: tegra: Move suspend handling to NOIRQ phase")
Assisted-by: Cursor:claude-4.6-opus
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260518114013.62065-5-akhilrajeev@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-tegra.c |   53 +++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1938,28 +1938,37 @@ static int __maybe_unused tegra_i2c_runt
 
 static int __maybe_unused tegra_i2c_suspend(struct device *dev)
 {
+	/*
+	 * Bring the controller up and hold a usage count so it stays
+	 * available until the noirq phase.
+	 */
+	return pm_runtime_resume_and_get(dev);
+}
+
+static int __maybe_unused tegra_i2c_suspend_noirq(struct device *dev)
+{
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
-	int err;
 
 	i2c_mark_adapter_suspended(&i2c_dev->adapter);
 
-	if (!pm_runtime_status_suspended(dev)) {
-		err = tegra_i2c_runtime_suspend(dev);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	/*
+	 * Runtime PM is already disabled at this point, so invoke the
+	 * runtime_suspend callback directly to put the controller down.
+	 */
+	return tegra_i2c_runtime_suspend(dev);
 }
 
-static int __maybe_unused tegra_i2c_resume(struct device *dev)
+static int __maybe_unused tegra_i2c_resume_noirq(struct device *dev)
 {
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
 	int err;
 
 	/*
-	 * We need to ensure that clocks are enabled so that registers can be
-	 * restored in tegra_i2c_init().
+	 * Runtime PM is still disabled at this point, so invoke the
+	 * runtime_resume callback directly to bring the controller back up
+	 * before re-initializing the hardware. The adapter is then marked
+	 * resumed so that consumers can issue transfers from their own
+	 * resume_noirq() handlers and onwards.
 	 */
 	err = tegra_i2c_runtime_resume(dev);
 	if (err)
@@ -1969,24 +1978,22 @@ static int __maybe_unused tegra_i2c_resu
 	if (err)
 		return err;
 
-	/*
-	 * In case we are runtime suspended, disable clocks again so that we
-	 * don't unbalance the clock reference counts during the next runtime
-	 * resume transition.
-	 */
-	if (pm_runtime_status_suspended(dev)) {
-		err = tegra_i2c_runtime_suspend(dev);
-		if (err)
-			return err;
-	}
-
 	i2c_mark_adapter_resumed(&i2c_dev->adapter);
 
 	return 0;
 }
 
+static int __maybe_unused tegra_i2c_resume(struct device *dev)
+{
+	pm_runtime_put(dev);
+
+	return 0;
+}
+
 static const struct dev_pm_ops tegra_i2c_pm = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(tegra_i2c_suspend, tegra_i2c_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(tegra_i2c_suspend, tegra_i2c_resume)
+	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(tegra_i2c_suspend_noirq,
+				      tegra_i2c_resume_noirq)
 	SET_RUNTIME_PM_OPS(tegra_i2c_runtime_suspend, tegra_i2c_runtime_resume,
 			   NULL)
 };


