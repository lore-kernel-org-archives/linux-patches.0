Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61CA4266BA;
	Tue, 31 Mar 2026 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975982; cv=none; b=V6akIx+/9vhD0r8/uIWf6yDcu+IxshFxV4dQL1dQnWQgLBsUJJN5V3mHAmJqFnNLXLN3cgwYuAL95iD1Lv17k9IH7x4ZvFknmdpEqMiWV9C6B0fXLRCgG1AH7SDxf06zotChR74By7GubGu7kveJM2ZMDltxr96DP5Xe7dG+OPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975982; c=relaxed/simple;
	bh=+Uf/wVwP0KPYurecSXtSE0zkyssinIVEfoPKg64bdyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjQa0YxlLyREMORs8NDk2J3e4K9F9pLb+rKoc9qSkwEUCn2DpnXP7IVTMB+AhFRfP6eJ++NPeQk/n2xCW1d45XSW/7CM4+cMcPCHR0DjVd0WcBCN6btMi8MK5sBIsGkjPJZJwgx/zQnNcGR2Hkb98xDxzHqcgjjzR9GdiM0vOx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL4eBT7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL4eBT7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4B4C19423;
	Tue, 31 Mar 2026 16:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975981;
	bh=+Uf/wVwP0KPYurecSXtSE0zkyssinIVEfoPKg64bdyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vL4eBT7rK9sts9fat2PBwnfx94TyhQwnbq40QW+dYKQnyc2xImXnLafoAjsN3pgf5
	 PeRFaYfM+/J9qWzbi3l2aqBnuIk8ORrvEjhAFZV/YJ8gNuqzMuOexoPe7L/QFbR6R1
	 Kqwd9CRkUk6L8SJDTUCCZcAt33Bg9vnEu9IzYQi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable <stable@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6.12 161/244] scsi: ses: Handle positive SCSI error from ses_recv_diag()
Date: Tue, 31 Mar 2026 18:21:51 +0200
Message-ID: <20260331161747.712755991@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
@@ -216,7 +216,7 @@ static unsigned char *ses_get_page2_desc
 	unsigned char *type_ptr = ses_dev->page1_types;
 	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
-	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len) < 0)
+	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len))
 		return NULL;
 
 	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {


