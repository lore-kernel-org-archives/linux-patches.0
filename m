Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB98149C58;
	Tue, 25 Jun 2024 09:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309212; cv=none; b=PM4170tuTv+84KaMfy/ng+IBlnmdrCf+RRLnpDA7WlGNsDLt03gcFxmZn1q/NqDpVfyvPBZkutdgqb6TuG6rn0VGgJig4I/VfJSfmikKF9ZtJcDJp40KP0vkellOdOhPXT/+pGpi8Jhj1auSt6hpdMfX3yE1W44cPvuVvBQRFpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309212; c=relaxed/simple;
	bh=KddNs2+n34UfvWcpCMzaMVXbCm/LY99N4IAVi0cE/Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Joqk1+mM0LIAlD3DzS5v3naZCWJa2XfA8+SIolFENCrWnfNBcXL5TqOHauq50eaoeOjk5DXfkfvlE6oDUvud/gWwtweJA1EXRntvwaN/e84Wxa2RFJ1oAqS+YR/m1MdByA5/4TBvENctHXkFu30XkQn9BzlhRjHmTkOWJyAi/nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUX6ocuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUX6ocuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40429C32781;
	Tue, 25 Jun 2024 09:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309212;
	bh=KddNs2+n34UfvWcpCMzaMVXbCm/LY99N4IAVi0cE/Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUX6ocuWZbn45kiorkb0NziEyzdlQ19tOYoqtw7QWoiKAxmZsp4sDCIaW5O6qV95T
	 hKubpYFfRTS7S4dc150WT489fIcX/mQ0LJLBl5myToJHdJCQPWkew1sZioUBuGTIeQ
	 v6mqTtTJoyBFwJDoQYUyIcY/waUrlkdJiLtbcAig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 133/192] net: stmmac: Assign configured channel value to EXTTS event
Date: Tue, 25 Jun 2024 11:33:25 +0200
Message-ID: <20240625085542.264481645@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 8851346912a1fa33e7a5966fe51f07313b274627 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -218,6 +218,7 @@ static void timestamp_interrupt(struct s
 {
 	u32 num_snapshot, ts_status, tsync_int;
 	struct ptp_clock_event event;
+	u32 acr_value, channel;
 	unsigned long flags;
 	u64 ptp_time;
 	int i;
@@ -243,12 +244,15 @@ static void timestamp_interrupt(struct s
 	num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
 		       GMAC_TIMESTAMP_ATSNS_SHIFT;
 
+	acr_value = readl(priv->ptpaddr + PTP_ACR);
+	channel = ilog2(FIELD_GET(PTP_ACR_MASK, acr_value));
+
 	for (i = 0; i < num_snapshot; i++) {
 		read_lock_irqsave(&priv->ptp_lock, flags);
 		get_ptptime(priv->ptpaddr, &ptp_time);
 		read_unlock_irqrestore(&priv->ptp_lock, flags);
 		event.type = PTP_CLOCK_EXTTS;
-		event.index = 0;
+		event.index = channel;
 		event.timestamp = ptp_time;
 		ptp_clock_event(priv->ptp_clock, &event);
 	}


