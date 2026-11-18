Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055341;
	b=A6QoIMqaxxGnVzyS7ZnWCFS/o6JP6hMQTLlJ++0Mheo5Ug/g/0vlM/iTWFsxojz1iZKP
	 hF1klCeoPD4rTos99KTcpg2VvCNkgOVyhcoRm7LXfC84NgiCm1w8MGnvkxtnNuwinOtGB
	 yK1Fk7yr3AMxNFcrwMKPg+Z1fxMx2LJFz07UT0qZaLwMAGBx5c+GOORamOlpH/e7ZDCiq
	 ljEDQ8nvu2pGaX8e1bwIBqG3rQk2OaJZwvSGHbr/cWlzaOydT8YZZb1TyTLFO/Tl4vwc/
	 szDhszvP+RZAhJ2xjjEjchby97lgWb+fr3nveiN8qSLfNuPQhanfNd3fqUA3SGl6Uqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oPUAnMLcVg2oNw1pgEu5CAseOLdMfFDkKt5RlshJ/Vg=;
	b=RqqXUt8N0kQGbhlyycckj7/JIwM4VV7NvVaSilFFkyNejjWD83qbW57OeX/GdX9qB8Lt
	 tUfbVVHYUkCVZr5O8v9ArKsnfdRcJIjXJP/NciVSRL6auNNsmdPfQ6SEicM8bT5CUDqMg
	 vJk9w2PCeEaJi9CDSE/dz22yv4Ep374UujyhRY+SjgF+/c0fP6IAlUKA2MrGjJ07+nbmw
	 xaZWwo+GMvOgCX38GKVx74po1flYmvH/rQsL5d0EdOJGVLZMU7220xQWllGzuOHobwKGi
	 G/IxGLllvTSaf6kN3AflqUdXMgpVlRIpP2KexFIeZ7+nIJLjtICPriobff88aYNXokQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyblLQPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A433606A325;
	Thu, 19 Nov 2026 02:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyblLQPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378271F000C4;
	Thu, 19 Nov 2026 02:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055340;
	bh=oPUAnMLcVg2oNw1pgEu5CAseOLdMfFDkKt5RlshJ/Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyblLQPmFqT8pnomIKZmEQZ7I7ZDtLL7pA3XVZLgG0QzWkdhx31+NldqSNy0r6lsG
	 20T8zYi/S+fo3jaMK89tB3NJU8IfdgwTT+AhOTomkzcmznCgdh2x1L2ERxFi4DMCnJ
	 QEmAOvtqx9kEbU8chMaD/+7BYWyM3DoWTo2Wwojk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1556/2214] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:53:52 +0100
Message-ID: <20261118150114.342111188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 5eb6ecb612841927b5ede554a0e9d88240934282 ]

rx_pkt() takes an extra reference on the received skb so it can be
handed to the firmware completion path via req->cookie.  When the
work request skb allocation in send_fw_pass_open_req() fails the
function returns without releasing that extra reference, leaking
one skb reference.

Free the packet skb before returning when the allocation fails,
matching the cxgb4_ofld_send() failure path.

Fixes: 1cab775c3e75 ("RDMA/cxgb4: Fix LE hash collision bug for passive open connection")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183715.2092663-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 2d651fce63f92..e5f0a8b779ed7 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4012,8 +4012,10 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
 	int ret;
 
 	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
-	if (!req_skb)
+	if (!req_skb) {
+		kfree_skb(skb);
 		return;
+	}
 	req = __skb_put_zero(req_skb, sizeof(*req));
 	req->op_compl = htonl(WR_OP_V(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL_F);
 	req->len16_pkd = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(sizeof(*req), 16)));
-- 
2.53.0



