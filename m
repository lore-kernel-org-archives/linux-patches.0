Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0AB18595E;
	Tue, 10 Sep 2024 09:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962193; cv=none; b=K/YrsYUcYz/t8WXUqJGXJB796ZU1xdPqBC4nKA4z7sdRfYP9Ihafyax1keoNuJf8SxmTEhR+bIkV9sV7a5DeBRpul8Xuyu59hwdAI8qxRCGQmbFcxbF66Q94ZaowuaC/KhGUH6x2YRa/R0/VvUdKz4eqbajSdtQIX91b2oVwjyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962193; c=relaxed/simple;
	bh=3KJO7d9h/csOxD2D0LwetUX14rStCoxR05IGQ+l5Y7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCcb7S/kqEaB7imNBb4MvES+S9vLDett1WNUGLJ/wzWMmDD/y2d2/Hw5TJ5BXNgoff+973iRYd5Q9Pkgn9rwx7aK4eHl7DRcHHL5hC25rGEY3/rf5moC5e7GF2SiE3Hkv5t6o1o8y69BeQTtl/6AXWGbtQS/uE/g7Vcgg+5JfmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1XXPQR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1XXPQR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C413FC4CEC3;
	Tue, 10 Sep 2024 09:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962193;
	bh=3KJO7d9h/csOxD2D0LwetUX14rStCoxR05IGQ+l5Y7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1XXPQR3HR7pcevtfPtCZoyghBMdXTd9igGTXwt+0YQyoVJo8vlyIW+iHZeKyRRfQ
	 0Wq+u5DY4SFKHZta8PjgafK05rYGRSSK/VgjaxFDnQx1SrTuqnQlPYV9dbHOz0iPOR
	 rbsP7h6X1LT24OLSB6FumLAmY2mafX9Ih3nXFxu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 327/375] ata: libata-scsi: Remove redundant sense_buffer memsets
Date: Tue, 10 Sep 2024 11:32:04 +0200
Message-ID: <20240910092633.554109230@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 3f6d903b54a137e9e438d9c3b774b5d0432917bc ]

SCSI layer clears sense_buffer in scsi_queue_rq() so there is no need for
libata to clear it again.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Link: https://lore.kernel.org/r/20240702024735.1152293-5-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 816be86c7993 ("ata: libata-scsi: Check ATA_QCFLAG_RTF_FILLED before using result_tf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4e0847601103..4deee71006ef 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -926,11 +926,8 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
-	unsigned char *sb = cmd->sense_buffer;
 	u8 sense_key, asc, ascq;
 
-	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
-
 	/*
 	 * Use ata_to_sense_error() to map status register bits
 	 * onto sense key, asc & ascq.
@@ -976,8 +973,6 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	u64 block;
 	u8 sense_key, asc, ascq;
 
-	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
-
 	if (ata_dev_disabled(dev)) {
 		/* Device disabled after error recovery */
 		/* LOGICAL UNIT NOT READY, HARD RESET REQUIRED */
-- 
2.43.0



