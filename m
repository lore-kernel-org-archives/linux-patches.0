Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0A6411689;
	Thu, 30 Jul 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427128; cv=none; b=FlYl1pVi6xZRmZHUEdav/HdINEHkaUtxz7KOGf8hD3TCD0Kg72o6M4i9OnH5liOHmBQpBqox0mlJijKuTRHTOPLtry0fq1Tu5xr7cyZ1WRJ50gKH5bT0/kGKatjeYkXgYkuh3LSsaxKan83Iu3EEOPSba6oy6+iKGeNflB/qyUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427128; c=relaxed/simple;
	bh=gNV8U1X2YF7Hf4AK09hCoiJ83HJDLkPkqt8k2UWkpjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXkK0lY/L55f3XPhTtBBmOoNthBplpn67vbX/7Ne/z0mdyAKyHgFHg/GYvvTQjIyzjDpb+ebhhCjI0yz832a+0KxOIZ+YmODNPyPHqgR6aNVqmhajerQ0Evo07V8rPut+obX1ogp/Stvb8OJPDM3wOnTQZXhO0ENUokcmj/fxn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hh5p2hYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hh5p2hYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B231F000E9;
	Thu, 30 Jul 2026 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427127;
	bh=6ne75wcydmJQEqAnmg7INP1QUYlOmXHj0A/BaUO/ejQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hh5p2hYRHT74EmdrSE1cNYzvI61TDYUR5SiX7TQZ/hGlUCqkqx792RQ7E0t5i9slG
	 Yu72AuOXrGQGuxzVzR+LhUxyGhqXG6UFmNcrVQxjeiyFl0wlAwDoYLMGtik5+6SGEX
	 4TCfIjN5LWG8bHBOQBq/VDW2JRGwA/TDD1J+jT+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/484] wifi: cfg80211: validate PMSR FTM preamble range
Date: Thu, 30 Jul 2026 16:09:18 +0200
Message-ID: <20260730141424.757986296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 36230936468f0ba4930e94aef496fc229d4bb951 ]

PMSR FTM request parsing accepts preamble values outside the
enumerated nl80211 preamble range.

Reject out-of-range values before using them in the parser capability
bit test using the policy.

Fixes: 9bb7e0f24e7e7 ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612133703.93274-2-enderaoelyther@gmail.com
[drop unnecessary check]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 93dac673f2a348..545f7ecaad76ff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -309,7 +309,9 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
 static const struct nla_policy
 nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
 	[NL80211_PMSR_FTM_REQ_ATTR_ASAP] = { .type = NLA_FLAG },
-	[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE] =
+		NLA_POLICY_RANGE(NLA_U32, NL80211_PREAMBLE_LEGACY,
+				 NL80211_PREAMBLE_HE),
 	[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP] =
 		NLA_POLICY_MAX(NLA_U8, 15),
 	[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD] = { .type = NLA_U16 },
-- 
2.53.0



