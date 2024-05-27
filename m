Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7C3D518;
	Mon, 27 May 2024 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836636; cv=none; b=D/fM1I5zCTOZD5+g1cB279TY+pZDiPEw1J6pj7E5J1AF0cW/dtQwVKFZ22GEzyzLgyr+NA6oM3PjN8NMldkAUy7RKeWU/5MwBpYl+sLUFnnw9Ljz5YUY6gc73XGx6FLUwd/fLPmgWU2rnz6dtVfbS1Q5m3lxHdi7stzleVzaFpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836636; c=relaxed/simple;
	bh=tqYsUHqsf15htg515qBOMyb96FhDsmOnnr7LsZSHOBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vyt57Nkk/vJE1bNz6+hxio1zqywbjAkYF5/iLUcMaGKeiZ0xTMvhnBu4cBpDQMorTg7xogRC324Z+XKZ4ldTXIyTGmMLnSaQMFBq88tivWByWBza5AcG9KCxfrQtl7KUPHwas1su73T/F7bH19f6l1ZuKyzEtQ8byXpTAi8yq0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuQ6ww57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuQ6ww57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C23C2BBFC;
	Mon, 27 May 2024 19:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836635;
	bh=tqYsUHqsf15htg515qBOMyb96FhDsmOnnr7LsZSHOBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuQ6ww57AWv+Px5No7Gp7krHdQqqcBgAN+sdXNkE/jxnRS/Nm/cTboN/qXHIlZQZm
	 IhyY8HbKxTjvDe3CRQfk/D+COd0lQRZSA2TBb7H93iLM/X4SuW+un8FE7DgjpGx4uL
	 1AGufjWv8joab7EA0G4q6XqKcCXMtKPwjgo8DIM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 129/427] scsi: ufs: qcom: Perform read back after writing CGC enable
Date: Mon, 27 May 2024 20:52:56 +0200
Message-ID: <20240527185613.975873551@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit d9488511b3ac7eb48a91bc5eded7027525525e03 ]

Currently, the CGC enable bit is written and then an mb() is used to ensure
that completes before continuing.

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s purpose
wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-5-181252004586@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 004a0f6b1fffa..62c343444d973 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -412,7 +412,7 @@ static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
 		    REG_UFS_CFG2);
 
 	/* Ensure that HW clock gating is enabled before next operations */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG2);
 }
 
 static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
-- 
2.43.0



