Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637BC37F8D7;
	Thu, 30 Jul 2026 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425440; cv=none; b=MTFObC842BG/dsMNHV7P+4Io6ZmWfbvj49Akq+UE2aeIGhF3q/C0RMGtdtrLHXPURw5zpZvRTJzHhaYfbUXZY9jBRTIhVY38xTRkEXlN8xuzUdbv6j4pEg3/2BL/JIFdhj3I9diKLi8cX4HLJlcjRAS0QABfIbWRBPtX9xzIics=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425440; c=relaxed/simple;
	bh=jnRUKBq/uTGQR2xRBdFIQzd3rqaU8juMv1KmqNiyIa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzSzds7jbjPZWIiZrXtzd2nEp0SNlTCNlFY0NtDR9Ru21dNzwavqxgGiUnfTOQ5bOoPfZ5kUzpgYXAz1aSO2oyGI6QK5QHJRQOjR+yvY0/ZAdslQ8dGCu0tUlr0eb8H0Kjsn9eiDp9A02oOfXJzYIRT7qd19JjDJ0iv8d18jndQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ua/VWm2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ua/VWm2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBEE1F00A3D;
	Thu, 30 Jul 2026 15:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425437;
	bh=hGiJvHGpArZtA1Y1tWjHd11F2P8pxQwb+T60kSEs7MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ua/VWm2YzXHG2qvGcl9CLmlNJQz9itkZ1m46gKPRaGrqySDqxn7uRXvS/+Nn8iENc
	 tU9Q6+RlT8RBG6AoRmru1HIzcwRqL5O/Pp+aY775bRFOIp5xe95HmIMkZp78SGxcq0
	 K1RUE9U4YIf6ZXdNgFCd/jVmxDjl/WbTIDkCXs4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/602] wifi: cfg80211: validate PMSR FTM preamble range
Date: Thu, 30 Jul 2026 16:07:41 +0200
Message-ID: <20260730141437.449234805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1702616d9e1c9a..b54da0f83247a9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -312,7 +312,9 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
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



