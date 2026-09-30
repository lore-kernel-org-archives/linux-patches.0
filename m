Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDCD50C2B7;
	Wed, 30 Sep 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782417; cv=none; b=mU76ZM95u5wauAesy8zVUf+k7q0S8H/CewDd2Lv6ZDKf3FwgjDVGU/IECsymZJHKGV121SYU7R0vdzmuZT2LSJhYG6n2mSW5stjsbfcKL/n06JTOvy72yPBdGo2YsfkK2JPR807QfTeEUP0uKkr7u8Xm9jk+k5w9luXUEeyFhm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782417; c=relaxed/simple;
	bh=7CfO9Dv3jDN/7vJR9yL3pSjBhNxRTSf8a9UTz7Ag2cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z54Ok0YYG5Aj307bhd8/6SJU+EY/y6ol5TcvCw5Hockmds6bJ0dVUtf9M0GoP5zW9bdC1s5eCkGHhSFBNhOMQ+ZeQbADG+fyXfxZh4iR6WJaIn33ru2ZPPgE2u3l1Dh5wZiutlB4IUhBokLXLM9M+9/ZgHr659V00u+20QWJmbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCBqcH0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCBqcH0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8E61F00893;
	Wed, 30 Sep 2026 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782405;
	bh=gtOniwB4zfc2NTeDwS9iPm6zWOP8KyH3oDKvABFRNo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCBqcH0wnk8YWbGUG2PNtcODX8WXhSkIzosoAkTe2HM2+5p5rwwvnRNJDrbDNVqYU
	 kqLGBzkJjo5EnvzoVkLqiGIIgzAOyJDgKZTZ6R+fvLrvhlmIqcW+TyHeS5rHgCTec0
	 N75rR1NoFxytRj9eQGOxFuvPJqxExMBps//EHn80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/595] wifi: mac80211: dont call ieee80211_handle_reconfig_failure when not needed
Date: Wed, 30 Sep 2026 17:18:48 +0200
Message-ID: <20260930152348.483164370@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 7a8a3ff2815501f78f494808355ddf37e08647d0 ]

In case reconfiguration of NAN fails, we call
ieee80211_handle_reconfig_failure, that marks all interfaces as not in
the driver.
Then, at the error path of the reconfig, cfg80211_shutdown_all_interfaces
is called to destroy all the interfaces.

If we have any other interface but the NAN one, for example a BSS
station, then when its state (links, stations) will be removed, we
won't tell the driver about this, because we will think that the
interfaces are not in the driver, and then drivers might remain with
dangling pointers to objects like stations and links (at least for
iwlwifi this is the case).

ieee80211_handle_reconfig_failure is meant to be called after we cleaned
up the state in the driver, there is no reason to call it for NAN
reconfiguration failure.

Fix the code to just warn in such a case, as we do in other error paths
in reconfig where it is too complicated to rewind.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260513182548.6a25f3a0a6ec.I83d1f2a7eed20200a78a62757c6b193e3bab892b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7cb32340108e3..16b286511977b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2519,11 +2519,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			}
 			break;
 		case NL80211_IFTYPE_NAN:
-			res = ieee80211_reconfig_nan(sdata);
-			if (res < 0) {
-				ieee80211_handle_reconfig_failure(local);
-				return res;
-			}
+			WARN_ON(ieee80211_reconfig_nan(sdata));
 			break;
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_AP_VLAN:
-- 
2.53.0



