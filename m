Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5B143F8AD;
	Tue, 21 Jul 2026 22:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673509; cv=none; b=sfpPYFR9J03MzuiXSZnUqRx5ljpKWavVJX9ej+QHFDHVS2s/MlxJ+byqr2apvrh3lVEA1q5gF/kjqNmV17VgOhDQTQe8PIssRqW7DtAIQExMO7JWkNgoFOKTpm0xROTHwtAxTXyaiQNWnWq8PZUmjRwYanRKvbQ3CfNdSSbSdOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673509; c=relaxed/simple;
	bh=euYfQt0DiQlrjsOX6EF3f3s+MvXYQVKXJZDMZIubv/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkbDsrpW+hzalaUBNJcfqXtHnPBPMpt0zkeGU2sDHZBPRw1yWb1cjZiYCbxh7Iu11jslPEtspnoQgDgl65e36yuNer5FPXBsyooqA5XGaCnTDlHCakulQ8MnP9+yy82OtDyJJdpMI4C+KwrGeb51iLYaecEuhjRVb0gTZuQpYQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8ah8VnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8ah8VnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA741F00A3D;
	Tue, 21 Jul 2026 22:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673506;
	bh=W8o66SyKGUiVsUgZ8nJrQ3prOtjlWFB1AeXkFlp1BfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8ah8VnSnrDYEzU8TOVftKThrq9f5cpduB6Ygl6fo8BiOFRUmK0ujlUh8I9cfGPEj
	 qvJ1AzrQ91gAzuLPsWJJzLxpFWtQAl0jEJzP2aH1v4Zt4bSGwc5KVa5Gku90fol1ey
	 DeD5ZlKyFrhs+N9pG6Z/FnQ17inJjOm3W5R7wq+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/699] RDMA/hns: Fix arithmetic overflow in calc_hem_config()
Date: Tue, 21 Jul 2026 17:19:08 +0200
Message-ID: <20260721152359.961106031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>

[ Upstream commit a38e4410af9ad8b7ad2217254da06cd4dc21f0ed ]

If bt_num is 3 or 2, then the expressions like
l0_idx * chunk_ba_num + l1_idx are computed in 32-bit
arithmetic before being assigned to a u64 index field,
which can lead to overflow.

Cast the first operand to u64 to ensure the arithmetic
is performed in 64-bit.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2f49de21f3e9 ("RDMA/hns: Optimize mhop get flow for multi-hop addressing")
Signed-off-by: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
Link: https://patch.msgid.link/20260413091527.39990-1-Alexander.Chesnokov@kaspersky.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 7cb98d09fb9b27..570a1bc24fd5a7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -346,14 +346,14 @@ static int calc_hem_config(struct hns_roce_dev *hr_dev,
 	bt_num = hns_roce_get_bt_num(table->type, mhop->hop_num);
 	switch (bt_num) {
 	case 3:
-		index->l1 = l0_idx * chunk_ba_num + l1_idx;
+		index->l1 = (u64)l0_idx * chunk_ba_num + l1_idx;
 		index->l0 = l0_idx;
-		index->buf = l0_idx * chunk_ba_num * chunk_ba_num +
-			     l1_idx * chunk_ba_num + l2_idx;
+		index->buf = (u64)l0_idx * chunk_ba_num * chunk_ba_num +
+					 (u64)l1_idx * chunk_ba_num + l2_idx;
 		break;
 	case 2:
 		index->l0 = l0_idx;
-		index->buf = l0_idx * chunk_ba_num + l1_idx;
+		index->buf = (u64)l0_idx * chunk_ba_num + l1_idx;
 		break;
 	case 1:
 		index->buf = l0_idx;
-- 
2.53.0



