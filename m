Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0795263F28;
	Tue, 11 Nov 2025 01:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824539; cv=none; b=D9oHMSCxhuM4YAtKgmKUmlLn2IvlLxV0wWFjq6EzUkUOYvycB9dEYSI7KbsVcV/qTzrZPVJsig7TciNl54yPOvoNuHJdkGDFVVUyArn/H/EdWXNBoo2whNFVwkIVGO0A5C5VgIKos730WoNqHvMkSM7qimg2yqn7Pr5yA/35sPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824539; c=relaxed/simple;
	bh=IS3ERUAREjz3GmSCYXYRGPrNGeYhcgkyJ7SI/TE8Cqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8S4B+Jb1ODnNWbGrUgI8MGfeJv6nicqLgJS8YTSNXhP+nY7NYJxBLe0DwMz94pGYdlmLD+Z0qgbBU5OIDiAba0l4nm2gBk9zw3ja5FqgiNu4fO3vfQGHCVHVQncoCLtygdEYD97UOnUUZQPLK3i7QtzIlKvTqMieSpdYW+N9Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bH6s8ePR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bH6s8ePR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C822C4CEF5;
	Tue, 11 Nov 2025 01:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824539;
	bh=IS3ERUAREjz3GmSCYXYRGPrNGeYhcgkyJ7SI/TE8Cqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bH6s8ePRRcgRG6mgki+5N5VnwKypvovuGqSBXAXPdwGWXY3kYNfTGxHYZ3Qu1g5KP
	 Yuu3qZeqYILUsLK+tjdUNn3N8x2b5ZVL2D3hZCkmgBtfi45K4zhL1aLkGYF1Hjy8O6
	 uCbfjKGdCycAs1BqqFWSt9KQs1fsqhxp0PmSV0qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 497/849] scsi: ufs: host: mediatek: Correct system PM flow
Date: Tue, 11 Nov 2025 09:41:07 +0900
Message-ID: <20251111004548.452404812@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 77b96ef70b6ba46e3473e5e3a66095c4bc0e93a4 ]

Refine the system power management (PM) flow by skipping low power mode
(LPM) and MTCMOS settings if runtime PM is already applied. Prevent
redundant operations to ensure a more efficient PM process.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 6bdbbee1f0708..91081d2aabe44 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2264,27 +2264,38 @@ static int ufs_mtk_system_suspend(struct device *dev)
 
 	ret = ufshcd_system_suspend(dev);
 	if (ret)
-		return ret;
+		goto out;
+
+	if (pm_runtime_suspended(hba->dev))
+		goto out;
 
 	ufs_mtk_dev_vreg_set_lpm(hba, true);
 
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(false, res);
 
-	return 0;
+out:
+	return ret;
 }
 
 static int ufs_mtk_system_resume(struct device *dev)
 {
+	int ret = 0;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct arm_smccc_res res;
 
+	if (pm_runtime_suspended(hba->dev))
+		goto out;
+
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(true, res);
 
-	return ufshcd_system_resume(dev);
+out:
+	ret = ufshcd_system_resume(dev);
+
+	return ret;
 }
 #endif
 
-- 
2.51.0



