Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9585A313298;
	Mon, 13 Apr 2026 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099137; cv=none; b=GBNpVpUTz1/Nf80sUBry2Rtc38X3rkhbvH7vAEhhO62FccC2Mh8yANaaDythTM+nLAe27w2tItuSN4QePO89MDWtcjIL+88AMbN1SM+SY5+3JJn9PWTdvTBaC80egCtA5TcsRdWV8G+VVolHXb7Bmd/l4pC8S7FMOlNKqCjHYHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099137; c=relaxed/simple;
	bh=l2L208qy3R3iElF/g2euRcbQLKEeXq6JODEg/bjALsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/OOPwDsQfwYNPWIOVDMD8GxEDGmQ22hrLCD9xY8XjvpPZ6a+sq+TADo02K18CTE+Eq6ygnwyD6fyHliAthvoSBTVrEMtWQjUTzaE+nADLcYkqb+72Tv3SUdtOEjqD4v8nzMHfxTW6Ejra/gJWiXmxBwLM0XxJlMBbL1lJLZ07M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojXxUwIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojXxUwIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D348C2BCB0;
	Mon, 13 Apr 2026 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099137;
	bh=l2L208qy3R3iElF/g2euRcbQLKEeXq6JODEg/bjALsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojXxUwILWSP0/+gmbfZ3rzqHa8SbGZLlZZjd5sHb0GEClVWGK1/ZVqU52OF7zSsDC
	 1RUxspWQaGPSUrZynFocs4v3cpYl/s8xl8EHbfSp90vOm8h42xlYHFjSsHOrH19384
	 NWQnihoRSIwGGhdv2tmFR4pbcbFmCRvtNIjeO+lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Anas Iqbal <mohd.abd.6602@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/491] net: dsa: bcm_sf2: fix missing clk_disable_unprepare() in error paths
Date: Mon, 13 Apr 2026 17:57:50 +0200
Message-ID: <20260413155827.484454411@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anas Iqbal <mohd.abd.6602@gmail.com>

[ Upstream commit b48731849609cbd8c53785a48976850b443153fd ]

Smatch reports:
drivers/net/dsa/bcm_sf2.c:997 bcm_sf2_sw_resume() warn:
'priv->clk' from clk_prepare_enable() not released on lines: 983,990.

The clock enabled by clk_prepare_enable() in bcm_sf2_sw_resume()
is not released if bcm_sf2_sw_rst() or bcm_sf2_cfp_resume() fails.

Add the missing clk_disable_unprepare() calls in the error paths
to properly release the clock resource.

Fixes: e9ec5c3bd238 ("net: dsa: bcm_sf2: request and handle clocks")
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
Link: https://patch.msgid.link/20260318084212.1287-1-mohd.abd.6602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index d0f94a5fae5ae..7c64317e0f191 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -871,13 +871,17 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 	ret = bcm_sf2_sw_rst(priv);
 	if (ret) {
 		pr_err("%s: failed to software reset switch\n", __func__);
+		if (!priv->wol_ports_mask)
+			clk_disable_unprepare(priv->clk);
 		return ret;
 	}
 
 	ret = bcm_sf2_cfp_resume(ds);
-	if (ret)
+	if (ret) {
+		if (!priv->wol_ports_mask)
+			clk_disable_unprepare(priv->clk);
 		return ret;
-
+	}
 	if (priv->hw_params.num_gphy == 1)
 		bcm_sf2_gphy_enable_set(ds, true);
 
-- 
2.51.0



