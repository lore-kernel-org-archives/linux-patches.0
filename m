Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE5B146A79;
	Thu, 13 Jun 2024 12:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280812; cv=none; b=sDDEqx2d6YJZzj9trZYRqubrlUbivIwHtAGgfMDHuWm35kRpVFf7/Xe/bLKuH0vURDphvIJaUZHhzKaQVVsp+51Aa/jN48aNYT+MJ/59YWSJJy/en+jKtrxTm44CrccTJPQtMshCmG0tXVPHFqAD4q0jVQ9ucFGgVtViFiYqZLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280812; c=relaxed/simple;
	bh=XzTkMskJ36A1P5O94q7/z7/HuaVtlvVPB0+CxBwz/VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEscj7uilysS2sgiL+Iihya7KvkcxXIofbX4fSTmqwXL96WD9+QtUESucA6jGI7W+M3/OgheuHvo7DVqkS55Edx1SbrQ0kq8F1o0VrhwLdioN/eR4UWoyJW06yQMHf2Me9N0mGjTcz00UswOGosTVj1FxE/ce7k9jJjceZEs5MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+Pc5P/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+Pc5P/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C4DC32786;
	Thu, 13 Jun 2024 12:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280812;
	bh=XzTkMskJ36A1P5O94q7/z7/HuaVtlvVPB0+CxBwz/VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+Pc5P/tM+Np1tDcbbThUwawod3KMMcdJG5kbwHKTg53JADxffzEE0igweOTlzTjj
	 DUYal5QRWzIouqXVZjRLoE9JKsoXV5YOX9sVGQQTds2ExqezHIUrsHA5z7/totFbaE
	 kGWJe1iAM+FvVrjFLt3lfXesvbhMACwSMYx9o/fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/317] scsi: ufs: qcom: Perform read back after writing CGC enable
Date: Thu, 13 Jun 2024 13:31:01 +0200
Message-ID: <20240613113249.217519746@linuxfoundation.org>
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
 drivers/scsi/ufs/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 7b8e591265671..ed0d6ea967e17 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -353,7 +353,7 @@ static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
 		REG_UFS_CFG2);
 
 	/* Ensure that HW clock gating is enabled before next operations */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG2);
 }
 
 static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
-- 
2.43.0



