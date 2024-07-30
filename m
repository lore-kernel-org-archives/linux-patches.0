Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A7F1A6195;
	Tue, 30 Jul 2024 16:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357383; cv=none; b=GY1wqLQKpUl4nREXhJsaqpr4Ae3lORZ/Jr/0iUG47I7k1ZK7k94fSvPRceD6349KQNvKAK3Gpj+G0kC/RrEQw926O1utPRwtUG2fqVkWtWdSgyC2TdY1o5cXjmydig+pBxGSC0PKfJNLzylrv5tq5TH6VzQ9USuEJX2rhG2vqOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357383; c=relaxed/simple;
	bh=SsQ0kLyOlV23Iar5z3cD2IcYmfyULWF0DTLwQV2sUPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nrm0WI68PaTrTASSnY3lB0t1FtLOkMqx1QByLWbe5IwIUBKYlXX38SZPlb+Hd1gXrdr/6+CdSuiGFbuzJTDVuVVheSBzhWlOH12hzf7NVOnm/mAidKHHyNWhhMqWMPvVxeZjOicpmw7CKFBZi2bMyOqr5XDYfwvz7v9s20FQZZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVagbC/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVagbC/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7C2C4AF0C;
	Tue, 30 Jul 2024 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357383;
	bh=SsQ0kLyOlV23Iar5z3cD2IcYmfyULWF0DTLwQV2sUPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVagbC/bnfnWglFW5hnmoc7MlyZpVHnNn7lMHgB2gJ8wMawhtft7iVIfSqKgJi5tG
	 q1o4snN+3HyDoRIxT1xIGK/gSoSa2szl/BKhWvk1bgIt2a7RCISJhZXBjZryHkDxYk
	 gkFudPDiZNUD+eeXOLHsvYuOZKugRYoPufUcoi70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6.1 287/440] ata: libata-scsi: Honor the D_SENSE bit for CK_COND=1 and no error
Date: Tue, 30 Jul 2024 17:48:40 +0200
Message-ID: <20240730151627.040507186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -900,11 +900,8 @@ static void ata_gen_passthru_sense(struc
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


