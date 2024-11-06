Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7371DF726;
	Wed,  6 Nov 2024 12:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895674; cv=none; b=MA4NkeHpS3aFACiqPcShd3XAMg/aJlti4MCV0hjL/tNvE8AKbK8hOiTOdiGV0wrATjMy3WciymolY4kxj8MXGX77JI3d8y2p4s6a7U/RJZIPkImyCHfUY2TY430LsjpJ1jRTOHnHyRCyzV1qR/WCKSwgsqV//uFDTK1GE+3zjq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895674; c=relaxed/simple;
	bh=2KA22ImCm2U9VN/Ak1p3kjFs6ioyL6iUV4e9XgqfzoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpjORwXjw3yhF4iSK1jybFP4BDW6jzqeO0buvroms2eODvj/Cbvro54cjVweIOvV2Z+4z3id4TGILqCPG+2+j9VgajNlQXgZUqAyL+GexcPqjyO3YqBy27Bq0KYE5O/NnFJBOVKeBC9XyQEbFoUJRCk0pKyazApkhgcWn6rb2a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o33oKpYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o33oKpYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C38C4CECD;
	Wed,  6 Nov 2024 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895673;
	bh=2KA22ImCm2U9VN/Ak1p3kjFs6ioyL6iUV4e9XgqfzoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o33oKpYXnC0FGjnSWLGh7m4Fkn3Pe4EQupN4J55bncZ2zmCJEP8jSOYOF3OxJpqJC
	 D86BrFmJVmPQQlVirMrvxP7Ju9czlAK4iEp2g5oiaJL8DJEmi93+Ibst+PwBgIEnsk
	 4ckOWzlmJw/JiSrQPnM1XwFbB/KLTSMhQ7kePgeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 298/350] net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()
Date: Wed,  6 Nov 2024 13:03:46 +0100
Message-ID: <20241106120328.169457904@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4df8da8f5e7e3..59690330d81ca 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -488,7 +488,7 @@ greth_start_xmit_gbit(struct sk_buff *skb, struct net_device *dev)
 
 	if (unlikely(skb->len > MAX_FRAME_SIZE)) {
 		dev->stats.tx_errors++;
-		goto out;
+		goto len_error;
 	}
 
 	/* Save skb pointer. */
@@ -579,6 +579,7 @@ greth_start_xmit_gbit(struct sk_buff *skb, struct net_device *dev)
 map_error:
 	if (net_ratelimit())
 		dev_warn(greth->dev, "Could not create TX DMA mapping\n");
+len_error:
 	dev_kfree_skb(skb);
 out:
 	return err;
-- 
2.43.0



