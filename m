Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD75F223339;
	Mon, 23 Jun 2025 21:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714368; cv=none; b=d5ER+HhZlwz90EEu0XwbeT3SmUq9UPFgiNvHJt9m1dHusYcqXK4a25PLs3v4DJp+dXkDmcZT6mtzgLljWGQQ6z/oeb/LM+DVqo4RAQtGe5V5L6Gk8jxV42EU0rteg7ziaTSEcG+XUyxQpZrM2sdg/6aIZHsAM+kVB3fGl8SxsSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714368; c=relaxed/simple;
	bh=HFnuksIWM0uYZoLiKdBLJ2MqlRnLIYgvVnZ0CzS2+so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7DuziFr64XSjg2PDn+U+MIZ3E1720wgz15XDYe1NrLGZY8CncjJ+rN4YZmcWqLbpsBkj734sZT4MjJxE+wTgObG/v6VgW+wfxkebzsuvoRSDPAdPxZolD5agd52sjxloyLRSQx8+6Y37Il1QEbeoCw1lDyZPL+oldz5EeCs1P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGTUJVvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGTUJVvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B87C4CEEA;
	Mon, 23 Jun 2025 21:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714367;
	bh=HFnuksIWM0uYZoLiKdBLJ2MqlRnLIYgvVnZ0CzS2+so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGTUJVvvuKQOA4plQuEuissd/OF/e5h1FYgcJkiR7GyvfjVDQc7TTi2Hj1F7jSV0E
	 aZPv0dpvbjvnQKjOemaScvlp5vgvbuWUWadcA5pD7mrdy3H2RsGBlVftheWnkUctPI
	 v4nIHaVFBcLAEXvJxoCU6aNM3WODmiCPGdKyoNHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 386/592] netdevsim: Mark NAPI ID on skb in nsim_rcv
Date: Mon, 23 Jun 2025 15:05:44 +0200
Message-ID: <20250623130709.623661596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit f71c549b26a33fd62f1e9c7deeba738bfc73fbfc ]

Previously, nsim_rcv was not marking the NAPI ID on the skb, leading to
applications seeing a napi ID of 0 when using SO_INCOMING_NAPI_ID.

To add to the userland confusion, netlink appears to correctly report
the NAPI IDs for netdevsim queues but the resulting file descriptor from
a call to accept() was reporting a NAPI ID of 0.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20250424002746.16891-2-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 31a06e71be25b..b2a3518015372 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -29,6 +29,7 @@
 #include <net/pkt_cls.h>
 #include <net/rtnetlink.h>
 #include <net/udp_tunnel.h>
+#include <net/busy_poll.h>
 
 #include "netdevsim.h"
 
@@ -357,6 +358,7 @@ static int nsim_rcv(struct nsim_rq *rq, int budget)
 			break;
 
 		skb = skb_dequeue(&rq->skb_queue);
+		skb_mark_napi_id(skb, &rq->napi);
 		netif_receive_skb(skb);
 	}
 
-- 
2.39.5



