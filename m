Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7861D12EBEA;
	Tue, 25 Jun 2024 09:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308612; cv=none; b=WpS2Wb2q+Fl6uwvgPn9nip4bT7f/k1t7b1Wb7FkMh3zUwSgB3hdBDS28+coO6BVvqRaMBPi+uzhmPGEQ7nC3yFe1xhzbSelXL0KVKlB28P7r6SMhKwXxrlrGPsCPWfQs4vfFXb5UVFVw2WziPxXFUupI3E0ifurYAc2ovbnhMZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308612; c=relaxed/simple;
	bh=eMcZXUqlmsSqYoFz6BQcYObna51WyohFV8njDOmOgc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHuQxSYIiHOrrQKPEsGPOgw5KUSqWbDGX7Ye+LBjS1wIfKIYhmWJLWWESzZOahZaMhV75qGDmW02CBEGPo8TCSk051NfkozlSE7O/OPZigBbrveLu3wMsw8e3Y5i1psr4Vjk1zUMKKMAmXT8IyOVvIguxKSQx48exq+qcVStq9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywCivIHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywCivIHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18D9C32781;
	Tue, 25 Jun 2024 09:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308612;
	bh=eMcZXUqlmsSqYoFz6BQcYObna51WyohFV8njDOmOgc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywCivIHE48vo78QEI1wi+5kOw4bZfKD9GEkUAyOSecfZg5pNKnd1Yk9z7HYenw+UD
	 MMaMWXjheGslSC91S3d/wK3to7ACzMFHOl1sEsIfF8/teirm4lgUlBIJYemDJkZvFF
	 nEKrc28TiH8CLLCLh76sCKjcd82j8TsNWpJTAMWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.9 181/250] net: stmmac: Assign configured channel value to EXTTS event
Date: Tue, 25 Jun 2024 11:32:19 +0200
Message-ID: <20240625085554.998532988@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


