Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236B327F758;
	Mon, 18 Aug 2025 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524952; cv=none; b=OxVGy2xNn/qFv8pYp5XsxsmfS7aAmyVV8iFNrgsv20mqx7UwoOeQk2EzMShj1jWMefhCo1ZdwXCAdQgkipMwccGfBm19Q+gNKKlWSwVRLogDo8pfw9xdLw24S3uEoAnY7lanCtk+npoEA1DVq37xPiEdN0LddDcNrUewLhweixg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524952; c=relaxed/simple;
	bh=ey9z6U4ceqV4TeUDJewi8O465GyDJzHVvh777RN3XGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIK277Bewk7qRZkL9VOMBh8ABxfxz7bbMN9rJl+bHCPi9KNiJ9W4jsmr5OgVUm9pFVh0/MLe93Q+zRNvB6azyl7MuxT+UO0UbzoUoprXhiC6yn8SUyHZ3GsNjMGiZzjr6fGggNyq8Yawf6fNYX3efMamt9tjgm1RBa+DuFjRvHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfKJqg3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfKJqg3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2D3C4CEEB;
	Mon, 18 Aug 2025 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524952;
	bh=ey9z6U4ceqV4TeUDJewi8O465GyDJzHVvh777RN3XGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfKJqg3kevaN1GSU+DtVhVV5rdNtEdrjq+82+b0NVhVWNtR/3n2hosNBhWrV/cnSK
	 Gzr3RVYFyBgL941B6wA9RHooTnmty7YRo0V0SJQrB8NU9NwlgzIvp/zXfFbXxxhWbL
	 z8kRkd7Z75AnqH7a0qHOqqYL3RuOaRmNE+XKsajc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 114/570] ata: libata-sata: Disallow changing LPM state if not supported
Date: Mon, 18 Aug 2025 14:41:41 +0200
Message-ID: <20250818124510.204045599@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index cb46ce276bb1..47169c469f43 100644
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



