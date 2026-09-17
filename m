Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B854E2F09;
	Thu, 17 Sep 2026 18:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668485; cv=none; b=FCsTYzaT/FIKhBusQT/2wQwXrM0SMTtNONiaXJ5IxUpSsbrxsv5RjCJzpxjHKPfrq0/m5THz/54aRTohulyLA7zTS5hdwlXsFt5tw6/02H6xUkIIPTmF7W20a6+TKQBlXNHZr8btG9kk7hqaxL19a21Gh6X86ezIPzB+gCWq0jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668485; c=relaxed/simple;
	bh=TKmF2iUIT98rfIOxmHa34EhnDdq/5w7VLcLvdJN9aKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgMns9o67Gs7/Z5pH0ltNSIbsieLUxdQMQWuUv3nTGXm3c6944Svu2RmTdTYQAd5BX22YdNPU3HZl88vawc7zWXHnqTUbjZqqo9tqxZXbHp3myt7OuEdE6K3qEVr0YKEysBGkx1IJpg3wOtOTs/KZHKsx5PvSte1AfBtfhqWw+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXZWrGcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXZWrGcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642E91F000FF;
	Thu, 17 Sep 2026 18:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668483;
	bh=u+ZCFA56KG63IbWBTNhPs4eS59vmaBOr/hgaODzfIa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXZWrGcmK90xNjrr0EvqCF4M/v3mtf4kHjwXW8rbfeao7M/o4az7MLo/sBOPnNEfs
	 Go+gB0SsKbm5H1gpRLe3+cMLoNuyfgrazd4iJPuGWyC8d9oHjm7mn9xgXRWEnl+GPY
	 Nmv3k41RaU+jr2OPsuw7n8G4LXWprG/t08K7i4N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0439/1102] wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO
Date: Thu, 17 Sep 2026 16:06:22 +0100
Message-ID: <20260917151550.696894337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

[ Upstream commit 3dc723ac78a6e4fa0fd49e27e487ed319da40a9f ]

hwsim_tx_info_frame_received_nl() casts the HWSIM_ATTR_TX_INFO payload
to a struct hwsim_tx_rate * and unconditionally reads
IEEE80211_TX_MAX_RATES entries (8 bytes) from it. The policy only bounds
the attribute from above (NLA_BINARY .len is a maximum) and the op sets
GENL_DONT_VALIDATE_STRICT, so a short or zero-length attribute is
accepted and the loop reads past the payload.

Require the exact length in the policy, so a malformed attribute is
rejected before the handler runs.

Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Link: https://patch.msgid.link/20260721115346.17236-1-security@auditcode.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 4622cbf4f5f98..9410059e97f01 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -903,9 +903,9 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_FLAGS] = { .type = NLA_U32 },
 	[HWSIM_ATTR_RX_RATE] = { .type = NLA_U32 },
 	[HWSIM_ATTR_SIGNAL] = { .type = NLA_U32 },
-	[HWSIM_ATTR_TX_INFO] = { .type = NLA_BINARY,
-				 .len = IEEE80211_TX_MAX_RATES *
-					sizeof(struct hwsim_tx_rate)},
+	[HWSIM_ATTR_TX_INFO] =
+		NLA_POLICY_EXACT_LEN(IEEE80211_TX_MAX_RATES *
+				     sizeof(struct hwsim_tx_rate)),
 	[HWSIM_ATTR_COOKIE] = { .type = NLA_U64 },
 	[HWSIM_ATTR_CHANNELS] = { .type = NLA_U32 },
 	[HWSIM_ATTR_RADIO_ID] = { .type = NLA_U32 },
-- 
2.53.0



