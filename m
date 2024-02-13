Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76A75FBB5;
	Tue, 13 Feb 2024 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845017; cv=none; b=tLbvk1rtgwSkvl5xQjdcsPS9pVWN10v/fPmjczkrGGzT4ZvmptfEzNTcIlp4G8i1y3bKZVlJOA8kmRBJiPrg4J9DDxaHAjb5XFu8vZXLGju/wMRwU1xS851XD9rRLmDVzITlPsGTZbGoS2E1ciLCHZ1q38gWbJcYss4kpaqfXHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845017; c=relaxed/simple;
	bh=Ahgi4A1qCSLhUb7fkcuT7llRPXEdlHFlLcKNYJn6WNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHvIePgEctiRXFjrJvdZ2Vw6Lr0GbWTWECTBrSc0aVQ0EOt9wokpd0NoAIQ6l9CKjw3+hZz7K7NgOP1XnAFvOMxgpaLZ4xPy6D8t1zlwGJ0jI3OHcFAAJouSjoCEUa0ZD711//4tUSk+ffVJ98/ykZv1fy2X5+nrU68nBiKqX90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kr1/H+Ou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kr1/H+Ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A710C433C7;
	Tue, 13 Feb 2024 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845016;
	bh=Ahgi4A1qCSLhUb7fkcuT7llRPXEdlHFlLcKNYJn6WNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kr1/H+OuAvsOE28Mhfv77FH2FxDI6MaGigqz/aGM2wYyIOsILr+z4+CgPg8Cmnd9j
	 lTnHWhIsNRLUrX9Q7Tti04OuHoYQWbEc5dKiUniSMQzRIlesqos3T4G2fVJaJIaP2L
	 e3sP3FG8wAoRjQaQKbFwdUWM1sohWsRwoso0qCV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/64] octeontx2-pf: Fix a memleak otx2_sq_init
Date: Tue, 13 Feb 2024 18:21:07 +0100
Message-ID: <20240213171845.405777404@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit b09b58e31b0f43d76f79b9943da3fb7c2843dcbb ]

When qmem_alloc and pfvf->hw_ops->sq_aq_init fails, sq->sg should be
freed to prevent memleak.

Fixes: c9c12d339d93 ("octeontx2-pf: Add support for PTP clock")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 0f896f606c3e..c00d6d67db51 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -930,8 +930,11 @@ int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	if (pfvf->ptp && qidx < pfvf->hw.tx_queues) {
 		err = qmem_alloc(pfvf->dev, &sq->timestamps, qset->sqe_cnt,
 				 sizeof(*sq->timestamps));
-		if (err)
+		if (err) {
+			kfree(sq->sg);
+			sq->sg = NULL;
 			return err;
+		}
 	}
 
 	sq->head = 0;
@@ -947,7 +950,14 @@ int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	sq->stats.bytes = 0;
 	sq->stats.pkts = 0;
 
-	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
+	err = pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
+	if (err) {
+		kfree(sq->sg);
+		sq->sg = NULL;
+		return err;
+	}
+
+	return 0;
 
 }
 
-- 
2.43.0



