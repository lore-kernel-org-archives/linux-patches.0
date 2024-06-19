Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D12A145352;
	Wed, 19 Jun 2024 12:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801907; cv=none; b=C2cfF9wpLp4bE65flJO2YcpOqtJV6nG/jluNuZ526T/7ngaoH4WfaydlpRAV8EG9hxdeaIwqfQH4ADzelqrECyVm5o7dcxCnLs+X9LQ5xPndKW1cdMjXxsEGMoxhGYf1LowVvaQM3dQ9k9NqJtm69hwHEKk1kXZbfEbmc4Jwp5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801907; c=relaxed/simple;
	bh=TdymwAxH8T1IGuPc9eeYClltX39bqbSiZNHUGZjgt9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzhl/XdotitGrJNs4D1OyZy4PMF2SbEYTn82v7ZiIbMnTj5Z93V+Jk0/gZvRVcGTa8SspA1KKqUdrINU//gBi9gFOnl9n4zFmanhyuLocng1KJPmejvlg/6u6FbYrzcqf7hGmNiGfXbaSf+UeQ7fabp1XypNH1+2AdGNaNlvQfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJbAU9O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJbAU9O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D72C2BBFC;
	Wed, 19 Jun 2024 12:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801906;
	bh=TdymwAxH8T1IGuPc9eeYClltX39bqbSiZNHUGZjgt9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJbAU9O4eV9aze0Qwzji56MxL3YZMoekRdv7HHMWgcLPYJLEWARH0rOHXr2xmEcas
	 RqPDJeaTZtg6UETJEyzzN/1HsJBZ7t3QBRdpbMdZ4mS4innVwNW5KdQ1VZ0sQGH/Jx
	 oAJKTYE2lcvvONs7KZg+mAetLiTkhUu32EDCxG1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/267] wifi: cfg80211: pmsr: use correct nla_get_uX functions
Date: Wed, 19 Jun 2024 14:52:36 +0200
Message-ID: <20240619125606.559839700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index 9611aa0bd0513..841a4516793b1 100644
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



