Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24D6340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301091; cv=none; b=K3psYOwPQYPdpj72CBT2vBklshE69T3lK7uzEToQ9Yzb0Q21RCR0CHB1AqMh8CHAo5kwDDiAqMdffqp0bj+GqnHjCMRa5QcCw51/ohRq4gCRId2TWxJGUrJYC/aCbmJSfYujaNZxDOzp56+tbjKdbeqLHP5eGlpPwd4eGqJQbRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301091; c=relaxed/simple;
	bh=QyFenIxw6dkDQlrB4OFw1nwczt4vY80C/iYIZoBiqCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLssrpZSnPzc4jlqw4DXWj/UuBf6KyF/PhVPxOjHaUUHg9EIvBx6khP78h6HrRj9r+O7y7thJx6aWJpsAxqfs24y4wfIZNegPUrFyR7VMp7pT+H8mXECWHjBWPn5Xh8nGhEgd/sRxWhYHPAn1uSPTvIhRLCom6ahB9bBLRzeBSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfJxEAhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfJxEAhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4335AC19423;
	Sat, 28 Feb 2026 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301091;
	bh=QyFenIxw6dkDQlrB4OFw1nwczt4vY80C/iYIZoBiqCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfJxEAhgwEhUiNo688x9v0lSar3DuDZC4CqJkGTkmO3uy90LuAWGsgSz+YzvxG76h
	 9HtkN2HAr/b3tlPclytdSL+d2dM1O/WeEEPkmrfzFnZRvNtNjaZ4t3oqHBexHi28VZ
	 IxlqOnb/33u+K0DlWBVzdg7mFH+BNwcX1IshVF/nTL0xTknV0YecIyumiTlGZtdtt1
	 Ar8ceNflbgHYdUQNUym/2bNb/nqhtJEpZpJDyYUNHDMw7/PV+QlU2HxHwMZKO42uaY
	 i8qz3Sn8+K9fyH0kqEEZyjadgZ17+Jg9iWZ6lsVATGJRRykGDtxdqZuud7Ms+AGIgf
	 qJUObJZgmKJGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 242/752] wifi: cfg80211: allow only one NAN interface, also in multi radio
Date: Sat, 28 Feb 2026 12:39:13 -0500
Message-ID: <20260228174750.1542406-242-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit e69fda4d07701373354e52b0321bd40311d743d0 ]

According to Wi-Fi Aware (TM) 4.0 specification 2.8, A NAN device can
have one NAN management interface. This applies also to multi radio
devices.
The current code allows a driver to support more than one NAN interface,
if those are not in the same radio.

Fix it.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260107135129.fdaecec0fe8a.I246b5ba6e9da3ec1481ff197e47f6ce0793d7118@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 87f083d9247a4..2ce6e39926d05 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -658,12 +658,8 @@ int wiphy_verify_iface_combinations(struct wiphy *wiphy,
 				    c->limits[j].max > 1))
 				return -EINVAL;
 
-			/* Only a single NAN can be allowed, avoid this
-			 * check for multi-radio global combination, since it
-			 * hold the capabilities of all radio combinations.
-			 */
-			if (!combined_radio &&
-			    WARN_ON(types & BIT(NL80211_IFTYPE_NAN) &&
+			/* Only a single NAN can be allowed */
+			if (WARN_ON(types & BIT(NL80211_IFTYPE_NAN) &&
 				    c->limits[j].max > 1))
 				return -EINVAL;
 
-- 
2.51.0

