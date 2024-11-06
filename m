Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46941E7C1A;
	Wed,  6 Nov 2024 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897930; cv=none; b=IO8BM/BkTV3seDicu2cj/yyjX+QBd2EsjyWaxDQiJsp99QkRXiAF0hetncuhUcZ0rPFIdMJqXB8T3RLcxjuYRBe1PgZ98dTIfIBOtmmOM2JHagi/R72EcmVJpPMLiJ6uMBuc9jyzqWJynfh/WogBEcSsfvDGCNjuXQ1Tb5WrO7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897930; c=relaxed/simple;
	bh=a/zXdJsyaeJpQ3Sny0K/FmICzRE9NU1SxNWYpVpTMbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYzRqY6HzMMqrFcviNEE6QzlFnB2F5GpWQDtiYt9LzLa33KKeLKZFTsX4k62ZQM2ElxOWfyz9Fs8nr/+oJXpw9XLH9JIqiLbBqOR/fOqVf4Bqm+VNPFoaXnfDg5mgzyxRygjIeJ/4nL78rViEKNjRzRha17aPXkxWJiAPlrTmWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2kOhrtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2kOhrtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9CEC4CED3;
	Wed,  6 Nov 2024 12:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897930;
	bh=a/zXdJsyaeJpQ3Sny0K/FmICzRE9NU1SxNWYpVpTMbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2kOhrtJu6rajaPqRKHlJhlEIseYzju4Wa4d9feyNoxvXrB0xxEPUcjYu6cFsbujD
	 8TAnqMSCN/OUuE/pJ7YqCxws7sheZDqzs2N/fHa9MetWTXxKNwflQE1/GxsjEceIzL
	 nIttctVg5gEIdgWuCZy+4uxrEG/JwQfAlngDwx7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Henrik Grimler <henrik@grimler.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/462] power: supply: max17042_battery: Fix SOC threshold calc w/ no current sense
Date: Wed,  6 Nov 2024 12:59:19 +0100
Message-ID: <20241106120333.142243768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 3a3acf839b2cedf092bdd1ff65b0e9895df1656b ]

Commit 223a3b82834f ("power: supply: max17042_battery: use VFSOC for
capacity when no rsns") made it so that capacity on systems without
current sensing would be read from VFSOC instead of RepSOC. However,
the SOC threshold calculation still read RepSOC to get the SOC
regardless of the current sensing option state.

Fix this by applying the same conditional to determine which register
should be read.

This also seems to be the intended behavior as per the datasheet - SOC
alert config value in MiscCFG on setups without current sensing is set
to a value of 0b11, indicating SOC alerts being generated based on
VFSOC, instead of 0b00 which indicates SOC alerts being generated based
on RepSOC.

This fixes an issue on the Galaxy S3/Midas boards, where the alert
interrupt would be constantly retriggered, causing high CPU usage
on idle (around ~12%-15%).

Fixes: e5f3872d2044 ("max17042: Add support for signalling change in SOC")
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Reviewed-by: Henrik Grimler <henrik@grimler.se>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240817-max17042-soc-threshold-fix-v1-1-72b45899c3cc@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17042_battery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 170639a1e734a..b3afcc5ffd57b 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -834,7 +834,10 @@ static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
 	/* program interrupt thesholds such that we should
 	 * get interrupt for every 'off' perc change in the soc
 	 */
-	regmap_read(map, MAX17042_RepSOC, &soc);
+	if (chip->pdata->enable_current_sense)
+		regmap_read(map, MAX17042_RepSOC, &soc);
+	else
+		regmap_read(map, MAX17042_VFSOC, &soc);
 	soc >>= 8;
 	soc_tr = (soc + off) << 8;
 	if (off < soc)
-- 
2.43.0



