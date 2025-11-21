Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7362FF656;
	Fri, 21 Nov 2025 13:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732502; cv=none; b=N0T4vG1qGVdxaGEKRm5/RJfLuevtw7LIkERZqYUkWKEdu4AA6rLVQMmJEpJT9YIgtnJVSVjdXhR9XQWu5N/VoKYArXi1jlKsowQiOaI3bYCLFF5a8jnnNDyIyaomPNOTC2b1wza/YqrTgCXCr8gOgsK5cyYLPAEx4W+jGr6OpB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732502; c=relaxed/simple;
	bh=ncmhWvCi3oQ2DQBW24OIAq0rXRpQzGG8jlAw6IrX7lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXtVQttm708iM7Q4N5J5JtcTOH3mD9oQPuw8z5qNRtAoMKkMb2XmX73Xq5Plrs6+rExMxlFEzKMwLclUgpAovbHvUU4Aj2vePr6ClliC+MV/5ReaIcQKm/bn6aEuOfZgYlD0GF0d/56a2Ix2c8Fi3NMjloYCnUmzILVr+tz2BEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgZbtwGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgZbtwGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD14C4CEF1;
	Fri, 21 Nov 2025 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732502;
	bh=ncmhWvCi3oQ2DQBW24OIAq0rXRpQzGG8jlAw6IrX7lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgZbtwGfOKhK7B1Yj6sIA1vazvs5KUk7r4/BuIL+XDCTxKTHH5ZsnwmSqlh2rotvX
	 s4MkeZXPqu8pt/x6661TDhGA5D9xtlX/hCxBDN2eoSYoICfgErZbXZvt2pEw+rfp88
	 vOdwSeiliSfILQ/OcAAg7KIB5YP6LSVTbHY53DJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/529] scsi: ufs: host: mediatek: Change reset sequence for improved stability
Date: Fri, 21 Nov 2025 14:07:23 +0100
Message-ID: <20251121130236.139491871@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7b506220438bb..90a698f8a082e 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1234,11 +1234,11 @@ static int ufs_mtk_device_reset(struct ufs_hba *hba)
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



