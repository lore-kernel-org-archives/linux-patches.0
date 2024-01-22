Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4DE1860;
	Tue, 23 Jan 2024 02:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975767; cv=none; b=WFTrtRcoSqxmV/Csl42XWiRJNN09gcnrJaB/+5YbmKt0K54Cw8OobwjpjpYBXW4EiXD7e0gw/dkKMZhvQnBoEKey5CmNmplXBotfOG0Zpnmyqf87Fus8DX2ZWvQC7tlPeTr760TNmBY/x8uNB00u5fo/61fZzHcLtH75P4XofxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975767; c=relaxed/simple;
	bh=R6inlNBydfZLUD+LAf5y9cfKezPFtrRtWzNKqAPs57w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4S1+/RpqGyXEe8n8Ijq9wCxtnsRQl0wYIJZOprL6vqM+BMbUYoIrGZ8vaAFYqKSbytR1YGgqjqx21CafpMmJfR2ck1Lit2/lf8+RuBvVsoY3/c35V7KvX60IhWXZc6Y8+YsqLqnwO4m4zYDstcn7h+z8Ph/4Pt9j3wPLYQsnSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgMo2xUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgMo2xUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4373C433C7;
	Tue, 23 Jan 2024 02:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975766;
	bh=R6inlNBydfZLUD+LAf5y9cfKezPFtrRtWzNKqAPs57w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgMo2xUWglS6eoC9/ouHGCdAmTEUoFdo8WHCl/TPqa6tLKJtdZdsclRXlIepHzcho
	 aEZwpgy3Ue6fU0Ic9aYd3iuSZRx/VE6LwAwfgB6dQfxNVDVxB4odpa7brJBbvP8gW/
	 lO0iU86Uxqmfsitc7INJXnxcz53frquCzsM+FdrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 543/583] net: netdev_queue: netdev_txq_completed_mb(): fix wake condition
Date: Mon, 22 Jan 2024 15:59:54 -0800
Message-ID: <20240122235828.745464491@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 894d7508316e7ad722df597d68b4b1797a9eee11 ]

netif_txq_try_stop() uses "get_desc >= start_thrs" as the check for
the call to netif_tx_start_queue().

Use ">=" i netdev_txq_completed_mb(), too.

Fixes: c91c46de6bbc ("net: provide macros for commonly copied lockless queue stop/wake code")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netdev_queues.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index d68b0a483431..8b8ed4e13d74 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -128,7 +128,7 @@ netdev_txq_completed_mb(struct netdev_queue *dev_queue,
 		netdev_txq_completed_mb(txq, pkts, bytes);		\
 									\
 		_res = -1;						\
-		if (pkts && likely(get_desc > start_thrs)) {		\
+		if (pkts && likely(get_desc >= start_thrs)) {		\
 			_res = 1;					\
 			if (unlikely(netif_tx_queue_stopped(txq)) &&	\
 			    !(down_cond)) {				\
-- 
2.43.0



