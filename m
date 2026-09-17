Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B597C3DFC99;
	Thu, 17 Sep 2026 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667492; cv=none; b=ZmqnNZX6Tn1Ni6dNSrVWkqrI8VzFjVR+GXuKB6I8oAw05fC4X2EH9Gduq2nd2rXT+bh9uf1V3HP9dPO0STvSleizkxQy96SD5gBZHc6X+QPXyPfSX0YaQ4Mf7CfkWezqrYH2hRXLx2GKgab9wryLjwt8xOnxzgPC2jOAWRTctyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667492; c=relaxed/simple;
	bh=UGR+U0/sXr4Ad4i6l9MqS05TjEV8wmMk12N7zEZAyPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5dW8CIJUWlYcXVbHyA6WcU2ImHuXAaQQuDd2AZr0JOkRh1bL+fxpND65G3kG19/NIJwdvUL1JAgDFYDHCJpG8fARetbAAesqMHxeSaMQ+g+tCvznQW/yRdwjyRVwc9VV9rwyF7GdU588vGM67HbOOPYah210m0J2NjELAnIDro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnq1WJkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnq1WJkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1977E1F000FF;
	Thu, 17 Sep 2026 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667491;
	bh=G3x1oYTzsnxT9jcXXqSNb16yvIROGtqHF+VEUJKUbro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnq1WJkp8uUueA3ZrMM91NKcu20T6ubpvI+GRuoVj22FNucf1oXDqapT/A41wD88s
	 DR3w0KQmx6+XlrgKsNf+Xng392zhS2+DlDP9TSsM82QklHjTggN1pHLOjMknYlj6PY
	 G7//AG+LmUbiWEidliDo0XRDC3FpiUZReANRYjrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0111/1102] wifi: mac80211: dont call ieee80211_handle_reconfig_failure when not needed
Date: Thu, 17 Sep 2026 16:00:54 +0100
Message-ID: <20260917151542.289359369@linuxfoundation.org>
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
index 5bb9e1d2479f3..8ffd7e0643751 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2049,11 +2049,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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



