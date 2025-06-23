Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BB022069F;
	Mon, 23 Jun 2025 21:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713148; cv=none; b=d8gbNTyCXBe26/D3BVNc/mTw6/HFE0PmJ/rJxJJn3uFZ9v7WzenGCtDJ5WCT2AsFI0t9XCukIjGJGMf9aZ9YGyNlEnyTCZU1Lppuw2M443UT3WwiRlUnLtJhbwoRZTbmbD5GLSFwOPH4hmTqdasnm3DWoQ+YpdjNjQIUIdKOL6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713148; c=relaxed/simple;
	bh=r+o1Szn3kgey/hq0VACsNrROugEzwIH1ngYXRpiuDk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTjtpxg0CSnQDGCyapb1qIRiWxjAE0EJbshcmy5Wpah585yNYyweve5mugdrfjGjodtg6PYMZIdfebpYrpzYVXyoUWQ9egQyWjYriDHzwEdeTs/ROSx5JXEnvob1GAupA17jU8WiQwkQVrU8NLBkUFxT2D5JbW4H0kgpsKpAqe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNzKrC4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNzKrC4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50CCC4CEEA;
	Mon, 23 Jun 2025 21:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713148;
	bh=r+o1Szn3kgey/hq0VACsNrROugEzwIH1ngYXRpiuDk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNzKrC4fOPmjDzP4ASChsoz6GhgCN4OWsc1c3ALGQ5YRSh4poC0VSpDs6GBU0izBQ
	 u9bxTUYwVsgC/Jsor6vzO/X+EAYElDCxtU2eEC2kWAMlSloj98NL79ig2b+/5+hHo1
	 DGkXKok7m6MReUfV3m4pUO5S749Fwd2/YHNpkhXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/508] net: phy: mscc: Fix memory leak when using one step timestamping
Date: Mon, 23 Jun 2025 15:02:25 +0200
Message-ID: <20250623130647.736316801@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 846992645b25ec4253167e3f931e4597eb84af56 ]

Fix memory leak when running one-step timestamping. When running
one-step sync timestamping, the HW is configured to insert the TX time
into the frame, so there is no reason to keep the skb anymore. As in
this case the HW will never generate an interrupt to say that the frame
was timestamped, then the frame will never released.
Fix this by freeing the frame in case of one-step timestamping.

Fixes: 7d272e63e0979d ("net: phy: mscc: timestamping and PHC support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20250522115722.2827199-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_ptp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index cf728bfd83e22..af44b01f3d383 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1165,18 +1165,24 @@ static void vsc85xx_txtstamp(struct mii_timestamper *mii_ts,
 		container_of(mii_ts, struct vsc8531_private, mii_ts);
 
 	if (!vsc8531->ptp->configured)
-		return;
+		goto out;
 
-	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_OFF) {
-		kfree_skb(skb);
-		return;
-	}
+	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_OFF)
+		goto out;
+
+	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_ONESTEP_SYNC)
+		if (ptp_msg_is_sync(skb, type))
+			goto out;
 
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 	mutex_lock(&vsc8531->ts_lock);
 	__skb_queue_tail(&vsc8531->ptp->tx_queue, skb);
 	mutex_unlock(&vsc8531->ts_lock);
+	return;
+
+out:
+	kfree_skb(skb);
 }
 
 static bool vsc85xx_rxtstamp(struct mii_timestamper *mii_ts,
-- 
2.39.5



