Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021273;
	b=NTIdEo2LzMCKor3T7s1bzqAarKlpsZMIshTix8woWdzGSBHPFpvja+YOS/T7MagC6lYs
	 GhEftX7E1u9tD6DF9QjJX9w2gHzG82rfCojsReV5mRQYxwIlZpXilTTMKLciGxMKNFC3G
	 MFphsqBFIvcmKKvUwGDoBdQpOk8oT2EZtb2VeYQ5iIZE8ClzN4+J0xx9D9tfQNARlfycJ
	 dAo/JRg/OuQ0nd0qQAsq/r9KFLsxTiN1RpzA6EX5Xwe0BtOf1khEYlnpU4Bc+XG3Vi2Q5
	 bHxWJYex9nAHS/Wi1Axb83Nyh8kH+IXmEAh8V3upThutOs/ZABhHpaydrtOZrMbLb/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I/0eXU4L76TwaD/wDynIcln19jxdPTao1WnhYBhlY2U=;
	b=KtmjUepN7qCXoM87lE8Hr4M9YDPGH/449O6DrUWaSw5JgmS2smgctF4EUBFTz7rPeQBw
	 e9D5aJq9VExSYZ3OaC1tk5wgFRq8WaCe2nOv8vhKm8es5UQtXqDIg7k1/5vdKZarMBh9b
	 rh+cjBD8m/3p+dBHyofqt73J1afT7G7mJNJi33xtom5eIGoeu7zXkZV3/kvGLYDEykZn5
	 HUK8IROhmQ7dGd5YNUVfVPouCGRn6q80P5bVjeBBYk39LNttnMs69GO91W5G8ogn6lN8h
	 D6WaJOT9CjE0vh+S797/0v5Lav4HQFkT7hpxM04MjLSHhUNcL9VN7MS/X9/LD3XilZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYnT4e+a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E681606A325;
	Wed, 18 Nov 2026 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYnT4e+a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1381F000C4;
	Wed, 18 Nov 2026 17:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021273;
	bh=I/0eXU4L76TwaD/wDynIcln19jxdPTao1WnhYBhlY2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYnT4e+aLSFavYRfK0nSjHecvwwfkCzoyK3vxndJ7J3b9CCPJR0UxTjvslU57sA+y
	 aCebkiJhFJdVzVChg+wAsXwRcCmru6vOmnlCfnf8jdjSlrgoW5jFgBCKZXkZEH1pSA
	 VTYd5yXqamKDE+yxDlkSoiayRReKnZbIr8VeQB8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2248/2651] octeontx2: Fix use-after-free of qos node in delete path
Date: Wed, 18 Nov 2026 15:58:08 +0100
Message-ID: <20261118150406.387685101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f160b1618efa2..2ede0b84e5f52 100644
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



