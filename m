Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC68148FE5;
	Tue, 25 Jun 2024 09:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308568; cv=none; b=KIH5sNVkyFyoZvFdHltik0a+pssqXR4mTJWK8xbGOAUJYl4bwI25ndVaOtB0izHXwPFd5WhZNZDxQEBXWW0P4vsrcoLbJJWzKsT/JX1Kihyy3ysXA2nhNkDIQ+TYpImgJ7OTT5PXoUbEzvo5foNHf1EJ8BwEIGv+SUi7Kaa0qEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308568; c=relaxed/simple;
	bh=nVkk2ALD6Gl+YLumIY7XpZhQiz2k7ZaThuQnre1gtAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqBvUwKciUhsA/w67itHGWLk2Q1QIrMkXm63dHyrtw3BCRVdhbIf/HNFeXjlEdzqeak+edUtY2fmEejsserlDyLwGMVWziq/Cb1qmFOiCTvpmBb5qwh4O+n/LefgFO1mbtTgI5ptiVBqp5tFYaunY4Qo89bVGHiIAOp7O7X87Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2PoQBJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2PoQBJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0214FC32781;
	Tue, 25 Jun 2024 09:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308568;
	bh=nVkk2ALD6Gl+YLumIY7XpZhQiz2k7ZaThuQnre1gtAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2PoQBJLNjan2oQZBrTGdCpyV4NlDoWfFqiSvn42xC+q7ymjaUM6A1eL1gef/BSFG
	 D36lTEpHtvKm67k3VwgQsMmA2bPl2CorV5SQu7Nc4j+BLPRx0EfavBqprI+hIIsdi+
	 PgWT6jnbyqHCDzIwXimaZmVMHVFgpSw9q4EKmJW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 134/250] octeontx2-pf: Add error handling to VLAN unoffload handling
Date: Tue, 25 Jun 2024 11:31:32 +0200
Message-ID: <20240625085553.205921889@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



