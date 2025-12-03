Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417A530F925;
	Wed,  3 Dec 2025 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776697; cv=none; b=QzA1kAQk8V2WQm0VKiy4b1gl/lDVJPqPAFfXmSm26u/XBEJq9HKBWLJn4jhHrWbFFzkAdJ6SVy8HWFXmHOficJHJ7+H5SZBA56aXBV8uUG2w3YSCx0ORDYm8p0cq0FABhw1wzuaiyfZ5ZELUbWzDeWHcejbpdfmFdRN0rLzjR3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776697; c=relaxed/simple;
	bh=xm1RsrV5yGIWhYMexIc1/mef/biGtuCEOrDslIIW7ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p18p9mHl9m3lsOCMedPy08yoFEx3T/YG8euOxiR4Z6dOCMnOdSXXGqBZUdh8RX5ODv8hspIuRS13/k53AdCo7dcr1G10wv8UsMoL0eR0yql1709/unuqnKyl5lV5fczV3wKpBXREosbZUjAP7/at0U2LBGtZhO7cBT0SMCOEm2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSBDW/fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSBDW/fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D30C4CEF5;
	Wed,  3 Dec 2025 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776697;
	bh=xm1RsrV5yGIWhYMexIc1/mef/biGtuCEOrDslIIW7ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSBDW/fiAgxZAEQcnBt0F9oAKJqMrvYaF/Qag9Y4G2Z9yjcytD4zUWNLxvhHVNXFz
	 XWUkVdAoaWrAs/Jyt4jHsHcLT8uICqInC2H4OVFEz3EWaUGMk4Goa1x1syDezvqfyo
	 +CGnglqJCozcMvqqFoPGZMd4ejw+lJfXnkzBUnI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/300] net: sxgbe: fix potential NULL dereference in sxgbe_rx()
Date: Wed,  3 Dec 2025 16:27:44 +0100
Message-ID: <20251203152410.270571402@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b1dd6189638b3..9c745d48f54b0 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1518,8 +1518,10 @@ static int sxgbe_rx(struct sxgbe_priv_data *priv, int limit)
 
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



