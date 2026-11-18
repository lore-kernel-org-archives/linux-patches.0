Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048459;
	b=Tix+sSXVrcj6fZmlJgIc+FmTel617Pfwy+hgVZdW2+RsvMmgbYkOF2LG7j6koRe58m0l
	 Czbtnjfnmd+USSPxp0YS4r8kkpRWJ4XxBGQ4Ar0ojMBN5wpGxWlpnpePFFXkFZCNGn4oF
	 /1BBSvcGQTbkw+bc+UOmOe7K+I4h/QZEm1RYfPXda9eP9DevNzvZSHLoWLmjosN47utmQ
	 03jliXbOoE/Wk+IH4Mn5npmXP10+Wy12Y1ZIwP7yXTAktfR2JPZi08cFRZvy8+Iq//ZUP
	 b6Hf7XbWFc+fBJjm0LxPQr7nSfMir52iwy4SiU1Dmyns71MjUqbXOTf6vdd+Ge/0H/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C54o2WCGjJ+Q5OEACdt2fV2i1gJrKHADhqgq1nF/Ktg=;
	b=J7dWhFHHQxQFUtSoTRlvf/eTTSMXerA6NIMUQ8plzr5bRbSo+66rjS6ncTtHBFmLMkF7
	 TLyguV/HBRiBIINvMPMUC7UciIRPzypJ4eUDG+rpY7bW4iFzijsezv72IauKENabIRk6C
	 ihaHIB5gieKpc+U+WNqgGToF/fe+4Pi/TBG/zMVP0+T72YEgYTj4f4ELFyPViFyeE7VVz
	 aDeRk04LkSe/VwRR1/Yxu+0JcbQL8DDF8u3/ITKGPInnzl3akUJ2fvvDd1SFReZL03qS6
	 9GTrft6ercegiKu5CSMEbvRFauTJPZDbp4wIJSKkWLBFLThLk8FFJBPo8Ikexd/Ulpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFezeLMN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA77C606A31C;
	Thu, 19 Nov 2026 00:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFezeLMN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D3A1F000C4;
	Thu, 19 Nov 2026 00:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048459;
	bh=C54o2WCGjJ+Q5OEACdt2fV2i1gJrKHADhqgq1nF/Ktg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFezeLMNWt1BW13BB7EYgNCttuIiZTW2wGDggsSI235W9Zah6MyxzO+pukUOKwIit
	 AJyz54kRRYHRrB0OVCq/fyX20n+2WrE+zHhHyyg5QS5vPu32bRkPwrgqITz9rUiT7n
	 1H6RtGsw1I748SbFwSariRhwbNIaW8gfNldYKoMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2003/2857] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:50:37 +0100
Message-ID: <20261118150313.481663909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



