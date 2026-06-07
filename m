Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F862AD00;
	Sun,  7 Jun 2026 10:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827553; cv=none; b=A7+ct0pGWr7zboj7bgqe3F8ce77fzAa0tLVDi9cgZWGqPFDBNPt98dQ/harzpzgu7Qe0FtXGK50Ci7r41ecpnq2Svzl4lqvEBtN93R4CyWYaZ9a5Vr0qEPSv6aDi+d8igpKCU3Mx910q+RVHnazyYlfhXv2ZFwJWLqKn3MU6rAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827553; c=relaxed/simple;
	bh=Mb7AE2tjPSO3u1lneIJMNINIGJNdvGyexBE7K2lQCOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJFH5LKHeXLiS+0845kA+P/AZcNPrv4w+27qEZ0rida0wOx5wHrMFcEq6b3AwUK2OB7oVqEU8CVtRoju6i2d7ixAwTHUDvsVT7ORZgNCxBV/Vz7GvF2Ht30uekTEElJH6h0oSZ/eOq7Lo6r4vdnSqj18UxRFmXAQQkKuYGuJujc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYrs1JAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYrs1JAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96C71F00893;
	Sun,  7 Jun 2026 10:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827552;
	bh=BX9Zm2l82xaLVwaofCXT9i2fHhMNWc0YSUemfZEjA+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYrs1JAKvsDkYoWEVCasGIuHWo1scGGgHoodd5C9PPWVXJFPobsusaK8F3eC6gfkt
	 mGNKmIk0C6ExKa4LEPE+fBMI0VZ088RZmpJMyPy0U+RFpCLCMWkrKysUjd3k5zbBqp
	 LsISePHC1CGq9g4GzZkIsrcmCyBBLxuFvBTPRv6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/307] Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()
Date: Sun,  7 Jun 2026 11:57:41 +0200
Message-ID: <20260607095730.101564553@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e5186a438290ae..03f0b5d27b60d3 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -485,6 +485,8 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
 			int ret;
 
 			local_skb = skb_clone(skb, GFP_ATOMIC);
+			if (!local_skb)
+				continue;
 
 			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
 			       netdev->name,
-- 
2.53.0



