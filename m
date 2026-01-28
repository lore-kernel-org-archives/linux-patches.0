Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374E5288C22;
	Wed, 28 Jan 2026 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615465; cv=none; b=oxMHHK4chjO3BQLZ205WKv7gibyA88/H7m6zxJJesCyxVVA8fLYO0TLKCU5l2IGaJTlvpdHA2yYdpoHkmzJOqeQYxO+xnaBDwvfqBwmwpWnZxsLYLZE0uCnnW/g0YDtOubcZbvGjwtZelmvn7RQVk8QUrGwhv+zEiXHxogjQzD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615465; c=relaxed/simple;
	bh=jm9u7lL26mOUQW1GOTOcCYI8pEKpBfJsNySVLUM954g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UR5cQ0JYijQICFgdWCUGx0nvGRcuWlYWVMJsbYFJpgfY4TW2/naOGbqjG6IhBO3o2mVrAc6V2iQLxKblrD8m1Jo49TUW35YooLvpM5Xrm/CZGkwh5SHwE8ChWmaymH4H6sjUc2zq/WEe8lBZ7g2Ai1ViFGCU3j4iznZXkzHBh3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bx0t2mmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bx0t2mmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7A4C116C6;
	Wed, 28 Jan 2026 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615464;
	bh=jm9u7lL26mOUQW1GOTOcCYI8pEKpBfJsNySVLUM954g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bx0t2mmo8cmdbcguv6rJ0xEIu3nAkXfbhxV22+MsTBg4yb7fB2NyvMVMffECcp8HK
	 z8nbls1jpd7J7AffcG+OnTEM/5oCrTe0KHwOUmaHKcj3qYqOyxXBG/AFikFpaNuPFK
	 APtpf1wBvuElCvI9XvjKyx9d7O6ZWZm1acZIDEGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingying Tang <yingying.tang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/227] wifi: ath12k: Fix scan state stuck in ABORTING after cancel_remain_on_channel
Date: Wed, 28 Jan 2026 16:21:03 +0100
Message-ID: <20260128145344.999610151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Yingying Tang <yingying.tang@oss.qualcomm.com>

[ Upstream commit 8b8d6ee53dfdee61b0beff66afe3f712456e707a ]

Scan finish workqueue was introduced in __ath12k_mac_scan_finish() by [1].

During ath12k_mac_op_cancel_remain_on_channel(), scan state is set to
ABORTING and should be reset to IDLE in the queued work. However,
wiphy_work_cancel() is called before exiting
ath12k_mac_op_cancel_remain_on_channel(), which prevents the work
from running and leaves the state in ABORTING. This blocks all
subsequent scan requests.

Replace wiphy_work_cancel() with wiphy_work_flush() to ensure the
queued work runs and scan state is reset to IDLE.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: 3863f014ad23 ("wifi: ath12k: symmetrize scan vdev creation and deletion during HW scan") # [1]
Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260112115516.2144219-1-yingying.tang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index ffeb667734358..00b3bf4d882a5 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -12833,7 +12833,7 @@ static int ath12k_mac_op_cancel_remain_on_channel(struct ieee80211_hw *hw,
 	ath12k_scan_abort(ar);
 
 	cancel_delayed_work_sync(&ar->scan.timeout);
-	wiphy_work_cancel(hw->wiphy, &ar->scan.vdev_clean_wk);
+	wiphy_work_flush(hw->wiphy, &ar->scan.vdev_clean_wk);
 
 	return 0;
 }
-- 
2.51.0



