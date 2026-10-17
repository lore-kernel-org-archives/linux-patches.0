Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D410835DA41;
	Sat, 17 Oct 2026 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260420; cv=none; b=LqqKT63Li2o6u7PO33FJhBR1uyAHwSXFHMbIrMknKOSGt6XSxtjVEbtdCHXxa9jyjlxOz0gDRST6+HRIsmCKuglzE8J30xGYV3Hup+WRCDli02KexROHoBKUEkk8snpdnmMMP+cXq+D6nXzQFzabeDTN+dRvrWUO5Bf406sbBV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260420; c=relaxed/simple;
	bh=dA4iJY9kJ7UoPiOfKTdUW7KbngZgIq2kBmEtOQAQgDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwrQEXXUNZj+WB5eG2oJ0WmoFvAUEnCX9lwetXoQlS/ZxuTN6t3CXHPDGB5ab0gyXapsKNm9TXCZRInwVgwiwu8iSG4k+btSH6FF4CuvFbhuB3yfRuvR+DTKlzwihYCGXUD/mTKYSezXAdZ1xqxd8cK6oA+9ZTJAIerNjKgwtLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2doP37h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2doP37h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391741F000C4;
	Sat, 17 Oct 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260419;
	bh=KZ5ePJK0l6kWVbZVhXMQHPEFzUamtlnxr1szM3B/GrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2doP37hYk6L7G5R4L4fVaqki8xEjO9SKjAzStIWlXsvH1RKAyfKXYT00A7gBB+GB
	 AQDr7K1nMEx2Snu6itMUPbqIxdyi67ee3Fv8PIgq0Ci4+SjGdy7Svc7t5rYAq03Iay
	 4Uu0U+OfELpjaqX/X8YC9Z9ByRCBY/UpJRZjVb6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1537/1674] wifi: mac80211: dont call ieee80211_handle_reconfig_failure when not needed
Date: Sat, 17 Oct 2026 18:03:29 +0200
Message-ID: <20261017160510.566804290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 net/mac80211/util.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3a3cd09bdab65..28d2a7fafc315 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2814,12 +2814,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			}
 			break;
 		case NL80211_IFTYPE_NAN:
-			res = ieee80211_reconfig_nan(sdata);
-			if (res < 0) {
-				sdata_unlock(sdata);
-				ieee80211_handle_reconfig_failure(local);
-				return res;
-			}
+			WARN_ON(ieee80211_reconfig_nan(sdata));
 			break;
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
-- 
2.53.0



