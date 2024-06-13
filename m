Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21663136E00;
	Thu, 13 Jun 2024 12:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280892; cv=none; b=lo1yYrB2cKxZYuGMcghgpeaxTEp9NjKYUVAm1Rjnx/2mDC4m7Van4YZfsqbkFMPocS36/5TGR+Wsc/yxR3xfw1B/ONICnaZfK8gUX1L5rMCZZVM32VeaZnFN3NFXUrpkaOwKNppTAbq2fDMo2UVOpwhfZaSk6EbnkPIwFDofw+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280892; c=relaxed/simple;
	bh=OxoPTjS5GniDrbqg3Ig7theT7GhVFoQYFc0Y6icNYs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWrUnqkKZ43t/OGFdZv630235ZKA2pFk6CfugdB+PoFK6WGsL31rKFykNkhnlJXEQHxGU+UXQPcGflazpRrlK55SmiamtEU024OQLWhfM9ZctCweTcu1IQPgwWaEDHO8A4A3/Kpof9Pd8EYn2UeAuw0q2WNFO/sal4x5B97ifyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cji21yAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cji21yAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B683C2BBFC;
	Thu, 13 Jun 2024 12:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280892;
	bh=OxoPTjS5GniDrbqg3Ig7theT7GhVFoQYFc0Y6icNYs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cji21yAnPZRYMIQbSzG5Nxzmd3WgVBvcWkQRcvFcrObOXW2pTowrEAw6D5dGaSqzo
	 Sz2rZXxT8UIod4NOXSEsuXiY9o379qG9p4znqzwkALJ41kGrfV8KDDEqlamHtEkQ10
	 EpDdUvXAwUvTBcRy4lVg8810AQYNJt990W+f7Tro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/317] scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US
Date: Thu, 13 Jun 2024 13:30:57 +0200
Message-ID: <20240613113249.060307445@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit a862fafa263aea0f427d51aca6ff7fd9eeaaa8bd ]

Currently after writing to REG_UFS_SYS1CLK_1US a mb() is used to ensure
that write has gone through to the device.

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s purpose
wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-2-181252004586@redhat.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index a432c561c3df0..45d21cb80289d 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -449,7 +449,7 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
 		 * make sure above write gets applied before we return from
 		 * this function.
 		 */
-		mb();
+		ufshcd_readl(hba, REG_UFS_SYS1CLK_1US);
 	}
 
 	if (ufs_qcom_cap_qunipro(host))
-- 
2.43.0



