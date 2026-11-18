Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024130;
	b=wS084YnWuvzBqrmzfnnnAih0rupIAs144ju01bdhZHWK0Wq4eoMSZPSouN+q/2T5ebgz
	 TID+7uE3Vitbo/5ntDQhsuYmlfgyPs5hf0UTQvIWXPLcE4ronQoyeO61sWkxDe3KaZgmB
	 NnwME9iOboz+Nh+LuQ9ciGeSG1GBfzDiA0Z+RAw0CVxi80Q8fTRb8sFd72SK7HxGw/iCN
	 QpnfXrZzPpCdvmubgkElyX02gDEeC/3Da9LNFCF6TJlUPz530alpRu2/R0oWapvO+DQHo
	 RCPpp1/33mi88PAs0ky+V7laWSfrwUeCTCV5wjRdq85oMZIDdwvduIijRvSe91nSwIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UHXHUW0r3PQmhNB7//vAJP4pyFLcoajEhyl+v/I/aBA=;
	b=RW8dUu7q6nrGIZytUHHthx12iiFyQoqUSIPrU1HLVS0+JfeZOfYjteT+qGFPwISA/h+0
	 XViscg022tj8irRmE7oCFo4CdUyCV2kdOc8xO/Ey+FJVexwTfQal7yzvoQlg0Y1OGA5YA
	 xYSnXcBO8JqUHMdYjRJiFyTRmo3q643GiK3IJbUdNFqTNfo1KtAC/Fv6OVUdG7F2u1sGA
	 EwAJzDoL7e87/psQodWC9idRvXyUaU0ugZkGCOqUkQQ8fGGkvgw4EkEx7ltZ4JnhV+syJ
	 K7zv4rQEZhXPOzoSgH2YMJwM+mJ3gT1UcMvcdabKu4xCRm9Z2zlAuzCHQAo+6U2BzPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k6POc1hc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C010606A31C;
	Wed, 18 Nov 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k6POc1hc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FE71F000C4;
	Wed, 18 Nov 2026 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024130;
	bh=UHXHUW0r3PQmhNB7//vAJP4pyFLcoajEhyl+v/I/aBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6POc1hc7EdzMnSN06VOdqwZVHzW/TJ9LOGTwFjRZ0Ru7QooI+JIeKgJAEbfuS1Np
	 R89AP1zKxSgVwDFPHsxbHWrRLBhE6zt9LNo8dWzNN+l+Oq7POeJnOtyO6YSOCeeo8v
	 HtS3/KSatkBN0bhrEjE9w21gyIkp8IHZDGw2ZQqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0617/2151] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:39:12 +0100
Message-ID: <20261118150144.395612592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f57a31cf4fc78..a6f520f49d592 100644
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



