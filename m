Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC9436C0C1;
	Wed,  3 Dec 2025 16:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780363; cv=none; b=Rk6OK3Za7+mWPezjxh94pCWr0KyWiG+Sn2FvTKOMbNRSUp4xKcY2j12bVxYwwDd4fkGkb1WJOqUmvKjDOJzJeAHTTALn/BNeZ6LRGHWbyPRScLOIOUXU9OBv9PaOah9t8hqLB0EkDHH9BuBvrbi7fMUmYTIuF9nWTHv7fNm3Zio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780363; c=relaxed/simple;
	bh=Rl0PrUreyVvIHp2JdWApMeIVIcM4xLYMDj3nXbYVCKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2+qw8I+D5jHR19sJ+kQOqHzGQP3jpdk7LOxIfAxIzKXhdFMXTz+aeghEBdlb6J/1x7CZIKwlj4vHaoWsI5t2alUqPEehIwM0/1DdCMkQBhLzf5Lok4nXKvhDIrS9Qc6lcsaYvs5Bgf12W1+8ZLYxJKq8+Rd+tpDs00zZYAJkyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1cqq6rG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1cqq6rG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF8AC4CEF5;
	Wed,  3 Dec 2025 16:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780363;
	bh=Rl0PrUreyVvIHp2JdWApMeIVIcM4xLYMDj3nXbYVCKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1cqq6rGqCh28YhmhTwi01onxxltt1q2uOK/B2clBUqR8csCFpSRVFNx3pNd5nt/k
	 6Rzf8ltG3gOQvNzY7+jyYPTMJUEYulKai+dfHx/4fvVFOsRmwE1UzNv7mY/K/izEM6
	 r+u86H+DAW7oXT9N1QWRbOes9bT5uDpcH4286KhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 501/568] net: sxgbe: fix potential NULL dereference in sxgbe_rx()
Date: Wed,  3 Dec 2025 16:28:23 +0100
Message-ID: <20251203152459.063528986@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit f5bce28f6b9125502abec4a67d68eabcd24b3b17 ]

Currently, when skb is null, the driver prints an error and then
dereferences skb on the next line.

To fix this, let's add a 'break' after the error message to switch
to sxgbe_rx_refill(), which is similar to the approach taken by the
other drivers in this particular case, e.g. calxeda with xgmac_rx().

Found during a code review.

Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251121123834.97748-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 9664f029fa161..f6f99712d562e 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1521,8 +1521,10 @@ static int sxgbe_rx(struct sxgbe_priv_data *priv, int limit)
 
 		skb = priv->rxq[qnum]->rx_skbuff[entry];
 
-		if (unlikely(!skb))
+		if (unlikely(!skb)) {
 			netdev_err(priv->dev, "rx descriptor is not consistent\n");
+			break;
+		}
 
 		prefetch(skb->data - NET_IP_ALIGN);
 		priv->rxq[qnum]->rx_skbuff[entry] = NULL;
-- 
2.51.0



