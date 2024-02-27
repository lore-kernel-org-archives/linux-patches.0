Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D899613F01E;
	Tue, 27 Feb 2024 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041878; cv=none; b=YmE6aRIW83dOfJyBhbuNNZD0EQq98U0A/mqk+6CHsBAfs5CgWkRd26CP6fCCdpTzXV/yuCjD0YIHqXYb9uWiq3RuxN6gERvwW6eOqXlH8xGSMaXtos6ya+q1ey6aJ4oHcFs6fzlR3zSzUgHTKeEJ532zXuT0xHgKK4R7n7PD+wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041878; c=relaxed/simple;
	bh=TDhw+FbDE/dgB+QLInflz2ZSsawegEpSpSm73oKGteg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJWNMLlbWUCDATwL1ddqU6RePitC2vnqSIZyYgVxD+gTqZqs/RRvmn1NoMb9SVjb0gQ0uaUcdMK0h0L084BeISNoVMoNcZ82mITqZIfs90TyCEfZjG3oHoxt4JT+yhib6VXm6Mc0mSfUoCVYTv1J6mLjb0XlbYrWY6VJD5C+kGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eM+XOgJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eM+XOgJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64986C433C7;
	Tue, 27 Feb 2024 13:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041878;
	bh=TDhw+FbDE/dgB+QLInflz2ZSsawegEpSpSm73oKGteg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eM+XOgJv0/dNb+IaBWhRS+aoFPSZs3HJAn1j3enVLIiamkcYKLSK6QulgiQjf0L5i
	 N5+CEzGSHiULqRoC4R310fF/1/MUt0hyCsKDO27abnq3JN3WCYNicFlb9k1PpNE5ww
	 6q905RfeCS74b9t/LnHyRQ//O9jXJVgrrHaCzSzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SEO HOYOUNG <hy50.seo@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/299] scsi: ufs: core: Remove the ufshcd_release() in ufshcd_err_handling_prepare()
Date: Tue, 27 Feb 2024 14:23:32 +0100
Message-ID: <20240227131629.141277202@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SEO HOYOUNG <hy50.seo@samsung.com>

[ Upstream commit 17e94b2585417e04dabc2f13bc03b4665ae687f3 ]

If ufshcd_err_handler() is called in a suspend/resume situation,
ufs_release() can be called twice and active_reqs end up going negative.
This is because ufshcd_err_handling_prepare() and
ufshcd_err_handling_unprepare() both call ufshcd_release().

Remove superfluous call to ufshcd_release().

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
Link: https://lore.kernel.org/r/20240122083324.11797-1-hy50.seo@samsung.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f6c83dcff8a8c..ee9119b708f01 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6253,7 +6253,6 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_hold(hba);
 		if (!ufshcd_is_clkgating_allowed(hba))
 			ufshcd_setup_clocks(hba, true);
-		ufshcd_release(hba);
 		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 		ufshcd_vops_resume(hba, pm_op);
 	} else {
-- 
2.43.0



