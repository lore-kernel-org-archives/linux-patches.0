Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0AF374C4;
	Tue,  8 Apr 2025 11:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110807; cv=none; b=Ug2fcyPipdvLGcgT0tZlQ0t1y3H6rdX+fsxJOvXIMCC0iDtJXvKWwo5DaVJ/m7nz/MosDlEbHCy8vFpqifTvy27lm0fbkMy6mpcOk8Ff6jlAx9W6lGBV2Klj2EH1fS6BjgTP5wJS+ItkFlNxESOc6ArnleQOlXeRlD+LRlHXMt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110807; c=relaxed/simple;
	bh=C7ppG2FcHJmZnLBlvVZjUfJ8cyPsfW+MGm2DSR28KEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdPxupUPvLs7JpDCuHg2+MiiNXkqlwRk0bnsOkSchu+S9mNi9f5b/0blaVgzU/UKYFeFLRRnCsi/pKpC1v1hXF+WttWFewVqLgqXy8/WUFXguHMWeTlGbYqMbNje3phoA51OxrBItMp8vaHLLzRqehwPt/M+j92oMtgosn1KeTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lyx49dzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lyx49dzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E41C4CEE5;
	Tue,  8 Apr 2025 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110807;
	bh=C7ppG2FcHJmZnLBlvVZjUfJ8cyPsfW+MGm2DSR28KEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lyx49dzFt5qU9QFcFgxofaosVKrqaa3nF40EQofg/s/sFDIG7LW7kyi385dUka5r0
	 xvBr5G3mq2k2yQwkKKBhSjrTrx9Qyhyb/Wi+UnmUSkEcCPDy/njx4OSogI05DOMozE
	 T3Cvb0VTL76NUIAD4C2TCu855s0W3ZIJJblzJpes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 200/731] ata: libata: Fix NCQ Non-Data log not supported print
Date: Tue,  8 Apr 2025 12:41:37 +0200
Message-ID: <20250408104918.932107602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit b500ee5fde1bd0c85026dfcdadbc175548fb5216 ]

Currently, both ata_dev_config_ncq_send_recv() - which checks for NCQ
Send/Recv Log (Log Address 13h) and ata_dev_config_ncq_non_data() -
which checks for NCQ Non-Data Log (Log Address 12h), uses the same
print when the log is not supported:

  "NCQ Send/Recv Log not supported"

This seems like a copy paste error, since NCQ Non-Data Log is actually
a separate log.

Fix the print to reference the correct log.

Fixes: 284b3b77ea88 ("libata: NCQ encapsulation for ZAC MANAGEMENT OUT")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250317111754.1666084-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d956735e2a764..3d730c10f7bea 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2243,7 +2243,7 @@ static void ata_dev_config_ncq_non_data(struct ata_device *dev)
 
 	if (!ata_log_supported(dev, ATA_LOG_NCQ_NON_DATA)) {
 		ata_dev_warn(dev,
-			     "NCQ Send/Recv Log not supported\n");
+			     "NCQ Non-Data Log not supported\n");
 		return;
 	}
 	err_mask = ata_read_log_page(dev, ATA_LOG_NCQ_NON_DATA,
-- 
2.39.5



