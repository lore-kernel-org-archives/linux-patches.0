Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CF3583ADA;
	Wed,  9 Sep 2026 14:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963392; cv=none; b=f5e5ERPiAXKMya9Ao8QoGMCEZlbllAHPN7uK/WDm30N3bozOqwWOKInrzVBcTVGXbyuKDNa+HjxRsZ4zj6tASFrPBBTF+devSJsgaCIYfEx7Yz5G22KETYzSkRLhII63FwMyBlO84s/CHElDIo4YGdwe4bjxM6g5WKdwpDjOtCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963392; c=relaxed/simple;
	bh=sbLDJvjLqD4+5owFLNYyFkn64Q2hUaWXS77a/iWkllM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz2J4emboeEVRDeyr+fcOY/gNVIyXH4fSOnXo92uHnhlVhR4SyB8NkFC9fvqTSKkakboNSceYM0LBiPnUmpudPi4XbIjcKquyf2KJa4Ziu6OxgKnunrgqP/wMzBuSM053Z7kssPsYlX2trdJ/adXUzHwAeAeXyUXIqljyATUwgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nz2PK6Ga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nz2PK6Ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE88D1F00A3A;
	Wed,  9 Sep 2026 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963391;
	bh=uAEF91MuT9AIyDMzVA2MXtjqMjX2fXBio+qQK2Z2PfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nz2PK6GaWwnw5Ae8vObL3EPTdEkYkeXhNbNeFciEsBZlfS7jI16GfEJweCnPX2JOt
	 Ei4dDUdACTwLt4edduP8TkaoiyyDBgHpQ2U8kFFVub/qfoSd6yHE7o1Sao56iA/dFE
	 zCV3w8zq77YWoH2hyJW3nvwlp4qbnl98HC5/ZV5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>
Subject: [PATCH 6.18 036/583] thermal/drivers/qoriq: Disable clock on resume failure
Date: Wed,  9 Sep 2026 15:35:21 +0200
Message-ID: <20260909134239.108534045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -366,11 +366,20 @@ static int qoriq_tmu_resume(struct devic
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
 
 static DEFINE_SIMPLE_DEV_PM_OPS(qoriq_tmu_pm_ops,


