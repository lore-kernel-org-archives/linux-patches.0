Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD781538F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3401AC433C9;
	Mon, 19 Jun 2023 10:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171642;
	bh=dI1ZuKJN2WqZcZD7wxoaohw9yOQqTmywOcWKZiUM+1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTSb908KzHHcoVS46PdmBaIt41fRKjcRbiWA09Y5tnth2qFXdCwBkV1/QJK+LtQPR
	 /U9QD6N5kk1W+c6TFFW/Z4YmGXN3znHzTyIiKG6KwVnSE3D21FNp3AHRSSgYGW84m8
	 mv6jouO8PLQZEl3cpltCvMTgt2hjR9J17NHBo4jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/166] net/sched: act_pedit: remove extra check for key type
Date: Mon, 19 Jun 2023 12:29:41 +0200
Message-ID: <20230619102159.828619806@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 577140180ba28d0d37bc898c7bd6702c83aa106f ]

The netlink parsing already validates the key 'htype'.
Remove the datapath check as it's redundant.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6c02568fd1ae ("net/sched: act_pedit: Parse L3 Header for L4 offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 19f6b3fa6a557..48e14cbcd8ffe 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -312,37 +312,28 @@ static bool offset_valid(struct sk_buff *skb, int offset)
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
@@ -374,10 +365,9 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 
 	for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
 		int offset = tkey->off;
+		int hoffset = 0;
 		u32 *ptr, hdata;
-		int hoffset;
 		u32 val;
-		int rc;
 
 		if (tkey_ex) {
 			htype = tkey_ex->htype;
@@ -386,12 +376,7 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
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
2.39.2



