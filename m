Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538784C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF9DC433C1;
	Mon, 14 Nov 2022 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431192;
	bh=GsEPf9UiXsPXAdRtpSzJ3L4F00fqPSfxMQNxEZmDn/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zH5iEJ2roO24WH8V+f/eoV1F3dsswHbTcD5R5/SwVw0TMFNPW0IQf0Q7m1pqssN8O
	 0La2GHEKYTXBA/mctwQv2jNV5L3Uorj+ZfCVGWEgT9MH+IaL1z9s9/H06jfjAD+bdL
	 5lK54qnBoEKZJK5qzBPAyN7rOrPWUSWpCMe4RrV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 6.0 133/190] ata: libata-scsi: fix SYNCHRONIZE CACHE (16) command failure
Date: Mon, 14 Nov 2022 13:45:57 +0100
Message-Id: <20221114124504.612148335@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
@@ -3266,6 +3266,7 @@ static unsigned int ata_scsiop_maint_in(
 	case REPORT_LUNS:
 	case REQUEST_SENSE:
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 	case REZERO_UNIT:
 	case SEEK_6:
 	case SEEK_10:
@@ -3924,6 +3925,7 @@ static inline ata_xlat_func_t ata_get_xl
 		return ata_scsi_write_same_xlat;
 
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 		if (ata_try_flush_cache(dev))
 			return ata_scsi_flush_xlat;
 		break;
@@ -4147,6 +4149,7 @@ void ata_scsi_simulate(struct ata_device
 	 * turning this into a no-op.
 	 */
 	case SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE_16:
 		fallthrough;
 
 	/* no-op's, complete with success */


