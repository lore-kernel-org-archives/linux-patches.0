Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28301A275;
	Mon, 13 Apr 2026 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097997; cv=none; b=CM82iolbPpqhSeu0AcYhJL4GpYJ7gAEIvgahKQvqHFE6KNl1QTHdzadOtRjSdU7rBLJZFwT8LYIq1WdLqwo4sG6O7ZvJ/EjPlvZracbf4D1v/GnBTfbexc48li7QDnfK2SwtPqz0r8dyLWgyM883HI2L2CK79zINV11xX2uALv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097997; c=relaxed/simple;
	bh=PzhQdIPkLsvcBPvtkCjgEwaOIE14PjpbWYoULMPahUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jteqT+2rLHMD0JAx38aYcngMHVYrc8xFR+g+sOfAU0O0qqEvzY02Sw4ddzIT2nskcZDeBtl3rz9T5dh/F9hWndiMi1D3McqG1iVc57yA/kYWWjlH41WTfFKy6Z5gzcB42T6tuHKze1Ajqc8PQtuqDiEW4RMuKll66ePwC5m2fuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cho4GA5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cho4GA5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D218C2BCAF;
	Mon, 13 Apr 2026 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097996;
	bh=PzhQdIPkLsvcBPvtkCjgEwaOIE14PjpbWYoULMPahUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cho4GA5hVrrsefaE92vI1aoEykdtfVcBxFW/0yKFwtjoXQuo+GfPmSxGZyw6Rpf07
	 qlw3oOuxHMMKMnvhNxoLBcH6RobQigRK4SjFVx+QDAlb8UuX6CNCdrHv2I52buW84a
	 vs2ZSQi4FI5DAGj+z+BVloKoW2VS3RGR14a2e2bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/570] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
Date: Mon, 13 Apr 2026 17:58:04 +0200
Message-ID: <20260413155843.709697094@linuxfoundation.org>
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
index 87c5ed56e47bd..ecb2e8aed93bb 100644
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



