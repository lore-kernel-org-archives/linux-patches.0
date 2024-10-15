Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7C1C7274;
	Tue, 15 Oct 2024 11:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992572; cv=none; b=GmwZ3XClqI1i+q2d4YUoAk+5fgpIkTemQmWM1FhGKiuH7Rkpfb7HAhHzoBo+xn8qX4NswO0HP2tiOrNXcXDm5ynEoeLJ/0kGmC15pXDkGmkT0bOEJlLKiXDnlnAGQakSz1LpyJfXRbARd7kZmQWYw1ei/VQpScYPAFE+UDUzPRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992572; c=relaxed/simple;
	bh=Z36gv/Y/BXEJzBDwQgl9KeFJigbGkTN9h+HtAfoJ5GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8qj6PP0ywK53zZAn5LUB4hSw66+GPzbLt4EcgzI1cIxqNxB+5WHjENLRX1Mi3BqrvSnIxz9mqDEsPFNvkrs+q4dzq+z4/EF5KVODJF2SC2Q86jhlUR69NJ2BtEhhZrBUUn7OSxxyKKU0wcZfLW9k7Qnp3/Yl+Df2kcsxiOas9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6SRglNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6SRglNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B18C4CEC6;
	Tue, 15 Oct 2024 11:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992572;
	bh=Z36gv/Y/BXEJzBDwQgl9KeFJigbGkTN9h+HtAfoJ5GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6SRglNaASK3fo48pM3JAejjrXq+J5/xK+R6BtTmwLX4PS+cNyqD+bQM9JDpzbfyZ
	 0thW38O6uUU2mdOl/b1BhLL0EqlafdTkOf90z0uNKm3bEl5ULG2G+vwEuOFp078Q2i
	 H44oWbObvZRA6jHC8RkYhdl5GmLMNQ7+wB3VN6Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Henrik Grimler <henrik@grimler.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/691] power: supply: max17042_battery: Fix SOC threshold calc w/ no current sense
Date: Tue, 15 Oct 2024 13:21:44 +0200
Message-ID: <20241015112446.553503287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aaf6f1bd3d298..754d78b4c0aad 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -857,7 +857,10 @@ static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
 	/* program interrupt thresholds such that we should
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



