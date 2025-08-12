Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1712F5338;
	Tue, 12 Aug 2025 18:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025030; cv=none; b=WEC6guddnUqAVzlBA3s+/mpKq8QOf6Nak6I9v7YCVzcjgMAJAqnuRBEAIuUKf8L6JJb3g/RsM1f7aMs5o7FtzySYQxqzmJJr2X59UYue2hvuxIuOd8OrlKRXTCVHGX1mx1FcMHG1qNRYrvh6JBVQQQpPohd5h1gSNIJwV/SmLsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025030; c=relaxed/simple;
	bh=6ef6iS8NzBV1nU9pQL1ziKP4eQz9iuEkzsn9+jWX9GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnHcN2G8nnqjhUUyqabtZxNw7bbeuRBbBDMQ1oMJTZ9OpV7RluxlTkmrhdCYHI11rCZs/7uogp73vz1iQ1b2IofvKN7Sv6dAvAKskhmuHMoTHS8rm8TRc+XK/FWJ+J94Df6v4AiKTDie5di6JfWun1OpYvH5OvyTlyfJQE3OdfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyUuD6Uk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyUuD6Uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E074C4CEF0;
	Tue, 12 Aug 2025 18:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025030;
	bh=6ef6iS8NzBV1nU9pQL1ziKP4eQz9iuEkzsn9+jWX9GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyUuD6Uk0m9T9FFCQZt36LTfnl8bLmf5bW4+7YGtLA/OK6XIPjSRS5jGgo/PCAe/X
	 dSUwUPDWghSDpiFWWALgNVZirFJK2eOt+afYddLruXMkjOG9ztQHkgygLbyYJOkPIY
	 hVXekgyJdKypdMzS27/hEXVR6yOWEiWORC9WMyQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 549/627] eth: fbnic: Fix tx_dropped reporting
Date: Tue, 12 Aug 2025 19:34:04 +0200
Message-ID: <20250812173452.793079313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohsin Bashir <mohsin.bashr@gmail.com>

[ Upstream commit 2972395d8fad7f4efc8555348f2f988d4941d797 ]

Correctly copy the tx_dropped stats from the fbd->hw_stats to the
rtnl_link_stats64 struct.

Fixes: 5f8bd2ce8269 ("eth: fbnic: add support for TMI stats")
Signed-off-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250802024636.679317-2-mohsin.bashr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 93717cf5bd8f..76c0167319af 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -422,16 +422,16 @@ static void fbnic_get_stats64(struct net_device *dev,
 	tx_packets = stats->packets;
 	tx_dropped = stats->dropped;
 
-	stats64->tx_bytes = tx_bytes;
-	stats64->tx_packets = tx_packets;
-	stats64->tx_dropped = tx_dropped;
-
 	/* Record drops from Tx HW Datapath */
 	tx_dropped += fbd->hw_stats.tmi.drop.frames.value +
 		      fbd->hw_stats.tti.cm_drop.frames.value +
 		      fbd->hw_stats.tti.frame_drop.frames.value +
 		      fbd->hw_stats.tti.tbi_drop.frames.value;
 
+	stats64->tx_bytes = tx_bytes;
+	stats64->tx_packets = tx_packets;
+	stats64->tx_dropped = tx_dropped;
+
 	for (i = 0; i < fbn->num_tx_queues; i++) {
 		struct fbnic_ring *txr = fbn->tx[i];
 
-- 
2.39.5



