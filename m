Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9344F18E04F;
	Mon, 28 Oct 2024 06:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097577; cv=none; b=srKTr8v5PkVY0cArnef/NfJ/nLBAOzoyS6qTS9anzR8y3ltBH5Lgsy7fmltyAntMGJI795evnWNFU50TWpJUO3SFqF9wWHB+p25CSHINbSMp/CyuEJhVlZ8EW6rdfqvkwtlOmUxpZdAi6c/f4AUKzTHO3cG99jcHMbz033JcHpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097577; c=relaxed/simple;
	bh=WIfYuyTNXfGaON5JsAPkMLRUaGatOh1+lSXJoBaRCOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs7/n8HpiMq1z/39mlxkbNkT6h9o1ExeEHQp2io4dHs7ZGTzEqAQNu6fyeYxB9iqic9dHT3ZbcaGkk9jqQKlWZwpDja6HCdzZnu/IXtkhX+BASg53zzdLVTuI4D5xnNclEKYz2nAGYKLH+B8JS0Ee003nKxDy5wanZ4LBxA2XPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbfkiJXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbfkiJXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA17C4CEC3;
	Mon, 28 Oct 2024 06:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097577;
	bh=WIfYuyTNXfGaON5JsAPkMLRUaGatOh1+lSXJoBaRCOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbfkiJXRUh7qkcCpbrcxyPa3WNwJQoJ2CYioNmF19Nb0O390zpja06egATxfubED4
	 Ky7lOP0bjmOzAXdivsTf4Q4a5cEWfwiQvVLxwFNPxOc5i1TZRgDb0B2LwI1KsrTGlu
	 3l7raNlzIRvzkWtGBXl3nIgjb3HsttzhYV6g+R4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/208] macsec: dont increment counters for an unrelated SA
Date: Mon, 28 Oct 2024 07:23:53 +0100
Message-ID: <20241028062307.962782550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit cf58aefb1332db322060cad4a330d5f9292b0f41 ]

On RX, we shouldn't be incrementing the stats for an arbitrary SA in
case the actual SA hasn't been set up. Those counters are intended to
track packets for their respective AN when the SA isn't currently
configured. Due to the way MACsec is implemented, we don't keep
counters unless the SA is configured, so we can't track those packets,
and those counters will remain at 0.

The RXSC's stats keeps track of those packets without telling us which
AN they belonged to. We could add counters for non-existent SAs, and
then find a way to integrate them in the dump to userspace, but I
don't think it's worth the effort.

Fixes: 91ec9bd57f35 ("macsec: Fix traffic counters/statistics")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/f5ac92aaa5b89343232615f4c03f9f95042c6aa0.1728657709.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 778fb77c5a937..2ada8baf815b1 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -151,19 +151,6 @@ static struct macsec_rx_sa *macsec_rxsa_get(struct macsec_rx_sa __rcu *ptr)
 	return sa;
 }
 
-static struct macsec_rx_sa *macsec_active_rxsa_get(struct macsec_rx_sc *rx_sc)
-{
-	struct macsec_rx_sa *sa = NULL;
-	int an;
-
-	for (an = 0; an < MACSEC_NUM_AN; an++)	{
-		sa = macsec_rxsa_get(rx_sc->sa[an]);
-		if (sa)
-			break;
-	}
-	return sa;
-}
-
 static void free_rx_sc_rcu(struct rcu_head *head)
 {
 	struct macsec_rx_sc *rx_sc = container_of(head, struct macsec_rx_sc, rcu_head);
@@ -1205,15 +1192,12 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		/* If validateFrames is Strict or the C bit in the
 		 * SecTAG is set, discard
 		 */
-		struct macsec_rx_sa *active_rx_sa = macsec_active_rxsa_get(rx_sc);
 		if (hdr->tci_an & MACSEC_TCI_C ||
 		    secy->validate_frames == MACSEC_VALIDATE_STRICT) {
 			u64_stats_update_begin(&rxsc_stats->syncp);
 			rxsc_stats->stats.InPktsNotUsingSA++;
 			u64_stats_update_end(&rxsc_stats->syncp);
 			DEV_STATS_INC(secy->netdev, rx_errors);
-			if (active_rx_sa)
-				this_cpu_inc(active_rx_sa->stats->InPktsNotUsingSA);
 			goto drop_nosa;
 		}
 
@@ -1223,8 +1207,6 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		u64_stats_update_begin(&rxsc_stats->syncp);
 		rxsc_stats->stats.InPktsUnusedSA++;
 		u64_stats_update_end(&rxsc_stats->syncp);
-		if (active_rx_sa)
-			this_cpu_inc(active_rx_sa->stats->InPktsUnusedSA);
 		goto deliver;
 	}
 
-- 
2.43.0



