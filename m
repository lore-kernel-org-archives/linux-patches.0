Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B82414DE5;
	Thu,  2 Jul 2026 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009414; cv=none; b=Sqwagfi0NrRZZJbG+M1mNbymD14px9jKI2vkb7VkKj3N/a9D0mtyp+1r5izA+edWKt6T+WREOk6ksdzvYdlVhICpcgBDPxGbYVWp1T/rz4iBmqAWeJk2kg7HQGh9XoZYjOFYcXEcK2mNYek5C4IdcK/hpfitA/lKZaglHop713U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009414; c=relaxed/simple;
	bh=MQUZqke4g27KghawRDBcbjHdRe1NM2DJr2sRyquF2Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wog+WFVoMw/E4ucRfAXHOxN6fo1Uh6ojUxwSLpsUyh6Pbls75CBQYnyWbR6QsHxeJ6GtfX0ktKSpXY18tzUNpguwYPz127CjM1eG5asLSv3v/45iQcLmPHfsReAZCEZzuEQ3KoWGqXZcaIQuQUzauDgTAjwjHVyHPyoXV9Na6sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdMCLcb4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdMCLcb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDAC1F00A3E;
	Thu,  2 Jul 2026 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009410;
	bh=fggnnEQwdObJ2BdXANJSJUaFZvms6VwZGVjpQLJ/yuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdMCLcb47zicGsq38BZoZsVL+CEGERC76SJf1VHB5Hz6+5SPPA94Uciasnq4Iopyf
	 96pKnPQxWLXInMANBTU5M9LUcl+Bl6IzEKfGmfPnVpwgIMVKtEizpF5J9Xrb/4ySrj
	 fxzvx+Gw1vqbVccH7GZeN5Sh7x+46K3v4Jl/NPzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/96] net/sched: act_pedit: remove extra check for key type
Date: Thu,  2 Jul 2026 18:18:56 +0200
Message-ID: <20260702155109.055892028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 577140180ba28d0d37bc898c7bd6702c83aa106f ]

The netlink parsing already validates the key 'htype'.
Remove the datapath check as it's redundant.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 84152d3a492469..957ce9017c3f73 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -305,37 +305,28 @@ static bool offset_valid(struct sk_buff *skb, int offset)
 	return true;
 }
 
-static int pedit_skb_hdr_offset(struct sk_buff *skb,
-				enum pedit_header_type htype, int *hoffset)
+static void pedit_skb_hdr_offset(struct sk_buff *skb,
+				 enum pedit_header_type htype, int *hoffset)
 {
-	int ret = -EINVAL;
-
+	/* 'htype' is validated in the netlink parsing */
 	switch (htype) {
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
-		if (skb_mac_header_was_set(skb)) {
+		if (skb_mac_header_was_set(skb))
 			*hoffset = skb_mac_offset(skb);
-			ret = 0;
-		}
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
 		*hoffset = skb_network_offset(skb);
-		ret = 0;
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
-		if (skb_transport_header_was_set(skb)) {
+		if (skb_transport_header_was_set(skb))
 			*hoffset = skb_transport_offset(skb);
-			ret = 0;
-		}
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
-
-	return ret;
 }
 
 static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
@@ -367,10 +358,9 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 
 	for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
 		int offset = tkey->off;
+		int hoffset = 0;
 		u32 *ptr, hdata;
-		int hoffset;
 		u32 val;
-		int rc;
 
 		if (tkey_ex) {
 			htype = tkey_ex->htype;
@@ -379,12 +369,7 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			tkey_ex++;
 		}
 
-		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
-		if (rc) {
-			pr_info("tc action pedit bad header type specified (0x%x)\n",
-				htype);
-			goto bad;
-		}
+		pedit_skb_hdr_offset(skb, htype, &hoffset);
 
 		if (tkey->offmask) {
 			u8 *d, _d;
-- 
2.53.0



