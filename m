Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A90413777E;
	Tue, 16 Jun 2026 18:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635306; cv=none; b=QIlPXiOxCv/+ojJ9czUwExZC67m5/CIT0XmdOrCJq5oaHM57h1PhSeqvxuf9oeJDAk/70dW8Or1oGsHdV9sQc1xsTlSx9lAI5Cw1BCZh173K44rW950lQ6QOxn+JVtxicEMAAYWArSR6T+PngQ33/At+AqeBaxtTWicaBAR2dHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635306; c=relaxed/simple;
	bh=eXEBugUleZp2jyjjC87kxX5Xtcr2yq82fduKNbrRX3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWmHzDxaAI1OgAC+iYeNuDyh6YuyCvPfK4zksIF7v61pvFjYAoj4IZ/EqGYoz6lwgaNNrze35czvTw7ln5R9oRQDNDQWXEgTrgxWp3mzHhRSrpNbisclEwBB50I+8KE5m0v+IEIyaCQuVd4k1y1bFGfKPit8SSfR5vAYGsaV08A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yj8TG3Ds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yj8TG3Ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429491F000E9;
	Tue, 16 Jun 2026 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635305;
	bh=KPuInXZVIHR5vms47uY25HZoMJMMGetC4m6Nxh9oQ8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yj8TG3DssoPluXNDgYs/jwpG7jQ6LftOTatAtwzQYj6HyT2rdKWojKnTKYEm6+bsF
	 Rxo0HG5TrktI3IS/39LPv4t5lU2HwyZ3IInZqDgIqloQMbdpZQrb4xVRnNrPym5XKQ
	 2G3uOJpe4/LFG1NE1jpsT4y1hyQMZyAHi95I/CtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/342] Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()
Date: Tue, 16 Jun 2026 20:25:20 +0530
Message-ID: <20260616145049.385337510@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

[ Upstream commit 3c40d381ce04f9575a5d8b542898183c3b4b38dc ]

The skb_clone() function can return NULL if memory allocation fails.
send_mcast_pkt() calls skb_clone() without checking the return value, which
can lead to a NULL pointer dereference in send_pkt() when it dereferences
skb->data.
Add a NULL check after skb_clone() and skip the peer if the clone fails.

Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 9486d66863264f..4ab9a31163b8b9 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -514,6 +514,8 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
 			int ret;
 
 			local_skb = skb_clone(skb, GFP_ATOMIC);
+			if (!local_skb)
+				continue;
 
 			BT_DBG("xmit %s to %pMR type %d IP %pI6c chan %p",
 			       netdev->name,
-- 
2.53.0



