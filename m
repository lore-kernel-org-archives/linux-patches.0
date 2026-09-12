Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B453325726;
	Sat, 12 Sep 2026 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221222; cv=none; b=SgT8ZaX80FaoRCgo382xs8GrhGBDGQCmMnx41EUWIEN3NnJzkBxSk4jqfLnysAbpekbggBBVWvboGSrs2m2kpps1nwESHtin46PsmZdr7n1JDhvsLxDPsYUEEykBqnQHZGFBrsb5FoNpislOoqu8WocxF6cDhTd/MezvuZrwt3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221222; c=relaxed/simple;
	bh=ex4D25SHmjU4CcomSvr1VC7ZCGaUq9NTg6QPqMndP8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtfYM0rOX5oGjNdr+EVunx3gd6jeC3zAw4QyWMekBmc3CXkg438CBItDig/KXrVyio6GZvDTQYqg31tMsas8sCotdKlbW8OjPhXabk7wy/h6jOFp0FQiANGZdQ5MQ2VN/nI1klJGH/aPzM1wzwkXy659tc0uVkLGf3u4WXkiCmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rk/RP1bC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rk/RP1bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2E91F00893;
	Sat, 12 Sep 2026 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221216;
	bh=BcF6IaIGlgGZF5qard51g4Tb/MNPAVvMEkB2+niP/qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rk/RP1bCVnYpIOC0igEEf/vRBWd7rlD7tox+XkRmpKv3a4gLeNB56W8Hyx9UKc6jq
	 1I5tNXqyWHYcZcAbB7kYFL6gGJhZFVHtrMyUjQE810SGAT0ayHwRnLfajkLuNhKVw1
	 LfCY4ZJkz8yz9vlcLwMPZDFFOgc6vYkBueNEld9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.6 0336/1424] thermal/drivers/imx: Disable clock on runtime resume failure
Date: Sat, 12 Sep 2026 08:46:08 +0200
Message-ID: <20260912065614.810008301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit bcc6d886e5006a4656901d2d7fb6a215c96068a0 upstream.

imx_thermal_runtime_resume() enables the thermal clock before
powering up the sensor and enabling measurements.

If either regmap_write() fails, the function returns with the clock
still enabled. This leaves the clock enable count unbalanced after a
failed runtime resume.

Disable the clock on those failure paths before returning the error.

Fixes: 4cf2ddf16e17 ("thermal/drivers/imx: Implement runtime PM support")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260722084909.463437-1-pengcan@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/imx_thermal.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -851,12 +851,12 @@ static int __maybe_unused imx_thermal_ru
 	ret = regmap_write(map, socdata->sensor_ctrl + REG_CLR,
 			   socdata->power_down_mask);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	ret = regmap_write(map, socdata->sensor_ctrl + REG_SET,
 			   socdata->measure_temp_mask);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	/*
 	 * According to the temp sensor designers, it may require up to ~17us
@@ -865,6 +865,11 @@ static int __maybe_unused imx_thermal_ru
 	usleep_range(20, 50);
 
 	return 0;
+
+disable_clk:
+	clk_disable_unprepare(data->thermal_clk);
+
+	return ret;
 }
 
 static const struct dev_pm_ops imx_thermal_pm_ops = {


