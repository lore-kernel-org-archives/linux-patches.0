Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9D4171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0181C433D2;
	Mon, 22 May 2023 19:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784220;
	bh=YxJ2rS9JsCiGTpAu0q0ucI4aqCc8eB70rnFgIQECHUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAdCRJg6bFZc9C5iYjJsx44pD7YYf8ADvfqCiyU6UrkmMLHQfKei3AI/tWxsrDWca
	 wn24f9n+5Qp9f3mD+z4GbndmuwWyOdAVHnhNmBcs6Q5LH3Nkn/yKBpC99EDXTZYuCy
	 RtDaqGatSCcjkYjF5s+Nd3vd2v7AjLZd0F+zOC9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 010/364] scsi: ufs: core: Fix I/O hang that occurs when BKOPS fails in W-LUN suspend
Date: Mon, 22 May 2023 20:05:15 +0100
Message-Id: <20230522190413.074183076@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keoseong Park <keosung.park@samsung.com>

[ Upstream commit 1a7edd041f2d252f251523ba3f2eaead076a8f8d ]

Even when urgent BKOPS fails, the consumer will get stuck in runtime
suspend status. Like commit 1a5665fc8d7a ("scsi: ufs: core: WLUN suspend
SSU/enter hibern8 fail recovery"), trigger the error handler and return
-EBUSY to break the suspend.

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Keoseong Park <keosung.park@samsung.com>
Link: https://lore.kernel.org/r/20230425031721epcms2p5d4de65616478c967d466626e20c42a3a@epcms2p5
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 70b112038792a..8ac2945e849f4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9428,8 +9428,16 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			 * that performance might be impacted.
 			 */
 			ret = ufshcd_urgent_bkops(hba);
-			if (ret)
+			if (ret) {
+				/*
+				 * If return err in suspend flow, IO will hang.
+				 * Trigger error handler and break suspend for
+				 * error recovery.
+				 */
+				ufshcd_force_error_recovery(hba);
+				ret = -EBUSY;
 				goto enable_scaling;
+			}
 		} else {
 			/* make sure that auto bkops is disabled */
 			ufshcd_disable_auto_bkops(hba);
-- 
2.39.2



