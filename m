Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DEA158545;
	Tue, 11 Nov 2025 01:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824629; cv=none; b=jwEdBM2fIKF50SwRKm2jxp4r1evqdEztcBB+jByerwwOZhG+VR+BiJmU+gsOxFUhldrjr3plGAJgSRylD4SJaepWHxts9SPLkos9WvzhfcZOy8dK9TQu1F4Bpf1U8sP55Y9wD9ZUSNanxI64JI+NpVlmgBkNa+FNJvn4zdYIJ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824629; c=relaxed/simple;
	bh=jpsti5m5z2zePBISgoCKGD54VzHmbW76HoMgz7XKYbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARSeerrYoTsBDMCX98ItioLLHd/p5Ose+XpShvGQyZaRWPF24/UDomkJxywNkbSsJNXdEveeERczDwYzF4lwM4wQEcpn7K/rCQi8W2FNbakcMP6LqMKHiUabXfXZEAagZzPQkEjA7UpqxTrb8BcQ9KM/xsAG/XZo77XZTKszF9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAtxCCI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAtxCCI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F43BC113D0;
	Tue, 11 Nov 2025 01:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824628;
	bh=jpsti5m5z2zePBISgoCKGD54VzHmbW76HoMgz7XKYbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAtxCCI8kyNxh039NtPZex8Mr63oG5sr3E40b+f3X/XBMDB48+4oa64e2FumtrtcR
	 POsZQAIGS9w0JpJklGDFXU05XhKFYmbPXEa0uBF+w5BAMClYSCVDIlbqEGiy0ps2+H
	 ZYd07RUZouSA3NX9igLdFgTjHyPhWizuzvFdXYM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palash Kambar <quic_pkambar@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 493/849] scsi: ufs: ufs-qcom: Align programming sequence of Shared ICE for UFS controller v5
Date: Tue, 11 Nov 2025 09:41:03 +0900
Message-ID: <20251111004548.358871745@linuxfoundation.org>
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

From: Palash Kambar <quic_pkambar@quicinc.com>

[ Upstream commit 3126b5fd02270380cce833d06f973a3ffb33a69b ]

Disabling the AES core in Shared ICE is not supported during power
collapse for UFS Host Controller v5.0, which may lead to data errors
after Hibern8 exit. To comply with hardware programming guidelines and
avoid this issue, issue a sync reset to ICE upon power collapse exit.

Hence follow below steps to reset the ICE upon exiting power collapse
and align with Hw programming guide.

a. Assert the ICE sync reset by setting both SYNC_RST_SEL and
   SYNC_RST_SW bits in UFS_MEM_ICE_CFG

b. Deassert the reset by clearing SYNC_RST_SW in  UFS_MEM_ICE_CFG

Signed-off-by: Palash Kambar <quic_pkambar@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 21 +++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.h |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 9574fdc2bb0fd..3ea6b08d2b526 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -38,6 +38,9 @@
 #define DEEMPHASIS_3_5_dB	0x04
 #define NO_DEEMPHASIS		0x0
 
+#define UFS_ICE_SYNC_RST_SEL	BIT(3)
+#define UFS_ICE_SYNC_RST_SW	BIT(4)
+
 enum {
 	TSTBUS_UAWM,
 	TSTBUS_UARM,
@@ -751,11 +754,29 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	int err;
+	u32 reg_val;
 
 	err = ufs_qcom_enable_lane_clks(host);
 	if (err)
 		return err;
 
+	if ((!ufs_qcom_is_link_active(hba)) &&
+	    host->hw_ver.major == 5 &&
+	    host->hw_ver.minor == 0 &&
+	    host->hw_ver.step == 0) {
+		ufshcd_writel(hba, UFS_ICE_SYNC_RST_SEL | UFS_ICE_SYNC_RST_SW, UFS_MEM_ICE_CFG);
+		reg_val = ufshcd_readl(hba, UFS_MEM_ICE_CFG);
+		reg_val &= ~(UFS_ICE_SYNC_RST_SEL | UFS_ICE_SYNC_RST_SW);
+		/*
+		 * HW documentation doesn't recommend any delay between the
+		 * reset set and clear. But we are enforcing an arbitrary delay
+		 * to give flops enough time to settle in.
+		 */
+		usleep_range(50, 100);
+		ufshcd_writel(hba, reg_val, UFS_MEM_ICE_CFG);
+		ufshcd_readl(hba, UFS_MEM_ICE_CFG);
+	}
+
 	return ufs_qcom_ice_resume(host);
 }
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index e0e129af7c16b..88e2f322d37d8 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -60,7 +60,7 @@ enum {
 	UFS_AH8_CFG				= 0xFC,
 
 	UFS_RD_REG_MCQ				= 0xD00,
-
+	UFS_MEM_ICE_CFG				= 0x2600,
 	REG_UFS_MEM_ICE_CONFIG			= 0x260C,
 	REG_UFS_MEM_ICE_NUM_CORE		= 0x2664,
 
-- 
2.51.0



