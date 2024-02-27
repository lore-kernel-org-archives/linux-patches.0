Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6091386CB;
	Tue, 27 Feb 2024 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043418; cv=none; b=smWbrsc32zRTVKrYae2Ed32ssox7tFkLdFCLZZp3roHmTRF6TkjzdE/Gem5G9ggBrbmImP+adbYkq9zLBEpqYLWqQCUbWuJ++yParwc9yLm4sirOmIZefIBqw5+lPiA6+IEYA9ZtV/CSHbrVkCFCMghZnowJiuDsbi0bfuCzqq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043418; c=relaxed/simple;
	bh=FUzqCxHI5+7NHxZjjM3hH8Z4YBNB6FfFNTiXEHm9y7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIe6n6kEZlPMXmMqQ53U9CyTO3W500rCJp6sgop14B8Pe6hKeXMOgE1UAbwbbuftZj5IdsD3R6Qn36HTHz8Oc8IRR303Owk9ig+fj1dvIICEtBqwA5ST12zSENRt/qtD3UewE+nRXUr6ffdr2Tl6cf0xUlBy3I27XPFgd0lA98s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8SH0ZqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8SH0ZqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A626C433C7;
	Tue, 27 Feb 2024 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043417;
	bh=FUzqCxHI5+7NHxZjjM3hH8Z4YBNB6FfFNTiXEHm9y7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8SH0ZqMVZifjZKr4hSbfc7Ot5g4fRy0VOBLmupyZ3dDzlvRoIKrufrv1uw3Ey0rQ
	 MO6049NIzIfaxAL9+JVdouLJ1ubiCl+yO8jDXJdXfJ9pw/wvd2B0a1l+K8w6xOX1cF
	 xWiUw9zeZ+qB7WCXocsa5UCacVo20XRH2qkLCwfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SEO HOYOUNG <hy50.seo@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/195] scsi: ufs: core: Remove the ufshcd_release() in ufshcd_err_handling_prepare()
Date: Tue, 27 Feb 2024 14:25:33 +0100
Message-ID: <20240227131612.876345416@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
index 9fd4e9ed93b8b..f3c25467e571f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6159,7 +6159,6 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_hold(hba, false);
 		if (!ufshcd_is_clkgating_allowed(hba))
 			ufshcd_setup_clocks(hba, true);
-		ufshcd_release(hba);
 		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 		ufshcd_vops_resume(hba, pm_op);
 	} else {
-- 
2.43.0



