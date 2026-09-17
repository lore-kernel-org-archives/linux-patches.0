Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2E74FE2ED;
	Thu, 17 Sep 2026 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661346; cv=none; b=XlY5tGYU7fPyeFYcDUsB6wk7h4wY/JwpKBYUmDFdb+DP0qzMFDNVZgpJrYrFBAHL3yDcB8+/Ptd2cLCfn3K3UPO3bMmB6SXyaoYjAAVDhOh+O6WStyOcWH6cL+tqja7SXoY4rXYMZU0USBj+mwKOadD+6vKUD29JhmrO7kwcmxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661346; c=relaxed/simple;
	bh=PZw4y1DCW6wQhbcdpHfEm3K/XaFRM6lmX4bdPII3p6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffWGhIDqVlqrZCkiRom+XqiqisXafbm/6C7Y5kExyTf3gSdPe0nAXFit+MuhnUzAkwiMkqM6Q1ZsO820JZNeALAWt9g33OljCNSwKWVsbHc33AYrtfNkdcv04WeGCy8o1gWSZg/8k2jk6vrwTLbZ0R92vBQKpOnToVXJrsVJ6AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrOorhAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrOorhAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291921F00898;
	Thu, 17 Sep 2026 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661344;
	bh=H42cuRUsQ2esFEuG3MaTEmSqInRW3/fLzNrVI/wQjhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrOorhAlkdWdKQZ4sdRDmOC/ljokg2FCJuTyfzZSYyPygndAjocJN/4JiyrRM3M9x
	 yAo4u8R3k3JxXQfq6ff/cVtbG8cDMld09K3jt7ONbKuIlsjag1CfFaOqMc7VaIObBG
	 /qCRVcRjvT77cqTSSQGQzVvG9ZM800stKqyghrAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0163/1250] wifi: mac80211: dont call ieee80211_handle_reconfig_failure when not needed
Date: Thu, 17 Sep 2026 15:59:18 +0100
Message-ID: <20260917151556.506827744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 62e1a37849d04..af99ac02953d9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2055,11 +2055,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
-- 
2.53.0



