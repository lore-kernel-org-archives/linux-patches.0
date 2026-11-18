Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060709;
	b=mAmAD7ThX9ZwyzFvsqQlKnR0HRE2qTzfyGoif8tyMes688s+N5MqY+MEviuQuEfLNM1I
	 2akEqu3KrXNGoJtvWwjGS8qG5nRtGBORtlE3GJEPW9A/DmKLL7dqfJ1fnBShB3371BYUa
	 DamYbxk/wDRWcbgfA6Zv0zoR1eEguIr2ZirRu6gsqTiDfZCcWaG/BLR3sGCZN7C1ORLVZ
	 turYANAiFICZf1qzp1JO27Sj5OeB1rX8+O+Heb7gH2TgolH+KOB4OZmIQH4NOOKo3hHbi
	 1bHv34hWQj9iU8wOVrLgpgNUgtjw6p2kKwTzmW+4ssdd7h94YGIN96T7zx0Z6g3O3qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rvjj6lAZK44U9mxCNektIR04pxCmDRDWKmwGABbK3Jo=;
	b=J4Sa7Ma6g+BBng2nSWxI17fbgnw5SQv9ds537ZLKANu+DabqLQkcPz4jQvGpfZtpnz1L
	 pQ+HN6kZ4vpxQPY2kZDEQ7nmC94HplFh4KZTLGxfT70PumHZ0klsqWejKkAKd0GgTi4Uw
	 ZW169Etlz2e/pUCBoYNSthsN67bwV5WL/Nche/TqYPqaV7lLhNmvGKeTYH0pKQ6QsnEN7
	 iImGIdqk8vjty5ZB2CHg3l5J8AaEbew3jfG1pVchyCDauH7nPMAHjsOBSXVgtmRWm1Jy9
	 vDps/Y2Lgb+xMbQLMtoC9UcFae66K32kReERwxuy9I/PoJ66tBy/2hpJmvrg2gkY/wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zi1Kj9hD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E70606A32F;
	Thu, 19 Nov 2026 03:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zi1Kj9hD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C781F000C6;
	Thu, 19 Nov 2026 03:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060708;
	bh=Rvjj6lAZK44U9mxCNektIR04pxCmDRDWKmwGABbK3Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zi1Kj9hDXcVw+Qi37z3uJtteLecicombkDtWHZaA0SRafszrVtnOVWqSAXy3t6dvI
	 jGi9KQiw0ULamKKbVKO5b1CuP+svmcrnk0p6N7DHEOcf/d54xmNDndcqflYMW0P8Vc
	 JQAxNJ2Ws2YJ0u1t4bvuyla8DjV5xkJTOHagFmg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1297/1848] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:55:35 +0100
Message-ID: <20261118150013.822073354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b607c17827382..6f2eb6b2f1186 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4009,8 +4009,10 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
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



