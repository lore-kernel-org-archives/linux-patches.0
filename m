Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9595E47A0DD;
	Wed, 30 Sep 2026 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789020; cv=none; b=X9XTGyCoJJ/sq1bpjtWWOfZ38BJGZ9ula4/5HJhBb/Upv5sQsLUuqRTEdXGrcVoqwXr7LuiKmTHRWEZdmu2CdcxszSiWksQwX7k8/CigxJ//0AUkJgpyIgG1nMPHTrJymZd7HHgUOaOcavrxmTkqmCF9VslVbc8CMzY+E2FbUjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789020; c=relaxed/simple;
	bh=N5NJmzn6I89tcnMIWi12dt0+JnzPPO8m4PtxXL42cxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7dgFZ+Weo6eB2ODLmdGgQuSzl+iXuQQQEz9yIPgiV/cOGSuDjDz0KUuxHG3LHCzuf1NpQ1IUu7egLLwc+NlaKUwnJ/B306t/MBK1DqnJ7t//+i3pvsEMiwBSq9nRW1vy76wHkGrjrmah5RIgUZtQDTG0m+FeRea/zzmDtD/sJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXJriZ/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXJriZ/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25B01F00898;
	Wed, 30 Sep 2026 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789019;
	bh=6g1bNnblU3z3LHML/B8GFGQJH/sfBw96dK3EvV6kdB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXJriZ/B/ljHrENuVPFM6pR15Ik1ZGAJ8Y/J9o8+1PdOXxKrqIBbSm2Q+U+Jae5v8
	 MnEC3KyE5ozw8xE7+5lR+vFvIXh/6tV8FaVwIsRc9SMZkmQge45KfidfjLaUgwAruG
	 i0EzzMtRvHXPRRGVAqQJlExYv3tTh9FNr3p1+P/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZHOU Jiaxiang <me@fxti.xyz>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/877] scsi: sd_zbc: Reject disks with too many zones
Date: Wed, 30 Sep 2026 17:20:41 +0200
Message-ID: <20260930152421.802042825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZHOU Jiaxiang <me@fxti.xyz>

[ Upstream commit b6ec0f79745967c751c85df373062c8d15e45fc4 ]

sd_zbc_read_zones() computes the number of zones with 64-bit arithmetic and
stores the result in the unsigned int nr_zones field of struct
zoned_disk_info, silently truncating counts that exceed 32 bits. The
truncated count is later used to size per-zone resources, while the device
may still report more zones than fit.

Moreover, sd_zbc_report_zones() counts the reported zones with a signed int
zone_idx, which overflows past INT_MAX. Reject devices reporting more than
INT_MAX zones at scan time; such a device is not realistic for any medium
that exists today, and accepting it produces inconsistent zone bookkeeping.

Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
Signed-off-by: ZHOU Jiaxiang <me@fxti.xyz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/C41798AB5AA6BF2B+20260916135822.32584-3-me@fxti.xyz
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd_zbc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index b8d42098f0b68..b96b49763322a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -595,7 +595,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 		u8 buf[SD_BUF_SIZE])
 {
-	unsigned int nr_zones;
+	u64 nr_zones;
 	u32 zone_blocks = 0;
 	int ret;
 
@@ -627,6 +627,12 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 		goto err;
 
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
+	if (nr_zones > INT_MAX) {
+		sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",
+			  nr_zones);
+		ret = -EINVAL;
+		goto err;
+	}
 	sdkp->early_zone_info.nr_zones = nr_zones;
 	sdkp->early_zone_info.zone_blocks = zone_blocks;
 
-- 
2.53.0



