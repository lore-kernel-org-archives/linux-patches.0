Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B84B3B1ED1;
	Wed, 30 Sep 2026 19:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794814; cv=none; b=Dp/B/oW1RvmElTVmFRU13m0SYJEFuYDcHIwjGfvwNdK0pWFX7yR2EjBLPXQOeoHF59mnEHKUh6Zs4anL5UPAELfuzaOeoO5H1Yla2cOx3Yh5ESKeDmrZPnKjAvlHbMl4222P2RH34OTqdNSi1VtSsoMg6GrsU3R/A2YFm9WEP6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794814; c=relaxed/simple;
	bh=hmApRyRdC7BN3hlyrLrlu7zFQ4hNqC24jF5qn95SJqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk7Tf3afrfegToaAbLsHQmQVSFObyWFXVlyJSDsJgLg9zFierRtF+wOcwlYiLXfNxXNfitA/xwozrTouvmO69CX+fCmas37Kj4/9XmuspoqyTJdHBor9mkOuFTX2iEexhD5uUTnH9nkiuSauSnTX4tpKJJPivGUsyan+5sTo82U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aA2eLI/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aA2eLI/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954411F000FF;
	Wed, 30 Sep 2026 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794813;
	bh=gqLKKU1ciClc7V2PaARmdSNJave0zlB8wbqocuRHSXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aA2eLI/qR8JpktU3izBSKDvV5EyOncYONU0blr+NDUbdwQ5lqmejS+DDvMhJ/P7C9
	 rB0+tNM2m/mMrBXvM3tvlQgql7OzNfi9HZfsGqf7/XEBNZjhGAga/pS1m3ZBMvo5v9
	 aBb5MFZdi2B4dOZEL4CUe0+oOxVWlCMEI69QDvO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0325/1193] wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO
Date: Wed, 30 Sep 2026 17:16:49 +0200
Message-ID: <20260930152441.359734411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index bacbb49889848..dd9e7ef2186d5 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -876,9 +876,9 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
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



