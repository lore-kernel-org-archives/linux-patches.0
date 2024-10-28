Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FF218CC1F;
	Mon, 28 Oct 2024 06:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096859; cv=none; b=k8hMwJ/iCd7MwBBNjYfbs9DS6aDzYL+ebRbY43drEHnmFJtDi3RC44ZyMtxtKcmNInL8FD4a7sDgT985hKytGdsjuyuDVs4Pgwx56srl4no+jVD6Hr4GlB++4kkWcHipJEqPq0AhXxo3XvkwFE0BNkcgy5V6jh7Vui1zCFgN5n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096859; c=relaxed/simple;
	bh=F0e148qrELx/aGs77fFTLtuvDEndNm34Ji2p6OSWv4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1W92UaMegQQ8AbY0P+c3X1rLJMit3wdrqMumgcUANpSYHL8PbVnjZphBR91ql4Fv1N/eGcmX6zA3AgpLOyFYhqselqMlWqL83Rb46WNEekGHnhJ1CPNY7tXYWsBXURkRwVLUeWGeon/XWVxiGik4MIS0ZvEfFZdS31poTeqImA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ld8D0GTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ld8D0GTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EE1C4CEC3;
	Mon, 28 Oct 2024 06:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096858;
	bh=F0e148qrELx/aGs77fFTLtuvDEndNm34Ji2p6OSWv4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ld8D0GTgXQkjiKi642DKMCk7sbZGASG6RBJ+97gaSIxwk0FOyaac7J59jWTRaBqwu
	 ps5+xc+0NXA/17Ci/YUrP3q8tUmBoEmgPLyRYFa8/K4oS15GLZj/4P+EHQpsI44J6K
	 ai3BTUyW3KOaZWqpt3+lRwju9tVCdYzO54KQXkoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/80] macsec: dont increment counters for an unrelated SA
Date: Mon, 28 Oct 2024 07:24:58 +0100
Message-ID: <20241028062253.127949267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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
index ab134fe1fda62..a91c409958ff2 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -160,19 +160,6 @@ static struct macsec_rx_sa *macsec_rxsa_get(struct macsec_rx_sa __rcu *ptr)
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
@@ -1192,15 +1179,12 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
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
 
@@ -1210,8 +1194,6 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		u64_stats_update_begin(&rxsc_stats->syncp);
 		rxsc_stats->stats.InPktsUnusedSA++;
 		u64_stats_update_end(&rxsc_stats->syncp);
-		if (active_rx_sa)
-			this_cpu_inc(active_rx_sa->stats->InPktsUnusedSA);
 		goto deliver;
 	}
 
-- 
2.43.0



