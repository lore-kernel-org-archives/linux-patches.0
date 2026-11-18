Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018286;
	b=gC/7F23bUp19vQvFGd2sZImI3Af25OZAIN9MgMdduok8th8hSuaCIF5eM9NRDOxgA/wH
	 afrjWyXrdRJJsWbOaaeqWSZBFb1V4gQRjk5xlDT76a7dL558vNaTqFykFu8sDexnS2thY
	 VDiB9ZlNlwpXKBaGdn9nBCGA5nzpoXYLpHn8gkMIsuczNLUlNsyTpHvkS5EAYu1oken0h
	 SuSoLeEshyI1suNDZlT24ZPuqCKs93KcEm8/QJ1MjoxWl6JFSLFwnB04M0BsFCxRoEQaR
	 EPY2ERffbYZbG5t6D6QTOx9RWIgoAMhl73xhL9+/nIY8q1NP2YOfYzwA4+2urnk+Pog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0T2nB55Dz8e2aJwEcNtAhkTPy0lIF9LBv5XEj7qT87w=;
	b=5cQudatHH5PR1jIzrV+AGfuo/TR6LHndDu/jjd8kmnB2DsHJJXbG0eOT4FZpzMi30g/l
	 IrcqYG3kmwAqfx1apQ071Nusl8MQRd69+UFda+owjnYuVPnVussy98rqqfdroJXRMXt9A
	 HYBRQGo69pGluzBIBjTVf/Nd5V+Vwnenqig/s3zAt6kZwg2asC6Cxl/sz5GMYPQOpDYlo
	 c8jNFZ7FmsifUSpx+80LyMnoQy4TV6j4EKUxmWRJc9jRmWyhN06JMnMm0ymef/jPgTss9
	 8CW2wIPtgWumwX3GoiJCZS60/p4rgUPXYZhz7RJUq3pFdGPmM/PrYYSCJOo6ZCxtQLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J1lodst/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F03606A333;
	Wed, 18 Nov 2026 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1lodst/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB7B1F000CA;
	Wed, 18 Nov 2026 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018285;
	bh=0T2nB55Dz8e2aJwEcNtAhkTPy0lIF9LBv5XEj7qT87w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1lodst/M2H/Yg1LCh/mtLHIZ5rq8eY429EGYmi4SMHAT0jXv5pRIEmW+MF0hyUlV
	 yqOh35xIL2Twjuy46tHCDW8hyjz8aFmuOgAkfOC2Ab3tBX3yUdq5IsnvOlt4BDIkUZ
	 DKf866zbEsVW2T7qiyzM01IAYeA9vvCDoXa0vdeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1187/2651] arm_mpam: Switch to kvzmalloc_objs() for allocation of component cfg
Date: Wed, 18 Nov 2026 15:40:27 +0100
Message-ID: <20261118150330.734708781@linuxfoundation.org>
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

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit 046384f02b57da84a697d32aff7d7d46e881ae84 ]

Each component cfg is sized by the size of a per-PARTID multiplied by the
number of PARTIDs. On a platform sized to push the limits of the
specification, the allocation using kzalloc_objs() will consistently
fail. Change to use kvzmalloc_objs() so that large allocations fall back to
vmalloc() based allocations.

Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index e859e877ca839..30d08d1634a2b 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -157,7 +157,7 @@ static void mpam_free_garbage(void)
 		if (iter->pdev)
 			devm_kfree(&iter->pdev->dev, iter->to_free);
 		else
-			kfree(iter->to_free);
+			kvfree(iter->to_free);
 	}
 }
 
@@ -2692,7 +2692,7 @@ static int __allocate_component_cfg(struct mpam_component *comp)
 	if (comp->cfg)
 		return 0;
 
-	comp->cfg = kzalloc_objs(*comp->cfg, mpam_partid_max + 1);
+	comp->cfg = kvzalloc_objs(*comp->cfg, mpam_partid_max + 1);
 	if (!comp->cfg)
 		return -ENOMEM;
 
-- 
2.53.0



