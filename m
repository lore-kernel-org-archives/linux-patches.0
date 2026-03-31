Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45523E3C40;
	Tue, 31 Mar 2026 16:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975192; cv=none; b=lN+D1uX3QjATxRX7Xpo50r2cimod5vqK/uvcUpp7q8JlPFjZ+YKbNXElJwh85vEMWhiZx85yt5YKmbdLm0rqhB43jRLgg1R3uzHMiO4u6PbEkXLgYw84dg1N531PWfkWdiz10Qu137D9G3RbeDfwM34QKUagg3xEi5Jbthc/u7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975192; c=relaxed/simple;
	bh=CxGJm+S+z31V0MfW0ZtuF88uKsNZ5Y2Lqimtl8Sm5MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWZC5TrrMNm3flYui0zeIxkYJ4lBeefrBWlrzfGiKAYYRU/bliUNs1uTEfwvNPV2OZ2ZbEt102uswiZwnphWFnWRjZfNnTl/sxPRXkqjdhSCkys/Rbj6B/n5W6PoZxNoZUMxiB0XtGnTLXdvSBbPpMv9xOiuwMqMSUpiZuuO33Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgSmjMcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgSmjMcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471EEC19423;
	Tue, 31 Mar 2026 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975192;
	bh=CxGJm+S+z31V0MfW0ZtuF88uKsNZ5Y2Lqimtl8Sm5MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgSmjMcTIwbFUayEot39Xfd198nM+Z45/y9IXJ5/jO0fh6qQKjJQkO9HzDdF7pt+F
	 VAbVawr+YG230DHP5gwhhJTDsKPYUl4vslGNRJK//IgLnqJ8sn/zmTSlprAzyo+2SL
	 1k60sYXxopyInTvJXIHQ0M6c63FXY5GSS/KgcGTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 166/342] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
Date: Tue, 31 Mar 2026 18:19:59 +0200
Message-ID: <20260331161805.119341934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index d69c7c444a311..081c168094374 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1734,7 +1734,7 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		break;
 
 	default:
-		if (channel < shost->max_channel) {
+		if (channel <= shost->max_channel) {
 			res = scsi_scan_host_selected(shost, channel, id, lun,
 						      SCSI_SCAN_MANUAL);
 		} else {
-- 
2.53.0



