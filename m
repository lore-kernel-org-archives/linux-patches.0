Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D690419ADAC;
	Thu,  6 Jun 2024 14:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683360; cv=none; b=Aw79mn1M23werctu/nIqUsU9QQTuXvJg7DhnSi37V5G+H9H331CeFmkOU9hpou4JplR3SFBcTO5wJ2vcJD+x9DLqrxhktIj4OVHcootBHsjIWTsXVrDHxlTxfj+0HRjymVxx8G7fZ6q5jhkCo4r8b3cPYI7hzP2mu0GxmnebJRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683360; c=relaxed/simple;
	bh=AbldccbUkSGv1XhBW7gRO2Z0xBnpBcKlea+7Lq5zLsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV+WpBP5YvjF9oz/DagcqonMbsv+9IZYIIDj7DFUd6ld8yz4vt86fhUWq9jjjn+97emsbiZ/2Xa8lL9weetRmDXL9Eva+WnipjJbXw64IcIlYapDevcFypxaChNuOy4DqTo6pYkJz5N7bNkfN5KfpnbnJUZaWCU6Ri3oVIa7XDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbaPh32S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbaPh32S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CB9C2BD10;
	Thu,  6 Jun 2024 14:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683360;
	bh=AbldccbUkSGv1XhBW7gRO2Z0xBnpBcKlea+7Lq5zLsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbaPh32SVeHVDlIhETdtd7en5phRkvuWAyuCkmWKubiHpmS30A18CXSunT26qqP+H
	 Apj9jtu8NOGdhX74gv3wxtuIri9ZzMBVzs/nwdazNBJze9wFoqr6b8Ga9bkZ9/u3lU
	 MbP/4HSEkSIepUxyR/lVjxEflf5zM6uj8K7TpVto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/473] RDMA/hns: Fix GMV table pagesize
Date: Thu,  6 Jun 2024 16:02:49 +0200
Message-ID: <20240606131707.765745085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit ee045493283403969591087bd405fa280103282a ]

GMV's BA table only supports 4K pages. Currently, PAGESIZE is used to
calculate gmv_bt_num, which will cause an abnormal number of gmv_bt_num
in a 64K OS.

Fixes: d6d91e46210f ("RDMA/hns: Add support for configuring GMV table")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d06b19e69a151..08e2e9569a52a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2229,7 +2229,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 		caps->gid_table_len[0] = caps->gmv_bt_num *
 					(HNS_HW_PAGE_SIZE / caps->gmv_entry_sz);
 
-		caps->gmv_entry_num = caps->gmv_bt_num * (PAGE_SIZE /
+		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
 							  caps->gmv_entry_sz);
 	} else {
 		u32 func_num = max_t(u32, 1, hr_dev->func_num);
-- 
2.43.0



