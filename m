Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1CA646;
	Wed,  6 Nov 2024 13:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899006; cv=none; b=uQHDTRpFPbTs5uZ5yTRL8E1UHyRG4CZK1sZJcplU9ePX0abB+YfmALIc63KK1nP1QIzq/20sMXVGzhqjegIBOeY6BwPFlZIN4O/U3a0t9qY+U9tbJ5ZhU7swNWuBTy57VWcJYoW0bQYklJdqMu2ZbuDeOhHxNxIflObFqqYwF+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899006; c=relaxed/simple;
	bh=WL//0tHIAWzc+oND/3JlBeIB2yrMSyaL7cKJ2/eLBks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8z7y12xAdM9Wtschb+ESJwksKe+zTdVnGFBd397Tkk6o08GmQHaekjCX4Q41UephWRvt6B0TB9U5ZByTSjTDbcCBK6dCh4XuD97ImEhy071j5jUcoiW2SqRe4fBKKf+dAMlgv065CRof2aof0QRD+CsFxrv/vT1iOYVq9qYJww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7OwlgkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7OwlgkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783C7C4CECD;
	Wed,  6 Nov 2024 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899005;
	bh=WL//0tHIAWzc+oND/3JlBeIB2yrMSyaL7cKJ2/eLBks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7OwlgkKeNIPVMxPDoRjZvYz3AIWbe239I+bfwynol58IJU51SAg0Jsa0Yjlv31GE
	 EZvNWDf85B58Mo1FPaJhNzsLRS6U7R1K6Jqq+OwoE7Y8Z/Chx4hWsPPuQ4FgKiS2nx
	 wqrEGZM3wBmuV8/nWWAOOxuRCo6i4BVX+K3PlUP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 392/462] net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()
Date: Wed,  6 Nov 2024 13:04:45 +0100
Message-ID: <20241106120341.207718259@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit cf57b5d7a2aad456719152ecd12007fe031628a3 ]

The greth_start_xmit_gbit() returns NETDEV_TX_OK without freeing skb
in case of skb->len being too long, add dev_kfree_skb() to fix it.

Fixes: d4c41139df6e ("net: Add Aeroflex Gaisler 10/100/1G Ethernet MAC driver")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Link: https://patch.msgid.link/20241012110434.49265-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aeroflex/greth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 19e2b838750cb..9e437aebc7907 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -484,7 +484,7 @@ greth_start_xmit_gbit(struct sk_buff *skb, struct net_device *dev)
 
 	if (unlikely(skb->len > MAX_FRAME_SIZE)) {
 		dev->stats.tx_errors++;
-		goto out;
+		goto len_error;
 	}
 
 	/* Save skb pointer. */
@@ -575,6 +575,7 @@ greth_start_xmit_gbit(struct sk_buff *skb, struct net_device *dev)
 map_error:
 	if (net_ratelimit())
 		dev_warn(greth->dev, "Could not create TX DMA mapping\n");
+len_error:
 	dev_kfree_skb(skb);
 out:
 	return err;
-- 
2.43.0



