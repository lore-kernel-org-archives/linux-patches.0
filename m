Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFDB18A924;
	Mon, 28 Oct 2024 06:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098077; cv=none; b=gq8AixVczp710KTjRbtEC7WER9pkmSnYb4D8DBcptOr9uH8Y8zbsfzJQ81gT1hrNwxw5llzBugsa+1OX0JJK47p1/fR6azgOMDMuQouZT5Sl3Umuef8/6dWHNgnpxXi2tamjttj1qI+mW+HniGjRhtEUsKIHKY+YEtpfUfDjPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098077; c=relaxed/simple;
	bh=iOyqcBUwFbFz0b3grGicQxve3mnPcXucpVDY2kU6zMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8X+3/dcZVnhPqrdAfDxjL+1+MqXQJY2jKAHkNVMMLKGrLxNqPu0V1g4dbOGWjpzmxYcBD8byk4fo6Dwr9Zho5D1ElJK66yhYtPgT1bw21vjrhIMzKF4+sPcNZiSenWnDPR7W0zmdcmq3XT0/WszFni/lwjtQ3gpffxCnXljoQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhExhq8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhExhq8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C018EC4CEC3;
	Mon, 28 Oct 2024 06:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098077;
	bh=iOyqcBUwFbFz0b3grGicQxve3mnPcXucpVDY2kU6zMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhExhq8fJst3KMfO+pgiS3zvIV/2aXZRPmB3i7eUnYv1v8O7qpNBNs9NhQrp2yC/7
	 qeDLH60ytYzAfarA2lFk5HAiDAX+JuKjkoNKaTS8tng2AWK1UfC3zZTxjDli4wOE/4
	 VIzAbHd57Yf0j+gVwSTZdUq1iVygcRDQILBxEk9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 067/261] net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()
Date: Mon, 28 Oct 2024 07:23:29 +0100
Message-ID: <20241028062313.713365112@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 27af7746d645b..adf6f67c5fcba 100644
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



