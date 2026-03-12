Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BD8401A28;
	Thu, 12 Mar 2026 20:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346496; cv=none; b=NNikekbtJjhC5a9OYEatnDkXMHDC0GVklXovWiF+aGUdEtId2N+Wht8URySgY7X60yD/BU6QxhGiHFKts98aZ28swA4MUgdGoYgHFzBHLHNcp4HXD2RAyux/AfAWCY2B3L77Rz4gQartnXnW0d7a3qjzYdNZj8SI0uGKqh2bQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346496; c=relaxed/simple;
	bh=d/K72toNHr5A2NAa1t+UbRdqn49etuHObZiIr8Sr+cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtJ39jojsjrtVhYGYfLN+cn6yQNp3vPB2sdVVTm0EDwK20CVpzQx3Bm7V6i/sVLpB31FjJm1/zUT509wLSFTCWQTRXhputTAVtfuUugF9eicdPDrSWvtxeOFIxHZdKWOcp6U/1dcrbW2hyBJKgnx7XjelkpojGRi8WECaxW9Jzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W58hZFdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W58hZFdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17827C4CEF7;
	Thu, 12 Mar 2026 20:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346495;
	bh=d/K72toNHr5A2NAa1t+UbRdqn49etuHObZiIr8Sr+cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W58hZFdCcKuMgrYZyyyfCy1oEUnWB0apmWu99basLhJXx7gxYajB+GGquFKVEo4gb
	 oFxLkGNYlW6Xy04Tdcz8wwpyaE5W215zNyEd3Rpmh8xZaFACPeBjSrR9mKXao4bX+e
	 TckU7z5ID44VJAIVE/6hlKph/XtTT3NFUz0ZcmCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/265] ata: libata-scsi: Refactor ata_scsiop_maint_in()
Date: Thu, 12 Mar 2026 21:07:24 +0100
Message-ID: <20260312201020.271407867@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 4ab7bb97634351914a18f3c4533992c99eb6edb6 ]

Move the check for MI_REPORT_SUPPORTED_OPERATION_CODES from
ata_scsi_simulate() into ata_scsiop_maint_in() to simplify
ata_scsi_simulate() code.

Furthermore, since an rbuff fill actor function returning a non-zero
value causes no data to be returned for the command, directly return
an error (return 1) for invalid command formt after setting the invalid
field in cdb error.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20241022024537.251905-4-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e5857229f0b7a..c214f0832714c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3425,12 +3425,16 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	struct ata_device *dev = args->dev;
 	u8 *cdb = args->cmd->cmnd;
 	u8 supported = 0, cdlp = 0, rwcdlp = 0;
-	unsigned int err = 0;
+
+	if ((cdb[1] & 0x1f) != MI_REPORT_SUPPORTED_OPERATION_CODES) {
+		ata_scsi_set_invalid_field(dev, args->cmd, 1, 0xff);
+		return 1;
+	}
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
 		ata_dev_warn(dev, "invalid command format %d\n", cdb[2]);
-		err = 2;
-		goto out;
+		ata_scsi_set_invalid_field(dev, args->cmd, 1, 0xff);
+		return 1;
 	}
 
 	switch (cdb[3]) {
@@ -3498,11 +3502,12 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	default:
 		break;
 	}
-out:
+
 	/* One command format */
 	rbuf[0] = rwcdlp;
 	rbuf[1] = cdlp | supported;
-	return err;
+
+	return 0;
 }
 
 /**
@@ -4418,10 +4423,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		break;
 
 	case MAINTENANCE_IN:
-		if ((scsicmd[1] & 0x1f) == MI_REPORT_SUPPORTED_OPERATION_CODES)
-			ata_scsi_rbuf_fill(&args, ata_scsiop_maint_in);
-		else
-			ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
+		ata_scsi_rbuf_fill(&args, ata_scsiop_maint_in);
 		break;
 
 	/* all other commands */
-- 
2.51.0



