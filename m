Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC171993A0;
	Thu,  6 Jun 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683254; cv=none; b=hHZkE3aK1Wo/OldFgekFcoah2DgTBk18+ZMgKpRK9Aafyw2f4hQ3tV43VY7V9pKS4/IWfHel73EITyDclvojERehHHdiUV6JOzBIuFs7L1vGM+wUba6k75e1lYh72UcnCTqV0WdX0q2pqn6B4OjfsDZlFCm4YOd1TjUjPt5ypX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683254; c=relaxed/simple;
	bh=Sh3nm9VxXcn/aU6pttDBb8aOiw0iIUUjcMvYj/xUAOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KelLmmqFuP07a8hkEULFlw/9KsTlP5EOoK3SxvFU16awLZEH3wUV54q57iQzq0KCyWDxOuls/HBKagq/F7f+qDK0osZK+IbXEAMID9sQZcz8PkKyboT3j9YIQHPZ92TGbiPoqFXEgPKX2YC/GrGHwQYhkSgGKOhRr5DaK1ojBOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKo0isbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKo0isbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3E7C4AF0B;
	Thu,  6 Jun 2024 14:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683254;
	bh=Sh3nm9VxXcn/aU6pttDBb8aOiw0iIUUjcMvYj/xUAOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKo0isbQSwT9RKj0FquiArJOK9jnDEQ3Jyzp5Gx0lbtSAOlwfr/sQAr5jN6QqhaOg
	 9G8ieia7JWu4rUCwaOkFjTRxmtGjJXGDwQ8cVHC079pbE6+q4QoZfYj5hzvbkS4uYD
	 DRq0j0VokNhgr84fsDuL8zLfwr5pGhf9j1khvdfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/473] scsi: ufs: qcom: Perform read back after writing CGC enable
Date: Thu,  6 Jun 2024 16:00:37 +0200
Message-ID: <20240606131703.484209822@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index edbd3d7cf83aa..337c0ef0fab6d 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -336,7 +336,7 @@ static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
 		REG_UFS_CFG2);
 
 	/* Ensure that HW clock gating is enabled before next operations */
-	mb();
+	ufshcd_readl(hba, REG_UFS_CFG2);
 }
 
 static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
-- 
2.43.0



