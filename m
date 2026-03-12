Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F0540244A;
	Thu, 12 Mar 2026 20:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346465; cv=none; b=aXUdbg1kV9HZPvzO5cVOKNncEhRHMQADzYazisiEFA0tz9+n3PeWI2flCZD3TENFiuIM+WOvZ5k7q72+/3dsj+mzWnIxdnXMNDcIZsaJ0/OqEydpRleP5B8Ke5fNx0EholJoFiIzGTDsof6WNE7+6tYDtWfh6SuCQSsIA6depcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346465; c=relaxed/simple;
	bh=+nNlmcBmU/QGM7FYrgIPatnRQcErQA/mSqsRIeEdu1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kH0V1lUXOGZEP+F8zo3n6dAWCmQ28FK3i+8tGlKTK5gsZYnTQ2TKmcxx61H/7L3NE3fPzIZtbDQFhJ5h+NM47HlME2rB+Ilp5UTul6N/i96LI5gja4M+sx9pbA56XpAp3uDFtTg92mMXBYUjfNLw/W+reFiiOOHIzBtE79biU08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPWAQ6eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPWAQ6eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65D5C4CEF7;
	Thu, 12 Mar 2026 20:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346465;
	bh=+nNlmcBmU/QGM7FYrgIPatnRQcErQA/mSqsRIeEdu1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPWAQ6eqeQeepFapqlpJ+XDKvsrGhO1bRAcuv0bBcaUsEbvVkFEHLmcFK0sTLK5WM
	 P4tjnhEQHVQYSFO7ALI/sA1xcPulSLK0CtAX64f2miUPz9P6Na3a+KOr3P400DiKmP
	 bxSPsQJVdpD0xXllnK1P4GfBpBrQd2bqlOA2y8I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/265] scsi: ufs: core: Move link recovery for hibern8 exit failure to wl_resume
Date: Thu, 12 Mar 2026 21:06:44 +0100
Message-ID: <20260312201018.799807541@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 62c015373e1cdb1cdca824bd2dbce2dac0819467 ]

Move the link recovery trigger from ufshcd_uic_pwr_ctrl() to
__ufshcd_wl_resume(). Ensure link recovery is only attempted when hibern8
exit fails during resume, not during hibern8 enter in suspend. Improve
error handling and prevent unnecessary link recovery attempts.

Fixes: 35dabf4503b9 ("scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223103906.2533654-1-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ba0cc2a051ff3..ad5866149e240 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4348,14 +4348,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
-	/*
-	 * If the h8 exit fails during the runtime resume process, it becomes
-	 * stuck and cannot be recovered through the error handler.  To fix
-	 * this, use link recovery instead of the error handler.
-	 */
-	if (ret && hba->pm_op_in_progress)
-		ret = ufshcd_link_recovery(hba);
-
 	return ret;
 }
 
@@ -9947,7 +9939,15 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		} else {
 			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
 					__func__, ret);
-			goto vendor_suspend;
+			/*
+			 * If the h8 exit fails during the runtime resume
+			 * process, it becomes stuck and cannot be recovered
+			 * through the error handler. To fix this, use link
+			 * recovery instead of the error handler.
+			 */
+			ret = ufshcd_link_recovery(hba);
+			if (ret)
+				goto vendor_suspend;
 		}
 	} else if (ufshcd_is_link_off(hba)) {
 		/*
-- 
2.51.0



