Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC25C472771;
	Fri,  7 Aug 2026 15:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117675; cv=none; b=KRyV1z3YpKls+rhat+CK2dGb8CqaYwJOj1TgAtrJGOMj50DopkMVs1wUP2mdxuVOi5oTIdXyhEVtJzbXBRGGS1ADjcXMAo2AYga77/HfzEX2ZbWvWeR3xSx/mY7CdY/1XP9CrzG34nZ0+F5xHeZy6CpUQVuywpLMZWoKVH+O8oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117675; c=relaxed/simple;
	bh=rN3usCZoGRxqk5+wv//zs2A6vvB2ww2Y+pF+In8hrgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oD6Jzk7urQtS6kBxtXUabwZg4+Rumd+mXgJejOeO/p5l0F8/JPVfD6tAg7dLXLciD/K7dCsOKrWZ081Mq+1TLgcxkUSFhNByevqGH9kMn39xhgZEoc13GjbOO+jpTT5VzoDMXA6nnmT6LHM/ZZREhr1TvhnqwrMKMmUZBwMqXqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZU4xMIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZU4xMIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A141F000E9;
	Fri,  7 Aug 2026 15:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117674;
	bh=qpKLNpOexfSxYU2KIU0/SrN4AOOEm/i4NWIe0q4vAwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZU4xMIehOD7dBVIgX0OZXm8q2H26dcpwzraXYP7yy85c4DCEVdOwTdPkHbiNyX8a
	 O1tnFuoaVjY6+s2uNs7rrcIbVN4lXe1XOjtYEvgTa/dpXAh8v92QqMlc+OJSmACbiI
	 cjzlkxT4onckFiyq0ufRgcz3mmJNYMfdcTJ5c600=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 357/438] i2c: qcom-cci: drop custom suspend/resume and rely on runtime PM helpers
Date: Fri,  7 Aug 2026 16:39:13 +0200
Message-ID: <20260807143435.584159599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -493,24 +493,8 @@ static int __maybe_unused cci_resume_run
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
 


