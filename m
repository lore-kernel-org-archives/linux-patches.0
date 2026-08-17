Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DACD285061;
	Mon, 17 Aug 2026 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975477; cv=none; b=no/EtrDcfphjcxX685l47NbMZqAgiYxr1eG7d1rP2pWzcG847WbvuunKLvSIMl9ojCM398wu/N6065a0zNVQCK916QOnhckYRTpQjx1EArCdu8BuTA13eARQGLSmSYv/cWU0Cz1g3TPQ8uzY61kt4cBxBKlT7libJsUsAUm5DLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975477; c=relaxed/simple;
	bh=TO8rtfAltkV6X53ewNasqGHlWcm7v32IP7Vj/9i+Wp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1I1wsKFVUJXhk1rBhlk5ADGM47Nt4x7MV1wKjskwWTD+ojGkTsKn9X4XW0wKcunuwv8pKbbvZZq5O5x2lJLxZxNl/XtYd4lgVyxkYRrg50PWnTtumReDJ8HSUF0GJsUGticfLT3t71ZZ96vRSCfhvF+MLa6dxTG3TlB+dors6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFLrLUBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFLrLUBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B191F000E9;
	Mon, 17 Aug 2026 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975476;
	bh=V3fYT6Jm6c5SeZJfzwCF7jA3FEYP/bFeZwfupjqEw7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFLrLUBrOsvLf2tLpGW6eO7rLrrV224Qt3wsn9o9LL3HHzMmWZ0tEAWbL58qgY5Nt
	 zaclnKErS2CtjgJ0Jj8EX1+0szY0iZUtSmgh/bGUMi5Rvmy/UGhqwyMhyde9PUrdFD
	 4aCdrcOlQAutIKEE9mlzaEEj4+qOfmDD2F5cJzVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/389] wifi: cfg80211: validate PMSR FTM preamble range
Date: Mon, 17 Aug 2026 15:27:43 +0200
Message-ID: <20260817132539.853233595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
index 33e2c29fbd3fde..3b2a70b467de9e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -280,7 +280,9 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
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



