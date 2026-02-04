Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EACF28853A;
	Wed,  4 Feb 2026 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217812; cv=none; b=rwQ6rxSJaqedoqyYTa7pKxNAOl+6Js6ck/1d+x4H7pNbxeA1g5eKwx3urslr+5jucwnD5NUijB7kWfyOLRKzxqutYbDokP5uh9TrjpENZ9qyJtJNR1MQsxeTK4e6lU1eoyg7WG2i7pnd5GajXtwq1IvrhHeLwspN+/EwmwZA3VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217812; c=relaxed/simple;
	bh=GBk689YEUVqWXhVuwcCK+9AzgzUlq5AHShYh6dSMS8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chR/KMq91OcyHWD1VvfMQ1bgCDUR4KS49Qh92QDNSjE8QZ8vvJQMptuMlfBgM+dLxghhTqzr3AmrTEG3Kctv0uOUokcVy2Q1gIpkIu8TUph5hWeyNkxyaTt1SMyiyiFst9M8JxqXrjpMce+AfRifDUCrO7ODXE2WKy0j5yziu1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEmKBYoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEmKBYoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD262C4CEF7;
	Wed,  4 Feb 2026 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217812;
	bh=GBk689YEUVqWXhVuwcCK+9AzgzUlq5AHShYh6dSMS8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEmKBYoYiWDPNZL6n7Fc8wf7nps8Dsh9Tj/JFBEP+4Isnzz0MBbri55VmgZy85i/p
	 GOkpcLYvuIZXQxZf9vBk9JIs82GWQXA34sPFnokD2RdrDw29XVLaYEe9PFxOTUHhVC
	 NmvcPnBxXjPB6y3BBCrMalrc9RaQaZLAZPybQc50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/280] ata: libata: Introduce ata_ncq_supported()
Date: Wed,  4 Feb 2026 15:37:46 +0100
Message-ID: <20260204143912.966509643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit fa5bde139ee43ab91087c01e690c61aec957c339 ]

Introduce the inline helper function ata_ncq_supported() to test if a
device supports NCQ commands. The function ata_ncq_enabled() is also
rewritten using this new helper function.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Stable-dep-of: c8c6fb886f57 ("ata: libata: Print features also for ATAPI devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/libata.h | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 363462d3f0773..99886930fb819 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1694,21 +1694,35 @@ extern struct ata_device *ata_dev_next(struct ata_device *dev,
 	     (dev) = ata_dev_next((dev), (link), ATA_DITER_##mode))
 
 /**
- *	ata_ncq_enabled - Test whether NCQ is enabled
- *	@dev: ATA device to test for
+ *	ata_ncq_supported - Test whether NCQ is supported
+ *	@dev: ATA device to test
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  *
  *	RETURNS:
- *	1 if NCQ is enabled for @dev, 0 otherwise.
+ *	true if @dev supports NCQ, false otherwise.
  */
-static inline int ata_ncq_enabled(struct ata_device *dev)
+static inline bool ata_ncq_supported(struct ata_device *dev)
 {
 	if (!IS_ENABLED(CONFIG_SATA_HOST))
-		return 0;
-	return (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ_OFF |
-			      ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ;
+		return false;
+	return (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ;
+}
+
+/**
+ *	ata_ncq_enabled - Test whether NCQ is enabled
+ *	@dev: ATA device to test
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	true if NCQ is enabled for @dev, false otherwise.
+ */
+static inline bool ata_ncq_enabled(struct ata_device *dev)
+{
+	return ata_ncq_supported(dev) && !(dev->flags & ATA_DFLAG_NCQ_OFF);
 }
 
 static inline bool ata_fpdma_dsm_supported(struct ata_device *dev)
-- 
2.51.0



