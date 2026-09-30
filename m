Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2E8243956;
	Wed, 30 Sep 2026 15:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782795; cv=none; b=VjjRdHvBnbFcGJMyUBX4lDcV73dX1BrGWV7837r9WIuX6dXOU0ZUKJYNCiTu98j3C8zEphLEEuz5QZd+GnjKU4lglcd5F17O+k7FeUdMpFVLOKp0EhBCG2rDwaigpZ0VuF5qSroD26HqDFoNZ0N+NR9wz5S6iIqezSOfJKoZJxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782795; c=relaxed/simple;
	bh=Ev0zhXsncWUWnDJJll+gVXh8l9mKHjD4fXU27nAQ3ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkzyvqKqwlssngytkxvtCRRICTC63pBE6QQHDAU2nrHWIV50JkW9M/rbNwqnYNzRyeQtGJ0TdqtSTOYZwtlQMwOhkgxAj349mQg6Z4Haecc/XqntIagoHYK3fKb/EpO0uc1Nww7mnx1MD/eUvbH0jzasrWd6Pdk6nCr/UxDnQEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXusDhkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXusDhkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633811F00898;
	Wed, 30 Sep 2026 15:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782791;
	bh=I6gWqQxZNSzD0ob0qayW04b40iRO78fZ/l6MPOj2FbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXusDhkZdgMngpMBPlDylkcxmfVkg4FjD2YsFkAgJZWtik+mBxmFXWfjUXRbsZrNR
	 Uk3P1NZQjUkivRlreILo4BkPW0H8/N11nc5hkV9sjIDiuGEsmrq1hi4KXQCFgSZdP1
	 PZmgFb5qdfSFwYleXFiu36t6Gu3imBT/WlnMz/Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/595] wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO
Date: Wed, 30 Sep 2026 17:21:05 +0200
Message-ID: <20260930152351.440395498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
 drivers/net/wireless/mac80211_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 02c31f7fcfd13..20d9f0c6142cd 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -738,9 +738,9 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
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



