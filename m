Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A689252908;
	Wed,  5 Mar 2025 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197603; cv=none; b=hpSFdXxcarte0/ZMqPuz9yySeaK5mQFxvmcdwvHrg9fGnt0ykLgAgGEIxU/R5do/uvU2VshXWeKX9dEWkLXwvY4TYMr2UTH/OGMUGPG0VCLNdaWupHn1EJPXD4TGe2pzCMR7uC5ACZLTi3jHpwRkQn8BgE4NJ6npjkD+dQuFf0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197603; c=relaxed/simple;
	bh=tbbp7U7NJOtNd9sXQ7HHVc4PyWX0uCsFKVyW0YSThN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udvCFS7AlTNPdev5XyFRaICOI09uEyYnN6ZW0+BhFw1CXBjvDyvd2VD0bDVzpT25qYEETzL+waOAAGfDFikcblDrkLvNS9hIlDFvUyGpq0HFoNuUmsXzHSVNa+g4LXjkSWSfx8WG8mOKOznoGbwu4UgdXzJmWeIjpONYj3nr3R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsFo+lCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsFo+lCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A0FC4CEEB;
	Wed,  5 Mar 2025 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197603;
	bh=tbbp7U7NJOtNd9sXQ7HHVc4PyWX0uCsFKVyW0YSThN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsFo+lCTQJDdID0ODPVOp0JTmaTnpckoLkamQd72qTBjB2dMb/YHEF+qMhlHbdWbX
	 KiQt9OYIXN8iPfS5navqjvsjYRUkusMdhsqZkxg/EFAr2m4qQqLJy98zrLOpS5EebJ
	 IQNH3ld/JlfBikwgQ6uKeTMRMCFshaDCBGhcNCrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/142] scsi: ufs: core: Prepare to introduce a new clock_gating lock
Date: Wed,  5 Mar 2025 18:47:05 +0100
Message-ID: <20250305174500.593209132@linuxfoundation.org>
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

[ Upstream commit 7869c6521f5715688b3d1f1c897374a68544eef0 ]

Remove hba->clk_gating.active_reqs check from ufshcd_is_ufs_dev_busy()
function to separate clock gating logic from general device busy checks.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20241124070808.194860-3-avri.altman@wdc.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 4fa382be4304 ("scsi: ufs: core: Fix ufshcd_is_ufs_dev_busy() and ufshcd_eh_timed_out()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 83d69e0564f2d..24f8b74e166de 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -245,8 +245,7 @@ static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
 
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return hba->clk_gating.active_reqs || hba->outstanding_reqs ||
-	       ufshcd_has_pending_tasks(hba);
+	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -1833,7 +1832,9 @@ static void ufshcd_gate_work(struct work_struct *work)
 		goto rel_lock;
 	}
 
-	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+	if (ufshcd_is_ufs_dev_busy(hba) ||
+	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
+	    hba->clk_gating.active_reqs)
 		goto rel_lock;
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -8196,7 +8197,9 @@ static void ufshcd_rtc_work(struct work_struct *work)
 	hba = container_of(to_delayed_work(work), struct ufs_hba, ufs_rtc_update_work);
 
 	 /* Update RTC only when there are no requests in progress and UFSHCI is operational */
-	if (!ufshcd_is_ufs_dev_busy(hba) && hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL)
+	if (!ufshcd_is_ufs_dev_busy(hba) &&
+	    hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL &&
+	    !hba->clk_gating.active_reqs)
 		ufshcd_update_rtc(hba);
 
 	if (ufshcd_is_ufs_dev_active(hba))
-- 
2.39.5



