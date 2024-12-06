Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF8B13D516;
	Fri,  6 Dec 2024 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496540; cv=none; b=AIsnOqmMBcMs+nZyxWN4f1nAdR5GL/niUPbX/7fdwni2s2re0hSfYJAFCjwdmv04mGSDt9TYp6GAHFucRgUwom6Uzwl03lhrZwBvcdAK81pe0IWIJgJ2mhAsS4ePSJpNs3S+wLu6M7pN3fxPFx4qD9cg9D2gLD6gXtwVq92WNqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496540; c=relaxed/simple;
	bh=pDKFiFY+CfIJAv2ZoMSWMTJdmOSWKsrXfPbgVWTsVqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pH/cby2hw7y4Mm6MxWv1eUt7KGexhy5gNKtTIwEsDa+4CtlXgPQUBdj3+LILaPHeWRPU3VEfIp/P58DTGLy4mP0567l2UAD5Ke6IWtoOo40MPDmd1xYMiTMS3UfL1hX/aETrPE85I3XlYf9QW58VqDoiLIk0c9TwWklx5b8q6TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyJWiwLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyJWiwLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEEFC4CED1;
	Fri,  6 Dec 2024 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496540;
	bh=pDKFiFY+CfIJAv2ZoMSWMTJdmOSWKsrXfPbgVWTsVqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyJWiwLZLqRem/v5nKvsQWreiA/f9af130m27PWt0Uifsb3yfY5Xihj+VaCaBgdd8
	 VrVV3WQBXhQgsTLCuIIAEKyRkddAIA4C3pXaa6CPP9xwi85To2i8BH0sjSUDwe0ioj
	 7CrvFGzHd/Jo4mByX4Bcrw6hZSswtTOE7NDcpzk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/676] mac80211: fix user-power when emulating chanctx
Date: Fri,  6 Dec 2024 15:27:06 +0100
Message-ID: <20241206143653.643743175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 71d60f57a886c..d1046f495e63f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -145,6 +145,8 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	}
 
 	power = ieee80211_chandef_max_power(&chandef);
+	if (local->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
+		power = min(local->user_power_level, power);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-- 
2.43.0



