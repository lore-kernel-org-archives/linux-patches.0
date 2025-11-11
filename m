Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F101305E15;
	Tue, 11 Nov 2025 01:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824426; cv=none; b=jBRrOfVxhnltCHDUsTyc4zF1F802unUotgfkvD9sQi23uziKjiHKsihQMQqWJ2qM1Gx5wtF8ENx9b0PeTAXlvTI5Dm0dg7yd3URdljfXWto4AR3yVjlyuWWaqyTtYfiKR6qBVD5cJQ6G4RWa41ev5DKVhprX9Z7dZqTecyowDXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824426; c=relaxed/simple;
	bh=0BrTit7OcryPNQIKoX+T2C99c2tjotWvS2n1p4iGyFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/5dqcHmn9SQR2BXP1HsmoLR4zGX2d1bqsxASy9dXo8NWvCF6krkAtz6UmJsXcuKqGP+Ww19TEf5ui9PkuH4e9Vxbj1YfbOM9DlZsbffT1DdnDIK7J8j0/BK1D/k4mkLcyp7DZOJhMap1q5MGD0+8sCPwnhyQYfCFetGlqAKCkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDbuRzZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDbuRzZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27092C16AAE;
	Tue, 11 Nov 2025 01:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824424;
	bh=0BrTit7OcryPNQIKoX+T2C99c2tjotWvS2n1p4iGyFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDbuRzZOrCfdiAEKtMs2NzEsV150aCGHJcfjeMEIYZBUEhP44wai75y/tUCQj8/af
	 nDVv56bvy99retApxOvJOoWf0oUThJo4eSIwa2pr0uWl25cRa+GqOHL+g8eG00Awah
	 3nYBNAo4qE4JDoYl+h22RLE3Wf3mB4XRU/FW/mUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 492/849] scsi: ufs: host: mediatek: Enhance recovery on resume failure
Date: Tue, 11 Nov 2025 09:41:02 +0900
Message-ID: <20251111004548.334806535@linuxfoundation.org>
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

[ Upstream commit 15ef3f5aa822f32524cba1463422a2c9372443f0 ]

Improve the recovery process for failed resume operations. Log the
device's power status and return 0 if both resume and recovery fail to
prevent I/O hang.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index bb0be6bed1bca..188f90e468c41 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1727,8 +1727,21 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	return 0;
+
 fail:
-	return ufshcd_link_recovery(hba);
+	/*
+	 * Check if the platform (parent) device has resumed, and ensure that
+	 * power, clock, and MTCMOS are all turned on.
+	 */
+	err = ufshcd_link_recovery(hba);
+	if (err) {
+		dev_err(hba->dev, "Device PM: req=%d, status:%d, err:%d\n",
+			hba->dev->power.request,
+			hba->dev->power.runtime_status,
+			hba->dev->power.runtime_error);
+	}
+
+	return 0; /* Cannot return a failure, otherwise, the I/O will hang. */
 }
 
 static void ufs_mtk_dbg_register_dump(struct ufs_hba *hba)
-- 
2.51.0



