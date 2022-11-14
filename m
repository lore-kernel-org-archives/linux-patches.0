Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF034C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A945C4314E;
	Mon, 14 Nov 2022 12:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430785;
	bh=Z+rTfa/AtkrF/BI6MXsGhMOYDsUY3XTy539dXb1YD50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDbDo0TxujwUhCTc5ra/XkbGEbGyzVYToM52WklCad7bpsm2AmHm1ozzA5Hu/M1zR
	 XkLzDs0w3DkLGi/AiejouPyHLnZm4kmCyPLS21jhII/IoEOPanor+k0C6MSz0RvcIA
	 fmcJKLitgDo+o8UhjRzu7+1AC/9+PXwjaACP6Msc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.15 097/131] ata: libata-scsi: fix SYNCHRONIZE CACHE (16) command failure
Date: Mon, 14 Nov 2022 13:46:06 +0100
Message-Id: <20221114124452.823975965@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit ea045fd344cb15c164e9ffc8b8cffb6883df8475 upstream.

SAT SCSI/ATA Translation specification requires SCSI SYNCHRONIZE CACHE
(10) and (16) commands both shall be translated to ATA flush command.
Also, ZBC Zoned Block Commands specification mandates SYNCHRONIZE CACHE
(16) command support. However, libata translates only SYNCHRONIZE CACHE
(10). This results in SYNCHRONIZE CACHE (16) command failures on SATA
drives and then libata translation does not conform to ZBC. To avoid the
failure, add support for SYNCHRONIZE CACHE (16).

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3259,6 +3259,7 @@ static unsigned int ata_scsiop_maint_in(
 	case REPORT_LUNS:
 	case REQUEST_SENSE:
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 	case REZERO_UNIT:
 	case SEEK_6:
 	case SEEK_10:
@@ -3925,6 +3926,7 @@ static inline ata_xlat_func_t ata_get_xl
 		return ata_scsi_write_same_xlat;
 
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 		if (ata_try_flush_cache(dev))
 			return ata_scsi_flush_xlat;
 		break;
@@ -4170,6 +4172,7 @@ void ata_scsi_simulate(struct ata_device
 	 * turning this into a no-op.
 	 */
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 		fallthrough;
 
 	/* no-op's, complete with success */


