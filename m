Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166921DE4C4;
	Wed,  7 May 2025 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643381; cv=none; b=JLBWLX63B79VgJUA+SsjG4o2RHi41MHZVnl9OZUBL3RL1WZ80IADyAjXM8JbZpdD1frMVmZZ/9kJ9WPgRCfGvSuHdbLmcgnlQ4HyrpfKQDAf6vdMZQLDxYD3YSOgBvfl+fjb6Rl8Wl/5soWxl923RyOr9tkvj4UHWymtd/Dv5oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643381; c=relaxed/simple;
	bh=k+RN9rWgjHtcitnu58PYszgEN5SsJcLXPJKH9irho5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0cY2xdNrpePxcXjP3CeR3TM0n+I4VaWT4UILy1i/RWhJA+GXUFbvTMmzkLJ4SkhGwdjlt+y/uqI73easR3436kLPc/yvoOlVufsV5zxEnOYxyThvbMMBcOWe8c/0oR9v04DgfC92Qg91riAlzGnp29gNr7vk4VFA4bSS+ZMAhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0kocs4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0kocs4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DECC4CEE2;
	Wed,  7 May 2025 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643380;
	bh=k+RN9rWgjHtcitnu58PYszgEN5SsJcLXPJKH9irho5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0kocs4XZLemxnxkQkEFt2UQXZhBcQhsrEZx/A2XlbLdazqUzZq/UfLdSrQgZILL2
	 kwesUFeaC/3Z8mXKJ+gpnrPqQEVXU9aKezjV/R5gs+eHFy5msPvtxbPl8R8KYT6uiE
	 gU9p9w8A7UuW8n3OTb2xyAvHYXxTj+/smgiZq65o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/55] net: hns3: defer calling ptp_clock_register()
Date: Wed,  7 May 2025 20:39:42 +0200
Message-ID: <20250507183800.699011404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 4971394d9d624f91689d766f31ce668d169d9959 ]

Currently the ptp_clock_register() is called before relative
ptp resource ready. It may cause unexpected result when upper
layer called the ptp API during the timewindow. Fix it by
moving the ptp_clock_register() to the function end.

Fixes: 0bf5eb788512 ("net: hns3: add support for PTP")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250430093052.2400464-5-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c  | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index 4d4cea1f50157..b7cf9fbf97183 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -452,6 +452,13 @@ static int hclge_ptp_create_clock(struct hclge_dev *hdev)
 	ptp->info.settime64 = hclge_ptp_settime;
 
 	ptp->info.n_alarm = 0;
+
+	spin_lock_init(&ptp->lock);
+	ptp->io_base = hdev->hw.hw.io_base + HCLGE_PTP_REG_OFFSET;
+	ptp->ts_cfg.rx_filter = HWTSTAMP_FILTER_NONE;
+	ptp->ts_cfg.tx_type = HWTSTAMP_TX_OFF;
+	hdev->ptp = ptp;
+
 	ptp->clock = ptp_clock_register(&ptp->info, &hdev->pdev->dev);
 	if (IS_ERR(ptp->clock)) {
 		dev_err(&hdev->pdev->dev,
@@ -463,12 +470,6 @@ static int hclge_ptp_create_clock(struct hclge_dev *hdev)
 		return -ENODEV;
 	}
 
-	spin_lock_init(&ptp->lock);
-	ptp->io_base = hdev->hw.hw.io_base + HCLGE_PTP_REG_OFFSET;
-	ptp->ts_cfg.rx_filter = HWTSTAMP_FILTER_NONE;
-	ptp->ts_cfg.tx_type = HWTSTAMP_TX_OFF;
-	hdev->ptp = ptp;
-
 	return 0;
 }
 
-- 
2.39.5



