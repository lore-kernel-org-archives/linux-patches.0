Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F3EEEBB;
	Tue, 23 Jan 2024 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969519; cv=none; b=KfD5GmiUIHbiKvJcMfGyMNCUU05zVjbNNCjNinUDR7wUJSbU5tLzjErwEjjfF/RMxuoxO8yln15CD6XHYJCdtDgsXalrv+0g3Q+v1kviBQHxECR8cOIHZvBKb8YknBfsSjhgpmPrM/pWx7xu0B0G0m+/ShjgbKWudEGEp/KKJUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969519; c=relaxed/simple;
	bh=FzIvI0Ps9eWdo3Qfy+pUihPcgp++mvl50uMW1AyMNWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGOO8oD38gjozVnHCzQi8MQbkZQJhgK28IL9YWo54NmnY+NZ9c1T/tbgQ+CgptbDxnIb+xGgYhr616cR+OcdP4wnSzUdJy16245U07tj7x5XjHN2wPin2dP5zouJkp66yIFKGqw1nxQ2iZgTQN7CsCoaOJoEiQ+KczS8BAq49+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCrzu8Ne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCrzu8Ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD5BC433B1;
	Tue, 23 Jan 2024 00:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969519;
	bh=FzIvI0Ps9eWdo3Qfy+pUihPcgp++mvl50uMW1AyMNWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCrzu8NeVPmyKMcKrylx62tdbarjHl9xY/0S1EPOmnOFwo/d1UqiBo+/aekuagmJ7
	 4BNYkMkmX9XIUPWkyTDdoAXvRvgYQNoGlHeuwFFFrX1PeYIHjsIZHY/0FovnlOOdPJ
	 VfiidRjtofWKeE0IUvOtNk//Sq0NQdMYNeFnCGwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 301/641] RDMA/hns: Fix memory leak in free_mr_init()
Date: Mon, 22 Jan 2024 15:53:25 -0800
Message-ID: <20240122235827.330264236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 288f535951aa81ed674f5e5477ab11b9d9351b8c ]

When a reserved QP fails to be created, the memory of the remaining
created reserved QPs is leaked.

Fixes: 70f92521584f ("RDMA/hns: Use the reserved loopback QPs to free MR before destroying MPT")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231207114231.2872104-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index e4753c802942..aa9527ac2fe0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2698,6 +2698,10 @@ static int free_mr_alloc_res(struct hns_roce_dev *hr_dev)
 	return 0;
 
 create_failed_qp:
+	for (i--; i >= 0; i--) {
+		hns_roce_v2_destroy_qp(&free_mr->rsv_qp[i]->ibqp, NULL);
+		kfree(free_mr->rsv_qp[i]);
+	}
 	hns_roce_destroy_cq(cq, NULL);
 	kfree(cq);
 
-- 
2.43.0



