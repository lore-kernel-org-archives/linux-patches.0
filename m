Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022188;
	b=ZR563HcR8EAQFdIzHff2pt9E/cZijpNnG/SJpkvhFaDn20TNkO4PmBb8DJlA/TJ5Sr38
	 bk+IYWRDpkAo/mcAzOF057bafNOxo3i1SSONCq16PwJFi9RKVIs7bcJJ1iCEiYSc727P2
	 N4fqrfc022WLu3aWZT5GoDzkcf12wAA+Fp7P0ayY0KX8/hNgHJl0JOiR+HXzSeIFb8+fQ
	 x3pWIoSBq5DqXYOjUftdxKrCY6Ciny8SFNlgeCepSlIDpdDF4T/yWPGZeG7DDCN2r+jwa
	 s3AtfFnq4TFPc5Rwnv/2V7cEINLbvB8jCTzOP8AMHp/jk5BgPwQYjC4zyaneCT6Tfhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s79mPOh4ILG2UVwiEq5kSMkMIZ4r1sEKgsV+MBO8VRg=;
	b=gPTWmvN+tIj+WUv1wKeNZmXSKBjwz6+PM7LwZjpdVpmwHrpwwVYVzZM/gO8SpwUAJz4M
	 xFMo6ZGWaE9RMHWTP5+DZypy2GO+RWuX26c7DBnnQ4+JwscaelnfZ4SJwm48E0Tz0/bNS
	 FJxdQfHwZ2lcjGzk91wSXEb8zTxs7q7W2IRR4IvlMzXIehSDHbolwNrvifpN5J0lBbEY1
	 ee6J0Da93GJydBMVp4Fjiej8aZOJTQH3tlaRG18AoBf872fCPn6iWG0V5HBaLHbW3G4FW
	 32wtT6b0UzyYQKMQWKtC0mGjKo9tUITsJvLNhC5d6vGDFZvCt7hQhpD1NtUqvjouZcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvvwhT7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E022606A32A;
	Wed, 18 Nov 2026 17:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvvwhT7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255141F000C4;
	Wed, 18 Nov 2026 17:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022187;
	bh=s79mPOh4ILG2UVwiEq5kSMkMIZ4r1sEKgsV+MBO8VRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvvwhT7c16jGL3Vm901lZeZ0EoB4veLeisXe79zC1SogntNTyU/OWVkbogQzetu9D
	 qpt2JKSXuLfhYzkxXYBX+a5uX0xuJDfbNnggamhbNx/ZSucC6wxebX4fU+WWX6USbh
	 Wji4IQXWezKt9M/r941nJAes9Lvc84xjdltQC/gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2572/2651] octeontx2-pf: fix skb use-after-free on ipsec transmit drop
Date: Wed, 18 Nov 2026 16:03:32 +0100
Message-ID: <20261118150416.970544513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 14d01ff1a4952198abae713a4ad428e07819b4aa ]

When an SA is removed while packets for it are still queued, the
transmit path frees the packet but reports the queue as busy. The stack
then requeues the freed skb, and the DMA mappings leak.

Fixes: 6a77a158848a ("cn10k-ipsec: Process outbound ipsec crypto offload")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20261027-nb-otx2-ipsec-tx-fixes-net-v1-1-2114c4f10c36@tipi-net.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 77543d472345e..3920cd0985831 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -1037,6 +1037,9 @@ bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 	cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
 	return true;
 drop:
+	otx2_dma_unmap_skb_frags(pf, &sq->sg[sq->head]);
+	sq->sg[sq->head].skb = (u64)NULL;
+	atomic_long_inc(&pf->hw.dev_stats.tx_discards);
 	dev_kfree_skb_any(skb);
-	return false;
+	return true;
 }
-- 
2.53.0



