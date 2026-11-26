Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705044;
	b=2gsm+l5G1secJYjdMpsvHGeJytBomKOQ3bTB84V0jMei7LocVDunVpJkcsUU1kptOpgP
	 7Zk3xJmBhIYMajtV7rQY4gCwFZkZcxfkU1OGFmOY9ybDocnsVi+aUoaRxRl7Uw753wizH
	 c4T+ul5iTWGHRx0OysidFjZXEUPMcTJnscILr8i8nM8WaGEtB2UrNpOuvRD4mbRXUE10m
	 zCwhcaa+3y3wHLlZOJHjKbPJp4xqY5BvOLxPfEwTzqaur9Rt3soVfyucvhoCnTT5Vh1rR
	 4CQA6V10kUgh9HCEmW8rMvV0A7nqAYLUb8mY2y1uUCJ0Xe8DbMCHk3Z1eULZREq5sfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t6ySXHNzZPp08Tl1haRmBGLsaAeJoCMxp0vG8IW8o3o=;
	b=D8pijA+cSdk4qU92v3mwQpbwBCUds+/yaycLPav237DROEvaVo986nTS3XNSy6Yql3fi
	 zdYIK3F0+A6Ws14kMuTqNC42PL0kQhN9jSsfWVbMk3/MLG1Iv1KHTFg8XptxgtdxY3NX5
	 pd/FKva8NMFCNp3IMbY1zI1H0YGlM8gnwx/XJKQg3iXLjdeawWgq72+g7Rtmfoy+E2ryo
	 XPdkrn9lWv2JCv93wESzwU6eKCw4ehTI7SZfOyU6sK8mRhl/R933gqN1EzTTA0wsboZWQ
	 PQQrbOsRoWEzLcv09CzVUHUrFsGtfWuA/6SPyiNsQYE0UnXhj7TPAYkD1BZHcRpAvCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4ZXvZd9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80421606A339;
	Thu, 26 Nov 2026 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4ZXvZd9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFADB1F000E1;
	Thu, 26 Nov 2026 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705044;
	bh=t6ySXHNzZPp08Tl1haRmBGLsaAeJoCMxp0vG8IW8o3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4ZXvZd9RpDgTf2laGS7p93+YOKofIzhc7FE/lAaPiywmSMWbBbiExmop9+fx3qhX
	 YRCetUY98UnkcEpX83eMxWFmSyZYxc4irdBwiFbrNpv1KFNKdKOdxg29MIn1d4L61D
	 sbxhI6/o/HZip+itisor/meUacTt+H1Ui/pPMWK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/319] net/iucv: take a private, writable frame before rewriting it in place
Date: Thu, 26 Nov 2026 15:37:11 +0100
Message-ID: <20261126144008.160733982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit f38bce9af9e2a3cced7d303a1476f21c1f42bcb7 ]

afiucv_hs_rcv() rewrites the frame in place -- EBCASC() on four name
fields, then afiucv_swap_src_dest() swaps them and pushes an Ethernet
header -- and can hand the same skb to dev_queue_xmit(), without making
it private first, so a packet socket that also gets the frame reads the
rewritten names. An ETH_P_ALL tap runs first and leaves af_iucv a
cloned skb; a socket opened for ETH_P_AF_IUCV sits on a ptype_specific
list, walked after ptype_base[], so deliver_skb() takes a reference and
af_iucv runs on an skb that is shared but not cloned.

Unshare, then cow, in that order: skb_cow() can reach
pskb_expand_head(), which has BUG_ON(skb_shared()). skb_cow() tests
skb_cloned(), which is what a rewrite of the data needs; skb_cow_head()
tests only the header. Asking for ETH_HLEN also covers the unchecked
push in afiucv_swap_src_dest(); on the ordinary path eth_type_trans()
has already pulled that much, so it only compares.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Closes: https://sashiko.dev/#/patchset/20260813-b4-disp-60433a46-v1-1-509e1200533e@proton.me?part=1
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261028-b4-disp-1edbbc34-v3-1-13495411f5b9@proton.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 8247f1f6c20b4..b4238fbac2d1a 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2067,11 +2067,20 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	int err = NET_RX_SUCCESS;
 	char nullstring[8];
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		return NET_RX_SUCCESS;
+
 	if (!pskb_may_pull(skb, sizeof(*trans_hdr))) {
 		kfree_skb(skb);
 		return NET_RX_SUCCESS;
 	}
 
+	if (skb_cow(skb, ETH_HLEN)) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
 	trans_hdr = iucv_trans_hdr(skb);
 	EBCASC(trans_hdr->destAppName, sizeof(trans_hdr->destAppName));
 	EBCASC(trans_hdr->destUserID, sizeof(trans_hdr->destUserID));
-- 
2.53.0



