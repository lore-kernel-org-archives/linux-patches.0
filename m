Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B666E13B287;
	Tue, 14 May 2024 11:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685001; cv=none; b=kbcobvwKFKcbnbv+n3L4tGGzHPgI4qvjFSVjNBZbr8x/zu+gj9P2nbnWw88LnFh3IeJKwfKlPedA6M7toKkAmx7UmmhcMI4lZIAFonQah4YZZWb3Ts0io96PMo9R9nWJ7bJQNwu5bg2SEuMUMD5JQSFFky+bY4MG93kBZP+TTqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685001; c=relaxed/simple;
	bh=AIhDmYJcvRJ8LsJm+b90FdVieXcguD8wrGACQlffPZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi44fHB/B9ZBuhlCUbWNSLVZ8qvSP5r6L2ob1Zs/JTeyA4amkpBBFtdN/jfdfb6AwlyAKB7UHgsejfpCYiF5Vyd48CzuLlmBqg+Pb8eDM/TZCSwYSSjFrRdl2l1aBMUFT/983+zy3lFDzpvah/0GDqF1pQpNrbcAZJXVlVDCmUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNuUF+5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNuUF+5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21F7C2BD10;
	Tue, 14 May 2024 11:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685001;
	bh=AIhDmYJcvRJ8LsJm+b90FdVieXcguD8wrGACQlffPZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNuUF+5QY7rg9DPCq6nu0i6cNGGj4kVza/ClTgLO3OqFB3ndJtoA0AfDJjNQRf7qz
	 ez3T6SUJBGABqMLumxNUeF1vzG5cBtQJ80d97SwHUlqv9BQa52qvCxlGHHDGR+mf2A
	 q3rJ7xQswp/nrq82mp0btsRgr66dXJ2Y4ALINiwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/301] scsi: ufs: core: WLUN suspend dev/link state error recovery
Date: Tue, 14 May 2024 12:16:31 +0200
Message-ID: <20240514101036.781314541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 6bc5e70b1c792b31b497e48b4668a9a2909aca0d ]

When wl suspend error occurs, for example BKOP or SSU timeout, the host
triggers an error handler and returns -EBUSY to break the wl suspend
process.  However, it is possible for the runtime PM to enter wl suspend
again before the error handler has finished, and return -EINVAL because the
device is in an error state. To address this, ensure that the rumtime PM
waits for the error handler to finish, or trigger the error handler in such
cases, because returning -EINVAL can cause the I/O to hang.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20240329015036.15707-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee9119b708f01..8005373e20bae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9547,7 +9547,10 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	/* UFS device & link must be active before we enter in this function */
 	if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba)) {
-		ret = -EINVAL;
+		/*  Wait err handler finish or trigger err recovery */
+		if (!ufshcd_eh_in_progress(hba))
+			ufshcd_force_error_recovery(hba);
+		ret = -EBUSY;
 		goto enable_scaling;
 	}
 
-- 
2.43.0



