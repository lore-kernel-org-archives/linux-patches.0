Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC06A320393;
	Mon, 13 Apr 2026 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099326; cv=none; b=NVG5af4ppgpTQ/zz4r8Bw9TjqO7XY/4GKphwn8QXu+JoG+pCXQs8ZYuhKFybRZS4UMqvVGJY1sOSyyEZL9LR3ihNBK7rqI2eDZvjDijCOkmmp3yQJoF0CYfQWCWuBg6eOJReMpFxcEwWw70n9oPDj5ZODqFJ9w36JOAGd5fvBNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099326; c=relaxed/simple;
	bh=crvgMj6AHMvStLCh6tlzPaA59uAAkphoz5i4S/LsAMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGQjHnx19+QT8lOROR1n6D+iPKNGaFSTFKmY9xrtnwuVZHbE+xTMYZSApAs44u+5VKK+xoo7OkZ9J01siPv0wmAXn6toCMmAQumDLVvI/19vVLI5pVRiFpWPcle72ELotgDSEaUez9OyvYFYziW302XzLLkO8FKJ8mk+4Sv8JnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUfWDMan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUfWDMan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41956C2BCAF;
	Mon, 13 Apr 2026 16:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099326;
	bh=crvgMj6AHMvStLCh6tlzPaA59uAAkphoz5i4S/LsAMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUfWDManfJB2JWPT63JQUYsx3GBueX0cb0Mciaip81XIC5DsOMcLjGti7VzMkKdn5
	 n6iwEsg/GjYvz3JWjFFYeRgte+M+KEkpBywAjwVaTCrMVg33hxZSSeigiv6+bUZg9V
	 w9IYGimhjkfxB5RZdMYj6uWPm6pisgKK3qP2XW1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/491] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
Date: Mon, 13 Apr 2026 17:58:45 +0200
Message-ID: <20260413155829.528162866@linuxfoundation.org>
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
index 1eb58f8765e22..8766ec93652ca 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1703,7 +1703,7 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		break;
 
 	default:
-		if (channel < shost->max_channel) {
+		if (channel <= shost->max_channel) {
 			res = scsi_scan_host_selected(shost, channel, id, lun,
 						      SCSI_SCAN_MANUAL);
 		} else {
-- 
2.53.0



