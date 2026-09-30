Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C24511235;
	Wed, 30 Sep 2026 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792836; cv=none; b=Rb+YGtev+wQ61Xn67+bZLhCkHsReUPgHUUqIGNFklz4no+/8r3rbSeJHqX7hrOzXHIXu46/NA0nCv9i116sXdNiuzyFxVuYDpJnewrZURRmAusjyA6s6Ar4wM9JjjqBrsMcIFmmxj1BEmQTqM/jZeiCYtmV39/FLrgbheCGdoR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792836; c=relaxed/simple;
	bh=4nTbU4Fjv/Itzgk3xYSZ+j/Mm0OhBCDAjFRJLxziKFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORvJPgxfW0Mnz1U+/X2k7owyNns5kIimJl3X123GyXBQGQI0pC9UABtDMxujFcG1cBIaBWkydlouJJz0wR2RKkuo3Kipk/DfKgARrBjeNpI/0VRUfgYxUemyyA5JFhcLoS456mLTjQy27Vmmh/b+Cz6wMombydrP8cXi/11uqcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxhTC6at; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxhTC6at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1A51F000FF;
	Wed, 30 Sep 2026 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792835;
	bh=wG+/ux8dCmb4GIzQZoSH3sjBRHdmsq2q6Aim/UhQyXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxhTC6atXFbFi6eebQH6iQBIUH+21oAtE6z2x7C5K3HEgMrfyQDzzCREYtiVy04He
	 tX2xYhCBt15zH3boYQx0quomphqLrBHjY467dxkDS8D/aojnsG6mDPA71z3wqmkRMP
	 z1biR2cUGwrd6ewuNiMzlRu2R9QKZLvQa8HpCRVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZHOU Jiaxiang <me@fxti.xyz>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/395] scsi: sd_zbc: Reject disks with too many zones
Date: Wed, 30 Sep 2026 17:25:05 +0200
Message-ID: <20260930152341.563609647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index a8db66428f80d..6f566d4f7706b 100644
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



