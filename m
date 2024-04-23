Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1601313FD67;
	Tue, 23 Apr 2024 21:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908585; cv=none; b=WEGsbzG38wD3xJXHvm+IFcBHWavs3JgxgejizA1kZQnEv6dI1TpUaN8PRWki0Uw3tOKFttfikbIdM9BMeeRkYLnZ5qK1I3RJU1XF4XevFu2AVe9DnHW1n6F2KidL+urShUNazQU9qVlyoRDzqfiFGDDlJQ4YZTkbuGiEPXU720I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908585; c=relaxed/simple;
	bh=ysdSYs1aYiCyc3BmUaasc0d+f7kHGFJlO2alLZ0UjUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PNo/zsIvqjNT73k+Ykp6E6MCFWbZRImNHGGcqBAfF59PNk5Z5Aj0ppf0RPY+yRdsrAO7byzFA+YsiXmvOhiyh4QMDojPxbCNX5YAtYVk0/6N7bgUe+kI0kaWIo0eRc2pIuEKkETxzLMuAWY8tfF4ZkNoYnaPWsc/JlM6Yazmajo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJvzRS6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJvzRS6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE78CC116B1;
	Tue, 23 Apr 2024 21:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908585;
	bh=ysdSYs1aYiCyc3BmUaasc0d+f7kHGFJlO2alLZ0UjUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJvzRS6sCDFSglYJeZxH0qFAiHe4aacmM+vcjFmnpedzRPF6TlHGS5jnZ9XFo0uMo
	 yT1Ah/+DlB8WOwO4iKyuSmny0Dx4vH6MlRSq4gsb3i4eQ/9R2cBTKGbJBn+eaxDf6H
	 riH4eilliZvzfD0rdBis55eiGXPtF+BsiaAk9TzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/158] net: sparx5: flower: fix fragment flags handling
Date: Tue, 23 Apr 2024 14:37:58 -0700
Message-ID: <20240423213857.092221633@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 68aba00483c7c4102429bcdfdece7289a8ab5c8e ]

I noticed that only 3 out of the 4 input bits were used,
mt.key->flags & FLOW_DIS_IS_FRAGMENT was never checked.

In order to avoid a complicated maze, I converted it to
use a 16 byte mapping table.

As shown in the table below the old heuristics doesn't
always do the right thing, ie. when FLOW_DIS_IS_FRAGMENT=1/1
then it used to only match follow-up fragment packets.

