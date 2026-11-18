Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039992;
	b=TLUqmLzMNL9u4rURAqyEGZJyhi06esqt/gqHAMRTrp58V1bvH/ngXa9EA6G72JPG9Ed0
	 9ipYpyWMveieuFVhemtCcmq4SpKCQvXOMFAnI/AHpNaVL+L63mZIszrDswzJFp2i3nrdB
	 ScS1kiTyYYBntykllXOjybMjVNrTcbKRqU7pWN8LRmCl0Ny18wRpba4gyVsig6nmU1GXs
	 ngM+foFO2kcYDZJeckgi1KxtTtUq0HASPaTOnFnJdzNKuKQt9N+HVHFllQ/sNMrDOkCRp
	 BRS48HJnpNnf1bUUMSu2kUXa9xjaQ4kwhrv76l8EGbYmhyJgZHJZ8gv4Ei2Zk8HhbRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VK+ywQjgDhw7IE6kI1JlTSqCPVn00YXm2fXf6rcyfqk=;
	b=pHM7F6grdnDbH2KURbBTMMXTZDhuooc39KkkjGv+Q/lNnjsgmDdybiF9v7uf6Wn3RYa3
	 DhVG/u/vt/HS5MWTYiO4WVlYZlP2jXg8RIG4lXY7WgOGu+XbAP45mORYshJ8sB92pNDyB
	 3rLHHPpD/tSzW2SiNwwa1F3BIQ0ylVyYl3fBvBOdBi6Nxxr2XKKEyK+GLsQ8BclUBPUdp
	 1cya9+DfwNCPOUGeoZB/tT9uJ7Hp5roqlbkiZs9Y9mYt9dALmcODRnpCOhrM6G1Bnh070
	 TjpCsFM3PwBcIpLulicwgV82WKSAj7CuEX88aluNqD7LWp+VaPMZzKUB9BHKjW7whfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qshL6ByS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D4C606A320;
	Wed, 18 Nov 2026 22:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qshL6ByS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23DC1F000C4;
	Wed, 18 Nov 2026 22:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039992;
	bh=VK+ywQjgDhw7IE6kI1JlTSqCPVn00YXm2fXf6rcyfqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qshL6ByS2dYSWO2G9q4xBomIjVw8zEE9ATY48/BNraPxrY19IIgj1wKVSWDL+r79x
	 u/TFF71ZZWFnrM59Qm7hSqrb6E/nxyXXMVtDy6xOcvXkh4cV+YshnMTh6E2zteRkhg
	 HHtv6IwbacBELpnkoonI8RHj59690el/c1fR707o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2298/3318] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:48:40 +0100
Message-ID: <20261118150430.660759436@linuxfoundation.org>
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

[ Upstream commit 5fb3051aa4611ae18e304814fb1b74a30065fd85 ]

If ip_dev_find() fails on the loopback path the code jumps to
free_dst without releasing the neighbour reference taken by
dst_neigh_lookup_skb(), leaking one neigh reference.

Release the neighbour before jumping to free_dst.

Fixes: ef42520240aa ("RDMA/cxgb4: add null-ptr-check after ip_dev_find()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183530.2092534-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8d753e6e0c719..07cf0026cf1e3 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4156,6 +4156,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 		pdev = ip_dev_find(&init_net, iph->daddr);
 		if (!pdev) {
 			pr_err("%s - failed to find device!\n", __func__);
+			neigh_release(neigh);
 			goto free_dst;
 		}
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
-- 
2.53.0



