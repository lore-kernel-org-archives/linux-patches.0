Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2EE3419D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPj+mx2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E15C433C9;
	Mon,  9 Oct 2023 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859535;
	bh=b39lAXdOCKZAOuWI6C5iFR5RoPKjUNtL/HYcZVkl/9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPj+mx2VTFiDjcKZC4OrkbDyyWLU29A9A95+FLYxcVFIxoYBbdCGDJNQ6ni/ukrPl
	 qZzff56BW6/scbglv6Eo79KCjQilUXMWAogQ9raqzPRZ2lQlZYuvja2+6vj/0J+Bvm
	 P8xrmlw4FWGwAvPU0go6CmW7ACLj9Trst6SGp4Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 4.19 52/91] ata: libata-scsi: ignore reserved bits for REPORT SUPPORTED OPERATION CODES
Date: Mon,  9 Oct 2023 15:06:24 +0200
Message-ID: <20231009130113.323263487@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4561,7 +4561,7 @@ void ata_scsi_simulate(struct ata_device
 		break;
 
 	case MAINTENANCE_IN:
-		if (scsicmd[1] == MI_REPORT_SUPPORTED_OPERATION_CODES)
+		if ((scsicmd[1] & 0x1f) == MI_REPORT_SUPPORTED_OPERATION_CODES)
 			ata_scsi_rbuf_fill(&args, ata_scsiop_maint_in);
 		else
 			ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);


