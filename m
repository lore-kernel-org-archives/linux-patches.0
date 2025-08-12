Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E6829BDB7;
	Tue, 12 Aug 2025 19:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026655; cv=none; b=H2vdVQdO13vxye/hNtGTMa6WNEmhNIeFMdoyuI3OU1R+E2we2XsA9e5UeDKQst09yr96ZukSFJjf8wdqJtgFWN5muvBbaJhzEotkY29wgifKO3j6PTHotJPXSAWEel6rfqJd/iAQayrYgj+5LzQhYw2qHFDHpODujNsBOm7SAZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026655; c=relaxed/simple;
	bh=hIk1XSzPEWrjTwBM96AEJFuCBpPawIEN8rEn9VvZz30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inqwVkGmWzTzUMxm2nCulm5AjNcMjpemEy+hv84E1yyxPFAgQRHgiRCeRu+lXxneh6GBGf33QSIndhiY/LE3fVIkQqktz+GiYIFpEbw5xVgy/YI77nNF8UCj0IYoIAPhRbPCBdX+VXYgyMAby8DrPqyi20y4DfzReCEL6vT+liY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R57sGS33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R57sGS33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F356C4CEF4;
	Tue, 12 Aug 2025 19:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026655;
	bh=hIk1XSzPEWrjTwBM96AEJFuCBpPawIEN8rEn9VvZz30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R57sGS33lzcUGG5K3z2P6b0OrMNakWF3strH7anKAdQYk49fhjBOFhit5EZJl1lok
	 jk8v2fWTOW28+CKB0Zx2kEHr78AA5V1sa6B8XXZbYLA+YvmrcmaJV7/yo6edxPVOIo
	 lLweM50je3rXj6T9HtYI8ZUTXQHyB07mpDg2q4uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghui Lee <sh043.lee@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 368/480] scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume
Date: Tue, 12 Aug 2025 19:49:36 +0200
Message-ID: <20250812174412.608727440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seunghui Lee <sh043.lee@samsung.com>

[ Upstream commit 35dabf4503b94a697bababe94678a8bc989c3223 ]

If the h8 exit fails during runtime resume process, the runtime thread
enters runtime suspend immediately and the error handler operates at the
same time.  It becomes stuck and cannot be recovered through the error
handler.  To fix this, use link recovery instead of the error handler.

Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
Link: https://lore.kernel.org/r/20250717081213.6811-1-sh043.lee@samsung.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Acked-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e7e6bbc04d21..db2a2760c0d6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4322,7 +4322,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	hba->uic_async_done = NULL;
 	if (reenable_intr)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
-	if (ret) {
+	if (ret && !hba->pm_op_in_progress) {
 		ufshcd_set_link_broken(hba);
 		ufshcd_schedule_eh_work(hba);
 	}
@@ -4330,6 +4330,14 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
+	/*
+	 * If the h8 exit fails during the runtime resume process, it becomes
+	 * stuck and cannot be recovered through the error handler.  To fix
+	 * this, use link recovery instead of the error handler.
+	 */
+	if (ret && hba->pm_op_in_progress)
+		ret = ufshcd_link_recovery(hba);
+
 	return ret;
 }
 
-- 
2.39.5



