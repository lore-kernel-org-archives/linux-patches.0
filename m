Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334D8331219;
	Mon, 29 Dec 2025 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025124; cv=none; b=niBXIwdiP/ytOInn1jyCmEOs7dF5hxQb3tuJiQ92o5mLj2JjpvQR5iOT15ffcCH7MxVJ0JiXuInBmBIP0vxeteTA92HXTGP0cC+SkFdhvPTOi7WF9iXIjEe2+UcbRyfwdjIsqe8hdm/ew2oBuIoNTnkIlIWmSlFT23ui2NPoJss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025124; c=relaxed/simple;
	bh=0Cr+6ksLVzuGe7Fku/yYpUoZet1cTkgxHHjbNh/RZcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/qCil1tP+xtnCOp/uTjEVlG511yrV6tU7Mx7bFnXzZf/QuvuSG7vTVJX+bRAqFIJ7bO6+PRc0tBkJOkMCrPiW1XlSUVjBwmVzY28QG/LVs2dSh+9N7ZUNOOrBKs8EyJIbxZlxDlvLdKeFYit8L26wKXlqN7TtVxD2OJ8xdNTa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=la/KVGeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="la/KVGeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF15C16AAE;
	Mon, 29 Dec 2025 16:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025124;
	bh=0Cr+6ksLVzuGe7Fku/yYpUoZet1cTkgxHHjbNh/RZcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la/KVGeDh1ijYZ4wQoWF/f+0Z8KCLNjOT3Y9qJBjM/FFh2vzyL6qBclWpWvS5/PZG
	 DrMIlrmXSpw86rJvZa1/Jn4YNAY7iJ4rTSlEJ9iZhX/asK7F8o//yGw3cdEiY0SEwD
	 fgenwdUcgBetcVZj7QLkLEuVZWrGTrj96JlTiAp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/430] net: hns3: using the num_tqps to check whether tqp_index is out of range when vf get ring info from mbx
Date: Mon, 29 Dec 2025 17:08:25 +0100
Message-ID: <20251229160728.159801572@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit d180c11aa8a6fa735f9ac2c72c61364a9afc2ba7 ]

Currently, rss_size = num_tqps / tc_num. If tc_num is 1, then num_tqps
equals rss_size. However, if the tc_num is greater than 1, then rss_size
will be less than num_tqps, causing the tqp_index check for subsequent TCs
using rss_size to always fail.

This patch uses the num_tqps to check whether tqp_index is out of range,
instead of rss_size.

Fixes: 326334aad024 ("net: hns3: add a check for tqp_index in hclge_get_ring_chain_from_mbx()")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251211023737.2327018-3-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index c7ff12a6c0764..b7d4e06a55d40 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -193,10 +193,10 @@ static int hclge_get_ring_chain_from_mbx(
 		return -EINVAL;
 
 	for (i = 0; i < ring_num; i++) {
-		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.rss_size) {
+		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.num_tqps) {
 			dev_err(&hdev->pdev->dev, "tqp index(%u) is out of range(0-%u)\n",
 				req->msg.param[i].tqp_index,
-				vport->nic.kinfo.rss_size - 1U);
+				vport->nic.kinfo.num_tqps - 1U);
 			return -EINVAL;
 		}
 	}
-- 
2.51.0



