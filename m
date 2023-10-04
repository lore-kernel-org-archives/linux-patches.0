Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E16A1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EEEC433C8;
	Wed,  4 Oct 2023 18:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443197;
	bh=KKaa0B9Sg+jP1C5zPoHdSm1SLVMAjycVd21VW+2J+EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TypeIzssE49cnb8USMf9FmhiCGPXslvwWEEt/ieIx3S8yYoge3bGjMg4jfs1ITDcj
	 KYvZ3IAY9lHCN2sk7etUk03m04oTqUhbR4TEXiqqi51aYKVGYl1V+oD7LrBxb7xXwR
	 O5ceN96kfhRGps1PEi63+JiePOAjAPqz/3sv8rYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/259] net: hns3: only enable unicast promisc when mac table full
Date: Wed,  4 Oct 2023 19:54:04 +0200
Message-ID: <20231004175220.664909129@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

[ Upstream commit f2ed304922a55690529bcca59678dd92d7466ce8 ]

Currently, the driver will enable unicast promisc for the function
once configure mac address fail. It's unreasonable when the failure
is caused by using same mac address with other functions. So only
enable unicast promisc when mac table full.

Fixes: c631c696823c ("net: hns3: refactor the promisc mode setting")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 884e45fb6b72e..a8019eac2b33e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8930,7 +8930,7 @@ static void hclge_update_overflow_flags(struct hclge_vport *vport,
 	if (mac_type == HCLGE_MAC_ADDR_UC) {
 		if (is_all_added)
 			vport->overflow_promisc_flags &= ~HNAE3_OVERFLOW_UPE;
-		else
+		else if (hclge_is_umv_space_full(vport, true))
 			vport->overflow_promisc_flags |= HNAE3_OVERFLOW_UPE;
 	} else {
 		if (is_all_added)
-- 
2.40.1



