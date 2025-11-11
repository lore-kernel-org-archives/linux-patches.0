Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7214C26ED5E;
	Tue, 11 Nov 2025 01:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823311; cv=none; b=D9EmTY/rTumrOx2L6tm48pJ+l7zQThzAmJhvzU/HTnzhTaG1pbHae8n6lZv48GfDKGJxjvNO8ftFMk6wMUe1Al2yDwj2tGYR8LtE3/JeD76wYjjRcEOAms36gW51anDwPz9zkCvqa1XL2/Q0qtzFP1IUSg/WUuGSlqUtTQY/VOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823311; c=relaxed/simple;
	bh=QJIU0YVI4OBdZxwPH2n7SoxIvZWGzVvKpflxEawhEVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMTAEfB+RsJZhp20z9TTLEh0GoCYamaQ64CySImXu/+ME7c5mqAigiPhbhlCMVuoS/yze+/EGa7uxcEyNrIT1+9TUO99OmRxTyxW3MIJ3FLLAIjZpSmmMj23yiGHgGPYGD88EicHKigIVv6hqHdynukw9qRkLU4flM4lqpVgX4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCc05hef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCc05hef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11117C4CEFB;
	Tue, 11 Nov 2025 01:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823311;
	bh=QJIU0YVI4OBdZxwPH2n7SoxIvZWGzVvKpflxEawhEVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCc05hefabI+mTCBs6tWn5UCR9eHvGvalGiY706OSXXCVtnWwntHWZhpMSg6iGqP5
	 HNTEdf/jUDSx89sKT+3BzEP2rjLW4SXnK+YLg3RRC6uBqC2l4sYy/N6vIwLefF+AHu
	 vW0W+55p1Z2baQmTc0wr/SA0Q0UiUJQPQ3oKGudE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/565] scsi: ufs: host: mediatek: Change reset sequence for improved stability
Date: Tue, 11 Nov 2025 09:41:13 +0900
Message-ID: <20251111004531.804745204@linuxfoundation.org>
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

[ Upstream commit 878ed88c50bfb14d972dd3b86a1c8188c58de4e5 ]

Modify the reset sequence to ensure that the device reset pin is set low
before the host is disabled. This change enhances the stability of the
reset process by ensuring the correct order of operations.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250811131423.3444014-10-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 191db60b393d9..c0106fb3792d4 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1340,11 +1340,11 @@ static int ufs_mtk_device_reset(struct ufs_hba *hba)
 {
 	struct arm_smccc_res res;
 
-	/* disable hba before device reset */
-	ufshcd_hba_stop(hba);
-
 	ufs_mtk_device_reset_ctrl(0, res);
 
+	/* disable hba in middle of device reset */
+	ufshcd_hba_stop(hba);
+
 	/*
 	 * The reset signal is active low. UFS devices shall detect
 	 * more than or equal to 1us of positive or negative RST_n
-- 
2.51.0



