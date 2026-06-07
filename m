Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D085B2E739E;
	Sun,  7 Jun 2026 10:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827120; cv=none; b=H5vPC5FbPtulvEWxahK+E987vuhyeG1F8/IRyWvR02Q7Hh4AzVO0cxLlohY8U135OK45ImbZ/CC6rIXpuzRjrp2LE+Umv77+YJujz3Ecy3ub0XasU9Cfcpklf+Busp+pSFsA8pnFU+rojQu5feynifG1F1b1M9bUfLG2Y4/D8/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827120; c=relaxed/simple;
	bh=sc2NLlmL5UttOEa7V4QVcn2zEDkiSEZx8dP58fpmEi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZO7RWxesLkoJLDNikW84RvlWwlsRl+ZcF1+uOns7C9L3vmOZYxIwVKbbQDrpvucRAtHSp4S3U0+aLCrBxZv5dF8f9LYnsI8EEKeMuWJVXkHiG26/8DJQ+d7XkGySOdruyAG1VNLIxz5T49XpGyxmLijHnpoPbmn2sypyZV38oBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgJmii3r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgJmii3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194991F00893;
	Sun,  7 Jun 2026 10:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827119;
	bh=qeJrjxt1kL6qLSzb7gvAOxyz2J3/j1Oi/p9GePTJvuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgJmii3rl0HHGASooxnJXfd53qFZzjA0687UtIhZXul706ui3yZoA+pWhXP03D1qY
	 UAe5hHcy7gZAlR/9+87YvZMf2zaMqFdJLTBeoM7JLa53APdqfyAQiRVXj9G+sf2ozJ
	 1H5uIqUgMXXyRnEusPMFTB1Rbz5wlHg5LHR1+IB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 064/332] Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()
Date: Sun,  7 Jun 2026 11:57:13 +0200
Message-ID: <20260607095730.483335491@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 2f03b780b40d84..960a19b3e26da1 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -486,6 +486,8 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
 			int ret;
 
 			local_skb = skb_clone(skb, GFP_ATOMIC);
+			if (!local_skb)
+				continue;
 
 			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
 			       netdev->name,
-- 
2.53.0



