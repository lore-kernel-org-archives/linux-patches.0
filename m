Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C307DA9E;
	Thu, 15 Aug 2024 13:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729695; cv=none; b=gvpErqKvvQO7k6le0tm6t12vwNnL7U5omPT/ZUiurVY7BRuQARyn8F5is1nEWztuIzTUMPWYzydDEyP3o3odIQCSRIirdqGO1YgAVSKPOvl6rJfY3dCC+8cXtuFFxMpZF+pOaeNsz7DDNF6gflyEF+rUYaluBrcOBmQHvWDHlq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729695; c=relaxed/simple;
	bh=lSjm/iW5oAchI3MvHwFofBL5/bB1voIt2QWCBOpwxQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yfr10B/DF2i6KgQKcy0Vv88NrM0vZGnZ01GimZlBVct4rzqpEaDP9j+p4XBll3ckE3Etw1XStLEYx4Kiq1mQ7XZ2SQx3n06kvXI9/Hn/mgzaJjtN0e3vgTl8qh7yhqXJYNbfWYBp8U22Jd3kv8LhvEmC90F2TAAi/HBJQ+XO7NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hfo4lpX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hfo4lpX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C48C32786;
	Thu, 15 Aug 2024 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729694;
	bh=lSjm/iW5oAchI3MvHwFofBL5/bB1voIt2QWCBOpwxQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hfo4lpX0/3YZZSq13uWOABwe5eYGgOpKdjwG30yyvokl4XIAS5W+cKaHIaPhYVXLr
	 3WdGA1CFUV4SJTUxVhAQ10eLa6j6yIT2jzmb/LlbsUejDofQ6mSSgfJlpasn41bMGw
	 geBVwUD6N8TYAFd41yZ1MWPTzrtBGNBztPYTlrIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5.15 179/484] ata: libata-scsi: Honor the D_SENSE bit for CK_COND=1 and no error
Date: Thu, 15 Aug 2024 15:20:37 +0200
Message-ID: <20240815131948.331340891@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Igor Pylypiv <ipylypiv@google.com>

commit 28ab9769117ca944cb6eb537af5599aa436287a4 upstream.

SAT-5 revision 8 specification removed the text about the ANSI INCITS
431-2007 compliance which was requiring SCSI/ATA Translation (SAT) to
return descriptor format sense data for the ATA PASS-THROUGH commands
regardless of the setting of the D_SENSE bit.

Let's honor the D_SENSE bit for ATA PASS-THROUGH commands while
generating the "ATA PASS-THROUGH INFORMATION AVAILABLE" sense data.

SAT-5 revision 7
================

12.2.2.8 Fixed format sense data

Table 212 shows the fields returned in the fixed format sense data
(see SPC-5) for ATA PASS-THROUGH commands. SATLs compliant with ANSI
INCITS 431-2007, SCSI/ATA Translation (SAT) return descriptor format
sense data for the ATA PASS-THROUGH commands regardless of the setting
of the D_SENSE bit.

SAT-5 revision 8
================

12.2.2.8 Fixed format sense data

Table 211 shows the fields returned in the fixed format sense data
(see SPC-5) for ATA PASS-THROUGH commands.

Cc: stable@vger.kernel.org # 4.19+
Reported-by: Niklas Cassel <cassel@kernel.org>
Closes: https://lore.kernel.org/linux-ide/Zn1WUhmLglM4iais@ryzen.lan
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20240702024735.1152293-4-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -872,11 +872,8 @@ static void ata_gen_passthru_sense(struc
 				   &sense_key, &asc, &ascq, verbose);
 		ata_scsi_set_sense(qc->dev, cmd, sense_key, asc, ascq);
 	} else {
-		/*
-		 * ATA PASS-THROUGH INFORMATION AVAILABLE
-		 * Always in descriptor format sense.
-		 */
-		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
+		/* ATA PASS-THROUGH INFORMATION AVAILABLE */
+		ata_scsi_set_sense(qc->dev, cmd, RECOVERED_ERROR, 0, 0x1D);
 	}
 
 	if ((cmd->sense_buffer[0] & 0x7f) >= 0x72) {


