Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BE41E8855;
	Wed, 19 Feb 2025 08:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955329; cv=none; b=vFNUR/L9bpXbETl+dVPHty6H1yK2bj/UVyEs3AO4MtUxo+uxnw3TaVvWSWkdlbGKhxsIWPLO0rbRx1bH4Mz3dPuVJmmihUNsNZlE0jHeetHscCBYc9h9wDRcFfIgsYmb3XQSbLw59KphUirKbYOBM3ddRT+JWktu66jthmgXoa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955329; c=relaxed/simple;
	bh=RqciFZiKUo6yavDPI7JKYjTaalisTU/iymA92fnwm0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRPAFHt+wLYqRDsKR7zMkXuurlRbtv3yWkGpaFcahssU9lzhleIBWQrDYQWGac0/xfMq+pg/UfqU1hYRCnEwz0jKOOYE11XIWU74PMoQgGU1pk/V+EGeh9uhONsiKNNQvVq5cf1BnBSU0LZgvYZzkrsuL2hlmFDimtTqh06qRn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjnNhTtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjnNhTtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78000C4CED1;
	Wed, 19 Feb 2025 08:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955328;
	bh=RqciFZiKUo6yavDPI7JKYjTaalisTU/iymA92fnwm0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjnNhTtNprIEuAp8o9kbtwxHFsWp7oqifolmteN48BbhujiOGGVmz+bhPJvAy9pPx
	 gmK9l67kfUsSoGYIGREOuzm/NxBHMgmE7+TKHw8D1bsHQQKuAbwdWoZrjkzGf4MLPG
	 U31aeOkeB4cH1wClyl0FIQnROt9PNVwCLt4P3jAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/230] scsi: ufs: core: Introduce ufshcd_has_pending_tasks()
Date: Wed, 19 Feb 2025 09:28:07 +0100
Message-ID: <20250219082608.353374353@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit e738ba458e7539be1757dcdf85835a5c7b11fad4 ]

Prepare to remove hba->clk_gating.active_reqs check from
ufshcd_is_ufs_dev_busy().

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20241124070808.194860-2-avri.altman@wdc.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 839a74b5649c ("scsi: ufs: Fix toggling of clk_gating.state when clock gating is not allowed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b786cba9a270f..94d7992457a3b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -258,10 +258,16 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
 	return UFS_PM_LVL_0;
 }
 
+static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
+{
+	return hba->outstanding_tasks || hba->active_uic_cmd ||
+	       hba->uic_async_done;
+}
+
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return (hba->clk_gating.active_reqs || hba->outstanding_reqs || hba->outstanding_tasks ||
-		hba->active_uic_cmd || hba->uic_async_done);
+	return hba->clk_gating.active_reqs || hba->outstanding_reqs ||
+	       ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -2023,8 +2029,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
-	    hba->active_uic_cmd || hba->uic_async_done ||
+	    ufshcd_has_pending_tasks(hba) || !hba->clk_gating.is_initialized ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
-- 
2.39.5



