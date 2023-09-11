Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF74F11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35794C433C7;
	Mon, 11 Sep 2023 15:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445063;
	bh=5EAASnXOBw5vby7O6JYuTHGOjvrd1iC889JLKGFYDzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQ5CwQBjU7j7u1nuZXQUAQl0AcTj9Yo6q+FCxpKt8Te97fm4SDhDN8nDDxvK+dQRw
	 JFhqwoXGIkkY53x+waRdtaiKU5TUJqsQsCA73LvT/U33ba59vBtkAlg6HcyU1UwpOo
	 h4Oh68JaiUJvGuh/IvdvsJFL/Y2tVU743NVewdJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/600] cteonxt2-pf: Fix backpressure config for multiple PFC priorities to work simultaneously
Date: Mon, 11 Sep 2023 15:44:00 +0200
Message-ID: <20230911134639.727068189@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 597d0ec0e4ca6a912affea4cc94df08959e9ec74 ]

MAC (CGX or RPM) asserts backpressure at TL3 or TL2 node of the egress
hierarchical scheduler tree depending on link level config done. If
there are multiple PFC priorities enabled at a time and for all such
flows to backoff, each priority will have to assert backpressure at
different TL3/TL2 scheduler nodes and these flows will need to submit
egress pkts to these nodes.

Current PFC configuration has an issue where in only one backpressure
scheduler node is being allocated which is resulting in only one PFC
priority to work. This patch fixes this issue.

Fixes: 99c969a83d82 ("octeontx2-pf: Add egress PFC support")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230824081032.436432-4-sumang@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
index 6492749dd7c89..bfddbff7bcdfb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
@@ -70,7 +70,7 @@ static int otx2_pfc_txschq_alloc_one(struct otx2_nic *pfvf, u8 prio)
 	 * link config level. These rest of the scheduler can be
 	 * same as hw.txschq_list.
 	 */
-	for (lvl = 0; lvl < pfvf->hw.txschq_link_cfg_lvl; lvl++)
+	for (lvl = 0; lvl <= pfvf->hw.txschq_link_cfg_lvl; lvl++)
 		req->schq[lvl] = 1;
 
 	rc = otx2_sync_mbox_msg(&pfvf->mbox);
@@ -83,7 +83,7 @@ static int otx2_pfc_txschq_alloc_one(struct otx2_nic *pfvf, u8 prio)
 		return PTR_ERR(rsp);
 
 	/* Setup transmit scheduler list */
-	for (lvl = 0; lvl < pfvf->hw.txschq_link_cfg_lvl; lvl++) {
+	for (lvl = 0; lvl <= pfvf->hw.txschq_link_cfg_lvl; lvl++) {
 		if (!rsp->schq[lvl])
 			return -ENOSPC;
 
@@ -128,7 +128,7 @@ static int otx2_pfc_txschq_stop_one(struct otx2_nic *pfvf, u8 prio)
 	int lvl;
 
 	/* free PFC TLx nodes */
-	for (lvl = 0; lvl < pfvf->hw.txschq_link_cfg_lvl; lvl++)
+	for (lvl = 0; lvl <= pfvf->hw.txschq_link_cfg_lvl; lvl++)
 		otx2_txschq_free_one(pfvf, lvl,
 				     pfvf->pfc_schq_list[lvl][prio]);
 
-- 
2.40.1



