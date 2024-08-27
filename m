Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CF81C93AF;
	Tue, 27 Aug 2024 15:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772367; cv=none; b=B6RrgullwEkiu4//jSR+FaKksVcvv7Lz2848ztReoBKjLtmQ87F38rD3Nd7xv+onFCf1LQvuZsxBnWtqIKLG0eo6W/MA29HRoMNJO9oFA0mPltATVgIUYkH+ogsCryF6fFtgy26sG0dZHDz4p+doRf31hNiqPYlc88IXFqGAbGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772367; c=relaxed/simple;
	bh=u/SXivUR/sWhOYM9gBxZaNItvgM1Tf0kVvmq268fEjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed0nj9G+Ss/8zMg+kaFJTXIuMDex1Gl9vroSJCmlt+emGuBjqOUPNbmKOGdat4lqs5/xGfiW8Vk36HoAfFQJu+koa7Z6nJ+V39nVJhxlQ4BnZDWQEt8qhUI/nbaFWaqAsbcDLnUjDF44pYko0K+SPpPzv9Q47q/nkBvFV5kNKvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkcjrWAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkcjrWAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A66C4DE05;
	Tue, 27 Aug 2024 15:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772367;
	bh=u/SXivUR/sWhOYM9gBxZaNItvgM1Tf0kVvmq268fEjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkcjrWANCVtFUZ7QHZ1IpD4G5a3vk56IPJ1DJnyAWOnx2ymGJaboCU67GHg5xo0rd
	 kNioYDDOMI5r3oGgaNpJ4vrPe5DqH8sB6gZNfA7vGrEg/937vphb1iAuVBt37pWMzK
	 coXy04dt1f0bQN0CBd+VjEm4uR6lrxs29gyQMNbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/321] net: hns3: add checking for vf id of mailbox
Date: Tue, 27 Aug 2024 16:38:21 +0200
Message-ID: <20240827143845.578110460@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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



