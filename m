Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565FB346E77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302256; cv=none; b=DMsAju7xi1S6YR9DaXBR6RAajXUEv8rDg++S+9aDWfMW4BmevLmGMkP9mtBikuydiHCfjg6SfHK+GAZvKBI0kwZCi+OCLP04xznSJTCRyt8Jm1Dmzwnj2MJiolX9kAQLvAebuwjiia3JEZy5TUAz7JpFKZWuZsSW2yt+Fdv8OuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302256; c=relaxed/simple;
	bh=PmPlCQtI6z8DBWIX3qnT5rBBuyD2YppfPgZJZVq1NGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgUDc0yQIjabRZsjohBut0muoOb6u6oAryemAOjhBsbLc7EeKTWW0EuIjC1BiUYXTvFNFWL/ng2HsErpZZwyTwab3aC1Eo27mG0OAD3qNqiO68uVEQAy0kBPUCMnwQr/kz4+JsBCXgS402XuxTzfEiwznM17vDZGdwBlcKGU1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HbkThrFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HbkThrFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AF2C19423;
	Sat, 28 Feb 2026 18:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302256;
	bh=PmPlCQtI6z8DBWIX3qnT5rBBuyD2YppfPgZJZVq1NGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbkThrFv5T/nZoJNBIf4l7k89jUbaz6Cn1fvVfCjV8G/UnU/oJWZrr8HkRGX+ZT/3
	 HMd/AfUepIUPcHci/1SwF8fGMz14OH2O0e/nIdBiaCedj2khpFlYCsW8HRkcU/ER7L
	 qdDNoaWeuixCT2dKrndVgE7MddbGRzxwj6OIts5coBSN1P6WeWw+kmXovmwWFw/7lv
	 r2jiidVCmNwV+A7HPbkfim9Vx5taJ6TF4Rt4ucNjw5a7skJalLOL9NZKwgb1uiw4Z8
	 a4+hLdGq6IQHwj8FG9fXAR7OrwhhwBxPGgD143kwR5m8RQh1yEnaq+CArggt4jPQqy
	 64kuxjU6uPTwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Machon <daniel.machon@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/283] net: sparx5/lan969x: fix PTP clock max_adj value
Date: Sat, 28 Feb 2026 13:06:52 -0500
Message-ID: <20260228180709.1583486-270-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit a49d2a2c37a6252c41cbdd505f9d1c58d5a3817a ]

The max_adj field in ptp_clock_info tells userspace how much the PHC
clock frequency can be adjusted. ptp4l reads this and will never request
a correction larger than max_adj.

On both sparx5 and lan969x the clock offset may never converge because
the servo needs a frequency correction larger than the current max_adj
of 200000 (200 ppm) allows. The servo rails at the max and the offset
stays in the tens of microseconds.

The hardware has no inherent max adjustment limit; frequency correction
is done by writing a 64-bit clock period increment to CLK_PER_CFG, and
the register has plenty of range. The 200000 value was just an overly
conservative software limit. The max_adj is shared between sparx5 and
lan969x, and the increased value is safe for both.

Fix this by increasing max_adj to 10000000 (10000 ppm), giving the
servo sufficient headroom.

Fixes: 0933bd04047c ("net: sparx5: Add support for ptp clocks")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260212-sparx5-ptp-max-adj-v2-v1-1-06b200e50ce3@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 5a932460db581..6b2dbfbeef377 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -562,7 +562,7 @@ static int sparx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 static struct ptp_clock_info sparx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "sparx5 ptp",
-	.max_adj	= 200000,
+	.max_adj	= 10000000,
 	.gettime64	= sparx5_ptp_gettime64,
 	.settime64	= sparx5_ptp_settime64,
 	.adjtime	= sparx5_ptp_adjtime,
-- 
2.51.0

