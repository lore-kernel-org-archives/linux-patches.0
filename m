Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D466E17E90E;
	Mon, 27 May 2024 19:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837232; cv=none; b=kVLOS24IZYoFg9N8p8loC0X8XSj3F9aRJje5wSbLO4NR87atfCGkvUKClaEf//8cxNjdgGzmEr2fnittE8iY3LTJM4Pt0BlUlqcAJDpby4DEWMqSVENcS8OnxKF3Um8FeQ1UaYzAyU3DdMlOq4AlUA8gcuNIcYJkz14Wy+Q7/hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837232; c=relaxed/simple;
	bh=jDi7GHOH6Fg9MfPaRnOY5LOvux3AWO+C4+BBRn5J7uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnDYsNv9ahjOjzZt0QA3PIpowUpw90YG5NOXViMX618pkAucGVo3Ok0+Ro6AcDX+QRLbatVghiUq0+xSi3I8Smisonj3r2n2uGt+1bCZ8wG93EwQUnNaDDnRbYKnmwaGdLoeCppr3xsp3JY5nVe2IF+5y17POMU4XJCfOBnmq1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rknK5wkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rknK5wkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B260C2BBFC;
	Mon, 27 May 2024 19:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837232;
	bh=jDi7GHOH6Fg9MfPaRnOY5LOvux3AWO+C4+BBRn5J7uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rknK5wkTuN6rUdgEPNFwwCGJoVxneN8SqImR/sWyuPbSCUTxHiaHHaAzBTAUyHfJ0
	 eh+4ru5Y6kc28MMhaNWLlOQIWAyHe591/7IA2JG10gklxQQNjKuhBxq19Xd3mDG5yR
	 k2VIp0coTlXPGaFRqwftcsWPWjHjebS35/ZsqP4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 359/427] RDMA/hns: Fix GMV table pagesize
Date: Mon, 27 May 2024 20:56:46 +0200
Message-ID: <20240527185633.817529014@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 99f6ae6135c2f..1120c7d3fa8ef 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2105,7 +2105,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 					 caps->gmv_bt_num *
 					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
 
-		caps->gmv_entry_num = caps->gmv_bt_num * (PAGE_SIZE /
+		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
 							  caps->gmv_entry_sz);
 	} else {
 		u32 func_num = max_t(u32, 1, hr_dev->func_num);
-- 
2.43.0



