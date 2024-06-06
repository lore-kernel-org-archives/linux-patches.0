Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420D919924F;
	Thu,  6 Jun 2024 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683207; cv=none; b=tVcmGBmXmLjgFW5gn77lYFH/sV/JD6ZecQeJdVyNEnWTUezQfUHbjQbXSqwV345P+dbZgEMGcNmW3lnGF6W97IVzbd3tQXdxzHGzY1SArALXPPgUOdqIC+JXclDu04ag+i/TwtfYzj7ZWdR6N8D6CnhnjGi4ZX9ttH5JpH+HKpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683207; c=relaxed/simple;
	bh=9KpcVrUwiHIH7DntxvIWUtNp8ZFVivfG1ZyU0wRhAGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7dV2YiT5Kx8V61k5tXo8DA5/ymhBUOlKxMV5+nr5KqGxUzL+vMS2X5/SQOwtvRg/z30+6KXzzsIJquF80Q3syqEuKggmj0AvRG/uwIG0wDnbpVMxTh2IKPAuMGenyzzeQdVLh4px2Z+O7zQtlpzfNwbKJdIuQ63XJU3bDFQSdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vux5pDhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vux5pDhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B6CC2BD10;
	Thu,  6 Jun 2024 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683207;
	bh=9KpcVrUwiHIH7DntxvIWUtNp8ZFVivfG1ZyU0wRhAGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vux5pDhpQ7QixwHrzr4kCxTeffkWWIz/l7hpsuVRJ6RvsnWKIK7kMmIdZszyq4YeF
	 o3f4F4S16t0u/dO5XbWg3CkfwtTA6OuynHAiXjvZQjVktqXDYNIyZq+b2iT2i+XO3g
	 Oj1gFy9LLfVqIuim+nSnHHudfIsOLdLcQdg+xytQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/744] scsi: ufs: qcom: Perform read back after writing reset bit
Date: Thu,  6 Jun 2024 15:57:02 +0200
Message-ID: <20240606131737.231559372@linuxfoundation.org>
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
index d6f8e74bd5381..532667d8e6f0e 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -149,10 +149,10 @@ static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 		    REG_UFS_CFG1);
 
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
@@ -161,10 +161,10 @@ static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
 		    REG_UFS_CFG1);
 
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



