Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339A442B0F;
	Thu, 30 Jul 2026 14:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421327; cv=none; b=X7wSsSvzw2Gd7MDrgQsnj/6MefaDFS8eXcrFMfbbIC/pXzPJ8TPqC+XZQjX1HUEUCA4EE6zyYNBmeaP3so1QCmPpzXbv3jdiEp7WDUZu//9DsbK/R59HtOe9k7e3clZd0unHhT4qJulQ0lqnYEaECfMAhFwfmcipAeHXWUKfk2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421327; c=relaxed/simple;
	bh=JBBCiwya6GDu9Swb7NY7N/8Ln7uvwgT91bJJbDb75Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpnNZDlACnO4Su1tvQAnG43pGFxkHdJxKIzRE3iRCdLdkFSxo0eFCrzvTZyJqsq4UN07Di82YgY+zrIIAm3yDLTE0YBF8ygAGxEddKfxkgMqhF4MF2MZoulaYjxv7c6YFjYBJMrxLIcwlMWG21jlyq6/mIfad2srE4TVpKbrszk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9G1H0ba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9G1H0ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43E11F000E9;
	Thu, 30 Jul 2026 14:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421326;
	bh=9cw1wCv9tiYym9U6u6fFLZ8cVzSxM/IMn/tEWLx/1ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9G1H0bawCf2pMivjA8k0n0TUq0vV5P1z/znab5+GsmyAi2ntTnx32fmwIdIEhrOP
	 qNK1Y87PCmP7MEY18v5I/dRCJ2X9Dwod7PlQi6k9u8fi9IEkICpn8stwq7ImhzD56z
	 Kx3LAGwmrWhS7hOxUR1bkNZkH7c4wQYIvmbkvSlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 065/744] wifi: cfg80211: validate PMSR FTM preamble range
Date: Thu, 30 Jul 2026 16:05:38 +0200
Message-ID: <20260730141445.659057570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3024fa8dd78021..3476681ecd7aa8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -461,7 +461,9 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
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



