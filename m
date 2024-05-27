Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67A7168C4;
	Mon, 27 May 2024 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837916; cv=none; b=nIy4YzdvL7VMK7XQVEeZEFNTMVkwMVhdic2CD1OKgKSsKXVdVeiQzIX7XZLZKMhD4TqkyCjTS2+34zNEqWYqT6ORw6usOqD3KGtYfF0xMElPvnljuPYbv1gWRqrd4P+YDckZ3Tw/YPlFsp3lcExM1MUPoLBT83zBzb3M9Vpfuks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837916; c=relaxed/simple;
	bh=mz8uBxwzHAgqYqkuLGpb2wx8e+gPGDRzgBMBbeLXGhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9hq6XCWUKK5KsJlLmgIOoWOQkKK1BYh/7+B6G49ws2+guj8ysroK+Egt5V/ghUR8TePfld110NztOQAY0S8vSz/apkqkuRZtCtedR1io27bI/05P5TBFq+pGYQ5Fxh3782qnnurGkIAsw3pOb4Owsa/mtO4tN92VuupScXfkQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLM1tSvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLM1tSvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476BBC2BBFC;
	Mon, 27 May 2024 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837916;
	bh=mz8uBxwzHAgqYqkuLGpb2wx8e+gPGDRzgBMBbeLXGhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLM1tSvk7vOgoWvozenmYmd65wsvKWC9VVPNrrv3e9ZTjs6tatcDu2+C8elz5d7Mk
	 Qaai+Ch4PgfnXihA3ferXXXTyIlth7rm/SC/wwQZEp150kcQS6FcvNROYG1RMybnco
	 rSuDupwj9JK3iUDdo+nqGJwnvbQv+1/YFNIBM34g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 195/493] scsi: ufs: qcom: Perform read back after writing reset bit
Date: Mon, 27 May 2024 20:53:17 +0200
Message-ID: <20240527185636.725076027@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit c4d28e06b0c94636f6e35d003fa9ebac0a94e1ae ]

Currently, the reset bit for the UFS provided reset controller (used by its
phy) is written to, and then a mb() happens to try and ensure that hit the
device. Immediately afterwards a usleep_range() occurs.

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. By doing so and
guaranteeing the ordering against the immediately following usleep_range(),
the mb() can safely be removed.

Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-1-181252004586@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 9dd9a391ebb76..b9de170983c9e 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -151,10 +151,10 @@ static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
 
 	/*
-	 * Make sure assertion of ufs phy reset is written to
-	 * register before returning
+	 * Dummy read to ensure the write takes effect before doing any sort
+	 * of delay
 	 */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG1);
 }
 
 static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
@@ -162,10 +162,10 @@ static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
 	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, 0, REG_UFS_CFG1);
 
 	/*
-	 * Make sure de-assertion of ufs phy reset is written to
-	 * register before returning
+	 * Dummy read to ensure the write takes effect before doing any sort
+	 * of delay
 	 */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG1);
 }
 
 /* Host controller hardware version: major.minor.step */
-- 
2.43.0



