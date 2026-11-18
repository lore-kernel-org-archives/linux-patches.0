Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032517;
	b=mLMyDFrk5fh3NjwOZKzCrXUEiruIfDPMZMv0pvr1NhaMboQCsuoOPOJeHE6htP2hkyun
	 9LNMyVCHq8DP3IHuD7SOT4kGxcA2TU21QznM8t5QWamiVuz7RSd+KGtuw6kilAngvqAX+
	 2SeDhyW5HyosRqiI1JQ54XfRPeSMwnbAzej21NMtjESbs9MNiDsdtzWsJ4YkLWL33/c7Y
	 E5abv2n+5xG9WMeWRxW7HNC4juYZ2NtaoDzqymVLU3RB4TFd+qx1Q4peZstu+Xe0/6WCL
	 Vn+DFC+hcdmtBWiVkaqmE0aTSMQE1wla6GJNZ3mbFhB8ONU650XF08XJrhxLWRc7P7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q3vMw+z4wgiI+NZfmTYq5yMmORpOnZGrI2BD4uhW72s=;
	b=2k3qpl7zkrk3Q2E8kG9W0ATCkIOX7X4RcXdJrFSoTAP/1oA3c3I3zlsKibYQ/qJWQX7j
	 8OdcWBpy4G4FFBuUwzQ/G8VeYYTBh2GBqiPa8Z/uug0VECYVsEyKvb9o/pvtpADE4mQ/K
	 bVAsJdfAM7m9mxobApNXnvlED8Yvy+h+yUWbS0mEvUmcv1GJNrtfckFJq25k0YDKGq0i+
	 8oyi6ECNhvJwA2EKr/o0G96uxeU/6qSE8C2iMOLH1Sx41YjcY/a8CmgrzTRxJhzMqpFDY
	 vuoty+8wcjrbl27p72gFlN/x/68jTKio1DME6QczQLjBOp91XwZH6cRDJZdamYd2a+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=12a5x8uv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90A6606A31C;
	Wed, 18 Nov 2026 20:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=12a5x8uv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC981F000C4;
	Wed, 18 Nov 2026 20:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032517;
	bh=q3vMw+z4wgiI+NZfmTYq5yMmORpOnZGrI2BD4uhW72s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12a5x8uvTZjNl973MQ62KfzVAwou1XqWiSjs0eRWpWejCBdpfhikF0piDQRYr4mpn
	 /KBe/ynm4DaK1D65nPBn6vdTG1FGVZ46YlJ6S50rta50QQysrGkDMTqrMGtZN/JXCI
	 66z+nxaW2JDJiKuAjKbceSKNw+ne25OMA2B8Dijc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1440/1756] octeontx2: Fix use-after-free of qos node in delete path
Date: Wed, 18 Nov 2026 15:59:27 +0100
Message-ID: <20261118150106.473349950@linuxfoundation.org>
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



