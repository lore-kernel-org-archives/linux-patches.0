Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E1F1C68C;
	Sun,  1 Sep 2024 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209048; cv=none; b=aTIH5KFl/EW3WLsdXflvzjylbv9nwYffmCA47Q6p5LACGn7n41KphlPIJZzM5yYUwi7BY06bCMbZIVvZJ3ntOMtHdXMhUIRuG95zQOhb6tbrJDLcJzETQ1vs0T5eL/TdHikj8kQqlMcswjvdPQfwJDmZdsP/3oqn5p+zXGQdpy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209048; c=relaxed/simple;
	bh=GMQO9UjamNPFvOhwODwIy0w6gBqUq52djJZGSIqxD4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQbyUO84mHNgiBBW8NPOjEMKFhN+Q1p+zgo8LR/Stqs9eRF9DXn8AzliDS2gILMio2OIR/X11UoHLiuEf/E2Zm1Dq4rejg/VyzgRV2e6sLfnULjH2R66jHextIamytXQ4PlRefl9/IrJJSf1JzgIlgcOjulCr/AATuslMzYcUPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1m2MyzgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1m2MyzgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7374C4CEC3;
	Sun,  1 Sep 2024 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209048;
	bh=GMQO9UjamNPFvOhwODwIy0w6gBqUq52djJZGSIqxD4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1m2MyzgSP/VPlHsY9Xki3PWsF7aqsYarwi/ZAeNR6SREthiLctx75XXV8iq6KjMss
	 WBwvAEJfkrG6wtHDQK20cjx1XesSP4yAkwCmuW1hFca1MRiUAJmkbY44FGj9SQpupC
	 S/MUuFgALF4K2SkidDOmeUaQ1dX/j66m1SKsp4Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/134] net: dsa: mv88e6xxx: Fix out-of-bound access
Date: Sun,  1 Sep 2024 18:17:16 +0200
Message-ID: <20240901160813.485078124@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

From: Joseph Huang <Joseph.Huang@garmin.com>

[ Upstream commit 528876d867a23b5198022baf2e388052ca67c952 ]

If an ATU violation was caused by a CPU Load operation, the SPID could
be larger than DSA_MAX_PORTS (the size of mv88e6xxx_chip.ports[] array).

Fixes: 75c05a74e745 ("net: dsa: mv88e6xxx: Fix counting of ATU violations")
Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240819235251.1331763-1-Joseph.Huang@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 2b314b416256d..f2e07d903aa73 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -421,7 +421,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 		trace_mv88e6xxx_atu_full_violation(chip->dev, spid,
 						   entry.portvec, entry.mac,
 						   fid);
-		chip->ports[spid].atu_full_violation++;
+		if (spid < ARRAY_SIZE(chip->ports))
+			chip->ports[spid].atu_full_violation++;
 	}
 	mv88e6xxx_reg_unlock(chip);
 
-- 
2.43.0



