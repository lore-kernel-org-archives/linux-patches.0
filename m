Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2621362;
	Tue,  3 Dec 2024 15:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241599; cv=none; b=dH+17ZnA+R9puUr7ZMnkCQxVRDpkDVD+za5iNAV8V9HHIz0YeGwYqWHxM8oDMlj+nFE6AW45v2SSmhWZnH1o1ALv7f7mvsyZhy+UasovNCWbSEnoFkZONLAYt9axj8jdJttgrM1CzyL+hGAPyJyzG58E92BHjN+JbNR02BnbwHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241599; c=relaxed/simple;
	bh=XW34TQYrsDcJVOIU7PwUsskcQDnTg5t5r1k6Xu+EIm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDcN/jXUEdYpVJjiZxZmSM5HkmWb1AmH4ZWK0CHmJd0Ev/Gx4xHiL+jWse0tD5h7M6AJhfImJg3dQ94Ue64BLGaqDmMtgS9n80C1CRrgpa17hIfwB8uMDGrUyo+UMxz8TTAa4lCzVyaqQehTpUToENqMGfvqPa3FnzPrh/IoSno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxjZl/AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxjZl/AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B966C4CECF;
	Tue,  3 Dec 2024 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241598;
	bh=XW34TQYrsDcJVOIU7PwUsskcQDnTg5t5r1k6Xu+EIm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxjZl/ATO6x4tE4W44oWwQlvdN/204a8j37TVsHIwKLs/BIZIwEDtHse+dHf7olCs
	 8xUig66/HUzpL5jhf09K31ELq+w/AiKIpFgO3Cnue7lGUft1BvXH90rboxM9aKr90K
	 FcIxX7dm/osD8UlheT1+ZQ03lK876I5uACgbzxrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 463/826] mailbox: mtk-cmdq: fix wrong use of sizeof in cmdq_get_clocks()
Date: Tue,  3 Dec 2024 15:43:10 +0100
Message-ID: <20241203144801.825381789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 271ee263cc8771982809185007181ca10346fe73 ]

It should be size of the struct clk_bulk_data, not data pointer pass to
devm_kcalloc().

Fixes: aa1609f571ca ("mailbox: mtk-cmdq: Dynamically allocate clk_bulk_data structure")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 4bff73532085b..9c43ed9bdd37b 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -584,7 +584,7 @@ static int cmdq_get_clocks(struct device *dev, struct cmdq *cmdq)
 	struct clk_bulk_data *clks;
 
 	cmdq->clocks = devm_kcalloc(dev, cmdq->pdata->gce_num,
-				    sizeof(cmdq->clocks), GFP_KERNEL);
+				    sizeof(*cmdq->clocks), GFP_KERNEL);
 	if (!cmdq->clocks)
 		return -ENOMEM;
 
-- 
2.43.0



