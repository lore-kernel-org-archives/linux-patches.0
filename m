Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B323320392;
	Mon, 18 Aug 2025 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521662; cv=none; b=JC4E4QppgvCUc9KnJwxIpx+KkAY44zo1AJTanOnEOH6dpcKxcenc6wAfBtKghwS1vDmQxztI1hoOO+eksbDA6ppnjoFcUk70ZHBrD39WoNeT8dOEqH2QAp+6jfRmZd4dQYXoROGTxr3+739tD8KtQrKwYf/72wH5NkvHlFCtf3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521662; c=relaxed/simple;
	bh=ciPbUYlBRRi7nPFpPIAZcwtZcDr317tC9R1yIl9r+2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lF5EtsVZetUpcXD+zg0ZIMhXK7yasGzfbCN1ML1zEB/Te0n15mRWxOeGTrPxGIZK3z1D3upostvycf3Iao9kxi8H9wRKYA3+mM5ZZvj9nSfLhdmewXvTD2oRhTGZszu39fjXYBD97rReZjTALh6bUU5knd5q9y57YB+YTDyloRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkA78ccE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkA78ccE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70848C4CEEB;
	Mon, 18 Aug 2025 12:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521662;
	bh=ciPbUYlBRRi7nPFpPIAZcwtZcDr317tC9R1yIl9r+2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkA78ccEUCm6iMpMEBsKsESUFuT5+NgfzLQQ/e77NM0au9GfSQr98DFqZiw3OVj0f
	 3bqfXPCHr/zDd/cumAgnPxyrvilAJpJc+VkyYc4mteqGZik0824P+kD59llJl6Csnm
	 j5AkVG0u7dnzWzQW13NjZPiu8y1df3/hMF60Gbio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/444] ata: libata-sata: Disallow changing LPM state if not supported
Date: Mon, 18 Aug 2025 14:41:52 +0200
Message-ID: <20250818124452.175029642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a7442dc0bd8e..f1e8dbc2d564 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -924,6 +924,11 @@ static ssize_t ata_scsi_lpm_store(struct device *device,
 
 	spin_lock_irqsave(ap->lock, flags);
 
+	if (ap->flags & ATA_FLAG_NO_LPM) {
+		count = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, &ap->link, ENABLED) {
 			if (dev->quirks & ATA_QUIRK_NOLPM) {
-- 
2.39.5



