Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3040047886E;
	Sat, 12 Sep 2026 11:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212639; cv=none; b=kel6Mpc4hxqAAveVMsjLIrdxBDSN8voP0EfahspaxYOmtjme8j+7GURiZBvX9jcuA+Hpdo7ZCNS9TeXNfDOf5q3AMvs5PKP0YR+i8C9KToSw7AByo7H2FZs6x+O+uZBUaicNbkBzG7wWNQUmsaUbk5ZDM6RiX6en8h97kfaXtAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212639; c=relaxed/simple;
	bh=JhboQJ9nu5FipJOxtxos+l4BG/XI+M8pw2UoUKIIv18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLMbnst9XvCEr2H7IGShLV0xBGtfFJLPAJ8U1SyXNiPtxws9O9q4tdLxRinmNaGuwKLcHe4lFqwh50IRNyIroA3M7i+4M7cU1ECXi/WqKohmlzvEb5PyfCsslLJqxXJoV4u9mwv0E4zIOZke5pcUCiXBYKTlGyjJrCLmPAWVF4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnMhZ5sD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnMhZ5sD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338431F000FF;
	Sat, 12 Sep 2026 11:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212637;
	bh=kRRNpg2b9CWJfOe+a56aA6oHjVBcja6PUxub2izks/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnMhZ5sDT51sV3olOxD/kieLSrk2HQE2Dzy87DOSOtkneMqWzw0FzIx3YhAVbA+ai
	 FiKxRv1LvZLhZ0fgqdvHoZ5wEs7bB1QvVOu1JbuhlRfWXEWKjfFC9Foz99jOU6fMCY
	 bXa9K7lBsY23LXnkuMfhIUH3Kn6uQDJ3LtK6LEBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1478/1518] wifi: mt76: restrict NPU/PPE active checks to MMIO devices
Date: Sat, 12 Sep 2026 09:00:47 +0200
Message-ID: <20260912065656.993315170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 7981aca2bd28a1f7ad7eeab89715442a95b1f72e ]

mt76_npu_device_active() and mt76_ppe_device_active() read dev->mmio.npu
and dev->mmio.ppe_dev. The mmio, usb and sdio bus structs share a union in
struct mt76_dev, so on USB and SDIO these read unrelated data from the
usb/sdio struct, which is non-NULL in practice.

mt76_npu_device_active() then returns true on USB, and
mt76_rx_poll_complete() takes the offload path and skips
mt76_rx_aggr_reorder(). RX A-MPDU subframes are delivered out of order and
the peer's TCP stack treats that as loss: heavy retransmissions and reduced
throughput in AP mode. Seen on mt7921u, mt7925u, mt76x2u and mt76x0u.

Gate both helpers on mt76_is_mmio() so they only run for the bus type that
owns the mmio union member.

Fixes: 7fb554b1b623 ("wifi: mt76: Introduce the NPU generic layer")
Cc: stable@vger.kernel.org
Tested-by: Nick Morrow <morrownr@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260720232640.41293-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5560787718599..d511592a1ad87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1705,12 +1705,12 @@ static inline int mt76_npu_net_setup_tc(struct ieee80211_hw *hw,
 
 static inline bool mt76_npu_device_active(struct mt76_dev *dev)
 {
-	return !!rcu_access_pointer(dev->mmio.npu);
+	return mt76_is_mmio(dev) && !!rcu_access_pointer(dev->mmio.npu);
 }
 
 static inline bool mt76_ppe_device_active(struct mt76_dev *dev)
 {
-	return !!rcu_access_pointer(dev->mmio.ppe_dev);
+	return mt76_is_mmio(dev) && !!rcu_access_pointer(dev->mmio.ppe_dev);
 }
 
 static inline int mt76_npu_send_msg(struct airoha_npu *npu, int ifindex,
-- 
2.53.0



