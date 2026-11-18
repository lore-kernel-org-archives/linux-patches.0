Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039995;
	b=0TwXe+FAKZ9kGfRW69SRzg7TIfU7dOqwOF/hrz6T9SGwKFKys7+0QdDDuNRme/0/Y/YV
	 zVqT3ukX6aOxun2B3ItUSmo4uBtU0M8vUtck6qmRuSmyipgh2zpjvOJMgnyIp2JSDOTXp
	 g3dg4c+wmTLjXHfHco5YzbVKJScfC5Pl9Jv6Hmvu5ZTOnx/CLGzaheNfe+zR3Ol3TDoOv
	 FNV0FXvo0uj6yfAMPWspu1XYfSCOGaT6+SAJPCW2wmtscEiCGEBnes++Csst1Cj+IVOGi
	 my0o4iQ1T6apC0AwhRa/C+tQINbkeuqQ/1cvSObJ1UrtzeVLkVHhL+V9vUc8AK/aGkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W3tuHktF8+5dz0rwH6fpqB8ccyL+//IKzDnuo16/Y9o=;
	b=Cj6lJUOv3Yjh8PugcJU594tN6mDm6QClS7KA6DvsdLfWAkEuIJ+nRPUSrWjz8koiQmiw
	 Ejnmsy5x0GHhxczpJFIGIu5Nq3mq3zIm3ArKfQfFIuGoW63ryvi63gHYWI2VcIZ+6qi/W
	 0xrg6ZolHbNkEKkqP1Ca5NishM//77Z0EmTLlZ9ASoSflGv5Vld5q8QHYvXFdyNKY507T
	 d2HXsriJEykrp9bB1EectBVCGY/3YvF+uVNzBHplgkzwAuA1a53GKf6cHrqLlSzV1i/FG
	 Ep1g7YAbxrHqjNDIrc0LFCe6B2wfx81pIW/HHtIqGk4ly4nrVHrcuDYOgRo9ARiRcZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kdi0cUdp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA54606A325;
	Wed, 18 Nov 2026 22:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kdi0cUdp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EC41F000C4;
	Wed, 18 Nov 2026 22:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039995;
	bh=W3tuHktF8+5dz0rwH6fpqB8ccyL+//IKzDnuo16/Y9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kdi0cUdp7aAm3xqqPBRIijkyI/ZY3ts6sPBndmp2o+bsLknFHmAGe4G501nqmVPGU
	 9M6zl0Pyoi/+5vGcIEh4GeLkPIagi056pn22vCDz2+51fUemByblwOOh4S2HZ0JOKN
	 WcM0+H6IuBDUFIR2uPhxMrHOOTMLDmwAHmmNjGqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2299/3318] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:48:41 +0100
Message-ID: <20261118150430.688432719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



