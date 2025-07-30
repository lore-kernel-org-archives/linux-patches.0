Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0FE1E25E1;
	Wed, 30 Jul 2025 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869111; cv=none; b=S+lEjNDztllejTfNaM6ZcYPB/UW4v9Id33verRPhngfNw+BFR49+A4+gliaVP96fvmA2fzFOjZE6dFb+cOawkWaLZS0NWaMgwrzjJX+FWNq+5lG2G6O2eIlPoUwSrOIix3l1Uao0dkU801VKWM5mGoX1cLwiFInwoHvQoEHhGqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869111; c=relaxed/simple;
	bh=6l4GrFeTs13ni3wRsZ4twFtCTV1kTrOBi2U7c7lzFDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlCe5kdCjp5KdCiM2kVXmvPy+mQkRkhs5konpi0RZKrAwdA9nE88GroW+6I4EZci4YyolADjZyiFWbTtU5FQi9Lt5Aosvik8KHigaPIcwnP1X2qo83EP0OcxMx+nrvh90E+ByKqRxsXvRs305GFu7fENTwYEDBm2N0fDEiu35lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIg2aWXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIg2aWXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD19C4CEF5;
	Wed, 30 Jul 2025 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869111;
	bh=6l4GrFeTs13ni3wRsZ4twFtCTV1kTrOBi2U7c7lzFDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIg2aWXxHZttwDDXJz1+HI9uAVSd6yJ1w3Ue5YwJNK60LyR3WgQN1egxNJepBYpXl
	 MhWyYoug/BRMzs7GXNy84uXvGpChRvHi3yxET0oqlbQu9vUonNFg9o+qg/Ti0hLJIv
	 bcX+fAt54DVBBtbYoAYuWPuF/FZ2ZJGJMglR6Mgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 40/92] net: hns3: disable interrupt when ptp init failed
Date: Wed, 30 Jul 2025 11:35:48 +0200
Message-ID: <20250730093232.314249169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit cde304655f25d94a996c45b0f9956e7dcc2bc4c0 ]

When ptp init failed, we'd better disable the interrupt and clear the
flag, to avoid early report interrupt at next probe.

Fixes: 0bf5eb788512 ("net: hns3: add support for PTP")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250722125423.1270673-3-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index ec581d4b696f5..4bd52eab39145 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -497,14 +497,14 @@ int hclge_ptp_init(struct hclge_dev *hdev)
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to init freq, ret = %d\n", ret);
-		goto out;
+		goto out_clear_int;
 	}
 
 	ret = hclge_ptp_set_ts_mode(hdev, &hdev->ptp->ts_cfg);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to init ts mode, ret = %d\n", ret);
-		goto out;
+		goto out_clear_int;
 	}
 
 	ktime_get_real_ts64(&ts);
@@ -512,7 +512,7 @@ int hclge_ptp_init(struct hclge_dev *hdev)
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to init ts time, ret = %d\n", ret);
-		goto out;
+		goto out_clear_int;
 	}
 
 	set_bit(HCLGE_STATE_PTP_EN, &hdev->state);
@@ -520,6 +520,9 @@ int hclge_ptp_init(struct hclge_dev *hdev)
 
 	return 0;
 
+out_clear_int:
+	clear_bit(HCLGE_PTP_FLAG_EN, &hdev->ptp->flags);
+	hclge_ptp_int_en(hdev, false);
 out:
 	hclge_ptp_destroy_clock(hdev);
 
-- 
2.39.5



