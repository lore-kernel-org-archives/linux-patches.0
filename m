Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2604E4502F;
	Tue, 16 Jun 2026 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630527; cv=none; b=tzhL66zdXgPm3apkfgE3B8K8HizWeUBh4KDFaEgQvVDVFYHxl7icsqKIJPYgVicZ5EyjcfO92lX9X9sk6K6IndDkRWoenWzzQbyTmN2ArSVH2e9UkBv//6NEwRI5J6F+g44H6Phps+dqvW8WGkKumThD7fdqQo3M7mWjEN3bcXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630527; c=relaxed/simple;
	bh=3zhH5KshwwYlGq5RabHJJsdqQcQ00Gvnml0Z7kf99+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+HHcZELQXAvW3l4xgTYrlZfm4ETH1KpptP5bea4UiSBBXer13tY053Ph5/EisNPrDbSIZAS/a5Bw+BCnJKL2jlPRNbI68ogQGnd+HpSwZ8DgSWAlPPQ1CbZRUfF6FphsMFdlU6sGi7OAM/5qT7Mr98vbrjlCoZpQnwkuafrlRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9+gnqUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9+gnqUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D06F1F00A3A;
	Tue, 16 Jun 2026 17:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630526;
	bh=TPXIWL12ZTIRtzdLFiwF73jhuc9uQewBnmMLnkmEqq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9+gnqUQ1Sj+ff/DHh4bqNsG4olo4IFNZQDnvKFAVCTat9CzMU0zr2kBRg8Sl7MYg
	 pQtbZ3gGvblYveLGsanQGp7/VTnopMJalOTfSm1IrFqmsnzZdzzlCxm8UDaH4AE8S1
	 g2Kq566frGMeQAGcNB0Vw8kEHHTYkvwSNR5VehtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/522] Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()
Date: Tue, 16 Jun 2026 20:22:56 +0530
Message-ID: <20260616145127.009618804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 347361ff0cc878..dc3d1d5326e96a 100644
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



