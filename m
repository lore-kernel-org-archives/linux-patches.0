Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FA04D9EA;
	Wed, 19 Jun 2024 13:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803583; cv=none; b=fcWGFMaqsJmv1Eg6/SZYhEP0IQAHhpLbE1+ywES/UDOZLNoWJvRaZ0k9UOmUaPGl7JgpIUAKAHlBnNn0FsFPY5I9Ht01899sTYlnPiAs0OT5tHES0fun6HvRX1V6IDvqwqI7ZyzYr4INhB3HJqZLweV++IrcI4lcKIgBHzIc0eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803583; c=relaxed/simple;
	bh=QpCcz8TFsFYjDqNkVgxdOLfw2L3ea88FpAyihwrwnQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoNtHvLCiR7RP2hf1uf/63NDo9x2kAe9rIa22UXaep9RyytJ+z7lI+AJDIsYHnsBzkPXe2ZVCzIZ0pfA0XMXPu0vMBG6MCYUhqZFcIuJtexBuHw55ngdlXf085D8e+/c2w2mQAJRmj6Rcv01qSAldH/nczbHKv17cDIIYCBvo10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hiofuf5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hiofuf5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFD4C2BBFC;
	Wed, 19 Jun 2024 13:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803583;
	bh=QpCcz8TFsFYjDqNkVgxdOLfw2L3ea88FpAyihwrwnQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hiofuf5aggY2NZOrPzaXN/1Um4XJK1+oUXE9jafzW6bN4kssXISRrTR6rAAn6Bduv
	 E1LRD6psi8uZzziTbmVkZH0S39oguxpoSpI30ZbOkfnhUZ0/NbKfX5IadD2vKRgoQG
	 wRUT3M6VyvEf0/tMHarksroHgmKfICIBHMifuHSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/217] wifi: cfg80211: pmsr: use correct nla_get_uX functions
Date: Wed, 19 Jun 2024 14:54:08 +0200
Message-ID: <20240619125556.707058788@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit ab904521f4de52fef4f179d2dfc1877645ef5f5c ]

The commit 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM
initiator API") defines four attributes NL80211_PMSR_FTM_REQ_ATTR_
{NUM_BURSTS_EXP}/{BURST_PERIOD}/{BURST_DURATION}/{FTMS_PER_BURST} in
following ways.

static const struct nla_policy
nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
    ...
    [NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP] =
        NLA_POLICY_MAX(NLA_U8, 15),
    [NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD] = { .type = NLA_U16 },
    [NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION] =
        NLA_POLICY_MAX(NLA_U8, 15),
    [NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST] =
        NLA_POLICY_MAX(NLA_U8, 31),
    ...
};

That is, those attributes are expected to be NLA_U8 and NLA_U16 types.
However, the consumers of these attributes in `pmsr_parse_ftm` blindly
all use `nla_get_u32`, which is incorrect and causes functionality issues
on little-endian platforms. Hence, fix them with the correct `nla_get_u8`
and `nla_get_u16` functions.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://msgid.link/20240521075059.47999-1-linma@zju.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 2bc647720cda5..d26daa0370e71 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -56,7 +56,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 	out->ftm.burst_period = 0;
 	if (tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD])
 		out->ftm.burst_period =
-			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD]);
+			nla_get_u16(tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD]);
 
 	out->ftm.asap = !!tb[NL80211_PMSR_FTM_REQ_ATTR_ASAP];
 	if (out->ftm.asap && !capa->ftm.asap) {
@@ -75,7 +75,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 	out->ftm.num_bursts_exp = 0;
 	if (tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP])
 		out->ftm.num_bursts_exp =
-			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP]);
+			nla_get_u8(tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP]);
 
 	if (capa->ftm.max_bursts_exponent >= 0 &&
 	    out->ftm.num_bursts_exp > capa->ftm.max_bursts_exponent) {
@@ -88,7 +88,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 	out->ftm.burst_duration = 15;
 	if (tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION])
 		out->ftm.burst_duration =
-			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION]);
+			nla_get_u8(tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION]);
 
 	out->ftm.ftms_per_burst = 0;
 	if (tb[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST])
@@ -107,7 +107,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 	out->ftm.ftmr_retries = 3;
 	if (tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES])
 		out->ftm.ftmr_retries =
-			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES]);
+			nla_get_u8(tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES]);
 
 	out->ftm.request_lci = !!tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI];
 	if (out->ftm.request_lci && !capa->ftm.request_lci) {
-- 
2.43.0



