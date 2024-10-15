Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751FF1C07C4;
	Tue, 15 Oct 2024 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997183; cv=none; b=OcDNgOwBvF+D/kFbiu4XH1HMic0CrdNcBQXwShchkcFu8DU6rgCkxd0RXjnjAJ8rPpaVUsoWQpYtMOrjx6ly1Gywlp/kqUhiz11xtchPb4IIFtCWLX+N9k8o+77DS5vfpSSUV59hUWI39kAJ8Czf+VbfQdR3gjaIuYhIG8s1gJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997183; c=relaxed/simple;
	bh=mFwQTSDRPuKy2XtaAUSvG/ABaeP67biUbHFmMrmsIZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBb2LcNR4ZGdUtqYNCvqsbu9+JZiwIoB1j/DUOtCbmfkOQCoTDelCsaZ5wqa4GSzAoQNVc9tSxrL8bsfK89jOT1ypmPzkGMdcSyZDiLaszFa+ekcimH042JUju7b5xeiML9N1W6qG7PQ/XB6FLzPAxZ+ULRdmmVWjZIkZVEGgTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMRLhdhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMRLhdhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E8AC4CEC6;
	Tue, 15 Oct 2024 12:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997183;
	bh=mFwQTSDRPuKy2XtaAUSvG/ABaeP67biUbHFmMrmsIZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMRLhdhrJ/kiOgju8JDDaTGLu/bfCIZtUPpk8+A6qw8HtKldKUudEsmG0Hwggnqw0
	 hrTvHPBSAGbjicx6zI0uMpB+ba1wi+24oOem2F85anJ2UU5ico9eSOiPS4SlHM2UWL
	 OwScqChKh034qFj42zt74avAIqi3fkJuKZzEcwHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Henrik Grimler <henrik@grimler.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/518] power: supply: max17042_battery: Fix SOC threshold calc w/ no current sense
Date: Tue, 15 Oct 2024 14:40:15 +0200
Message-ID: <20241015123921.283722958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 76b0f45a20b40..b68bf3a354654 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -851,7 +851,10 @@ static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
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



