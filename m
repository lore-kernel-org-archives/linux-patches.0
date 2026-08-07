Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F24733C1AD;
	Fri,  7 Aug 2026 15:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116849; cv=none; b=DJXiWJJ46ElDwu/FaPKgbjaXWlJGmxN9L2idiIDZDCN+R04aE+WBG7oLvmslCgceG3YgDzcdia4RbufCdP7/zWpXBFVdPXT2g1eX+ZTVaBbr9T7ODdiI9+nck26GRBYvPPggvfkMTtYab+lBDEQnjUMTTawQ5P5ghUwgExyajqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116849; c=relaxed/simple;
	bh=FN6wVUM4I9mumgeD02TjVZL63ZyRvOausp0QwS/DpEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQ60MAwgbMhqWo5mjOCM0YfYHYlOtJMt57EiPW/REu1rNM5gqvpA5rZM7fwk1b9iwra0ebRvOjqPKQRbLOayzl69v6zbQgXHcFkQ3oOEhOt2vko8r9sypqDTOwey+TcrJcWB7ZBpx9M72uTHdphyCZFeg+hFubbKW62XK681PiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtxRPDLF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtxRPDLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51EA1F00A3A;
	Fri,  7 Aug 2026 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116848;
	bh=bY0OHe1pXH9CVMdvFCQDbUMaRvG88e/LrIGjoONSNbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtxRPDLFEGCsQVqOIIv1QseyITKSTNkesbl/BDdzjmY/SZnNquQT2+gwtE/Xv9Lvk
	 hnAZ6rwJpKKk3UuW8gsbAF2VSDXpzfcMIKwTPk5RVMZ4N4IXXD1F0BpXlLjionJAbb
	 fqf1O+U2AK4n2MD9YBglYj0yDBfni9iMpGykxJ24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Justin Lai <justinlai0215@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 110/438] rtase: fix double free of multi-frag skb on DMA map failure
Date: Fri,  7 Aug 2026 16:35:06 +0200
Message-ID: <20260807143430.335225041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Lu <luyun@kylinos.cn>

[ Upstream commit 6fb7b769d6ed6d1d2e02af4a80e57a2477f35086 ]

In rtase_start_xmit(), when the head buffer DMA mapping fails after
rtase_xmit_frags() has mapped all fragments, the error path clears
the fragment descriptors with rtase_tx_clear_range(), which frees
the skb through the last-frag slot and accounts tx_dropped. Control
then falls through to the common error label, which frees the same
skb a second time and counts it again.

Return right after clearing the fragments when the skb owns frags;
the no-frag case still drops through and frees the head skb once.

Fixes: d6e882b89fdf ("rtase: Implement .ndo_start_xmit function")
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Justin Lai <justinlai0215@realtek.com>
Link: https://patch.msgid.link/20260721023836.6691-1-luyun_611@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index a57a525327a3b..bc9b14614f7a7 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1620,6 +1620,9 @@ static netdev_tx_t rtase_start_xmit(struct sk_buff *skb,
 err_dma_1:
 	ring->skbuff[entry] = NULL;
 	rtase_tx_clear_range(ring, ring->cur_idx + 1, frags);
+	if (frags)
+		/* the frags were cleared above, along with the skb */
+		return NETDEV_TX_OK;
 
 err_dma_0:
 	tp->stats.tx_dropped++;
-- 
2.53.0



