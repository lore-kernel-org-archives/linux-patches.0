Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020561D0429;
	Wed,  2 Oct 2024 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876343; cv=none; b=M3P6fuhgSlhGePniczabbEj9pTpvEsBzyEhQtlcnRIQ24W2DYjVVaAgiUlODvc5v3gQL6IHm4zCzdjhncdPExoUAZxO8jlJ6FQDt77YvySO0xFrWSBIYpd5PQxmwQlD75QHRt5AgwOmyKjf++rBkvFRzjorOOz7kKHGS0ZVX3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876343; c=relaxed/simple;
	bh=0Rmv3TvukU2eKNaDbg9YeKpP/LmvD0GFXdGgYsVjarU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeWzVp/ErV8JOjWP8I93ldl+AVHLG3yocMsYR4mrq0Wwre/ud/3ek87jHRcg2HJEVSlaWU5wpm+4gABswoU7qH/Drw8EdMDlKW+ED9Q0gLGYeS1h5hoCe/dTwwg07jelh6IlEMPTYaEHCrF3EipeOSjXoGn0SX6AqFUbKxw2cKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7PrZlbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7PrZlbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE07C4CEC5;
	Wed,  2 Oct 2024 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876342;
	bh=0Rmv3TvukU2eKNaDbg9YeKpP/LmvD0GFXdGgYsVjarU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7PrZlbA68k7c/ZlmJ53tp63jAUK50GfI2gGIRlZtnXsFYu500M2R5E/chhfA528k
	 oehYKKYjQY4bh/xmplIZdE6t8nPcPdeQWd+SCQMIZPOR0KafXLszyagZuCQ/wLE0V4
	 D+PU7GDi7bONiaSKm0WehcD4Z6aN3RZj0rGnSorQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 411/695] RDMA/hns: Fix Use-After-Free of rsv_qp on HIP08
Date: Wed,  2 Oct 2024 14:56:49 +0200
Message-ID: <20241002125838.858834500@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit fd8489294dd2beefb70f12ec4f6132aeec61a4d0 ]

Currently rsv_qp is freed before ib_unregister_device() is called
on HIP08. During the time interval, users can still dereg MR and
rsv_qp will be used in this process, leading to a UAF. Move the
release of rsv_qp after calling ib_unregister_device() to fix it.

Fixes: 70f92521584f ("RDMA/hns: Use the reserved loopback QPs to free MR before destroying MPT")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a166b476977f1..2225c9cc63661 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2972,6 +2972,9 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 
 static void hns_roce_v2_exit(struct hns_roce_dev *hr_dev)
 {
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08)
+		free_mr_exit(hr_dev);
+
 	hns_roce_function_clear(hr_dev);
 
 	if (!hr_dev->is_vf)
@@ -6951,9 +6954,6 @@ static void __hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
 	hr_dev->state = HNS_ROCE_DEVICE_STATE_UNINIT;
 	hns_roce_handle_device_err(hr_dev);
 
-	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08)
-		free_mr_exit(hr_dev);
-
 	hns_roce_exit(hr_dev);
 	kfree(hr_dev->priv);
 	ib_dealloc_device(&hr_dev->ib_dev);
-- 
2.43.0



