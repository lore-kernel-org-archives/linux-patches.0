Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7547514A08E;
	Thu,  5 Sep 2024 09:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530010; cv=none; b=bzlirZ4BxWvtRQJ9JgEizNUwcnceVjxvVXO4I5mKaShIzmtn2hO57d54ZtTH1gqg8nudCn2XvXZR9CdPU2IP/aSxetk3KSRB5Ipk8h6nMc5L/i2qWGkWrxO6iz8NMfM4CBxCRLi/mhQxqYt2iDUtSA52xFmeH8vEq6WGOxpxync=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530010; c=relaxed/simple;
	bh=yHHvYLIttbzhR+Zh2w3Ctaydv/4R5kZkCPqWc/yRsp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL2aZ6pyoC7YArpxZt5AFgJgmvElFIkE9hbXuihInijEOCB/TcfhMB3f7KOs+AMRiJyhtqiPyynj7UQHOn57bb83Mt37oyBnOhpuzmOqIynlXfa5qiEBszvmz3AaMsqVfiw/uatxun8x81FmrAA15pLcN/F81NWycyXZvb34yM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNpQ0mMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNpQ0mMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D72C4CEC3;
	Thu,  5 Sep 2024 09:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530010;
	bh=yHHvYLIttbzhR+Zh2w3Ctaydv/4R5kZkCPqWc/yRsp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNpQ0mMFGd/M1mb7svdCYCC/FE7rCjvQM00m+aTUHmSkYAnXxlvQ60+OSCgCFL9Yt
	 FnjanvGL/Q9uCFvMg2RAD3V7awC/hQumqXQhyMh5APOYvKMkYfR5zimTvJO43zIvei
	 Ul3EmmJzIQkVBMvNGTCDzm6MIOaqyN6IFdV5Ky+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyoungrul Kim <k831.kim@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/132] scsi: ufs: core: Check LSDBS cap when !mcq
Date: Thu,  5 Sep 2024 11:39:50 +0200
Message-ID: <20240905093722.368210969@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kyoungrul Kim <k831.kim@samsung.com>

[ Upstream commit 0c60eb0cc320fffbb8b10329d276af14f6f5e6bf ]

If the user sets use_mcq_mode to 0, the host will try to activate the LSDB
mode unconditionally even when the LSDBS of device HCI cap is 1. This makes
commands time out and causes device probing to fail.

To prevent that problem, check the LSDBS cap when MCQ is not supported.

Signed-off-by: Kyoungrul Kim <k831.kim@samsung.com>
Link: https://lore.kernel.org/r/20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++++++++
 include/ufs/ufshcd.h      |  1 +
 include/ufs/ufshci.h      |  1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 94edac17b95f8..bfa9f457f24ea 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2281,7 +2281,17 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 		return err;
 	}
 
+	/*
+	 * The UFSHCI 3.0 specification does not define MCQ_SUPPORT and
+	 * LSDB_SUPPORT, but [31:29] as reserved bits with reset value 0s, which
+	 * means we can simply read values regardless of version.
+	 */
 	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
+	/*
+	 * 0h: legacy single doorbell support is available
+	 * 1h: indicate that legacy single doorbell support has been removed
+	 */
+	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
 	if (!hba->mcq_sup)
 		return 0;
 
@@ -10386,6 +10396,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (!is_mcq_supported(hba)) {
+		if (!hba->lsdb_sup) {
+			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported)\n",
+				__func__);
+			err = -EINVAL;
+			goto out_disable;
+		}
 		err = scsi_add_host(host, hba->dev);
 		if (err) {
 			dev_err(hba->dev, "scsi_add_host failed\n");
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e4da397360682..2a7d6f269d9e3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1064,6 +1064,7 @@ struct ufs_hba {
 	bool ext_iid_sup;
 	bool scsi_host_added;
 	bool mcq_sup;
+	bool lsdb_sup;
 	bool mcq_enabled;
 	struct ufshcd_res_info res[RES_MAX];
 	void __iomem *mcq_base;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index d5accacae6bca..ae93b30d25893 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -75,6 +75,7 @@ enum {
 	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
 	MASK_CRYPTO_SUPPORT			= 0x10000000,
+	MASK_LSDB_SUPPORT			= 0x20000000,
 	MASK_MCQ_SUPPORT			= 0x40000000,
 };
 
-- 
2.43.0



