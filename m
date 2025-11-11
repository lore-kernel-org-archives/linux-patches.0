Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6E027FD54;
	Tue, 11 Nov 2025 01:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823465; cv=none; b=FGxmn535land2XHaB9NJKjgjlxHJ4x2vAcWkWBNYQqbU771Y6xLeLvY7NaXmZGQF1RJ40k9qP7tX/O6RlZBFbgDt6rIoCYvGUAUpjQ4v1WO+iE8wEz+ysm5ALJb18ZP7Abd4cEvIeu7vx5bpfm20iiSmtRJur9hczU0subvnXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823465; c=relaxed/simple;
	bh=app/Nd6Ri+Pud+lMdNvQHjrXzn2V4SrZPd0dkSxaEWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r44zZkEXBVeiewRs+/SDHYHUX2BGhciby/a1d/oJANhFaXBG2p1xDSLXBEXoJV/URCSAfBBlbeumA424PnHbJDObPOEGnXYSNqUuyAHeKGuVbYzmALWI1h9hHFEpDP+JCl2jXEkkvfR/P5MhrOHyyHuT47WJn2ybljhN0aRwV+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3yYOcGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3yYOcGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5CAC4CEFB;
	Tue, 11 Nov 2025 01:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823465;
	bh=app/Nd6Ri+Pud+lMdNvQHjrXzn2V4SrZPd0dkSxaEWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3yYOcGPedqYin9UMCmbZ999hsiEjeYbrUVVTrn8y3njNL0gNwjUwV/4NTKdVqljy
	 nOHYDhLyxvJUTGDJaWedXC7zQkJWYCqjYYkmpQi/zEoVJGzef7mEh9p3AFGYKP3L2D
	 OnzzzjzBpwNrq//cKQwILDmCCH0Jxgk4AylzydFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Chao <alice.chao@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 305/849] scsi: ufs: host: mediatek: Assign power mode userdata before FASTAUTO mode change
Date: Tue, 11 Nov 2025 09:37:55 +0900
Message-ID: <20251111004543.780167999@linuxfoundation.org>
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

From: Alice Chao <alice.chao@mediatek.com>

[ Upstream commit 979feee0cf43b32d288931649d7c6d9a5524ea55 ]

Assign power mode userdata settings before transitioning to FASTAUTO
power mode. This ensures that default timeout values are set for various
parameters, enhancing the reliability and performance of the power mode
change process.

Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250811131423.3444014-7-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 4171fa672450d..ada21360aa270 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1349,6 +1349,28 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
 			       PA_NO_ADAPT);
 
+		if (!(hba->quirks & UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING)) {
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
+					DL_FC0ProtectionTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
+					DL_TC0ReplayTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
+					DL_AFC0ReqTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
+					DL_FC1ProtectionTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
+					DL_TC1ReplayTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
+					DL_AFC1ReqTimeOutVal_Default);
+
+			ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
+					DL_FC0ProtectionTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
+					DL_TC0ReplayTimeOutVal_Default);
+			ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
+					DL_AFC0ReqTimeOutVal_Default);
+		}
+
 		ret = ufshcd_uic_change_pwr_mode(hba,
 					FASTAUTO_MODE << 4 | FASTAUTO_MODE);
 
-- 
2.51.0



