Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568D930146A;
	Tue, 26 Aug 2025 13:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216116; cv=none; b=c1D0bnhptIkXUs0BW18IPK4DKvMqOGcJ5Ufxx6ppZxuIrEUsg59xaaYdgJpyS4m/eG7nUESaKNwHepeQxpUy+oTELt3nO8BdPlIiek442RWQKG9URE9H7fplXw3LeA1wnAksOMN3MnP57MbHstk0Wve+n/oRIgaq/beysN2kVMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216116; c=relaxed/simple;
	bh=KsOWl7X3Var+Ijw2qV4uBR23MAGs2bYlYeLJt0FGF0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFFd2HvFcFhaEwlnT/Qkmrrr7WIw/DGrpdW36fCey5qlWJvRrqEjWHB3l8mT3uqmxTg3At0qaBC2LIN6D5aizWdwzp57EpYWSqzMt61EF3gZ7hA3jBtmNGgj7dcXzAYIecrixPGX8rCq0yM9QgfVB69AsxmSJdpXf4cPPwFtumc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ec88x08/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ec88x08/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5CAC4CEF1;
	Tue, 26 Aug 2025 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216116;
	bh=KsOWl7X3Var+Ijw2qV4uBR23MAGs2bYlYeLJt0FGF0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ec88x08/sgu/HG3X5QLJXACcZMfkU0U1lZyxbDu0r6+km5F/pDX5WM3XE+mtcqPRq
	 fSrmvE+BwvXD40+4Sx/elzasNUx58BtlZZpnFAfeeatCBifxOLS0LKLnN8jpFZl0sV
	 SiQRpZyEcUHP2u1inGNImDipiOjSiBPTUcm2vHu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/644] ata: libata-sata: Disallow changing LPM state if not supported
Date: Tue, 26 Aug 2025 13:06:21 +0200
Message-ID: <20250826110953.568372474@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 04bdd53abf20..7cacb2bfc360 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -815,6 +815,11 @@ static ssize_t ata_scsi_lpm_store(struct device *device,
 
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



