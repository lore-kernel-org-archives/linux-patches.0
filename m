Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA5E3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBEDC4339C;
	Tue,  7 Feb 2023 13:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775528;
	bh=mL2Xv086YHKFQ132QvU+UqfkzeMBMdu3wLN6CGZo3vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfaHvKk3YuaLXpLYu7hdKMajJtyWLFlhFVGSKfUtl9x9WrflbYwc1VA3mht3xTUjz
	 rnB6vyayzLwU93YZFCeGvdvRIVM9OKxF4TTJ+esw/P6IYKQVZPDiJxPuMNS5g+BKAq
	 NUpFPWk2k8Q/Mcep8xsQxkUENQJf3+XwPk6bo2x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marius Dinu <marius@psihoexpert.ro>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/120] ata: libata: Fix sata_down_spd_limit() when no link speed is reported
Date: Tue,  7 Feb 2023 13:56:54 +0100
Message-Id: <20230207125620.595951563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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
index c430cd3cfa17..025260b80a94 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3076,7 +3076,7 @@ int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
 	 */
 	if (spd > 1)
 		mask &= (1 << (spd - 1)) - 1;
-	else
+	else if (link->sata_spd)
 		return -EINVAL;
 
 	/* were we already at the bottom? */
-- 
2.39.0



