Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFFB3AE19E;
	Mon, 23 Mar 2026 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282999; cv=none; b=P4uikOUMFdcOb8HQbSy01rFhuZAQ+tm5QzOg8qQCqNKehI07ZTFKFOSYA9KqbXFRpTk50h1VNZfv5bxT67lBB3KWw47toMc9dYRmwym7RHd/d7PnEZfh+Zx+LIZMVHalyZ/w24xHBySXdazlZrJ9sC5j/sh4FUyfv0uAOAM76Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282999; c=relaxed/simple;
	bh=GBomFcJv83VUfWNyJvC+dUWl15Q1HvrGyI3gf7wM6P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXcd8jVEm0yD8hU4XeNg+9JTUZTyUM5R3flogQhg46i14fM0diyDYdSZKDmvWILkLm72/UJ9ohbTeIkHc1aw7w2jIMAA+Z5DLmmoiww8o5bd1vOWoy7WCuq8JabkmsyWFTFcMAGX/YL9OG3oST5pc4lW9kRFU/h9ldGMfw8yX6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFtc8zs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFtc8zs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7868C4CEF7;
	Mon, 23 Mar 2026 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282999;
	bh=GBomFcJv83VUfWNyJvC+dUWl15Q1HvrGyI3gf7wM6P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFtc8zs9HR1+N4ct9FMyNd4MFOvfibO5sSQt90XOGKq3+U5m03YziZbF44+bS3l4I
	 Yd3HRAzqxgwylL0lRxzhAaA2Gvm+T082RCck2HzHLbVdZnCeuu1UQnajBmMa6PdDpl
	 vHD+wEMySTtedCdOyhbjawbZvlvRXym194O6pE/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanyang Wang <quanyang.wang@windriver.com>,
	Kevin Hao <haokexin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 363/481] net: macb: Reinitialize tx/rx queue pointer registers and rx ring during resume
Date: Mon, 23 Mar 2026 14:45:45 +0100
Message-ID: <20260323134533.958613869@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 718d0766ce4c7634ce62fa78b526ea7263487edd ]

On certain platforms, such as AMD Versal boards, the tx/rx queue pointer
registers are cleared after suspend, and the rx queue pointer register
is also disabled during suspend if WOL is enabled. Previously, we assumed
that these registers would be restored by macb_mac_link_up(). However,
in commit bf9cf80cab81, macb_init_buffers() was moved from
macb_mac_link_up() to macb_open(). Therefore, we should call
macb_init_buffers() to reinitialize the tx/rx queue pointer registers
during resume.

Due to the reset of these two registers, we also need to adjust the
tx/rx rings accordingly. The tx ring will be handled by
gem_shuffle_tx_rings() in macb_mac_link_up(), so we only need to
initialize the rx ring here.

Fixes: bf9cf80cab81 ("net: macb: Fix tx/rx malfunction after phy link down and up")
Reported-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Tested-by: Quanyang Wang <quanyang.wang@windriver.com>
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260312-macb-versal-v1-2-467647173fa4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5386,8 +5386,18 @@ static int __maybe_unused macb_resume(st
 		rtnl_unlock();
 	}
 
+	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC))
+		macb_init_buffers(bp);
+
 	for (q = 0, queue = bp->queues; q < bp->num_queues;
 	     ++q, ++queue) {
+		if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC)) {
+			if (macb_is_gem(bp))
+				gem_init_rx_ring(queue);
+			else
+				macb_init_rx_ring(queue);
+		}
+
 		napi_enable(&queue->napi_rx);
 		napi_enable(&queue->napi_tx);
 	}


