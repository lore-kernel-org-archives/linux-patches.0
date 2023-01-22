Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E2E2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1022EC433D2;
	Sun, 22 Jan 2023 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400973;
	bh=sHqqHcirly3vZgANDjlUIzbOjjHGPUFJzc2Hu5ZeVvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rj4UyyC4/1eo937aDHsYgRHBVvo/UBPEqs1RzRRg9GdrHKjzazCT8axEREX2fUOUX
	 Q/9xZ7vNquy97Ez6uREpwctXyqoNTs7UIWj1AT++jE9AWzXnULu+M06MJ+MAr8BbVt
	 u9ZnCbhZ8dC351t5Cl+4xll1MkLeHIcMHASlqUNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jouni Malinen <j@w1.fi>,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 034/193] wifi: mac80211: reset multiple BSSID options in stop_ap()
Date: Sun, 22 Jan 2023 16:02:43 +0100
Message-Id: <20230122150247.962817133@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aloka Dixit <quic_alokad@quicinc.com>

commit 0eb38842ada035d71bb06fb9116f26f24ee0f998 upstream.

Reset multiple BSSID options when all AP related configurations are
reset in ieee80211_stop_ap().

Stale values result in HWSIM test failures (e.g. p2p_group_cli_invalid),
if run after 'he_ap_ema'.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
Link: https://lore.kernel.org/r/20221221185616.11514-1-quic_alokad@quicinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -147,6 +147,7 @@ static int ieee80211_set_ap_mbssid_optio
 	link_conf->bssid_index = 0;
 	link_conf->nontransmitted = false;
 	link_conf->ema_ap = false;
+	link_conf->bssid_indicator = 0;
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP || !params.tx_wdev)
 		return -EINVAL;
@@ -1511,6 +1512,12 @@ static int ieee80211_stop_ap(struct wiph
 	kfree(link_conf->ftmr_params);
 	link_conf->ftmr_params = NULL;
 
+	sdata->vif.mbssid_tx_vif = NULL;
+	link_conf->bssid_index = 0;
+	link_conf->nontransmitted = false;
+	link_conf->ema_ap = false;
+	link_conf->bssid_indicator = 0;
+
 	__sta_info_flush(sdata, true);
 	ieee80211_free_keys(sdata, true);
 


