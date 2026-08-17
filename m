Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E862DC783;
	Mon, 17 Aug 2026 14:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976569; cv=none; b=rnf/lL73k9JbmTpCs4qEEXELwlLaV8XD5hFl5syYQshWqKW0AHuTkPqGOqh8TAXNi1F+SCg9uhTz+AtQoVIDzdKB6yJAcPDjofwaGVl9oev9dMJ+Cm+q2eUvyO3Wn4WVEgmNOALymjb2ps38+BG638/SUTJbKYkM6ICLRqqT5p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976569; c=relaxed/simple;
	bh=dhyr5oZaxt7BvwI+Yd6KQNbygFErSBEWhI5BKppXTog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9lIT/vqwoUlxJI5A1A2a4vI6b3lKFNGlNOJp+5ylax92neEjIalUAXsqH+VOBNKeGDVfRP6NRJvuL+w4WtSsBDWDyy3sEd25oiPDCXvWbZz4BY1ixF8jjxuZPK/hxFnlrPOQP1W64sCzDKxW1H2BwmsLB0626yoKfuuc4rBL2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEC2spdP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEC2spdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFFE1F000E9;
	Mon, 17 Aug 2026 14:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976568;
	bh=i7b01DwNFqA6T8aEmnm1KCsPGmC2u7o24Ct5DJq8kE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEC2spdPM2F2yM8hnsCgX+s2M8dEXxe5afsvhB9GyoLlDcQLHx8RJ168oDl/XWKWx
	 Axr+zRjzHosNfuxxdqQK7qbhOl3fEaZi0Lov9khbKf/B2XOCEMvsFQLRRW3c8Oc9g+
	 CHELLrgQwt22AEs1y79fE2+epZJMiNA60h2PLNp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/456] wifi: cfg80211: validate PMSR FTM preamble range
Date: Mon, 17 Aug 2026 15:26:59 +0200
Message-ID: <20260817132541.138812394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a7f91b584ee0cc..2c74da398cf4ed 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -300,7 +300,9 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
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



