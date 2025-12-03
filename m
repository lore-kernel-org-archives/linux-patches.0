Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995663446D6;
	Wed,  3 Dec 2025 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779099; cv=none; b=SdxkwKia4eDFOrtfk6Jz10xhyUqtErUszkjzgR/o9pDwFJ3pipnX43jFcH+xs9M1XZtG+lbBou3I69unRe49To101HEBg1WwPzepXX3SRwiVHWPRwjZStgt2jKHI6u81M/8Cnmh32nnCOwDTuajg4miEif/o0iMjhUdSkV/zpAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779099; c=relaxed/simple;
	bh=fTgtpU6jWpWyx0r4EbSa2mQPBhI6bHshaKOxLYVKEf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOwXD6c7OCSYhUyWr+r7UcqstsT4wZyu7cJTaw10nb9LNhthU4/+CBrLkjP/qfMLgM+TSqWKC4HxOvtry7WdErapag7eX5HN/Z1w8/K+xA9hea1rFvNWSBmAC8Oy0Z0L4UOtO2QUgfnEOaUqVX9mvTU3n/mCJiBIBT4nZFmQRRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRtYqOkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRtYqOkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB81BC4CEF5;
	Wed,  3 Dec 2025 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779099;
	bh=fTgtpU6jWpWyx0r4EbSa2mQPBhI6bHshaKOxLYVKEf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRtYqOkjGMEDRF6T6MZ4/yxxLOOwMs36CtmF1VUe+MlVy+nAF1pswqHwB3oO2ZRgE
	 2Svzc8jxWFuWTJojpFgjKuSiLPjXAERx+AtjLrDUYxkQpYbcwEMWLhJWSHXEXEQQ8n
	 I+/WGeBfDWbIV9tCxxlnVnMPRXh1qMZYDamt6XCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/568] scsi: ufs: host: mediatek: Change reset sequence for improved stability
Date: Wed,  3 Dec 2025 16:22:37 +0100
Message-ID: <20251203152446.403749751@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 023ded88acef8..df17e6d606ded 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1158,11 +1158,11 @@ static int ufs_mtk_device_reset(struct ufs_hba *hba)
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



