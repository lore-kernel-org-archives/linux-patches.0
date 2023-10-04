Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102FA1DA3D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38111C433C8;
	Wed,  4 Oct 2023 18:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442944;
	bh=j5VYygMeyjvVyTY86HZkv0UNYIce+DChBKL9eNtt11U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRaaDbP6Fr1QxbU+LeMp/9v1W3pZIKLssZf8Esu0ndMJ8SSkP55zY4SLVyKnZLFVP
	 xRNd/cry0Vmo5/54diQItqwExvV8u2rtA72hndUW0q00rRS22N28wXH3uYAwlsIUUa
	 wjOY2vI/nyMjQmDygKYaIV1pfxP/9xYpKckk4nDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.15 165/183] ata: libata-scsi: ignore reserved bits for REPORT SUPPORTED OPERATION CODES
Date: Wed,  4 Oct 2023 19:56:36 +0200
Message-ID: <20231004175210.938460726@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <niklas.cassel@wdc.com>

commit 3ef600923521616ebe192c893468ad0424de2afb upstream.

For REPORT SUPPORTED OPERATION CODES command, the service action field is
defined as bits 0-4 in the second byte in the CDB. Bits 5-7 in the second
byte are reserved.

Only look at the service action field in the second byte when determining
if the MAINTENANCE IN opcode is a REPORT SUPPORTED OPERATION CODES command.

This matches how we only look at the service action field in the second
byte when determining if the SERVICE ACTION IN(16) opcode is a READ
CAPACITY(16) command (reserved bits 5-7 in the second byte are ignored).

Fixes: 7b2030942859 ("libata: Add support for SCT Write Same")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4214,7 +4214,7 @@ void ata_scsi_simulate(struct ata_device
 		break;
 
 	case MAINTENANCE_IN:
-		if (scsicmd[1] == MI_REPORT_SUPPORTED_OPERATION_CODES)
+		if ((scsicmd[1] & 0x1f) == MI_REPORT_SUPPORTED_OPERATION_CODES)
 			ata_scsi_rbuf_fill(&args, ata_scsiop_maint_in);
 		else
 			ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);


