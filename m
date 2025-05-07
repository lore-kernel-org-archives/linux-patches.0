Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C5C28DF2A;
	Wed,  7 May 2025 19:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644707; cv=none; b=pc8D9Ytj9GFIsb8ec/MacjShCrnJEu0I+e+bLrot+6F/SrBrt8keFocJTUdNfqf1zkcviq0e2MwT9rE1b6Wji1rM9fQ/S1SBJ2ud+ZyxlaTiasgthbzw3Xrk6A/011meuksYARi3ewF6AC40A2No06hUgNkrZlzsBPHDRdgrTyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644707; c=relaxed/simple;
	bh=ufKQRtuO7Uh+ZgvEwvpyqh3gwoOgzsjiGmv9TM39auw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA9wzjbk16c9E+HQM+Cn3UEAsruUaLgiDwDjjbBHNEZqmVZaO0dIh5TncBsadYhY/uxmIekquGw/Riyq2RXGXw7ZmYr4ySTRxF6jf8Qsrskr3k8j+btq48no6DLTWI5TjAqoakEqRB1KcmFRlai5dLUBenFNa4gtVu0MsA1huYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etTegxhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etTegxhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AFFC4CEE2;
	Wed,  7 May 2025 19:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644706;
	bh=ufKQRtuO7Uh+ZgvEwvpyqh3gwoOgzsjiGmv9TM39auw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etTegxhpstmRwq2St+I97tFv/fKcfLgowP4OVhRhR6D4BbhFmFp/PZ9bCun1RYMBi
	 QTL3FnRyz5jnf2BFL+7IGpPhPa3zy/fMtaLXsEaKgMowktnunrMOI4yci1L+CqXksm
	 MJG5Er7VtSycElTa9TE8mbZFlXQkcd3r8h+uk7iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/164] net: hns3: defer calling ptp_clock_register()
Date: Wed,  7 May 2025 20:40:16 +0200
Message-ID: <20250507183826.275542137@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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
index 181af419b878d..0ffda5146bae5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -439,6 +439,13 @@ static int hclge_ptp_create_clock(struct hclge_dev *hdev)
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
@@ -450,12 +457,6 @@ static int hclge_ptp_create_clock(struct hclge_dev *hdev)
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



