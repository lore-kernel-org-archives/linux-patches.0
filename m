Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BAA457E76;
	Sat, 12 Sep 2026 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210045; cv=none; b=oC+UWrIZ1SQuwMxyUkFtAmEAzstJ4cQ2hMUa7gT/UFkXojlUa8oWC6cTKiIJez3D1pD/v70cG7Us0lDEO/+iynwjPSzJUvOAwSOZMUyj6jeIbloaF7B8VtrkbuoMuwN5SRe2Ts37jdiu/lYEKJAOQbVJ8XrS2vlok7/tBAo0QQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210045; c=relaxed/simple;
	bh=K0gExsmcsswBoDCWQan8hFxhzN4/r0nLCFeQhuKH420=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSJhLshL1ohZ31aDb91dyOXusVOw6teLxBUDRRMuMxGQrXPWjq/zdMh2SxBVq6GIYgZwZmkfTlgH7zwdMxOv5p71LRvOuecWTyVPd2XccvBfqvliJjqrg6wQblrUwRtJ7J27XN4YWSZhGUjhc8QznqTMWUTDfrNZfjcSVtJYDeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHCgQqBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHCgQqBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC341F00893;
	Sat, 12 Sep 2026 10:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210040;
	bh=uGn+0HJc4G65CT0SZAnH3jLvBOj87n8fFg+lbPGuKW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHCgQqBKdxwBbDHq2bh1cBTmnvSaeZ3ftIH2EKljptNd4Ui5LGJX/CmbKEx3u6gf6
	 IC431r+0MjcVLYsKcLNJZfPCZNVVrZun/qoCgU/G1k+2rJgeARc3NJdXKUuKQvvf0N
	 UmkA4g41VTwwKjDtSLpttwXM8s2CEeclLwyCbc7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0945/1518] phy: renesas: phy-rcar-gen3-usb2: Fix devm action registration for disabled VBUS regulator
Date: Sat, 12 Sep 2026 08:51:54 +0200
Message-ID: <20260912065644.832613420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 49c9b71b45081e5e5eeb507a2d6edb80d332dc59 ]

devm_regulator_get_exclusive() initialises the regulator with
enable_count = 1, requiring the consumer to disable it before release.

The devm disable action was previously only registered when the caller
explicitly requested enable, so when the regulator was left in its initial
enabled state without an explicit enable call, the cleanup path skipped
decrementing enable_count, triggering a WARN_ON during regulator
release on device removal.

Fix this by always registering the devm disable action based on the actual
enabled state via regulator_is_enabled(), regardless of whether the
caller requested an explicit enable. This covers both the explicitly
enabled case and the initial state set by devm_regulator_get_exclusive().

Fixes: 24843404efe4 ("phy: renesas: phy-rcar-gen3-usb2: Control VBUS for RZ/G2L SoCs")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260806102236.149159-9-biju.das.jz@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 03ea292bbfd4c..547d61ccb85a4 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -912,15 +912,17 @@ static int rcar_gen3_phy_usb2_vbus_regulator_get_exclusive_enable(struct rcar_ge
 	if (IS_ERR(channel->vbus))
 		return PTR_ERR(channel->vbus);
 
-	if (!enable)
-		return 0;
+	if (enable) {
+		ret = regulator_enable(channel->vbus);
+		if (ret)
+			return ret;
+	}
 
-	ret = regulator_enable(channel->vbus);
-	if (ret)
-		return ret;
+	if (regulator_is_enabled(channel->vbus))
+		return devm_add_action_or_reset(dev, rcar_gen3_phy_usb2_vbus_disable_action,
+						channel->vbus);
 
-	return devm_add_action_or_reset(dev, rcar_gen3_phy_usb2_vbus_disable_action,
-					channel->vbus);
+	return 0;
 }
 
 static int rcar_gen3_phy_usb2_vbus_regulator_register(struct rcar_gen3_chan *channel)
-- 
2.53.0



