Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E89194A60;
	Thu,  5 Sep 2024 09:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529407; cv=none; b=kGKKmi0a7Gw3oendrz1m8kAYkq4hdffIbwgNUbYlPIPtlDDesUTvdoZLajJIzIOHiCsso2mFPNHHIPiSyr2LXB6vnBpVPPWOhnBuvd1Wv0NmaIZ4AoLKyT4DRoqaoyz9F03qaRdYI3aGuYjdUj21GIhP54c7ukH4ZANv1CAySlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529407; c=relaxed/simple;
	bh=6TFi7vrJ1xJwRRZhLxJoSl0z/3eMweRYEtkNxGBD4rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNHs0X6NZnDhhLmg9WgBjlU01sL/wJAOlpOtK/j8Jw4gZewo+3r9dUs8W4dPMKKLVNEYX3tm84eE6DE61uc85Rdy4oEFQcFRR1lFGt9OXgWVAdos5XpZZF6F9YbemwjLniGVBeYHDGDM5PF07N9RPk4BvIIdZmorMjf7LGCDcoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+iNwN/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+iNwN/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCEFC4CEC3;
	Thu,  5 Sep 2024 09:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529406;
	bh=6TFi7vrJ1xJwRRZhLxJoSl0z/3eMweRYEtkNxGBD4rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+iNwN/L9P0L+/N2jycnFd4bbuS6Fo/+ww4WdYSoLM2EvXdXzHIDG7d5M5FWhSGYG
	 PZ3L7obMGXmzVokewTnINaf82hc+CgOYdzoVfKxHtPEHSfIvzE90j3ReaAKqeINqVs
	 EtUj8x4GZIMuxAlcUxiDxHGEtVsfU1kR02yL7hxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyoungrul Kim <k831.kim@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 003/184] scsi: ufs: core: Check LSDBS cap when !mcq
Date: Thu,  5 Sep 2024 11:38:36 +0200
Message-ID: <20240905093732.377308761@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5864d65448ce5..aab8db54a3141 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2412,7 +2412,17 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
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
 
@@ -10456,6 +10466,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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
index d965e4d1277e6..52f0094a8c083 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1074,6 +1074,7 @@ struct ufs_hba {
 	bool ext_iid_sup;
 	bool scsi_host_added;
 	bool mcq_sup;
+	bool lsdb_sup;
 	bool mcq_enabled;
 	struct ufshcd_res_info res[RES_MAX];
 	void __iomem *mcq_base;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 385e1c6b8d604..22ba85e81d8c9 100644
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



