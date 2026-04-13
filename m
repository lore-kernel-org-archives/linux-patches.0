Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569362D5A19;
	Mon, 13 Apr 2026 16:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098056; cv=none; b=ib4vKMIkvKc3HPTtEsFxB3oela0iQIqJIrg+uW3/vzpBL/xe34xBhj53b4DhqwTcYgSRzEDgbeKR7qTA6FP9Wi7HnPAznzL12ln49SYanvr/zz0gv5GGd0wueWHvONz+HenT4hez4ECOj76CZuTYfZWjCAg1LZmDlbC6Sm2o4l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098056; c=relaxed/simple;
	bh=crsVvqVWMgAx52gQT3KfMl4S5Q4urkds7f1TLPQ1tGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Chbsyq7nO8NxoJ6/vySnacpfkR5ZYWAvW8Dzr4XWufuTiKkSWY+jh0r3ymu9NhyNq4Hq3Kq8O8gqUDgZC4TneJRVa/ZvgdB5nZNfDxxACJH2x56PdRDcu3nXSSaJkaLAeE+QHS7QvAcsqpMeM2RDMsSuv+fs/cv4aYwtbrEPQzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj4xtr6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj4xtr6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C599C2BCAF;
	Mon, 13 Apr 2026 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098056;
	bh=crsVvqVWMgAx52gQT3KfMl4S5Q4urkds7f1TLPQ1tGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aj4xtr6yp5YwU0E0eg9Q1bodekR2pBu3wPjLrf+oSP79xy1WdaVHml8cS0OqoYA7/
	 uZlaS2Q7F2RviE8StFAVcUCM9rg+K2w4eeJpbNCzz2QlJoBe9rpJU/OT1IbfAv+RTx
	 SLaYsVOqERhtxPiSeT8bYzgtsJva/U9E9BLm9RYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable <stable@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5.15 377/570] scsi: ses: Handle positive SCSI error from ses_recv_diag()
Date: Mon, 13 Apr 2026 17:58:28 +0200
Message-ID: <20260413155844.600710001@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