Here are all the combinations, and their resulting new/old
VCAP key/mask filter:

  /- FLOW_DIS_IS_FRAGMENT (key/mask)
  |    /- FLOW_DIS_FIRST_FRAG (key/mask)
  |    |    /-- new VCAP fragment (key/mask)
  v    v    v    v- old VCAP fragment (key/mask)

 0/0  0/0  -/-  -/-     impossible (due to entry cond. on mask)
 0/0  0/1  -/-  0/3 !!  invalid (can't match non-fragment + follow-up frag)
 0/0  1/0  -/-  -/-     impossible (key > mask)
 0/0  1/1  1/3  1/3     first fragment

 0/1  0/0  0/3  3/3 !!  not fragmented
 0/1  0/1  0/3  3/3 !!  not fragmented (+ not first fragment)
 0/1  1/0  -/-  -/-     impossible (key > mask)
 0/1  1/1  -/-  1/3 !!  invalid (non-fragment and first frag)

 1/0  0/0  -/-  -/-     impossible (key > mask)
 1/0  0/1  -/-  -/-     impossible (key > mask)
 1/0  1/0  -/-  -/-     impossible (key > mask)
 1/0  1/1  -/-  -/-     impossible (key > mask)

 1/1  0/0  1/1  3/3 !!  some fragment
 1/1  0/1  3/3  3/3     follow-up fragment
 1/1  1/0  -/-  -/-     impossible (key > mask)
 1/1  1/1  1/3  1/3     first fragment

In the datasheet the VCAP fragment values are documented as:
 0 = no fragment
 1 = initial fragment
 2 = suspicious fragment
 3 = valid follow-up fragment

Result: 3 combinations match the old behavior,
        3 combinations have been corrected,
        2 combinations are now invalid, and fail,
        8 combinations are impossible.

It should now be aligned with how FLOW_DIS_IS_FRAGMENT
and FLOW_DIS_FIRST_FRAG is set in __skb_flow_dissect() in
net/core/flow_dissector.c

Since the VCAP fragment values are not a bitfield, we have
to ignore the suspicious fragment value, eg. when matching
on any kind of fragment with FLOW_DIS_IS_FRAGMENT=1/1.

Only compile tested, and logic tested in userspace, as I
unfortunately don't have access to this switch chip (yet).

Fixes: d6c2964db3fe ("net: microchip: sparx5: Adding more tc flower keys for the IS2 VCAP")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Tested-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240411111321.114095-1-ast@fiberby.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 61 ++++++++++++-------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 523e0c470894f..55f255a3c9db6 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -36,6 +36,27 @@ struct sparx5_tc_flower_template {
 	u16 l3_proto; /* protocol specified in the template */
 };
 
+/* SparX-5 VCAP fragment types:
+ * 0 = no fragment, 1 = initial fragment,
+ * 2 = suspicious fragment, 3 = valid follow-up fragment
+ */
+enum {                   /* key / mask */
+	FRAG_NOT   = 0x03, /* 0 / 3 */
+	FRAG_SOME  = 0x11, /* 1 / 1 */
+	FRAG_FIRST = 0x13, /* 1 / 3 */
+	FRAG_LATER = 0x33, /* 3 / 3 */
+	FRAG_INVAL = 0xff, /* invalid */
+};
+
+/* Flower fragment flag to VCAP fragment type mapping */
+static const u8 sparx5_vcap_frag_map[4][4] = {		  /* is_frag */
+	{ FRAG_INVAL, FRAG_INVAL, FRAG_INVAL, FRAG_FIRST }, /* 0/0 */
+	{ FRAG_NOT,   FRAG_NOT,   FRAG_INVAL, FRAG_INVAL }, /* 0/1 */
+	{ FRAG_INVAL, FRAG_INVAL, FRAG_INVAL, FRAG_INVAL }, /* 1/0 */
+	{ FRAG_SOME,  FRAG_LATER, FRAG_INVAL, FRAG_FIRST }  /* 1/1 */
+	/* 0/0	      0/1	  1/0	      1/1 <-- first_frag */
+};
+
 static int
 sparx5_tc_flower_es0_tpid(struct vcap_tc_flower_parse_usage *st)
 {
@@ -145,29 +166,27 @@ sparx5_tc_flower_handler_control_usage(struct vcap_tc_flower_parse_usage *st)
 	flow_rule_match_control(st->frule, &mt);
 
 	if (mt.mask->flags) {
-		if (mt.mask->flags & FLOW_DIS_FIRST_FRAG) {
-			if (mt.key->flags & FLOW_DIS_FIRST_FRAG) {
-				value = 1; /* initial fragment */
-				mask = 0x3;
-			} else {
-				if (mt.mask->flags & FLOW_DIS_IS_FRAGMENT) {
-					value = 3; /* follow up fragment */
-					mask = 0x3;
-				} else {
-					value = 0; /* no fragment */
-					mask = 0x3;
-				}
-			}
-		} else {
-			if (mt.mask->flags & FLOW_DIS_IS_FRAGMENT) {
-				value = 3; /* follow up fragment */
-				mask = 0x3;
-			} else {
-				value = 0; /* no fragment */
-				mask = 0x3;
-			}
+		u8 is_frag_key = !!(mt.key->flags & FLOW_DIS_IS_FRAGMENT);
+		u8 is_frag_mask = !!(mt.mask->flags & FLOW_DIS_IS_FRAGMENT);
+		u8 is_frag_idx = (is_frag_key << 1) | is_frag_mask;
+
+		u8 first_frag_key = !!(mt.key->flags & FLOW_DIS_FIRST_FRAG);
+		u8 first_frag_mask = !!(mt.mask->flags & FLOW_DIS_FIRST_FRAG);
+		u8 first_frag_idx = (first_frag_key << 1) | first_frag_mask;
+
+		/* Lookup verdict based on the 2 + 2 input bits */
+		u8 vdt = sparx5_vcap_frag_map[is_frag_idx][first_frag_idx];
+
+		if (vdt == FRAG_INVAL) {
+			NL_SET_ERR_MSG_MOD(st->fco->common.extack,
+					   "Match on invalid fragment flag combination");
+			return -EINVAL;
 		}
 
+		/* Extract VCAP fragment key and mask from verdict */
+		value = (vdt >> 4) & 0x3;
+		mask = vdt & 0x3;
+
 		err = vcap_rule_add_key_u32(st->vrule,
 					    VCAP_KF_L3_FRAGMENT_TYPE,
 					    value, mask);
-- 
2.43.0



