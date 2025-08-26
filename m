Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954AA34164F;
	Tue, 26 Aug 2025 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214226; cv=none; b=azAlANY24SJeO+skeaiXCN25HNF2TE5eso70p/lXhfqaXOjf6KWKyLAkzVpgfyUqw7ZWMxThjkAa2oFN1s/n4y4OLmlrHnXYFrZTgNt45lCwNF2ROC0Qj8+i6fMG/up5gSjSXKe6CdXuvAqEE3ylAdgNdX5iDB3Uvx4zPtwG9/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214226; c=relaxed/simple;
	bh=pbXsuTNwRbcFWSGx5P2I4o9ENy8ydqW3Uj7z5G+FDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiScXrmwkD3LESyqz2rHs10cSl3DFFsdsg0cKM3s+b+8ewCv/C6eNLMztVTruU8qIQNY76V4/Smg2+sjIne9YojYG1Rhv27MLgbdbSVXlTdwihc/3eR2Yg6FRR/IuQEwy3R9IxOPXd6qOalEMuGF7Cz6B00wPis1pSya1ytTHrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtzKqhzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtzKqhzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2950FC4CEF1;
	Tue, 26 Aug 2025 13:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214226;
	bh=pbXsuTNwRbcFWSGx5P2I4o9ENy8ydqW3Uj7z5G+FDVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtzKqhzT5JWzYKEj0szjN0MFUcag+R6tXeSBbGEGq7D+o6UIzWv72goKWk9oJ7hDd
	 VcxwkQVjKZSG/AfIVKQSsoYDU9DBYZ6iR6wDFKtXwJldw7xUikynsZUkQXwEGLK7u0
	 tWxxFdhLdY9IJOulGYwXhtdVlx3Liwa9XmB9KjN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/482] ata: libata-sata: Disallow changing LPM state if not supported
Date: Tue, 26 Aug 2025 13:05:12 +0200
Message-ID: <20250826110932.281644140@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 71a00842eb5e..b75999388bf0 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -812,6 +812,11 @@ static ssize_t ata_scsi_lpm_store(struct device *device,
 
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



