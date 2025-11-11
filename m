Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956FC27D786;
	Tue, 11 Nov 2025 01:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823470; cv=none; b=HrZtqM7kfTOVIG/v1Y5wYK2ZO6IyFPEGNXniSBQ1MKFuU8UIRIk+Irlw1PW0U4jZ8mlS1fR636eUXYWD1OV6ARcgTLuE3raCqLQK8J+xthF8Nv0hQCaYOBCcyy1Wf2ZHQYNEPFEXKhwxJRPaPaqaoYlFy6b3hOGoo+XB/w4Kj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823470; c=relaxed/simple;
	bh=0A76K02b8apmHS9fLjjRC4Po7VPFGjKvDZwWgigV/kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMIZr683b+bkrdOZsrQ+guCZxTzLnZ0hmwp2uN81zEFSiejHYeIS2kSa+zoE1raupNBdxj/g1pqZeEfycVEwOW82fGk6V86M0UTBI2rElAy63In8d/Lqz9JpUJrn4rCFaiIaVrwIDffYt+3aCggXcoMnDEMLLBnbahC50tymE4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOJIU78u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOJIU78u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011BAC116B1;
	Tue, 11 Nov 2025 01:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823470;
	bh=0A76K02b8apmHS9fLjjRC4Po7VPFGjKvDZwWgigV/kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOJIU78uYwPS6rhESbaATTaz+HVgAS3zoYTVAJBfV1RVoUn0Jmn9W+CCsOYTV1Z2m
	 lTuK7oHQkwF4xnbFPzuQMgeBARxHEQRFxGwFcheOsaeW7uFzajpxFpIN/rVDtQLa3V
	 EmtNqVtMNEDJwggoHLDZ5dagq1TRXQtfSb6QtlTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 306/849] scsi: ufs: host: mediatek: Change reset sequence for improved stability
Date: Tue, 11 Nov 2025 09:37:56 +0900
Message-ID: <20251111004543.809224908@linuxfoundation.org>
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
index ada21360aa270..82160da8ec71b 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1503,11 +1503,11 @@ static int ufs_mtk_device_reset(struct ufs_hba *hba)
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



