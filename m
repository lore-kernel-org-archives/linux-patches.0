Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658A1279DC9;
	Sat, 30 May 2026 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165591; cv=none; b=KtGWM2loYeYFm26MAfz+MzDoalj4gbkFXRV39HoqzHREIYjITcC1eoiBP0pD/S61WVOi3LyOzURPBSdpaTBwlKcPEDbnYRQA+rsrcCXvkPZvdSPsOjTe84JqXzKp+y5REim0TVmkNx0KWnU87xeO0JEO/nGpmHAflmaWsKpbvQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165591; c=relaxed/simple;
	bh=CfvlMbHJZy8VaoIZQ4NnKwWHZYAGbpbNXcQRQCsl9Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeYMfyunYEbdOM6AMgWRWTdHwaey38hizzoTovLrY3V7Up8caZ3DziZkKz3sxBseXY9dxSQklfdl0yI6GWBkzPLWVw5cEPlVqelF8Rcc7uNIssX1aCTILa2VlPBflN6xOMlsPquBznzaSzbXVF5uSl1u1yrsi4UFB8E/tzXLSCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2QWb38t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2QWb38t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2911F00893;
	Sat, 30 May 2026 18:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165590;
	bh=vKKj4oQPtmEKZE7RajeG/8pAi8szjFLPN4FRfByOw3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2QWb38tYX6rPS1XUtKmLG3hDuYXE/CyfsWGCNWOZjBZtHowi7RN5E1ZinQ32DzPC
	 E3Jh8CIFpnEvDo/YbJ6YGS19iJtUH1L1wkLucasyS7JwB5cOI0pnKqUE5b9UswVdr1
	 aYM3HceAIMmdmMB/mcrnftiNfSdv2wKv7f3RJmqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/589] scsi: ufs: core: Improve SCSI abort handling
Date: Sat, 30 May 2026 17:59:37 +0200
Message-ID: <20260530160227.218464986@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

commit 3ff1f6b6ba6f97f50862aa50e79959cc8ddc2566 upstream.

The following has been observed on a test setup:

WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737 ufshcd_queuecommand+0x468/0x65c
Call trace:
 ufshcd_queuecommand+0x468/0x65c
 scsi_send_eh_cmnd+0x224/0x6a0
 scsi_eh_test_devices+0x248/0x418
 scsi_eh_ready_devs+0xc34/0xe58
 scsi_error_handler+0x204/0x80c
 kthread+0x150/0x1b4
 ret_from_fork+0x10/0x30

That warning is triggered by the following statement:

	WARN_ON(lrbp->cmd);

Fix this warning by clearing lrbp->cmd from the abort handler.

Link: https://lore.kernel.org/r/20211104181059.4129537-1-bvanassche@acm.org
Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ kovalev: bp to fix CVE-2021-47188; adapted placement of
  lrbp->cmd = NULL for 5.10 function structure ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c7bf0e6bc303d..1b8072f47e7e8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6788,6 +6788,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		__ufshcd_transfer_req_compl(hba, (1UL << tag));
 		spin_unlock_irqrestore(host->host_lock, flags);
 out:
+		lrbp->cmd = NULL;
 		err = SUCCESS;
 	} else {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
-- 
2.53.0



