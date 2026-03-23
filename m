Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F146C23815B;
	Mon, 23 Mar 2026 14:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277293; cv=none; b=O+gXPu2Omq/vsfoT9cyPWmT/Op0jFbg6ymhMaI8ZcjdC/emXuH16T1gA08V/uECjo5RElnnonCQYmfT0e6+z7s70bMj/7tEz7sYWgiEWswghVA7dXZuJGrHH9Lim++rARgfyUgBuse7Rl3m/hn/AiizPenUp9snR7eRz9SjM6HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277293; c=relaxed/simple;
	bh=8ByRVCOW6jfsyAHqzrPO6ifukAFpV9DBCk0qVrQ81+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0pY7XeZ2Rr60FpfYrIs4wxji7Ez3HjCyc7kz0XDir1kRxOMf49cTLUwXjfMWezUWx4CuiIRjHQGp6KnsjEtshUw0fyFXv+WcDDCzDVxKkoE5mvnjddoj/zrpOs9SNVQjbqMP0LOUlZCW4vKNsK1YXyxnVOE5MTYYvqQ/8D01OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xyj2dFls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xyj2dFls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CF4C4CEF7;
	Mon, 23 Mar 2026 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277292;
	bh=8ByRVCOW6jfsyAHqzrPO6ifukAFpV9DBCk0qVrQ81+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xyj2dFlsuHuS3+YAYIyWly8ifYI0TuYVDNoJe/npNtbmzpav0ipSZgUuNipEmdmWW
	 j/9OdlUyphSK+h8zyMYBbxTVXvoQ91EGZ27wnTO/NRLsjDiFAL4tqy9sFawJ2uYjUT
	 d/VDM8+Dhl5ie3umOW20NCz2ux7FUzWSnFUtkOZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/460] net: macb: Introduce gem_init_rx_ring()
Date: Mon, 23 Mar 2026 14:45:28 +0100
Message-ID: <20260323134534.683683678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 1a7124ecd655bcaf1845197fe416aa25cff4c3ea ]

Extract the initialization code for the GEM RX ring into a new function.
This change will be utilized in a subsequent patch. No functional changes
are introduced.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260312-macb-versal-v1-1-467647173fa4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 718d0766ce4c ("net: macb: Reinitialize tx/rx queue pointer registers and rx ring during resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2700,6 +2700,14 @@ static void macb_init_tieoff(struct macb
 	desc->ctrl = 0;
 }
 
+static void gem_init_rx_ring(struct macb_queue *queue)
+{
+	queue->rx_tail = 0;
+	queue->rx_prepared_head = 0;
+
+	gem_rx_refill(queue);
+}
+
 static void gem_init_rings(struct macb *bp)
 {
 	struct macb_queue *queue;
@@ -2717,10 +2725,7 @@ static void gem_init_rings(struct macb *
 		queue->tx_head = 0;
 		queue->tx_tail = 0;
 
-		queue->rx_tail = 0;
-		queue->rx_prepared_head = 0;
-
-		gem_rx_refill(queue);
+		gem_init_rx_ring(queue);
 	}
 
 	macb_init_tieoff(bp);


