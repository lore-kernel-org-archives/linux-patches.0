Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC314884C;
	Wed,  5 Mar 2025 18:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197601; cv=none; b=bKxCJROCxh94KVKxD9oZaqOfbI3v37wzULVQ5IqbP9hHsk5SZRMOIzzpwbwKHDmyT772t26YTrCSLbUK61uB1s6byDtYHLbHvryYnxRGHvopybjtYmO5oYsa7+iCLcZyt0sl4937MCOgKTXng5hbQQ+DesZpvSoxeQQ5C3UvTkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197601; c=relaxed/simple;
	bh=5U0lR6RldQjpRKQWgOYRgU4biLm4pxqOke7mEVLIils=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgqXtf4AVNUMyWIaUNQ7/fSX74FuqZZYkh8LB1meY705Va4F0x7jVugVpBO8mZgM69DleVGdpraIzvjc7BfVTR+74OkRTmZ4utqUDROdOGGgI1XDOrgIPjSNqomUZkV4DpIp9iKF0DrwSqaP31Hu3V/MobVjvONp3vuJoDHu5vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09C8dCuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09C8dCuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AEDC4CEE0;
	Wed,  5 Mar 2025 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197600;
	bh=5U0lR6RldQjpRKQWgOYRgU4biLm4pxqOke7mEVLIils=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09C8dCuj58i6o7dD4ZNMaty4GAmMRWL4uCF1l0KqUyEe7FMk2X9kdE7FdAAi9G/rO
	 Blrs5XS5QsB+BIPM4lLyGpoSnJHl/Ac27ZPaGxrR+exjTRocGZUQ16+hzvFcvdIXPt
	 1/ig1d+/afsL56b8fSQjAhGFKIIShKV9C3Q05GpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/142] scsi: ufs: core: Introduce ufshcd_has_pending_tasks()
Date: Wed,  5 Mar 2025 18:47:04 +0100
Message-ID: <20250305174500.553832333@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit e738ba458e7539be1757dcdf85835a5c7b11fad4 ]

Prepare to remove hba->clk_gating.active_reqs check from
ufshcd_is_ufs_dev_busy().

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20241124070808.194860-2-avri.altman@wdc.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 4fa382be4304 ("scsi: ufs: core: Fix ufshcd_is_ufs_dev_busy() and ufshcd_eh_timed_out()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a9a7a84e6cbbc..83d69e0564f2d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -237,10 +237,16 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
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
@@ -1883,8 +1889,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
-	    hba->active_uic_cmd || hba->uic_async_done ||
+	    ufshcd_has_pending_tasks(hba) || !hba->clk_gating.is_initialized ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
-- 
2.39.5



