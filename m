Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FC734A786;
	Tue, 11 Nov 2025 01:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823795; cv=none; b=Z9wNBQmSernOfPKZjs9pz2E5ekocBIf6XHuhCOBa3nwfcWbZdspdJK+5MEh3kNWALdZKVt/YjdLkpy1npojDH+n5mBpItD3mBxKtvQNlRAhetAJDlFRK32PNwiwOCJJ8oajaaGzYWaj6XOp3EiV6oBqrEdu4i/8V4mSYdt8JdBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823795; c=relaxed/simple;
	bh=ZpmFirSDmHFJJEKFB18sGP/8+JqlBH0FDiv2ZfbMKuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOXDFIR4VknmjjZj+ZY9l1isuJy93sSz7yomX38NDsKwvOLVidSHzC3pQ3TA/VFqF7u15mTbzrJUx9e3sQsHfq62tru29fkTqyE7+fBfNtkhJWxAXj9duV/O2gQpysIzh9fgRxciS/Lx3MY/5ITm2szCGcjHP91JJ7mUGVCzS9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLrqEjOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLrqEjOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3433CC116B1;
	Tue, 11 Nov 2025 01:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823795;
	bh=ZpmFirSDmHFJJEKFB18sGP/8+JqlBH0FDiv2ZfbMKuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLrqEjOiAwRsOtXapcBn5IBAQyGk7yCw0YmZyjxpJldPHxS7PXzyb942H5ecrtVOw
	 RtMydfutCOb9hza0cKM1AQCC+43I7s4N0w1LrhDW7vkeHpOK+fyYJPyXCMnF/+LY1L
	 xq6ec2u8gYxS8pKKoFSdSAYQ6GgHOp4rrBlqjCgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/565] scsi: ufs: host: mediatek: Correct system PM flow
Date: Tue, 11 Nov 2025 09:43:02 +0900
Message-ID: <20251111004534.218263191@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 7c13bce03694f..003ca5ad88228 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1989,27 +1989,38 @@ static int ufs_mtk_system_suspend(struct device *dev)
 
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



