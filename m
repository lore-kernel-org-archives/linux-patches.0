Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6E717BB14;
	Wed,  3 Jul 2024 11:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006007; cv=none; b=kv4WKPaQdvm6xWqI/ezsr9KBV1AFpZn7dnrhvY8kOHJ4l0kksqYtc8gZkyb6T8QjgzFOQBJOJhD5ZEXyf3LFTfxprVEOq0D4o+D8KR4ccWi1DO3snBZKMEvwJRwDyrZSkp3CDuw8chCtQBV8vKUN6f/ASWx7iVKVO5NLpXmIryc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006007; c=relaxed/simple;
	bh=+LTaelwGgaK3qXUKXIGffmalOdR/q3mGUuplbHMQZcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYxNd3wh+fzVTEXvDs7xiZDpQU9mA7NtijMnM8nwhzq2B9trOz4LVaDdYdvsuf0J5YNgzbuzEUL7ki3SvmFIlHWkXEtacNB80hTeCoogxRVmtkljsr1HrgsIdJMaDJYHsmG2OL3ktAWyk/TCc02hSkkCXD9Z6PmHtQK8eboGxzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+ksss5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+ksss5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2763C2BD10;
	Wed,  3 Jul 2024 11:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006007;
	bh=+LTaelwGgaK3qXUKXIGffmalOdR/q3mGUuplbHMQZcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+ksss5iOKh5HSrcdbVVcafDJ4pQotUYkNquAhIn+Ieuw8+TzYKwmnTY7If+L8xEJ
	 UWj5bBo+gqqrjOHzPfDVyteHjeT0P07QJVVVSIvGHO4Kg3Q4omBG1HPjVRjl+4sG6x
	 PLGITIS+UXeEFhl/LHsySrm35fBotFqBVbG1jGbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/356] net: stmmac: Assign configured channel value to EXTTS event
Date: Wed,  3 Jul 2024 12:40:05 +0200
Message-ID: <20240703102923.292323432@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 8851346912a1fa33e7a5966fe51f07313b274627 ]

Assign the configured channel value to the EXTTS event in the timestamp
interrupt handler. Without assigning the correct channel, applications
like ts2phc will refuse to accept the event, resulting in errors such
as:
...
ts2phc[656.834]: config item end1.ts2phc.pin_index is 0
ts2phc[656.834]: config item end1.ts2phc.channel is 3
ts2phc[656.834]: config item end1.ts2phc.extts_polarity is 2
ts2phc[656.834]: config item end1.ts2phc.extts_correction is 0
...
ts2phc[656.862]: extts on unexpected channel
ts2phc[658.141]: extts on unexpected channel
ts2phc[659.140]: extts on unexpected channel

Fixes: f4da56529da60 ("net: stmmac: Add support for external trigger timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://lore.kernel.org/r/20240618073821.619751-1-o.rempel@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 2c6245b2281ca..0d3d7874f0fc6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -176,6 +176,7 @@ static void timestamp_interrupt(struct stmmac_priv *priv)
 {
 	u32 num_snapshot, ts_status, tsync_int;
 	struct ptp_clock_event event;
+	u32 acr_value, channel;
 	unsigned long flags;
 	u64 ptp_time;
 	int i;
@@ -201,12 +202,15 @@ static void timestamp_interrupt(struct stmmac_priv *priv)
 	num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
 		       GMAC_TIMESTAMP_ATSNS_SHIFT;
 
+	acr_value = readl(priv->ptpaddr + PTP_ACR);
+	channel = ilog2(FIELD_GET(PTP_ACR_MASK, acr_value));
+
 	for (i = 0; i < num_snapshot; i++) {
 		spin_lock_irqsave(&priv->ptp_lock, flags);
 		get_ptptime(priv->ptpaddr, &ptp_time);
 		spin_unlock_irqrestore(&priv->ptp_lock, flags);
 		event.type = PTP_CLOCK_EXTTS;
-		event.index = 0;
+		event.index = channel;
 		event.timestamp = ptp_time;
 		ptp_clock_event(priv->ptp_clock, &event);
 	}
-- 
2.43.0



