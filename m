Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA1818734B;
	Wed,  3 Jul 2024 11:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005007; cv=none; b=Bg2XCqDgNuin+dCpVuPDCEz6aCQPFujtEEvSYiIQYrZ2jKaBLmRwKC6Utnpg96kHPkFM1NT6AaW8VnqxO1IIZiCzP/Xcq9EVn8K3kfDTDpeVCx5RkMeSYRAvfz8k6Xyz/OWijoeRYRVP0N4dyVauEIZs8p/L/lJMngsU+VPI5Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005007; c=relaxed/simple;
	bh=i1Nx+60tmJqITCPMB56MEW5qKIdkI8yQW8ofGQTA7w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSB0/dQWDctuHMOmFQ6oeP1EaCcTUhqV5YfDxdGI5EvyhLhcBKVzj9/grAL9ATlITBJ6yYf5rZaBvJ0DmiDEABvV1sawwl8H6GO4uwnI61sK0OnxefRP1p06xpRc5gKkD0DVzFgTaFStc/UALk4b/eX0gr7pDuHGIpM9vU5OYwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nR895ikF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nR895ikF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A766C32781;
	Wed,  3 Jul 2024 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005007;
	bh=i1Nx+60tmJqITCPMB56MEW5qKIdkI8yQW8ofGQTA7w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nR895ikFOLzGlZT1fsIzOE82MZL5BE/zMq1+jqXxT102otEFddrvG1ytSgeM/3bHS
	 gNVzEHD5Kl7nMG0QdDIAYu1LyfoFSKrmCjruSoQT2vvQichhytDgRBwuXzFWLaCohj
	 w8c2BNXim60XQd/UCuaQI1fZUz+zoQn6JrH+k2gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/290] r8169: remove not needed check in rtl8169_start_xmit
Date: Wed,  3 Jul 2024 12:39:29 +0200
Message-ID: <20240703102911.271070787@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit bd4bdeb4f29027199c68104fbdfa07ad45390cc1 ]

In rtl_tx() the released descriptors are zero'ed by
rtl8169_unmap_tx_skb(). And in the beginning of rtl8169_start_xmit()
we check that enough descriptors are free, therefore there's no way
the DescOwn bit can be set here.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/6965d665-6c50-90c5-70e6-0bb335d4ea47@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c71e3a5cffd5 ("r8169: Fix possible ring buffer corruption on fragmented Tx packets.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dbf885f4dd01d..dd4404efdb8d6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4285,17 +4285,12 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	bool stop_queue, door_bell;
 	u32 opts[2];
 
-	txd_first = tp->TxDescArray + entry;
-
 	if (unlikely(!rtl_tx_slots_avail(tp))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
 	}
 
-	if (unlikely(le32_to_cpu(txd_first->opts1) & DescOwn))
-		goto err_stop_0;
-
 	opts[1] = rtl8169_tx_vlan_tag(skb);
 	opts[0] = 0;
 
@@ -4308,6 +4303,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				    entry, false)))
 		goto err_dma_0;
 
+	txd_first = tp->TxDescArray + entry;
+
 	if (frags) {
 		if (rtl8169_xmit_frags(tp, skb, opts, entry))
 			goto err_dma_1;
-- 
2.43.0



