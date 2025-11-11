Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88EC3081AD;
	Tue, 11 Nov 2025 01:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823306; cv=none; b=V914YyABKKQEZlWFBtDElqpCOUMuy2RSRhrATq4EyMuBUexr48BI8VdRc7as9YKQyXGcXNuSztWiskU8i0Oq8+tn2gqvorLyiTzmsPQPdwvpCHh6TqIffxl+OLgO7PusjCdsPypfRR3o5xjNaR/lOuajBWJRZNOHQ/GKGsCX5qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823306; c=relaxed/simple;
	bh=X9oXn9qcSIR0eI2WmKggFwL88yn87p26MknU7PyptIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo/k7qc03W3nTgsIaUFN3wFQ84A55ou/Am0QBOWBdphpD1BFB2G0eCVeqv/UyzDji4mvehGORXZ4EEA5ESj7YYesJubcKM7sNS1j+aF0AjtGYP1elt8UU7pmJ00wPTchclIT2+fS7VaOTabxlUdWTTSDR4cp9/oKuH8VbKrEnRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYiKz87S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYiKz87S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34023C4CEF5;
	Tue, 11 Nov 2025 01:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823306;
	bh=X9oXn9qcSIR0eI2WmKggFwL88yn87p26MknU7PyptIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYiKz87SaB91inXmR5Xmehm1dwmS2A55Z72vNsvvZoaaRXlVqoWUoMQCvukcHmXrF
	 iA+l1EYsRrTkZCJ6sf9v2KPUrdTlB+ALYG4PoJzBdQ4U4kImchSN4LcQwrEPQwmOHv
	 +6Rxn1KzTkukk+KE6OxxqwnOOJr5n7l2wo1mItwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Chao <alice.chao@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/565] scsi: ufs: host: mediatek: Assign power mode userdata before FASTAUTO mode change
Date: Tue, 11 Nov 2025 09:41:12 +0900
Message-ID: <20251111004531.782349745@linuxfoundation.org>
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
index 8701d2307ad3f..191db60b393d9 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1186,6 +1186,28 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
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



