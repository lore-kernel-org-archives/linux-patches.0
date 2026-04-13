Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993263161BF;
	Mon, 13 Apr 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099339; cv=none; b=TfgFk1G9S58GIXm2wIufxpKN99lUENsr5Di1/MotfnOPLz2DLQVS856Y6q0Wsm6lZED5Ihznm4HVznvzFHpa+4HzKw+VxkSS3FkDXbFjnEctJTEA8/jU90+OcCqX2DJ8QTJLOhrMi8/AWc5p/wXSSJX6vYYBZjy110d+rVcxGKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099339; c=relaxed/simple;
	bh=HX1lAn0vVTiXbva4NIfPh9Lpi0rEtLWR1JRNmv5uq7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBopaBsbibF+qk8dR2o8mV9muvTEImWCOd5q2ufzySZouFDwVG4ucdfolgCHUwNS4AOG2frZnhXdoAmH8GfQ/Y4QRr0emctN45V9jYWzf2nWhkT/OyOZM/MW3snfPdBQAV03DpR5yDKqoV7OtN2M+1RDN0EmQq7agK7I4UOrrGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqNLI9Ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqNLI9Ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF68C2BCAF;
	Mon, 13 Apr 2026 16:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099339;
	bh=HX1lAn0vVTiXbva4NIfPh9Lpi0rEtLWR1JRNmv5uq7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqNLI9IatARSqoRisyX8/ddumHUgfNZ9Er0OSgVCRfzvgXNPKKnqMRKVLW72NCEKn
	 c0szDC6Q5IZ1pm5UUDbWOmFP6+PeXW5Ci4bLstxCPvOWHwxEGP/+ZsoN0GQJHSmkVa
	 MTEAoYtDTD8Ag8L6cV0QR6dw0btxGs6Pqa/Q/K/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable <stable@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5.10 302/491] scsi: ses: Handle positive SCSI error from ses_recv_diag()
Date: Mon, 13 Apr 2026 17:59:07 +0200
Message-ID: <20260413155830.349408916@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7a9f448d44127217fabc4065c5ba070d4e0b5d37 upstream.

ses_recv_diag() can return a positive value, which also means that an
error happened, so do not only test for negative values.

Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://patch.msgid.link/2026022301-bony-overstock-a07f@gregkh
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -184,7 +184,7 @@ static unsigned char *ses_get_page2_desc
 	unsigned char *type_ptr = ses_dev->page1_types;
 	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
-	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len) < 0)
+	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len))
 		return NULL;
 
 	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {


