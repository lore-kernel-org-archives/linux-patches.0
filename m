Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278831875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14C5C433F0;
	Wed, 28 Dec 2022 16:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243675;
	bh=0NR62xpQmLXGMFrzOugU88C4JdzBZ6902uIU3zqCOgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGONJQbGgTrBkIT8PdbbPoACsKOTvZgYbMAHXuo6l0ZkQxfJKT4pjrZA1AzZgAF/a
	 wsgNaPmEPee9sC27OQeYhZOvCd44ODutAGrekxUbvx82W9uGvrU3FBrqm3H91TAk3r
	 kpIXH2VW1IHR5DyMkp88l5hI/oAiP2kroX9BjE/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0532/1146] drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
Date: Wed, 28 Dec 2022 15:34:31 +0100
Message-Id: <20221228144344.625852128@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 01de1123322e4fe1bbd0fcdf0982511b55519c03 ]

If vp alloc failed in qlcnic_sriov_init(), all previously allocated vp
needs to be freed.

Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 9282321c2e7f..f9dd50152b1e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -221,6 +221,8 @@ int qlcnic_sriov_init(struct qlcnic_adapter *adapter, int num_vfs)
 	return 0;
 
 qlcnic_destroy_async_wq:
+	while (i--)
+		kfree(sriov->vf_info[i].vp);
 	destroy_workqueue(bc->bc_async_wq);
 
 qlcnic_destroy_trans_wq:
-- 
2.35.1



