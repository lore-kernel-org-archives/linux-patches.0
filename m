Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437DD15FD04;
	Mon, 27 May 2024 19:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836503; cv=none; b=gU+IBZdjfjYjMc5JwZCEHNSl0+N/rP2thLRc1xXNU8aYpwWmzjVU1w49k5WWZSsFsFIYCM9qTXrRb6mR80caDe+rc74DrohV6XmDb9gPVjshBMxFc9KGZuj2PvQJV0f36kYdUoFZ9Xz/aqiLfwkGvhVt71Hhcuy5xYtIT5ZYNVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836503; c=relaxed/simple;
	bh=vLRBwQxZ5XzW88BFsdxf++Myb3O4AKUYTS/bCksKueo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCcR2ZNwt4WGJ13MrUQM4wx9AaVcmjmj5e+BNu7bRL2tHBf1p/07LTlauMuaD0h2JykzBHgTk6oLXRRb5hXSYAFOfOtGW1btxYwxs8eYStuZS9hLRmQ+4RDcwgGiNaAenLr45f6SLtczqpmbpW07lZh+dlskDDtSHVh5NNAS2nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs8cCD34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs8cCD34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E81C2BBFC;
	Mon, 27 May 2024 19:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836503;
	bh=vLRBwQxZ5XzW88BFsdxf++Myb3O4AKUYTS/bCksKueo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bs8cCD34y39zEvrCznGbulCMA23WAPDwmxdJjWcmTvM5dIfeHHvlkkImD6kQ8i4oH
	 qxGksdImFSNR6RFJrwlR8YWk9wnTMUw7KxRoiZPNLwx9m9L/wWnAJIDWSHXmlfenxA
	 1DT5WEqBZMbgdadzx8FOahW1mK9UvgjHKBZy5xKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 078/427] hwrng: stm32 - repair clock handling
Date: Mon, 27 May 2024 20:52:05 +0200
Message-ID: <20240527185609.063185675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit c819d7b836c5dfca0854d3e56664293601f2176d ]

The clock management in this driver does not seem to be correct. The
struct hwrng .init callback enables the clock, but there is no matching
.cleanup callback to disable the clock. The clock get disabled as some
later point by runtime PM suspend callback.

Furthermore, both runtime PM and sleep suspend callbacks access registers
first and disable clock which are used for register access second. If the
IP is already in RPM suspend and the system enters sleep state, the sleep
callback will attempt to access registers while the register clock are
already disabled. This bug has been fixed once before already in commit
9bae54942b13 ("hwrng: stm32 - fix pm_suspend issue"), and regressed in
commit ff4e46104f2e ("hwrng: stm32 - rework power management sequences") .

Fix this slightly differently, disable register clock at the end of .init
callback, this way the IP is disabled after .init. On every access to the
IP, which really is only stm32_rng_read(), do pm_runtime_get_sync() which
is already done in stm32_rng_read() to bring the IP from RPM suspend, and
pm_runtime_mark_last_busy()/pm_runtime_put_sync_autosuspend() to put it
back into RPM suspend.

Change sleep suspend/resume callbacks to enable and disable register clock
around register access, as those cannot use the RPM suspend/resume callbacks
due to slightly different initialization in those sleep callbacks. This way,
the register access should always be performed with clock surely enabled.

Fixes: ff4e46104f2e ("hwrng: stm32 - rework power management sequences")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index b6182f86d8a4b..0e903d6e22e30 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -363,6 +363,8 @@ static int stm32_rng_init(struct hwrng *rng)
 		return -EINVAL;
 	}
 
+	clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
@@ -387,6 +389,11 @@ static int __maybe_unused stm32_rng_runtime_suspend(struct device *dev)
 static int __maybe_unused stm32_rng_suspend(struct device *dev)
 {
 	struct stm32_rng_private *priv = dev_get_drvdata(dev);
+	int err;
+
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
 
 	if (priv->data->has_cond_reset) {
 		priv->pm_conf.nscr = readl_relaxed(priv->base + RNG_NSCR);
@@ -468,6 +475,8 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 		writel_relaxed(reg, priv->base + RNG_CR);
 	}
 
+	clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
-- 
2.43.0



