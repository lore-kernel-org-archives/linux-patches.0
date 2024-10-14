Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544071ABEA1;
	Mon, 14 Oct 2024 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917758; cv=none; b=SbB2DYg0uNQUMtaadbQhY+q9P/jQVCvvkUGPr3St9wykXM78RFK88zSHcAgJ5G73Pbw9Oty4juKRnnyaIH9mPFG+vp1nnGU3lPNnAuU3iexXQWzcqLaILqb9oFvmXmpqy0D3qFdGz6J3YXbSuMMECYnDYk5u7EMkqjCrG18TD58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917758; c=relaxed/simple;
	bh=D3i/S7QLjqOAnLchteBT0IqzHdh+B4ARs9HOzhLzxLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POMmA/m9dx4cVyAxekkEPRax0dIItdW0CagtSxeaE5VDeUx3U48g3Z4JcAIgSH72d/ooN1x6+KqKqwuONOzIyXx6WMOV8VxESBAiUeNYFnmSb3D8FgZBXCIbGXVcWxWBW4SA3PiSfdkcw1FaP4BbNe4HJNqEVdSeLkweTlv6Np0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgxEbOcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgxEbOcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1204C4CEC7;
	Mon, 14 Oct 2024 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917758;
	bh=D3i/S7QLjqOAnLchteBT0IqzHdh+B4ARs9HOzhLzxLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgxEbOcjaaLp8kneb7T9hfrak5RTK8lOvtM8SVXGyNYoeMxQmyEkl3QJpiJoHIp11
	 fLl3krG7bDlhNlE2L/l1lufds11LnsmHapj+v7T1RI9YgzG2wLxwG5cd4mc/PvJJsg
	 IpHtQ7YhJap23EY4+nw+r/CfaoKMdRpfXVQycV+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Henrik Grimler <henrik@grimler.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/798] power: supply: max17042_battery: Fix SOC threshold calc w/ no current sense
Date: Mon, 14 Oct 2024 16:10:48 +0200
Message-ID: <20241014141221.625612093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ab031bbfbe785..605d2b05c7533 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -858,7 +858,10 @@ static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
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



