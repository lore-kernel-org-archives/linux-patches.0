Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73474191F98;
	Tue, 26 Aug 2025 12:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212720; cv=none; b=lteUqpb5gMJE7PtPbjbjDvyX28d2LT2x0GGYurlQQwts339pa1ewDqlDIPpJy7EE63dxGfGP7gyVrKxOmvWZ73V5MkbAxRkIWLSC5loqRNJVSsARjvCG6thgKq8teOmgCAqWTHOjgrJuJ6Fpjoa5ytjzUUvX76B2zP5Jg0LAyNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212720; c=relaxed/simple;
	bh=YanGN13DcQip7C3YjbaMPN9Zwv3Sy9nAHJ9BxImq2Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdhpRt4tVKvhGQ1na9XOCDW0YKR+0mgGo0nC3mzX3K1TVEwvojhRSuqPigb5TweFw2A1BCjn0HsuXFPvX95UwfrKWN26ggnsUd5dAEPmPC//Aogf/vIHx2IThe7gMWiV12dPj3Lz/ggEYYEEsOHDuw/jT/D1kO8bEsgmylkuOHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bj3bAGOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bj3bAGOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E70AC4CEF1;
	Tue, 26 Aug 2025 12:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212720;
	bh=YanGN13DcQip7C3YjbaMPN9Zwv3Sy9nAHJ9BxImq2Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bj3bAGOoRj+2/cYZGPS7zcm17A4EGFOcbEaIFd1++Liip/SK/dPkHZUf6Y/VlZUcw
	 vOSab18qmDgce3WfpINonQZX/H5js6i/Kem3GeT1X67F8okj4qQlNgcT8Q1cXJqoxx
	 +9i8CvX9dV/kKZivATMfhB85OHdMSQfgG7C7WQjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/587] ata: libata-sata: Disallow changing LPM state if not supported
Date: Tue, 26 Aug 2025 13:03:45 +0200
Message-ID: <20250826110954.868333952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 413e800cadbf67550d76c77c230b2ecd96bce83a ]

Modify ata_scsi_lpm_store() to return an error if a user attempts to set
a link power management policy for a port that does not support LPM,
that is, ports flagged with ATA_FLAG_NO_LPM.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250701125321.69496-6-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sata.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index be72030a500d..9e0a820d6961 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -817,6 +817,11 @@ static ssize_t ata_scsi_lpm_store(struct device *device,
 
 	spin_lock_irqsave(ap->lock, flags);
 
+	if (ap->flags & ATA_FLAG_NO_LPM) {
+		count = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, &ap->link, ENABLED) {
 			if (dev->horkage & ATA_HORKAGE_NOLPM) {
-- 
2.39.5



