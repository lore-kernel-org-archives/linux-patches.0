Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8495820F;
	Tue, 23 Jan 2024 01:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974063; cv=none; b=PfR+7ev4wVQbPawusq1YzF4ut54ARlkQbtskxUzyOKkKJy3jElYgWtuVGLWA6pNGS+zEnWjkTnTGGJ6vs2oRqctChFjvFpA2+mYM1ZOChrxYh5EAJjkowA5tZFKauMG5q0+R+hyrrQhAZKu/8YzpRvHt74qFtjq8UoQAzVzAPjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974063; c=relaxed/simple;
	bh=uiVEUKeXS5wEbvbQ0u9q869wnW6Rnzoy/wS8Xe1Fhls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGhxr3g0iGOBHyDNpMkosbvpHH50ttQAPIkuUc9pnUluDNnFm4t8BOheO5nOtw2tmkzV3+uFiYnMUfpcvC57JXcB3Ntq3D1gzwHBbW5RAfemDNSyQplc6Aq7cpcnca7/om1wDt99Hcef+7gEYQ5n2oLXRLjYlu61m87mhKnxxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiKUu6pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiKUu6pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB63C43390;
	Tue, 23 Jan 2024 01:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974063;
	bh=uiVEUKeXS5wEbvbQ0u9q869wnW6Rnzoy/wS8Xe1Fhls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiKUu6pwHCmSsumAPzAPuhons8XMoP17u7HDrhUGnDK1smOparwY1mCXTtQd8kfjv
	 Tf5za04sZnfTyv4v1+vMzrnOF98IpaXIn8jOHiObkrvCAQbHosERAZpuFEuXAUbpLc
	 XL4vpiiaDrluXf+EMDecwtAZnAYqNoJGwvMLmryE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/374] scsi: hisi_sas: Replace with standard error code return value
Date: Mon, 22 Jan 2024 15:56:40 -0800
Message-ID: <20240122235749.639914868@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit d34ee535705eb43885bc0f561c63046f697355ad ]

In function hisi_sas_controller_prereset(), -ENOSYS (Function not
implemented) should be returned if the driver does not support .soft_reset.
Returns -EPERM (Operation not permitted) if HISI_SAS_RESETTING_BIT is
already be set.

In function _suspend_v3_hw(), returns -EPERM (Operation not permitted) if
HISI_SAS_RESETTING_BIT is already be set.

Fixes: 4522204ab218 ("scsi: hisi_sas: tidy host controller reset function a bit")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 19081790f011..530f61df109a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1584,12 +1584,12 @@ EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 {
 	if (!hisi_hba->hw->soft_reset)
-		return -1;
+		return -ENOENT;
 
 	down(&hisi_hba->sem);
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
 		up(&hisi_hba->sem);
-		return -1;
+		return -EPERM;
 	}
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0e57381121d5..88af529ab100 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4983,7 +4983,7 @@ static int _suspend_v3_hw(struct device *device)
 	}
 
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	scsi_block_requests(shost);
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
-- 
2.43.0



