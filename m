Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFB918CC1F;
	Mon, 28 Oct 2024 06:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096861; cv=none; b=LD08/PoXLqgUM2CXNB9gWpo4rWG+gW1o1LgKU7fd0A1Kz/BiY0N+EQE9NduhBQgSJa9m4/xWaHN3NuXmfacm6pdF8Lv18Xn4tMHqytfjGqAeuYmvXQdMvQfDjYqoVBiy0WT+NlKVVjmkbk1H33ttzAakNP+okD3OEsl99Fzhlrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096861; c=relaxed/simple;
	bh=L6MKVECotlv/h6leW4Bc17vEJvbTbDsHeGQkiFvYaCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlDgmDhjoCICLKLt0ZGS7augNVDM7C73ssoNHqqNv0/JCI1AmtiN+bDuppNkRGXl/FB5NNFt4QSQtzrgK8A093a8sNDlc4emTaUQJlbv0qGI0lBZgOZ586v8MU04FCaZt9GGKSo83ug7YKvMWa+pp6YwLu9vfAWeVCVq4viDJpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmzhDA6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmzhDA6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4105C4CEC3;
	Mon, 28 Oct 2024 06:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096861;
	bh=L6MKVECotlv/h6leW4Bc17vEJvbTbDsHeGQkiFvYaCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmzhDA6ZzETtZAcQEtwNbDDxjrKGCifHoozcbIkUS+rJcdxxu+rVHqqIZ1ylUFd/g
	 WV/nVBBKVqBCkmSXlpMg5zsS1jW5UDMqZj6CkS1SFjYZPAhxfDcku2j7DlQ/8YeLIK
	 tFO1BgZ3P3LHwOm2yEj4GWDnEKbK0IeYKt6h4/mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/80] net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()
Date: Mon, 28 Oct 2024 07:24:59 +0100
Message-ID: <20241028062253.157927452@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a95bac4e14f6a..538043cd9e24c 100644
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



