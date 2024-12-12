Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCD82210CF;
	Thu, 12 Dec 2024 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021787; cv=none; b=tP6ccc924ipi9MdeAnQ9hf527+er/xQnZ8yScpJ0jKjcuil/ro5AHHkl+IJl9aeAQnuEUJ3sUy4X3FWUtShP2SYvNXNAPPKddiGRBERH93tD0wZSmoDyiojBtBqszknYpBHhpq4WZAsp5INyAZWVxAW6nqeOZPac8udcY8Fquko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021787; c=relaxed/simple;
	bh=aixvGzat4n0iciT1VVTTFnqgnEWb8H/OT4h68N5DUgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkwyF87ljuq+NyKtPJyBN/IOKVas8Pg5izCNxgQxlMBPKeH5DKTevfOgCQ3C/QfJ7aTi4Bjlwwjh4rHF9Jeb+PoTABv2MIjdwq45q64xh2dRxqp5F2ZhqDwmeQi9FBha618/XCviJlZwaX/rZMGvw54FmZMwZi9LT6Nv4rpVEgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbHAlIk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbHAlIk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBA9C4CECE;
	Thu, 12 Dec 2024 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021787;
	bh=aixvGzat4n0iciT1VVTTFnqgnEWb8H/OT4h68N5DUgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbHAlIk2da3HX/Cu2pYLpbmUsv5i5Kl4cqFywjQPVsU8brA53d6/SIpEmko5Ilm/K
	 AlG7D7hbnq2iuCFHvSLwfCbjZAeCErhspwEcx9Q3K1DMpM6AFcgJW3DSUN6Sy7k9R7
	 Zp1ZOYprcdirLRvMVFq/ny66y56e+1b1XnzkDQyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/565] mac80211: fix user-power when emulating chanctx
Date: Thu, 12 Dec 2024 15:54:10 +0100
Message-ID: <20241212144313.673802679@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 9b15c6cf8d2e82c8427cd06f535d8de93b5b995c ]

ieee80211_calc_hw_conf_chan was ignoring the configured
user_txpower.  If it is set, use it to potentially decrease
txpower as requested.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Link: https://patch.msgid.link/20241010203954.1219686-1-greearb@candelatech.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1c2cdaeb353b0..6253a89411cbe 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -144,6 +144,8 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	}
 
 	power = ieee80211_chandef_max_power(&chandef);
+	if (local->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
+		power = min(local->user_power_level, power);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-- 
2.43.0



