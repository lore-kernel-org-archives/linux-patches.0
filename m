Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4AE13D630;
	Thu, 13 Jun 2024 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281804; cv=none; b=IKIdz4QuzMbwTMYsTu2tXXDSHrNvUYfGljh1baqDKx/6Rir4Z4gnvqoLZgzTgSdbmwFy5ybEwUAYqwclfH9pRI3p/zNlxwWBPA5pFO/LgoqclFch2OJsXfZcO0hm/v6nGBNK8xhUDdN3KwD95YcDvBfRxQ3+6AmLlqEeq7MMI6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281804; c=relaxed/simple;
	bh=JkVMpduFssHxq8WP0yNFOraYvwGpVJZyKDuwOOgkGA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1S5zq7a26YLOAPql3vkilIUmn3Yt3bVznZ7kZJ/mDtWEjU5cJ+Ks9qIXxbD52Ztferp+r6W8UQvLVV3fEp2/eW2ZtQ35PqDUYmoXyiNV7A+YfpTnlsi1SLLLPVXhOpUy44vm8B3EC1WrTpUv0kXuQeJvf6TmBaj5U0IyuYFutU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S713vpwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S713vpwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6936C2BBFC;
	Thu, 13 Jun 2024 12:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281804;
	bh=JkVMpduFssHxq8WP0yNFOraYvwGpVJZyKDuwOOgkGA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S713vpwaLHAk7uG/gJI2aXExKBKt2fkAY7X93NBm2h6kTgUJb3PL8Kz+XC6Tr++Pd
	 6mjP8KhwZZCc/CMUhyXgJCCAr6kh+SZSmF8iZTWSSRgHmfsD9rRkkJMIRbD3rAJQXq
	 PYCyn4J8vHlMwWKtIqMD1O9xdK4plXGIRdB9LRXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/402] scsi: ufs: qcom: Perform read back after writing CGC enable
Date: Thu, 13 Jun 2024 13:30:19 +0200
Message-ID: <20240613113304.554807495@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ce45f3e8a35c3..361df2a2db5bf 100644
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



