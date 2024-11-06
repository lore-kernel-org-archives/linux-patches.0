Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCB51E0496;
	Wed,  6 Nov 2024 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896598; cv=none; b=EspmicXsDMxoZPvmCF4Blx7DnKVE6j3rJnFPnH2Nzchbnvzlmmyrpwah/NB3h3cVu4at0hkcCYVxPfR6iKZf9424tI6u+T8PHY/2AZeCty6pHbWk2LrxsLiiTS/Jp4rTUNlq2t878awrPSLlswQ3pdKiUjsujAzi1hThTs+T26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896598; c=relaxed/simple;
	bh=SiN2zwhaPilijGaL9AnK961/izpWswInnFtzITZPi3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9WLMWI4M7WaagEHcD8bCum+x3/PF+Z7jHIkU28tjpShKFSGomIOLU6O6KTd66RwfOscgrD9v1xoKDIJrqD9ZspBKtHljtyAFT+qFpNk6bMQykxMsWweTNAUzI5bP3g6rPyp11rf/Q+Cx8SfCJyh4prw+d0Kmn0lREoJasjSxHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9aL4QMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9aL4QMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B03C4CED4;
	Wed,  6 Nov 2024 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896598;
	bh=SiN2zwhaPilijGaL9AnK961/izpWswInnFtzITZPi3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9aL4QMIYAOGSPawN8G0HM+CRub5VrThbVSav2Lg6wrBCbOSYfTJZ+FIJQdfEUwm7
	 Snhlf/6mowUOyIwr+fUQ/Jwf1RdmrAN7iU0GwnCZY4lsc6S7i1hKQNr32T/jL8i+0j
	 O/1zdcnLywwHensQInszIR+IXQgFCfG0FKEJnbio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/110] net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()
Date: Wed,  6 Nov 2024 13:03:36 +0100
Message-ID: <20241106120303.438285550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d56cb4f5dd9b..c84b9acc319f7 100644
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



