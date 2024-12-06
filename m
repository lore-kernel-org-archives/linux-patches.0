Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBAB149E0E;
	Fri,  6 Dec 2024 14:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496194; cv=none; b=T8eqM0zau1gVvq54WYwILJPS0rYv0yoy6XYVrYRW74bVF1ebuH2dWdZYmzSp9wpZ6h70UhernkPtbGF59ZKexs2CnTwrGnKkCBzxaAsTX4pJTU8K8Yo1qrQJ8ZF6cs6lzvF8rdg5jnUbcB02qCiYpczor5Ukte1KQxPbk+jatB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496194; c=relaxed/simple;
	bh=XUQjsmFHaQxtNOds1NUftADw0cHndIBdSoVWIMgDbLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9y4gmg1BPuLgpeqGsOXL8YWGtK4Nd9/tOPIVsO8gKueS4eDQ57DatjOZaa5xPsv595PhImtQPC7cCOGrmYNsg2MhoLB+UY/1FTZW0u1kszAJGbiLWV3T07e2eQbc1jZBfInB/bUT9eIOsplCZXE57hznthtGQ89/GZzbXlKixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/orHm/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/orHm/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D91C4CED1;
	Fri,  6 Dec 2024 14:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496194;
	bh=XUQjsmFHaQxtNOds1NUftADw0cHndIBdSoVWIMgDbLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/orHm/dvb6/aDZdTge6XwHOIjaQPjWX9TF/uh1cuR6mDyTnXZx2NcFUFY5O74ysz
	 YsLm0pEK9TcSPL4yOLERRZnETfSZRLxQR0tveGGIwtH68N9k4y1O4CYUELoABdaCmj
	 lWQX6mdGHFwmJqdLzbjMderS7k1iUE+ko5ytimM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 078/146] scsi: ufs: exynos: Add check inside exynos_ufs_config_smu()
Date: Fri,  6 Dec 2024 15:36:49 +0100
Message-ID: <20241206143530.664984787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

commit c662cedea14efdcf373d8d886ec18019d50e0772 upstream.

Move the EXYNOS_UFS_OPT_UFSPR_SECURE check inside
exynos_ufs_config_smu().

This way all call sites will benefit from the check. This fixes a bug
currently in the exynos_ufs_resume() path on gs101 as it calls
exynos_ufs_config_smu() and we end up accessing registers that can only
be accessed from secure world which results in a serror.

Fixes: d11e0a318df8 ("scsi: ufs: exynos: Add support for Tensor gs101 SoC")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20241031150033.3440894-5-peter.griffin@linaro.org
Cc: stable@vger.kernel.org
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-exynos.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -724,6 +724,9 @@ static void exynos_ufs_config_smu(struct
 {
 	u32 reg, val;
 
+	if (ufs->opts & EXYNOS_UFS_OPT_UFSPR_SECURE)
+		return;
+
 	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
 
 	/* make encryption disabled by default */
@@ -1440,8 +1443,8 @@ static int exynos_ufs_init(struct ufs_hb
 	if (ret)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
-	if (!(ufs->opts & EXYNOS_UFS_OPT_UFSPR_SECURE))
-		exynos_ufs_config_smu(ufs);
+
+	exynos_ufs_config_smu(ufs);
 
 	hba->host->dma_alignment = DATA_UNIT_SIZE - 1;
 	return 0;


