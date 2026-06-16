Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617942F12AE;
	Tue, 16 Jun 2026 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633141; cv=none; b=Nmex354aKsmBn1SOf1O38KRYQxLnSzqMsO7g1T1h3/iZC7Gc+A6eCMkzRHl9bT9lxJl6u7iKyOsfDEHaajw3bXIbD+UsSgZMn03b4ZZp47AYTsmqqhl9LLcg9EGxJHf4cH2gUHVIMLz8spcJrJeeQcvdvUX7JeUrH+3ZvRnkPIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633141; c=relaxed/simple;
	bh=p6RB0+od2P2M0CCJooP+35PYfgq/VV5TGSAGsxm/iew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEEypo496Pt6Tqp3NExh1Pb+Bhx5v2tBrhkkC5BV1ufx/cI2fTMbDpsI78MpkNyMQwgj6HrbA3DJu3hGjKlx6lnw9ag8u0Dmqsce9qZ5acW2czdjr0msXFGu7qKB9MNW2sKAudjKDgrYX9mVKXwExPi1jjIZ7j9Co/C1oYnVjdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7j9D+T+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7j9D+T+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7901F000E9;
	Tue, 16 Jun 2026 18:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633140;
	bh=TYFs29qQZ2yXuAvK9qrgYyBiDvKVLRbWT7ugdwzLzM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7j9D+T+PwxhrU6MmvnBTSQ3kOEc72mThr+PvfHAe4JG3q+DiujttQA9iYYJ8kY9J
	 CqnMXAFCy8ZiRRqvIebH3VLZAexd0YZLZNRflwXB1jT0QFATZHgf3T7bqMDViZteLf
	 uMv52uXbuhrGwTNlWiDEwOGo0nnnb3LDi7IlAAqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/411] Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()
Date: Tue, 16 Jun 2026 20:24:24 +0530
Message-ID: <20260616145101.747286933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b70d3a38fdedc1..26bc594182ea08 100644
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



