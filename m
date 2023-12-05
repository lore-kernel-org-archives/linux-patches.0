Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2758F62;
	Tue,  5 Dec 2023 03:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3Uu0JZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AD4C433C8;
	Tue,  5 Dec 2023 03:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747493;
	bh=+p2+5eojcy8CvYvWw5FeeQVZ+1fr9mDL7Ve1TsAPYjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3Uu0JZaCoJyOdLKxN+S+ge5lZURaE6/uGFWA6GRM8gMCG8kSca5RHT1shmnzA46i
	 epzikfgj8O9T+wz6q3TdiMk1RZnx6qmI9U9sxqWKwdMYm7kpOPYBT0xifpqTuLhVwj
	 13YkSRVl77jCof9qx5861zZuddhFXrAqrrSFT4Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/135] octeontx2-pf: Fix adding mbox work queue entry when num_vfs > 64
Date: Tue,  5 Dec 2023 12:16:58 +0900
Message-ID: <20231205031536.772694055@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 51597219e0cd5157401d4d0ccb5daa4d9961676f ]

When more than 64 VFs are enabled for a PF then mbox communication
between VF and PF is not working as mbox work queueing for few VFs
are skipped due to wrong calculation of VF numbers.

Fixes: d424b6c02415 ("octeontx2-pf: Enable SRIOV and added VF mbox handling")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/1700930042-5400-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 000dd89c4baff..d6f7a2a58aee8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -556,7 +556,9 @@ static irqreturn_t otx2_pfvf_mbox_intr_handler(int irq, void *pf_irq)
 		otx2_write64(pf, RVU_PF_VFPF_MBOX_INTX(1), intr);
 		otx2_queue_work(mbox, pf->mbox_pfvf_wq, 64, vfs, intr,
 				TYPE_PFVF);
-		vfs -= 64;
+		if (intr)
+			trace_otx2_msg_interrupt(mbox->mbox.pdev, "VF(s) to PF", intr);
+		vfs = 64;
 	}
 
 	intr = otx2_read64(pf, RVU_PF_VFPF_MBOX_INTX(0));
@@ -564,7 +566,8 @@ static irqreturn_t otx2_pfvf_mbox_intr_handler(int irq, void *pf_irq)
 
 	otx2_queue_work(mbox, pf->mbox_pfvf_wq, 0, vfs, intr, TYPE_PFVF);
 
-	trace_otx2_msg_interrupt(mbox->mbox.pdev, "VF(s) to PF", intr);
+	if (intr)
+		trace_otx2_msg_interrupt(mbox->mbox.pdev, "VF(s) to PF", intr);
 
 	return IRQ_HANDLED;
 }
-- 
2.42.0



