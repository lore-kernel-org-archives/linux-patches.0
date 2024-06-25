Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187D213C90B;
	Tue, 25 Jun 2024 10:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309698; cv=none; b=izrGxPmbdLvDZSN8sJ+sHg9Zs0I6oIlDoScdq9KL1qFXqN+RVBWpuW5oIgXy+0nrb9V099rxH2y0+7XprO2y5BrQGrUTBMxlgsjE5H6p+s/HtAW2qS+OxGxnuZWwqazNfF/AdsvOLRRkJANvkKaNHrOUdtpLA63Nj6Fe8u3ib2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309698; c=relaxed/simple;
	bh=11LpTUJXAkmywBP74/Ih+lN5c53vZE077yv8uIxAG2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSuvwnFDN+YaptTnY2XNs3WHthY31pT21BfS6Kt2mG9lrx66gv6xUz0IVTtJXPK4hy2JL/KpOypImjHLCIiz34R8Nuqx6PMRMnD8jECGdZWflln0B3F9INXSnq0ua4mlkLoy/Vg5hOncxGfrBUVll+zlG7wFEWmOcvCGhwE/0EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ul0fPaNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ul0fPaNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BE1C32781;
	Tue, 25 Jun 2024 10:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309698;
	bh=11LpTUJXAkmywBP74/Ih+lN5c53vZE077yv8uIxAG2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul0fPaNXZ7+9kM9SaFKoNIoRmtlYbgkoC1ggbz2mBK5Ipc/MJnuo9inUmtJF1gevg
	 ON1aKhEcdtX87Lmrvcxx56tlxQbRsWzHuPvLk/Br58x/pMQc9D2HcbbA5qD5hoivHr
	 qbsyaE5EpYRUcY1WghvJ7dynT/ARM8Lk+NiSTwj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/131] octeontx2-pf: Add error handling to VLAN unoffload handling
Date: Tue, 25 Jun 2024 11:33:47 +0200
Message-ID: <20240625085528.679056092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aee392a15b23c..e579183e52392 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -1152,8 +1152,11 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 
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



