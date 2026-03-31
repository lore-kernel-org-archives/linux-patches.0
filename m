Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0463F8E04;
	Tue, 31 Mar 2026 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975860; cv=none; b=AkRI1p7MORLJ30ih1InwHEmEq4o3cQphRLh1lD9CKqjfPxPno9gTbl2wqSTh2zfYvtp78Iu6R4dKhE3gepkAYv0lfXlpYY1RSssCjbIDDIXbLSptcwohuviaE8esPZNcF9CPXRwKZp7J9WtqIA25JSMwnKkjdlUsig/+LM6GpgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975860; c=relaxed/simple;
	bh=cgOUdgEIcpNWI9L9giO2B+YLIacZGTJBJvor4fLRNLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZz/j4PMLjW0u0Dv4SDDNvBJR6Vkp2P1xgqcgOY+DPpL8EfQX4hjyUQDALUQuBV0Fl0CTerTuUuvoVrOmn+IbgmPYPmf2Ux/fP731svsI5dTgvOrQOVzkmVKdj2Gm6G5VpMTAjOhlvQJx7ezRrPn+SVRCmwx8PGGNrs4cRiQVwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dk5ByqZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dk5ByqZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40A5C19423;
	Tue, 31 Mar 2026 16:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975860;
	bh=cgOUdgEIcpNWI9L9giO2B+YLIacZGTJBJvor4fLRNLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dk5ByqZeZex2vkIfng9pWmXmA+FxPLor54bJEFR8B1I32THXgjELNAtUlW1KlDxLA
	 TJureaeOXBt7QIWNDuaynzBq1bu6wnOD+Dq875u1DlZrB+FXAu0vuUov+XTJyLLYOE
	 DvZSS22bVzf5fDpqBAEHRRnwmSjuAZkugR+/r1KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/244] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
Date: Tue, 31 Mar 2026 18:21:05 +0200
Message-ID: <20260331161745.912404024@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit d71afa9deb4d413232ba16d693f7d43b321931b4 ]

After commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard
and multi-channel scans"), if the device supports multiple channels (0 to
shost->max_channel), user_scan() invokes updated sas_user_scan() to perform
the scan behavior for a specific transfer.  However, when the user
specifies shost->max_channel, it will return -EINVAL, which is not
expected.

Fix and support specifying the scan shost->max_channel for scanning.

Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260317063147.2182562-1-liyihang9@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index d322802c7790f..f21d2be7ef1b6 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1732,7 +1732,7 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		break;
 
 	default:
-		if (channel < shost->max_channel) {
+		if (channel <= shost->max_channel) {
 			res = scsi_scan_host_selected(shost, channel, id, lun,
 						      SCSI_SCAN_MANUAL);
 		} else {
-- 
2.53.0



