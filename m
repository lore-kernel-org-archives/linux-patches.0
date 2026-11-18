Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027504;
	b=sDHnEBTMyYZaKj8AfFJ2YtyQ84ezG8usfMYghJj+FxJRS7jnPLTVH7N+rvMLL85aDoIG
	 pJ90m1a2IJsvuQooZbNkgaz5ZlmeTdxsn8r5n5SzPVpqAcI+cEj3xQyKyMmZANVjLEfFr
	 rLCPof9D1SERpwvdwDe9vuoPK6XHw0541odUs5/V/41zd5XmAdckkzYciiWWASKI36f2m
	 bKLibOzChL46VQSvq7iTyc7j6nQTERv4EsGSRBZlt8xRMgM4Cl7oKfoLcEgtgLIodBiG2
	 Sw0sIZ9420NrUDNiSbH3fi3XdheQOcOuyLFZs+JFc3xxEE/6x/7v+0f5mdDpG3BIXGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lvgp7RF3fyHDiT6BZdpRfNQw8NnfqhQTntaQ/e3z+sg=;
	b=FjBOgsxzl7TRTQPs745wM0Lh8+livN7AYmdEMAj4i6+V/6KPI0lcnYZxEXcY9QTSVp9A
	 a+pmek6KuhGPvae0OA001pERinkHlPGnA77M0BUgcEjneROlm7jAheyNpX3GXlJMx9Cab
	 a1wZAnoJVdbQPkyk24+823u/t+n/IYbgaTM4ZS4wFb5c9jivdA9RW7QxEEEZjk3tmJfHR
	 C46mZlUVkKGTJl2Mw9rj8kCq/GrfbfmBqX1Ps33lHUKnxPFbQLkLkQ8Qm8mkgqdNXcSwX
	 uA0fOhUsfEmPSyN2cZ6z78hE0wlr3n0iL8tWhZw3Ea/ogRpXfdJ+jXBmFdJZXMTtcGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTP6vt7X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7406660A2600;
	Wed, 18 Nov 2026 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTP6vt7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95861F000C4;
	Wed, 18 Nov 2026 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027504;
	bh=lvgp7RF3fyHDiT6BZdpRfNQw8NnfqhQTntaQ/e3z+sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTP6vt7XbVQ6s+RagUkn/F6PSHGUzsjJILDDM5US2GJZ6wHiku7KfOJFHm7EI32Jx
	 vt4B0lWIY86NXmTycOEUeKoVegb+BbjAxiGQiqI+PSpkhQl4UXcOS5ixslAGrK/yBz
	 d0ML8MjsJdzk7UOJ3dLT5suIRpkCbennSN2Tdisk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1812/2151] octeontx2: Fix use-after-free of qos node in delete path
Date: Wed, 18 Nov 2026 15:59:07 +0100
Message-ID: <20261118150227.813854735@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit dcaa6219648955f7a8160313f1685321dbd1bf28 ]

hash_del_rcu() only unlinks the node; a reader that already holds the
bucket iterator still uses the node.  The immediate kfree() has no
grace period, so a concurrent transmit on a socket whose skb priority
carries the deleted classid reads node->classid / node->qid from freed
memory (use-after-free in the softirq transmit path).

Fix this by calling synchronize_net() before the node is freed, as
mlx5e does.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 5e6808b4c68d ("octeontx2-pf: Add support for HTB offload")
Signed-off-by: Binbin Deng <18983559317@163.com>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20261014064204.291688-1-18983559317@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
index 69dfb34008572..7f22de0df3a5b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -331,6 +331,8 @@ static void otx2_qos_sw_node_delete(struct otx2_nic *pfvf,
 		otx2_qos_update_tx_netdev_queues(pfvf);
 	}
 
+	synchronize_net();
+
 	list_del(&node->list);
 	kfree(node);
 }
-- 
2.53.0



