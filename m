Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020099;
	b=hdJiDyijNnaSKYvACsDsMXcuehMGMKbRDy0/DMp8/KKP10pspt+wFQq6csQXxHqtx0Lm
	 hT0rOHS8L7mBjYOq+lBrCZbHBE5NzNZiATtskJG9GnHzHcla92M5aQEGzaHugNSs3wIEa
	 zBUETyRj/iMW6/367aXGOM6cCUpp8WPBb6/G71+RmGaidH5nujrKb57OoDHtMlUlFXdQH
	 zzU6F7LI2lvPVdTOaCDuhsP4n5Lxo5/zFqUxW/15Cdg8eLoxEokp+h0YKjv2djnxZKLNt
	 iy3kysiy9oSoeTbL8wUYFD0brz40ZVj3ON1hywKlciOzZ7dq22d15X9IvzG8bhJlExA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ISXyh592ZfqPWs9KXDt5JsCjH+09ksfE6/bWmdtD+jE=;
	b=kplGQpz6KHBYHkT9/L+SV2FGRKrsJR4WyljUnyAW7coH2v0IWsOG1rEo3qlskpUTGwzy
	 VdFZhoVgypiw0ZqHoEwhI8r/xtd9ERez9HU/0KO11XgGmJynx2vzUqGE3MJ86qkAUCUca
	 UFnlf5Wc1ibVDyCofDNkNq5c7l4StUAPLP/o5JX9kNv7cFFlsZtVCsNHSHNgY8T1yAbhV
	 76/wYAPGbRQSrvk2bPHHwlI3lFIxaX5Pjbuujs9n4xYE+/vGsVJ3xjm/o/9RFgbv7Euo6
	 Q/giCMNChsFiOK3sYLTz96D/kUmQ5PjVP/2J6dT5/YlcZEeRUATXXgWOesnF+n+1SIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjYFeTdm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9B4606A33B;
	Wed, 18 Nov 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjYFeTdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6CD1F000C5;
	Wed, 18 Nov 2026 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020098;
	bh=ISXyh592ZfqPWs9KXDt5JsCjH+09ksfE6/bWmdtD+jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjYFeTdmG/ShmDuUfPt4ZHr2zMMeMkEmxLyfNUCyHAfjIT/86l6uJBmGAzhRawyik
	 67rsMY2IG6RClkUQ3eqTuLsTHeLFNsTk5QsaYRZ57HoOl+wbIQPM0WB4TgUyvEWkc1
	 DGWtOlfUrpypUgTi4nifKetZgEDCcrOXEkMvkriY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Claveau <linux-kernel-dev@aliel.fr>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1829/2651] thermal/drivers/amlogic: Switch to clk_bulk API to support multiple clocks
Date: Wed, 18 Nov 2026 15:51:09 +0100
Message-ID: <20261118150352.979587481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Claveau <linux-kernel-dev@aliel.fr>

[ Upstream commit 44b39b4fb0f069a3bbe6bfb21a34d2d3730f393a ]

The t7-thermal variant now exposes two clocks (bus and core) in its
devicetree binding, but the driver only knows how to get and manage
a single struct clk. Using devm_clk_get() would silently ignore the
second clock, so switch to devm_clk_bulk_get_all() and the matching
clk_bulk_prepare_enable()/clk_bulk_disable_unprepare() calls. This
lets the driver transparently handle however many clocks a given
compatible declares, without needing per-variant clock-handling code,
and keeps working for existing SoCs that only have one.

Fixes: 18d65de8157c ("thermal/drivers/amlogic: Add support for secure monitor calibration readout")
Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260923-fix-t7-thermal-clock-v2-2-bff7a09eb487@aliel.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/amlogic_thermal.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/amlogic_thermal.c b/drivers/thermal/amlogic_thermal.c
index a0b530624b60c..60728de6968ac 100644
--- a/drivers/thermal/amlogic_thermal.c
+++ b/drivers/thermal/amlogic_thermal.c
@@ -100,7 +100,8 @@ struct amlogic_thermal {
 	const struct amlogic_thermal_data *data;
 	struct regmap *regmap;
 	struct regmap *sec_ao_map;
-	struct clk *clk;
+	struct clk_bulk_data *clks;
+	int num_clks;
 	struct thermal_zone_device *tzd;
 	u32 trim_info;
 	struct meson_sm_firmware *sm_fw;
@@ -142,7 +143,7 @@ static int amlogic_thermal_enable(struct amlogic_thermal *data)
 {
 	int ret;
 
-	ret = clk_prepare_enable(data->clk);
+	ret = clk_bulk_prepare_enable(data->num_clks, data->clks);
 	if (ret)
 		return ret;
 
@@ -156,7 +157,7 @@ static void amlogic_thermal_disable(struct amlogic_thermal *data)
 {
 	regmap_update_bits(data->regmap, TSENSOR_CFG_REG1,
 			   TSENSOR_CFG_REG1_ENABLE, 0);
-	clk_disable_unprepare(data->clk);
+	clk_bulk_disable_unprepare(data->num_clks, data->clks);
 }
 
 static int amlogic_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
@@ -323,9 +324,10 @@ static int amlogic_thermal_probe(struct platform_device *pdev)
 	if (IS_ERR(pdata->regmap))
 		return PTR_ERR(pdata->regmap);
 
-	pdata->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(pdata->clk))
-		return dev_err_probe(dev, PTR_ERR(pdata->clk), "failed to get clock\n");
+	ret = devm_clk_bulk_get_all(dev, &pdata->clks);
+	if (ret <= 0)
+		return dev_err_probe(dev, ret ?: -ENOENT, "failed to get clocks\n");
+	pdata->num_clks = ret;
 
 	if (pdata->data->use_sm)
 		ret = amlogic_thermal_probe_sm(pdev, pdata);
-- 
2.53.0



