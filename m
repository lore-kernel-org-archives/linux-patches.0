Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029886;
	b=IA5B65sxpNYGyfSwlfxdSyxoVHQgXwwChaVdxu9HVVRQwTKXDyYX0zS9UIHp3xzoyvBH
	 3dRBYTEgdYbetaf/koCJAdJDY97J3iP4vmQertMH6w5y+wp61lcAlLX4Ni1b/56PosenQ
	 opMN4VswIl3ipQSZd6CeGs2iVO85uJy3G0PBLi8B9G14aAjK6qNFEeviLeJxogY1h2C1Q
	 EJqjwsAKlfDaYK2AnaDJ7c5dAs4bOW9e6HLCPIL4jvNXldfSQ0QR0iYKQc9XGl8rztHYl
	 8IyRkTJE8goFpTWlsgJs3bYxifZTVyLUnocJM27xWEcW4IyMO9VYkZpwzoJ7yb+7LoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKtTRIoNqLg9HE+/dQWUhs/ABLhaCw+/9d1kh6Q9WAw=;
	b=K2OnwX380yBKOpqtO4+BQuKS1/E3u9pBtRfoSevaGWVgtK60zVCX3DBA9OTi3chuVV3d
	 75yFgf3Qg44ZzHFFbXDiZj98UEzt7RJUBUqohBG/MRYdfB+6KW8ZWNWzQiZqRSgKFINqe
	 fpCwJ5g3K6ZZd0+LBYpBJl2zeVemKKPJ5+GwKDBOC1kxhYUlc58tTifi9Hpzx8XkVhPTJ
	 wwviYbtJZMH/zgofYKwdyfjMp3p9HRedpqAVZfSbCsDtrUILQIUiWNWWuCGAJ0bRL5bTI
	 eDLYNxswtox1QjIBSRohvp5cAWv7G4elAA6i5naaYCmHHvQC0fjJPDyy2JhajxFzJTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKZ6aJpW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42F160A2603;
	Wed, 18 Nov 2026 19:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKZ6aJpW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE09E1F000D4;
	Wed, 18 Nov 2026 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029886;
	bh=rKtTRIoNqLg9HE+/dQWUhs/ABLhaCw+/9d1kh6Q9WAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKZ6aJpW+GsDOia628ogP5J99PxKztwPFokkBOLT+jwI1cEM3reHM1YPrQJWFYgPk
	 E4NRbHNEBu48BVJ839jlRd0PDskfWzcZNIyWr0mOI6G6aV3ZvuqAOcHFuQBMMpkGeP
	 nBtrLV5VqpLiZXVDOzF0is4CDcegSO9QTSL51E98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0507/1756] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:43:54 +0100
Message-ID: <20261118150029.344017795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 07cf0026cf1e3..51b0eb021dfc1 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4006,8 +4006,10 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
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



