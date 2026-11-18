Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042277;
	b=nvh1yxtyaBgZ++rLsL7BSq87opImIjniVr76HUZlWCu75+qp7XHLCHGDNmnXSelQ/jzH
	 8fWxJZDme9iMwnO/qbrknZkBYGUvQ5FVBaVMvtJri4MFLoY88xLqTQo74qaMULt8k0osC
	 os3PW53xkAu7R24YE6dTSy+ivJfOEmhNtBT30Sa3Pcq9FPrvAGfao5piNGIk2PZdH5e8P
	 LDIVxw4sieRl0ckE8d5pFh3Fefcs1GMd+Aw4EBJExK+DT6mCu/9qsNm6WQs1Vipo/mgth
	 hJ/BLHtc8DmTh0Bydg094TDIBbeAGPhJqZaBsz8OwK1m2mjZr1dPCH5ZvRUpMyv056A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EY8OsDb7KhcPdXju1GGVA71n219BnUfiUGDry1VoTJs=;
	b=yQresZ1d6nQ4EEHxsoVFNAjf9mo/XFwEqFhyAr+6INdvcGdltb/hJ6OjmmV1fEoxSDuM
	 8InUW1/3c1WoPi58g70MlLlXgpf2eOc2ZEJxd8tdeCShxGvbWul7dHscjwAYiuh8cb4Qc
	 mW8jdQ9aE+uEOnbmijetzyFNYw66n+dGE9xFnCOwtuVIr5bn4B4CzN/QmcRh5TfDJBJ7K
	 Fmj0hYnKD7Vc+2lgUC3vkNjyqziwi7M3hyP2FWoSdTGAE2R6YOWW3oK5zlUbTc34QZwU+
	 qWDxn+MjhWiNfFB1wNm5mdrC+02YGuvD0iLFCM6I2grn6LV0gcjmIKxom2iOohNUBgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V/GxjFS2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F2B606A31C;
	Wed, 18 Nov 2026 22:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V/GxjFS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1D71F000C4;
	Wed, 18 Nov 2026 22:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042276;
	bh=EY8OsDb7KhcPdXju1GGVA71n219BnUfiUGDry1VoTJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/GxjFS2+7HzIlOJOipwVj2m2HPk5op+2SCiWxg9axmg7rq5An6gxF4D44BiJ/Jsx
	 qTB8xZBSbKE3q2xo1scrA/0tT5VNx2MCIGfmj3/q7AvAR9/XPETTF/te+s17aWHXr+
	 FEnAqLH5HYEh6YUzqKT7LdQKyXmVu++2hb8j0IhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3072/3318] octeontx2: Fix use-after-free of qos node in delete path
Date: Wed, 18 Nov 2026 16:01:34 +0100
Message-ID: <20261118150452.260393903@linuxfoundation.org>
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
index ded8e49745193..4e6be1b644dae 100644
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



