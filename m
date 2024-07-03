Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214BE175549;
	Wed,  3 Jul 2024 11:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005802; cv=none; b=nxbIdkdY3Ew+qCpKJVI7gcrLGtMN940x9mLqDoE09I1ggt60DyFzqeJ6evnxDru39OsHnV6dFC4kk6kEQRqu4K5J+OZyoIX+rkR+AfALLtXk1HwTFyhQp049v22ffGrCBCQzfyAapxYdMVfhMNv1rQ3SawQPfoBKS34IG+AOeZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005802; c=relaxed/simple;
	bh=vBPMLiFZRLIVMNxoUqpuk3TYsHFklkR8Dhg3Bt1c49Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLSgqBJYe/O+IgFs0S1jJZmd4jmGbBqqnyqrHF8yoZ/II1LFM/kgVaCgC9gw9vQ2gAaB6CQw6h2BE7YZ51kial3U8f66dJn4dAngksdXovEadq9SOpIrHQ/mPKrI3pccBKccjRg/ioNs/rwQhXGiVJJ6lHADQHCKSIe1IBGxoPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQDje62C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQDje62C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB42C2BD10;
	Wed,  3 Jul 2024 11:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005802;
	bh=vBPMLiFZRLIVMNxoUqpuk3TYsHFklkR8Dhg3Bt1c49Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQDje62CFJdNZ+64UbT+ZvkcW0pjuBb+NGMLoCiObw/fO8fEjtP+SWGEObrWFCbcO
	 e8ftS8Hoz+yaq6QYCOxsgEvJ9ep1J1U5W7iwUpHZKQLUnMwWGLF9DYnnyTUxnPOMVr
	 sPPKnLNUjZDTB8edQqnJiBUC/XhEyUrgp+ZmlcHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/356] octeontx2-pf: Add error handling to VLAN unoffload handling
Date: Wed,  3 Jul 2024 12:38:57 +0200
Message-ID: <20240703102920.708413739@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d1e3928a24f5c..761eb8671096e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -933,8 +933,11 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 
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



