Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB47B19F411;
	Wed,  2 Oct 2024 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878610; cv=none; b=MdlMhZfugoTJ80Qkn4dtnEExuHPCcKyjoSWVt+4yL5aWwIELYN2KcOcR2ZLGp6AbPR28NWxTVZ1r/BRr12iiCh05r+O4tQL3L2ZjVGArz+5GetE06PAFk8LdB8UH3wns2FSImaVY829lwFuueKAuzgeqtihSiGuG2q0+KeQVjF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878610; c=relaxed/simple;
	bh=rV1raTofhcTLb2++INFv7n/oau5aKjOc6tWF9zCDDpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUsN+ep/KLrBds3xocQwjwP48gW5gTT3AFT/Ub5TcG4W7cVJtnyP93Ge/PE8RDTyk7eUsegEmpbl7LgChYaW6B9z+1WlScAMj/jcApQLt4/lRtxBluhD/VozmYk4tjHZeCjb77+XE79ptTuG6954+i+mQnEeptfABb1Y3Wbqxbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBe6wQ3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBe6wQ3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61465C4CEC2;
	Wed,  2 Oct 2024 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878609;
	bh=rV1raTofhcTLb2++INFv7n/oau5aKjOc6tWF9zCDDpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBe6wQ3+5vQAOPTdFAVoHVB8PKmwI7VIBQ26VNppzTaDP7d8Kh1fgeKPUgMW4zV3H
	 P3M4F/3OyRKmTLACekmDQkelzRrL9XOQYVhRa6Xsllwrj9XhpQNF1aN5wlMcnuYnT+
	 PbwzDkherUUlw1uHbESueqnOc8A7IvwmllC38zck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 441/634] net: ravb: Fix R-Car RX frame size limit
Date: Wed,  2 Oct 2024 14:59:01 +0200
Message-ID: <20241002125828.508698654@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit ec8234717db8589078d08b17efa528a235c61f4f ]

The RX frame size limit should not be based on the current MTU setting.
Instead it should be based on the hardware capabilities.

While we're here, improve the description of the receive frame length
setting as suggested by Niklas.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4d100283c30fb..067357b2495cd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -530,8 +530,16 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 
 static void ravb_emac_init_rcar(struct net_device *ndev)
 {
-	/* Receive frame limit set register */
-	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	/* Set receive frame length
+	 *
+	 * The length set here describes the frame from the destination address
+	 * up to and including the CRC data. However only the frame data,
+	 * excluding the CRC, are transferred to memory. To allow for the
+	 * largest frames add the CRC length to the maximum Rx descriptor size.
+	 */
+	ravb_write(ndev, priv->info->rx_max_frame_size + ETH_FCS_LEN, RFLR);
 
 	/* EMAC Mode: PAUSE prohibition; Duplex; RX Checksum; TX; RX */
 	ravb_write(ndev, ECMR_ZPF | ECMR_DM |
-- 
2.43.0



