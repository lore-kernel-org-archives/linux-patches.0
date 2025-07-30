Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8839F167DB7;
	Wed, 30 Jul 2025 09:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868260; cv=none; b=Ml2n/siV4GyCbb1zMpxM02wzMoVe3NdB3OfX9ErVL6eLxQpFFeZbBKs2MohrSdCuJZBCUtLwWDtsWXuk2sTgP8JvkerI4Ur870vey7ulbkbxyBeO8rsqGU4fXr/6Q+NLrOTNi1or4CA5JY+X58FtqFv49Tn821/TOZ5/kK1PCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868260; c=relaxed/simple;
	bh=0kIXy6req8TWhuL4Yh7b29cjenbs4oRuZIbwUQvIR7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdVsVrNsiSQdfl6cb/04LvbVENFgI0rzbNt39/uSCq+cnoS3RkrNhlZDzxYJykWuCJxawKDe9Ub03fFngY2EA5uNNOdePzYXywxBu9QFaNigXrZ6FCc8GSoo6H2EE+GMR6q8kaPPe4s/IJnxUp2h1+4hP3LuQ8pjZvvFbv0+N0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIB0UBMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIB0UBMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67995C4CEE7;
	Wed, 30 Jul 2025 09:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868257;
	bh=0kIXy6req8TWhuL4Yh7b29cjenbs4oRuZIbwUQvIR7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIB0UBMedRGCNpfMGIe2NDuRG2orBy703eJ9K2ytlIfzzG7MzFTAoyNpzIGmU6FFn
	 cRgcgzhltv9J74lEtusQj2j275qHDG/fI1i9S1ipBr+do8ZVnkw71/XYEwxSozi7fg
	 ixMyKue9D4guYbc7msk9mCOFZmMPIE1iAe+L39O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 19/76] can: dev: can_restart(): reverse logic to remove need for goto
Date: Wed, 30 Jul 2025 11:35:12 +0200
Message-ID: <20250730093227.595051060@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 8f3ec204d340af183fb2bb21b8e797ac2ed012b2 ]

Reverse the logic in the if statement and eliminate the need for a
goto to simplify code readability.

Link: https://lore.kernel.org/all/20231005-can-dev-fix-can-restart-v2-3-91b5c1fd922c@pengutronix.de
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: c1f3f9797c1f ("can: netlink: can_changelink(): fix NULL pointer deref of struct can_priv::do_set_mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 7d9a7c92d4cf6..6c1ceb8ce6c4b 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -142,14 +142,11 @@ static void can_restart(struct net_device *dev)
 
 	/* send restart message upstream */
 	skb = alloc_can_err_skb(dev, &cf);
-	if (!skb)
-		goto restart;
-
-	cf->can_id |= CAN_ERR_RESTARTED;
-
-	netif_rx(skb);
+	if (skb) {
+		cf->can_id |= CAN_ERR_RESTARTED;
+		netif_rx(skb);
+	}
 
-restart:
 	netdev_dbg(dev, "restarted\n");
 	priv->can_stats.restarts++;
 
-- 
2.39.5



