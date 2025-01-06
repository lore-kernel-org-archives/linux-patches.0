Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5880486332;
	Mon,  6 Jan 2025 15:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177733; cv=none; b=L7IgZ/FFM9VniJu6XGDD7rfdO1/dGBZqkrNqetos68MDokqXqzlg9pLZzPYhbLxS7UtgQvpU1byIB9NP3cD8XRqjEb29WFz2F9CfVCiAuAK6mUUkXQ3LCsYDsigLyHvns8fwzJlAQ8xVPvy9gLvdsyy0lGSURj4rEskEvO6965U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177733; c=relaxed/simple;
	bh=C9LwLldevINXyPcPUhAtKzJucy6aVggP+TxQQ1bt9Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAzADFW25N3qUh1md8rq+gbQLvvI2/IcOGHzO/hZLSzHO49NvrWtJw0ScJJo9pAdTqQsQrpLOvCXi4MGpPvhe45CLkzV8+HUBmlomNfKfeoWFYRuUc0iOtngNLZli2Hcp7RqjaOSkU+Ln+hqZAcuktG5nbjjL6GYsrsgBeggrRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STTNpgdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STTNpgdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89553C4CED2;
	Mon,  6 Jan 2025 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177732;
	bh=C9LwLldevINXyPcPUhAtKzJucy6aVggP+TxQQ1bt9Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STTNpgdx8vKlG+1O1R9+BvkpA2SlWzueH4vZ7gbibXOlMNYI675eNIpUK44KqqFG3
	 tw0wUu3SsJK4ErzovZe0vidDFBL5duUtESyvzt0MMHwIsBvCIIiJ+dwetqbimO3Mh6
	 qOvV+MK7G55gAGQrDMC2Edn8iTzm5mfrSRtmShBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/156] RDMA/hns: Fix accessing invalid dip_ctx during destroying QP
Date: Mon,  6 Jan 2025 16:15:24 +0100
Message-ID: <20250106151143.172219384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 0572eccf239ce4bd89bd531767ec5ab20e249290 ]

If it fails to modify QP to RTR, dip_ctx will not be attached. And
during detroying QP, the invalid dip_ctx pointer will be accessed.

Fixes: faa62440a577 ("RDMA/hns: Fix different dgids mapping to the same dip_idx")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241220055249.146943-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 697b17cca02e..6dddadb90e02 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5619,6 +5619,9 @@ static void put_dip_ctx_idx(struct hns_roce_dev *hr_dev,
 {
 	struct hns_roce_dip *hr_dip = hr_qp->dip;
 
+	if (!hr_dip)
+		return;
+
 	xa_lock(&hr_dev->qp_table.dip_xa);
 
 	hr_dip->qp_cnt--;
-- 
2.39.5



