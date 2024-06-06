Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEC5199383;
	Thu,  6 Jun 2024 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683210; cv=none; b=mMDhJffbz7b1rEt/QU9zRccYaJbehH2H/ReJUm2dH4tTlZMrN/zS/Us/Qq3AVoL0dXv5XDo3ukud9ghEdCGdUtO5AWhNkfpa2hl1MLgbOwL1frD0Pv5/xzh2kderMjdlrpgVA9kcb7oabJHbcU+26sAlPHZ0xNAR8hLtFXoYzFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683210; c=relaxed/simple;
	bh=WLdAhBwbbMkRWXdH7ussoBoEQVd+HlgGp52khDa1D/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwRj3IhBvOf6fhxPOZOqecJJgVSyp9F3dmgmNlwWCYD7KS7QK4q8Uw63rPntKhMcsIK1NSR1hX+99fHVEntJpeKEqcMrN9m2VF+9253oBHQNH2AydUW/I1EFY96Nzz5EwkSPdQZt8wrr3u3x6dApDmTPypL6O84K4DDMHxBQMPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yhbfdj8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yhbfdj8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EB7C2BD10;
	Thu,  6 Jun 2024 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683210;
	bh=WLdAhBwbbMkRWXdH7ussoBoEQVd+HlgGp52khDa1D/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yhbfdj8lbNLb9I+lOqBkCHdW8ukLxHShU/EdzXJzoHjWiw3pGX5mFqnsYUa+EQJXm
	 we06NZrkBy3EzQyvnSk6uc1CKTS/gmkbzpguNE0cRLoc+ON4mruoU4Km8kEF9Lmn90
	 yHfN9j/zEGWXYcr7bcQttLdcpUw9eMJ2FbhkxUJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/744] scsi: ufs: qcom: Perform read back after writing CGC enable
Date: Thu,  6 Jun 2024 15:57:05 +0200
Message-ID: <20240606131737.321046907@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 1f2a64d797c79..922ae1d76d909 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -498,7 +498,7 @@ static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
 		REG_UFS_CFG2);
 
 	/* Ensure that HW clock gating is enabled before next operations */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG2);
 }
 
 static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
-- 
2.43.0



