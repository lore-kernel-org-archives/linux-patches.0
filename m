Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF792D7393;
	Thu, 30 Jul 2026 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423670; cv=none; b=RiUw59lih+oEy+2onna7y3Bgc10cjnirxxTh28P6Z3OtCn9pObaKckqPCZIoo4RaTRsp49sG5p9uCd4La2E34zgM+pT9IKy7gEji1qagWC2uZLcVvpNeYqdQNz0B9uHc3ss05DeQcaS4cleE7ZGhnf81c+Rheghun5YoAqmdAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423670; c=relaxed/simple;
	bh=u7l8rXIPFBwZqEbsh/V7/5kM1+K0ZLQW8libUoaHeFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZKUbAayjfCQG0leNTow1dCR8agDseUznaNKuG5DbViHd9hYNr4ptEXt3q5EpqbU/p4t6sZsjZE4nNTrrdiV+su5peJ9z4hXzNHDysiw72sqD6aIMYhreq1T9yGpuZc5NtTio1iP62GRzApwe1t9hWE0U4KpDxc0PcLKC0iXWsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evnqTbVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evnqTbVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7700C1F000E9;
	Thu, 30 Jul 2026 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423669;
	bh=YpZ8x/SB+ZigBgmGCmj4vEtydMctG0gXUHjeS5fxFsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evnqTbVmkSPbRIu3Hfli/mGGNndw65EaQqDUp+n3u/WoiTCS5hkf7Or9zukjCPrAt
	 7wyQtpKLDMJKGBjqXLZlwXm5kxHSFzoNwSQkGTR0vdSrNGESCyVawDWiwPMtJFGJDm
	 rFZDU8cMiRkVxF+MBA+ZPTwYR/YIXRO/c/yzpdf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/675] wifi: cfg80211: validate PMSR FTM preamble range
Date: Thu, 30 Jul 2026 16:06:50 +0200
Message-ID: <20260730141446.832739162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 237e5d7eeb47c3..776dcf8835d715 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -347,7 +347,9 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
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



