Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884B31FBEB0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301935; cv=none; b=iBW1WLcIKZBQEFRgDi3V9Xo84xVk4FXHHI3anDopClKSPzHagg10fEae6h6bOrYedwK4MzipLsP6ejxRQEqDhHTwrh+UJeJka8KZJV2e2pUqf7Q9ZZkwU50aZGxM+TwgAPzo+SrmlXZNXTmJihRp5p6tOXpmlolzqXDqvAYldyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301935; c=relaxed/simple;
	bh=PmPlCQtI6z8DBWIX3qnT5rBBuyD2YppfPgZJZVq1NGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXdMbcYO1PlydwYYMzCQ/IxadFyLx8WgSFKpdAlK/AlSlzrM9kP87B2REiVVH1Z/q65iY22Zt8c/A486BVdgnuHyPtXO017Xir0WhIqkm4xUwGt4/uujDfgSg/NRwBLvw1Jj6JA3yr2GwYG32pYBeyhPiAA7RL4248TSCnTYJAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aM+hT0X1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aM+hT0X1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8536C116D0;
	Sat, 28 Feb 2026 18:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301935;
	bh=PmPlCQtI6z8DBWIX3qnT5rBBuyD2YppfPgZJZVq1NGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aM+hT0X128UI8BL7iyNsq1mxu+v2Zs16h7NZKA2qp98eiecQCzSWOw6bQUWwxj0Z1
	 b70PAYrdM4V880yG038A7C37mKHM/+9S+vAdmVWNBnspI9r0pPi3bv9xsDQz9rxw56
	 qrGYQxAOyIPsOon+pxybTK1XTw1vyd+wC7oegof/t5iGTibeaauT9Q8p156644/cla
	 weF+1Q4OktT7M3/biMJXGX0eWIAyzmNAbeGpiniQSiqLeq1DyuTVCwf6MxhQs1Nz2y
	 t6HPPDEXxwBe6N8gdepf2CGoVE0r8s0/I7kIwZgntLWifLnRNMP3BrD+JlEwBOYbbX
	 xSTD4XzRy+1Wg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Machon <daniel.machon@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/385] net: sparx5/lan969x: fix PTP clock max_adj value
Date: Sat, 28 Feb 2026 12:59:53 -0500
Message-ID: <20260228180011.1568201-371-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

