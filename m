Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453C924B34;
	Tue, 25 Jun 2024 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309101; cv=none; b=lhzt3N+6jVz4Mik1Cs/hzZ8AJaMCH/+OpXiwzIGy0Y4Pr8nQNE49kXIJJs+wHDPdh9h94iqzd2WHaYhN/JVBMEPfjuanuKmt+wfiCyEX18d8YE40xF2Fw1qnstMjtbaFSQOkvvXyArL3zv3rXBQS5QOL9nglAwrrl3xM2xpWV+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309101; c=relaxed/simple;
	bh=X5OtGxa3DxrCja9AaoD9jCUQgEl/8/UbG10+LI/HpAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzNsNnvjqWkDQk23VlRgAoA+PfyvKDvk9c56quwIqbfbog72lW9vhJlkYPkQwtipvUwPcwbsfGSZha4MO06u8TAkRQkyuE6zZJpxCyXw2Nq6c020sCb7OHPWPMCtytQSIZ3m/GGZKS/Dtzd9eZ6Yi5W4OqhOaiXHoXK8/GbXWOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tuGCOah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tuGCOah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECBFC32781;
	Tue, 25 Jun 2024 09:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309101;
	bh=X5OtGxa3DxrCja9AaoD9jCUQgEl/8/UbG10+LI/HpAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tuGCOah1gKkHYzIC+BO5ds8OSXYOqs1eycUhXwnIs5ZYbpM1cr7Edke4iq7B3u8e
	 sAyYx6OefGg8fINpAvTWS7o1L6Vph9u9v4Uo/HU4GA81K9HMstf2Mw83elGCpzugfu
	 qzvUQ4+6FBtW6tvRwWSy3Qx09ReXt9ePfcrEup3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/192] octeontx2-pf: Add error handling to VLAN unoffload handling
Date: Tue, 25 Jun 2024 11:32:48 +0200
Message-ID: <20240625085540.863536713@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit b95a4afe2defd6f46891985f9436a568cd35a31c ]

otx2_sq_append_skb makes used of __vlan_hwaccel_push_inside()
to unoffload VLANs - push them from skb meta data into skb data.
However, it omitts a check for __vlan_hwaccel_push_inside()
returning NULL.

Found by inspection based on [1] and [2].
Compile tested only.

[1] Re: [PATCH net-next v1] net: stmmac: Enable TSO on VLANs
    https://lore.kernel.org/all/ZmrN2W8Fye450TKs@shell.armlinux.org.uk/
[2] Re: [PATCH net-next v2] net: stmmac: Enable TSO on VLANs
    https://lore.kernel.org/all/CANn89i+11L5=tKsa7V7Aeyxaj6nYGRwy35PAbCRYJ73G+b25sg@mail.gmail.com/

Fixes: fd9d7859db6c ("octeontx2-pf: Implement ingress/egress VLAN offload")
Signed-off-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index f828d32737af0..04a49b9b545f3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -1171,8 +1171,11 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 
 	if (skb_shinfo(skb)->gso_size && !is_hw_tso_supported(pfvf, skb)) {
 		/* Insert vlan tag before giving pkt to tso */
-		if (skb_vlan_tag_present(skb))
+		if (skb_vlan_tag_present(skb)) {
 			skb = __vlan_hwaccel_push_inside(skb);
+			if (!skb)
+				return true;
+		}
 		otx2_sq_append_tso(pfvf, sq, skb, qidx);
 		return true;
 	}
-- 
2.43.0



