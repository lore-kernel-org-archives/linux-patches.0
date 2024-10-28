Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D960718A922;
	Mon, 28 Oct 2024 06:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098083; cv=none; b=Wya0yEB4HwNz9nbHfmXueRwhAycwruEOGhKJA5gJ7IFtCkMtqmGuN/T4ZrDL6pONisKZHKvKaeQ20UMcGLeVJSn5W40c3C8BNHrJUdX8mWBWM+SRXOlqD7PubzrV1k7MttmSM9dfPqrvI98mSsy2zWXJZ3aYbdd8ozRsWd5OE3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098083; c=relaxed/simple;
	bh=I0lsKYOQLYyAS/Wa8JCISoGAm+J4SjFvocSeOUPoICg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+9vT8+2k4dDCmKFSVSGSKnzXO8MQwnMcJrKDdLDxbyeScCgR8OV1aibcBpM+/MKud5y2DU5fMxKnNStqHyi8lDkGF2s5TcKeDOg7PWHbGX3wAUoVZ88f8ECgOQ1vyuxKtNUJDtZ/3oxp3V+je84uOtKPcPZm3RFbajsn5VHVVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GrxK/fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GrxK/fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3A2C4CEC3;
	Mon, 28 Oct 2024 06:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098083;
	bh=I0lsKYOQLYyAS/Wa8JCISoGAm+J4SjFvocSeOUPoICg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GrxK/fj84m5W8rdpvdoTbv6/oLbscjtgt3B+QiBChv5Ls6R9Q1t1BhQ20kJq5puL
	 QnRYiXc+3+LrFEMJi7vsE7etI6GYV1zSaOOkXl/o3vnlYr4cqw7qAuZzake90ZpIsX
	 et24Ruym7kG809qNo1b+NlrKDmC/JTLJxAwkEOYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 070/261] net: ethernet: rtsn: fix potential memory leak in rtsn_start_xmit()
Date: Mon, 28 Oct 2024 07:23:32 +0100
Message-ID: <20241028062313.786058856@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit c186b7a7f2387d9e09ad408420570be025b187c5 ]

The rtsn_start_xmit() returns NETDEV_TX_OK without freeing skb
in case of skb->len being too long, add dev_kfree_skb_any() to fix it.

Fixes: b0d3969d2b4d ("net: ethernet: rtsn: Add support for Renesas Ethernet-TSN")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014144250.38802-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rtsn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/rtsn.c b/drivers/net/ethernet/renesas/rtsn.c
index 0e6cea42f0077..da90adef6b2b7 100644
--- a/drivers/net/ethernet/renesas/rtsn.c
+++ b/drivers/net/ethernet/renesas/rtsn.c
@@ -1057,6 +1057,7 @@ static netdev_tx_t rtsn_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (skb->len >= TX_DS) {
 		priv->stats.tx_dropped++;
 		priv->stats.tx_errors++;
+		dev_kfree_skb_any(skb);
 		goto out;
 	}
 
-- 
2.43.0



