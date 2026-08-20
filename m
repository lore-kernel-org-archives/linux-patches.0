Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3045947D463;
	Thu, 20 Aug 2026 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243833; cv=none; b=Kij1y61/xbIsII1niOnMsjpdkz4gYkB48Eoa6HHu4fa+AUINb//xEe884CAn/+MJ2JVOcheu4SDJZPz/IgsEycjN3Dql8zUh+e0nQ9wxX/hdyg5xwUWOov9SMF/clAurctDSPSvPWZQu/7KGJmjJS5LHImO67w1CGRDX7FvshsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243833; c=relaxed/simple;
	bh=kvXHjudUEsCNP4mOzkWFtIpJUhJ3BGvRnkFlhf0X4hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/Ld1q4HLlDCW9aAwV1C2htRxRJoOyJHflbPDqBavS7uq7S65d/Yeuk2fYUKXPQbvfF4kFJMMz4XjAlYdf6DkH9oIUnzxROhnuTYoUzNNWEWMqH1DRNput3SjwTiLe5gQ02X7rlnMmtE14VYmS5ZG8Mm5PbkAATpagWf4Gm8iy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsgShhm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsgShhm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743981F000E9;
	Thu, 20 Aug 2026 16:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243832;
	bh=s/fA1Wd36a7VucKiwMFtfYEBQBsqUikv2pdrhAM2+Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsgShhm3tzgGHuVtZ6rQERGT82ZErqeAbT8cDnQlHZV9iFnKlwE/7DLu1KS0/3NGB
	 fw/38DQW0bMh3VOkQ+eED0x/nca76erfDpH/p8DaZjXAeeLIfx8pRK7Gc3DTk4RVeM
	 Bn26F23DHwNb8rW+sG1FEjK/N3LfgdRFIyhl3OU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/272] scsi: sd: sd_zbc: Use logical blocks as unit when querying zones
Date: Thu, 20 Aug 2026 16:56:54 +0200
Message-ID: <20260820145238.506673368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 43af5da09efb8abe450ec859d3063adeb7d1eb54 ]

When querying zones, track the position in logical blocks instead of in
sectors. This change slightly simplifies sd_zbc_report_zones().

Link: https://lore.kernel.org/r/20220421183023.3462291-4-bvanassche@acm.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: extracted this change from a larger patch ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 93dde0bf2f39 ("scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd_zbc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -223,7 +223,7 @@ int sd_zbc_report_zones(struct gendisk *
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+	sector_t lba = sectors_to_logical(sdkp->device, sector);
 	unsigned int nr, i;
 	unsigned char *buf;
 	size_t offset, buflen = 0;
@@ -234,7 +234,7 @@ int sd_zbc_report_zones(struct gendisk *
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
-	if (!capacity)
+	if (!sdkp->capacity)
 		/* Device gone or invalid */
 		return -ENODEV;
 
@@ -242,9 +242,8 @@ int sd_zbc_report_zones(struct gendisk *
 	if (!buf)
 		return -ENOMEM;
 
-	while (zone_idx < nr_zones && sector < capacity) {
-		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
-				sectors_to_logical(sdkp->device, sector), true);
+	while (zone_idx < nr_zones && lba < sdkp->capacity) {
+		ret = sd_zbc_do_report_zones(sdkp, buf, buflen, lba, true);
 		if (ret)
 			goto out;
 
@@ -262,7 +261,7 @@ int sd_zbc_report_zones(struct gendisk *
 			zone_idx++;
 		}
 
-		sector += sd_zbc_zone_sectors(sdkp) * i;
+		lba += sdkp->zone_blocks * i;
 	}
 
 	ret = zone_idx;


