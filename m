Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51894281369;
	Fri,  7 Aug 2026 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115603; cv=none; b=F0iwTI188o8pOMRvRTMEkMJbH4XKMMFI0rriftWcqlew+PmHwC35IHvoFe+5MhSnLnQLeLxQcaqtz7UxRdZSvQ+IHfI4Yn99ofsz3Prr7onGBHAcKqPkHnGErnLwhKMbOxkIqD1oFj93s6VJDYXD/MhmbbR83i0un7ZxsXPh5N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115603; c=relaxed/simple;
	bh=KG1HWQnhovLZy89r/lhOZBPMAjWu4UHrDU14V9HRPNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcIV5TxcnGQ5DW39xJY6k/aONy7KeiYSX9g89MHASiBEZuFuNfbazXOAxdLkm5LggeLSxF+zJbMprUYdMdV3+EGCh5VGIramcpDia9nz3f7erQFPvqrUNRoD49UzeILpqgT9YVPNXfRUwn65zTc2dX1JQ+frWygIkYRHyRaDrvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEldXwx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEldXwx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC40D1F00A3A;
	Fri,  7 Aug 2026 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115602;
	bh=7C0Fqaa1K1SICbOIHSOtazkJiD3XxZ0DBW/mpOEn37c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEldXwx8WS6MjEdewmYuh64+GcnwnC1pIqJuD+YEnwaPjAK5TWFmnb7XV0ybZ0u3B
	 /NzW1xF7iOOhJmaHYAeETA1oUp32zy7GirXlRWQcqBlmXj1sPA64aMcORsB/2X34hy
	 w36mvogLPZor5yR5mHo221l+y98JKHLtlaPOSLj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 289/396] i2c: qcom-cci: drop custom suspend/resume and rely on runtime PM helpers
Date: Fri,  7 Aug 2026 16:37:29 +0200
Message-ID: <20260807143430.504295983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>

commit b08c9857aa1f5f3a81d375d6d4bb1d8b92f22ebc upstream.

cci_resume() unconditionally calls cci_resume_runtime() regardless of
the runtime PM state.

If the device is already runtime-suspended before system suspend,
the clock is re-enabled while runtime_status remains RPM_SUSPENDED.
As a result, pm_request_autosuspend() does not arm the timer,
leaving the clock permanently enabled.

Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260625-cci-v1-1-a100cda673ce@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -496,24 +496,8 @@ static int __maybe_unused cci_resume_run
 	return 0;
 }
 
-static int __maybe_unused cci_suspend(struct device *dev)
-{
-	if (!pm_runtime_suspended(dev))
-		return cci_suspend_runtime(dev);
-
-	return 0;
-}
-
-static int __maybe_unused cci_resume(struct device *dev)
-{
-	cci_resume_runtime(dev);
-	pm_request_autosuspend(dev);
-
-	return 0;
-}
-
 static const struct dev_pm_ops qcom_cci_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(cci_suspend, cci_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(cci_suspend_runtime, cci_resume_runtime, NULL)
 };
 


