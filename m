Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7F03AFB1A;
	Sat, 12 Sep 2026 18:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237382; cv=none; b=TAPDjzIojeI0dIZM3/ZhGGcuBkV2hEI6A2fTvOVJ0/roB4XbFDQJfd4O36oRqpcKzOqqMP1wLLOXeP0VY6JaVk0+I3m9t2fkhZk5oIZWonYXXYtxbRxENabQIwtI7P5h5Sncy6Mlqe1aep+3Wdoc7GHdds38jDcE76bGaX4LnHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237382; c=relaxed/simple;
	bh=qbtAkTaAi6yb0iJ8fvI86fJiYoh7Oe1qjkUlUTUy2p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlAKRnP04aSOojzmUrZzt6YkvvsJXlwk7qOGo5q64LWWa6uR9qBgc+2d7GEuEx3pTK+mxl5snfu3ZVNqlVqUz3YQt8VZr9ZsrzLID6AfHJr4vUZmxFtSflmmYyUrXA5kaWx9ekNL21VECQZnT3bbFMUjFs2hXTMpgEj/00i+3Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmZGz13X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmZGz13X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C851F000FF;
	Sat, 12 Sep 2026 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237381;
	bh=8h6FTEVvVxuo95RWI+W14h874x40OYVIiiETtEGqh+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmZGz13XxAI01fIxfYo3nZlcSVhLG6jt9gWHv8Tw0bt+GB5JzY4kZuS9Ix3ksIybf
	 UPUWnCk9N5x+6rnVbwwbkrZzKDqXQgz5TjPnx9SN+SE2iQjjSqo27K8agjVN/sfIzr
	 SYSjGSfKCu8d04CDdvlHJXjeHRoT01j60li/y4ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>
Subject: [PATCH 5.15 246/935] thermal/drivers/qoriq: Disable clock on resume failure
Date: Sat, 12 Sep 2026 08:54:36 +0200
Message-ID: <20260912065532.468165322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit fcbf9964b67a6d6704c50ed28daa24c3b164f01c upstream.

qoriq_tmu_resume() enables the TMU clock before clearing the
power-down bit and enabling monitoring.

If either register update fails, the function returns with the clock
still enabled. This leaves the clock enable count unbalanced after a
failed resume.

Disable the clock on those failure paths before returning the error.

Fixes: 51904045d4aa ("thermal: qoriq: Add clock operations")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260722075625.452684-1-pengcan@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/qoriq_thermal.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/thermal/qoriq_thermal.c
+++ b/drivers/thermal/qoriq_thermal.c
@@ -369,11 +369,20 @@ static int __maybe_unused qoriq_tmu_resu
 	if (data->ver > TMU_VER1) {
 		ret = regmap_clear_bits(data->regmap, REGS_TMR, TMR_CMD);
 		if (ret)
-			return ret;
+			goto disable_clk;
 	}
 
 	/* Enable monitoring */
-	return regmap_update_bits(data->regmap, REGS_TMR, TMR_ME, TMR_ME);
+	ret = regmap_update_bits(data->regmap, REGS_TMR, TMR_ME, TMR_ME);
+	if (ret)
+		goto disable_clk;
+
+	return 0;
+
+disable_clk:
+	clk_disable_unprepare(data->clk);
+
+	return ret;
 }
 
 static SIMPLE_DEV_PM_OPS(qoriq_tmu_pm_ops,


