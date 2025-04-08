Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77716374C4;
	Tue,  8 Apr 2025 11:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110474; cv=none; b=QG9Ix+JvqjqFqtnS6TcQx0KC/627Bze71E3sNYJGtm4YDE6Sjo/vwE1qIyZkfssxZwrNTaeLhTSNX+sD2m81OtCSIDRk1G/CYDn4z4Dia1yczwCCU278B73Rr1YPo2QdKBubIxVs4hMyagM5Vlbmxk5Yx1vSRrtDxwtHPMvQAZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110474; c=relaxed/simple;
	bh=uxT1ejDjCZ6YVOGkiSzsX8uCpZDnTOtBKJ6DrL5KjWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbacoOpoSvMLdNZkhYamwn/tgSMB+xLihl5nFoxMx2WeaVeeNlIGZLWheY1Ebg2tFTc2lKxA7KxXDXY/dW93ZeQm9vhQyoWRegHuSTsg/6np2onHXWzzCVxs0nlC9XljcvT/rqAzZNthxQpqXh/07waidExRFiTrUtS1f/AjycY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hk9XONq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hk9XONq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E85C4CEE5;
	Tue,  8 Apr 2025 11:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110474;
	bh=uxT1ejDjCZ6YVOGkiSzsX8uCpZDnTOtBKJ6DrL5KjWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hk9XONq2AVQ3b7XBQG1rLHHNd3ZwQ5mtokfgw8qd/p/fUgdlUvn/QX9fJNp2vYWeh
	 f+4EaN6O7vx8qGmf5rJ8Zw0wRfcdT/ii9dk3zjVF+ik5wf/pxMF1OUJ214Mm08IpoO
	 yzDOhec+obSDCOzlph6YHVMgiEY2f//5pwbgbgeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Jie <liangjie@lixiang.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 076/731] wifi: rtw89: Correct immediate cfg_len calculation for scan_offload_be
Date: Tue,  8 Apr 2025 12:39:33 +0200
Message-ID: <20250408104916.037458733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit 361cb056e2468be534f47c1a6745f96581a721e3 ]

Ensures the correct calculation of `cfg_len` prior to the allocation of
the skb in the `rtw89_fw_h2c_scan_offload_be` function, particularly when
the `SCAN_OFFLOAD_BE_V0` firmware feature is enabled. It addresses an
issue where an incorrect skb size might be allocated due to a delayed
setting of `cfg_len`, potentially leading to memory inefficiencies.

By moving the conditional check and assignment of `cfg_len` before skb
allocation, the patch guarantees that `len`, which depends on `cfg_len`,
is accurately computed, ensuring proper skb size and preventing any
unnecessary memory reservation for firmware operations not supporting
beyond the `w8` member of the command data structure.

This correction helps to optimize memory usage and maintain consistent
behavior across different firmware versions.

Fixes: 6ca6b918f280 ("wifi: rtw89: 8922a: Add new fields for scan offload H2C command")
Signed-off-by: Liang Jie <liangjie@lixiang.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250112105144.615474-1-buaajxlj@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 5d4ad23cc3bd4..5cc9ab78c09f7 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -5311,6 +5311,7 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 	u8 macc_role_size = sizeof(*macc_role) * option->num_macc_role;
 	u8 opch_size = sizeof(*opch) * option->num_opch;
 	u8 probe_id[NUM_NL80211_BANDS];
+	u8 scan_offload_ver = U8_MAX;
 	u8 cfg_len = sizeof(*h2c);
 	unsigned int cond;
 	u8 ver = U8_MAX;
@@ -5321,6 +5322,11 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 
 	rtw89_scan_get_6g_disabled_chan(rtwdev, option);
 
+	if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V0, &rtwdev->fw)) {
+		cfg_len = offsetofend(typeof(*h2c), w8);
+		scan_offload_ver = 0;
+	}
+
 	len = cfg_len + macc_role_size + opch_size;
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
@@ -5392,10 +5398,8 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 					   RTW89_H2C_SCANOFLD_BE_W8_PROBE_RATE_6GHZ);
 	}
 
-	if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V0, &rtwdev->fw)) {
-		cfg_len = offsetofend(typeof(*h2c), w8);
+	if (scan_offload_ver == 0)
 		goto flex_member;
-	}
 
 	h2c->w9 = le32_encode_bits(sizeof(*h2c) / sizeof(h2c->w0),
 				   RTW89_H2C_SCANOFLD_BE_W9_SIZE_CFG) |
-- 
2.39.5



