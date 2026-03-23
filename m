Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567773AE6EE;
	Mon, 23 Mar 2026 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275194; cv=none; b=rb1PXlO7QkwUFdJFw487csywI0u9WqGDO3fGGYcoOzbrI6x3MkYhMgXz9NhVU4sC+D0wM6gWrcH2hmhRtgxZjYawq0cw9omzB1hGpEY/VEVeXXhMue+Gd+URgxFyjfJwquMwPDUv6sESlnLKHCeMDZtVLJnnwDhMf1LpgEGupQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275194; c=relaxed/simple;
	bh=BRVhRF2XPZdthfa4y5tN71zl2jgAjEwX0n8mt18iXgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sucwZJKrm7bMaHfi2y5w/GTwD+9xxbB3TEex+W6Cj4lqRMndDyhgGQp6vnadxdEE9TGpQGnYkrLN1V8OzN+8okOl2HBixEuUPHN0CM2a+pCFhio+iIhA39JSFka1rf/yuIn1VGdIlzhUw4DbMpLcQPR4LMyLwLoulhoIAZmp480=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZAyGlRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZAyGlRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18CAC4CEF7;
	Mon, 23 Mar 2026 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275194;
	bh=BRVhRF2XPZdthfa4y5tN71zl2jgAjEwX0n8mt18iXgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZAyGlRYY/bvWmsxyXdHsszfQ8MHqSUJAS91ktHk46+VJ8Dl51Uw1a2SH4nv6ZJ3i
	 ieuP913ac3amim6wHQCku8XmS9CXq7GGvUPu3NyDusupRnqIeG4+t9lmXFQt2LfENe
	 qkjHqU8eEEbDycgFCceM2OoYqhGhkSMMEIRUb5pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/567] scsi: ufs: core: Move link recovery for hibern8 exit failure to wl_resume
Date: Mon, 23 Mar 2026 14:38:49 +0100
Message-ID: <20260323134533.985192808@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 808b648e1f388..0b74ef63e6721 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4289,14 +4289,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
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
 
@@ -10016,7 +10008,15 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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



