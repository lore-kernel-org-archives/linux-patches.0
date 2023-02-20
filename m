Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367863B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1BFC433D2;
	Mon, 20 Feb 2023 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900429;
	bh=sF4/1HNcqnFN/pTjuRH6P+HedomVoKSYRrdd7ppdxOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGdb0+Rte9IyLgfcg1hN+D3tWDojil15tqIbjZTZ3LBmv2LeoRudmIAbgCiVSZhbI
	 hVcRdPvFuNi1U2R0uoCJzrsKBwI1w5ymQyDbrY8GLOWvj5+NF5eCg6SWBYy0ToqfdO
	 fB8QmbDii1GGHZNU9aC7WSeorm27vBEE5TrhikqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marius Dinu <marius@psihoexpert.ro>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/89] ata: libata: Fix sata_down_spd_limit() when no link speed is reported
Date: Mon, 20 Feb 2023 14:35:05 +0100
Message-Id: <20230220133553.305887138@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 69f2c9346313ba3d3dfa4091ff99df26c67c9021 ]

Commit 2dc0b46b5ea3 ("libata: sata_down_spd_limit should return if
driver has not recorded sstatus speed") changed the behavior of
sata_down_spd_limit() to return doing nothing if a drive does not report
a current link speed, to avoid reducing the link speed to the lowest 1.5
Gbps speed.

However, the change assumed that a speed was recorded before probing
(e.g. before a suspend/resume) and set in link->sata_spd. This causes
problems with adapters/drives combination failing to establish a link
speed during probe autonegotiation. One example reported of this problem
is an mvebu adapter with a 3Gbps port-multiplier box: autonegotiation
fails, leaving no recorded link speed and no reported current link
speed. Probe retries also fail as no action is taken by sata_set_spd()
after each retry.

Fix this by returning early in sata_down_spd_limit() only if we do have
a recorded link speed, that is, if link->sata_spd is not 0. With this
fix, a failed probe not leading to a recorded link speed is retried at
the lower 1.5 Gbps speed, with the link speed potentially increased
later on the second revalidate of the device if the device reports
that it supports higher link speeds.

Reported-by: Marius Dinu <marius@psihoexpert.ro>
Fixes: 2dc0b46b5ea3 ("libata: sata_down_spd_limit should return if driver has not recorded sstatus speed")
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Tested-by: Marius Dinu <marius@psihoexpert.ro>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6d110a1c090d..4a7da8f744e0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3112,7 +3112,7 @@ int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
 	 */
 	if (spd > 1)
 		mask &= (1 << (spd - 1)) - 1;
-	else
+	else if (link->sata_spd)
 		return -EINVAL;
 
 	/* were we already at the bottom? */
-- 
2.39.0



