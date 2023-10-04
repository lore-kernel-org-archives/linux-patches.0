Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC911D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwImN+7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A92C433CA;
	Wed,  4 Oct 2023 18:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443540;
	bh=CTu0bbSzp2BsonUzILoIWVb/CVxw98dDGLBkmNTm7Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TwImN+7woj+E+1rv8HiaesrA1gWzyVgOxLbqWoP5p7PzSTiynxxoK4hFvwXIpzRmK
	 M77cjpd/DfIaqwbmwDZindDtBGLGGrqrQ1+PbQA+D9kfR++NyUd4auw42fOUrAAWZo
	 DFWrHr8GvDaQAsMs5B7Mo/AgCGTe53y2cXmTosjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiwoong Kim <kwmad.kim@samsung.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/259] scsi: ufs: core: Poll HCS.UCRDY before issuing a UIC command
Date: Wed,  4 Oct 2023 19:55:27 +0200
Message-ID: <20231004175224.366928345@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Kiwoong Kim <kwmad.kim@samsung.com>

[ Upstream commit d32533d30e2119b0c0aa17596734f1f842f750df ]

With auto hibern8 enabled, UIC could be busy processing a hibern8 operation
and the HCI would reports UIC not ready for a short while through
HCS.UCRDY. The UFS driver doesn't currently handle this situation. The
UFSHCI spec specifies UCRDY like this: whether the host controller is ready
to process UIC COMMAND

The 'ready' could be seen as many different meanings. If the meaning
includes not processing any request from HCI, processing a hibern8
operation can be 'not ready'. In this situation, the driver needs to wait
until the operations is completed.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Link: https://lore.kernel.org/r/550484ffb66300bdcec63d3e304dfd55cb432f1f.1693790060.git.kwmad.kim@samsung.com
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Chanwoo Lee <cw9316.lee@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 135be6dd02523..b4e3f14b9a3d7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched/clock.h>
+#include <linux/iopoll.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_driver.h>
@@ -2254,7 +2255,11 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
  */
 static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
 {
-	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY;
+	u32 val;
+	int ret = read_poll_timeout(ufshcd_readl, val, val & UIC_COMMAND_READY,
+				    500, UIC_CMD_TIMEOUT * 1000, false, hba,
+				    REG_CONTROLLER_STATUS);
+	return ret == 0 ? true : false;
 }
 
 /**
-- 
2.40.1



