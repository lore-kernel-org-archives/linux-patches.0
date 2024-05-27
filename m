Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B1861FD6;
	Mon, 27 May 2024 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836628; cv=none; b=I6hp/r/XIasWgFY7uyNUjoKSgoKGI03RwlPnXpA4s7ba+tnSeR9b/na031QR6zjG0WJ4S8AruNiwJ8uz0b2O94l+r/X3SQGUvPpQQTrWjcz5o9BDeyaf8x6x4aUbJaCCHHyjZnls7cpXQ0X8yGN8ewBAuwvL/ggIlFMnOygeE70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836628; c=relaxed/simple;
	bh=wA0gECEapyncXHEfIbmpHX9arnwZS1SO+ePMtW/Mk3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzlyCMU4Qa1njf/398FxY+JxqJSApKQv03hSBgB6xFIHf7pT8Iv/b87ydscGHs3LwlKyfMNpkHwZdOVmEGBWQuGRaCE0P+ePL5BqbQWAy0cwE4g4LHhRKF747lpy9vEDPGFrjJsO8fT1zIJb76JAhnu6z3SCZN0fPOaG/0mepWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUbKg+hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUbKg+hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BE2C2BBFC;
	Mon, 27 May 2024 19:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836628;
	bh=wA0gECEapyncXHEfIbmpHX9arnwZS1SO+ePMtW/Mk3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUbKg+hm3oBhVyRkfBoNbCjGuUeI1pgi3alhv97ZkbLSUWr8q8EN2uhkIwDqoMJkJ
	 nQet1K2nasmoP8szDXtVOiyrEypFuuMlu2Mda0M8ZU55ruPSz+VEeJ6LvJ7+UgAiX7
	 1k5cRQDaw13IpfshN8WGedgirBCND0buRzHbFziQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 127/427] scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US
Date: Mon, 27 May 2024 20:52:54 +0200
Message-ID: <20240527185613.823205590@linuxfoundation.org>
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
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 7a00004bfd036..bb3445e5efa8b 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -507,7 +507,7 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
 		 * make sure above write gets applied before we return from
 		 * this function.
 		 */
-		mb();
+		ufshcd_readl(hba, REG_UFS_SYS1CLK_1US);
 	}
 
 	return 0;
-- 
2.43.0



