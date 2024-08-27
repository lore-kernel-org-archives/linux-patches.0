Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D02F38DC7;
	Tue, 27 Aug 2024 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770339; cv=none; b=bsVSL5dEl1KK23t3flOxNWrWKPZ7UCK7TD1x8O8frs4Y5hIDLdiyxCwkkv5fbgC72WzmjImGwKTAN9wWaSDtN+EbGF3Yj1fGV7bgwkJIRuayeH6TEmPCJXDZ2j4EeR4zEkkGtaTSuSzNtQne9A6PJLJwFKv1FwebGiTyaRkaQWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770339; c=relaxed/simple;
	bh=fzNjaX2gKKCB7mlz9d7xrlb5UfIgtwXS08EYubzfLLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnylPpdsQMC/3USbnJAbdQllJixMn3O/wU9AL2rSA8fxVFGzRg/dLvlQetOKPZdVJ/a1ay96TKTePPZPoNi1DUc/H1XayQAVp2SxHBV2nhv8cDjdWFMVInEfK1JxrKPfpm9LXd/CCE56HSRHoWzvW0QkcUtAkIQ0XpS+ja914/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHZlu7O3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHZlu7O3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7144C4DE1E;
	Tue, 27 Aug 2024 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770339;
	bh=fzNjaX2gKKCB7mlz9d7xrlb5UfIgtwXS08EYubzfLLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHZlu7O355+lj8J1jGWw0qM9XMMA3Ibo8ml9uXHUXK9ffxkO4VEPYzkzw1e0mo51R
	 njHI1SHvo6ezI/PdvsMICs0iGXg0bRaK6tq+CXe8JtmfoPmSLmuy9spPBKyIB4eLBv
	 mbtjU16ZUa3CyuuQgIY1sQCdtNSehbirBZHJCFII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/341] net: hns3: add checking for vf id of mailbox
Date: Tue, 27 Aug 2024 16:37:11 +0200
Message-ID: <20240827143851.025007304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 4e2969a0d6a7549bc0bc1ebc990588b622c4443d ]

Add checking for vf id of mailbox, in order to avoid array
out-of-bounds risk.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 877feee53804f..61e155c4d441e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -1124,10 +1124,11 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		req = (struct hclge_mbx_vf_to_pf_cmd *)desc->data;
 
 		flag = le16_to_cpu(crq->desc[crq->next_to_use].flag);
-		if (unlikely(!hnae3_get_bit(flag, HCLGE_CMDQ_RX_OUTVLD_B))) {
+		if (unlikely(!hnae3_get_bit(flag, HCLGE_CMDQ_RX_OUTVLD_B) ||
+			     req->mbx_src_vfid > hdev->num_req_vfs)) {
 			dev_warn(&hdev->pdev->dev,
-				 "dropped invalid mailbox message, code = %u\n",
-				 req->msg.code);
+				 "dropped invalid mailbox message, code = %u, vfid = %u\n",
+				 req->msg.code, req->mbx_src_vfid);
 
 			/* dropping/not processing this invalid message */
 			crq->desc[crq->next_to_use].flag = 0;
-- 
2.43.0



