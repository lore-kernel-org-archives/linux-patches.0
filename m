Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EBD1DE3B8;
	Wed,  6 Nov 2024 12:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894872; cv=none; b=U8ZKUmEvyfCv2ISJWGTwN2kfSAXcaizs2T6WuY77jpQp655HfQ297SSH9/weE1FBUmoRXgFWeTVuYpi9APRVGdXkv2cFbjHe4479vZIXvS06WApoy6jZrUlQ/Hml8MyAh5H60VBF4VVnbp56mfzygS3XZtQggia86tv3vCFpVy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894872; c=relaxed/simple;
	bh=dDWtKp/UPtSje9wKd2IXi2VS3mmNUsVtHSB/7fiJG2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7sJkvq+R/SjGa57G/8zanE/BNoqcEsbd6n7oD08gcxXZqenCKdKl53619kfyF5edFV2U0lhMKT0BAVWfkUKj7rmStLABbblAhKWgBtufJ0Axs/yUbPiIgwnpIcpm9Jg8h5HEwyVbrbj4S98Us550hy3SVUqKvfEn7t06lUIePI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTNbpE11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTNbpE11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9AAC4CED2;
	Wed,  6 Nov 2024 12:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894872;
	bh=dDWtKp/UPtSje9wKd2IXi2VS3mmNUsVtHSB/7fiJG2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTNbpE11QHfxV6zxMrHoM7rNGx1HCLTrlNRrGa73FB1XdvuVfl9jjmqOBbhXZVkjk
	 5Y832ZqQ2QSm474I2Mzf8j8W7M9R/6JiDZv3uRfTAHy86O+cyox0GNVZYHnvXxnVb6
	 wmXAfwJxwev/k4BH5kI7maimhm1EoBeUAyIrIb7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/350] net: dpaa: Pad packets to ETH_ZLEN
Date: Wed,  6 Nov 2024 12:58:59 +0100
Message-ID: <20241106120321.150592375@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit cbd7ec083413c6a2e0c326d49e24ec7d12c7a9e0 ]

When sending packets under 60 bytes, up to three bytes of the buffer
following the data may be leaked. Avoid this by extending all packets to
ETH_ZLEN, ensuring nothing is leaked in the padding. This bug can be
reproduced by running

	$ ping -s 11 destination

Fixes: 9ad1a3749333 ("dpaa_eth: add support for DPAA Ethernet")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240910143144.1439910-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2055,12 +2055,12 @@ static netdev_tx_t
 dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 {
 	const int queue_mapping = skb_get_queue_mapping(skb);
-	bool nonlinear = skb_is_nonlinear(skb);
 	struct rtnl_link_stats64 *percpu_stats;
 	struct dpaa_percpu_priv *percpu_priv;
 	struct netdev_queue *txq;
 	struct dpaa_priv *priv;
 	struct qm_fd fd;
+	bool nonlinear;
 	int offset = 0;
 	int err = 0;
 
@@ -2070,6 +2070,13 @@ dpaa_start_xmit(struct sk_buff *skb, str
 
 	qm_fd_clear_fd(&fd);
 
+	/* Packet data is always read as 32-bit words, so zero out any part of
+	 * the skb which might be sent if we have to pad the packet
+	 */
+	if (__skb_put_padto(skb, ETH_ZLEN, false))
+		goto enomem;
+
+	nonlinear = skb_is_nonlinear(skb);
 	if (!nonlinear) {
 		/* We're going to store the skb backpointer at the beginning
 		 * of the data buffer, so we need a privately owned skb


