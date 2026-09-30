Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48935349B2;
	Wed, 30 Sep 2026 17:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790694; cv=none; b=dZlhZugVqRuVWi2Jmh7v4bBSei0h3Vm6j0x3cr36sOSRvW73/DUEdQcK9pru8YNlcMqP3Z038SGOQMcLWX12BJgwYbFwbM/xZRGrBl8KOwSEF2UtgPAeW6EstocQn8enKKepewc6dxDhV/e2YkMjZ6t/8be81B0Winbf6eMWHtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790694; c=relaxed/simple;
	bh=SevGltsNGjF5DTI5HbV5gYkmdQBr+VUeS08JcqWEKbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeaP5RCGHYbZLURenEz1Sky65yXx0pyg9A8n5AnMZgtlbV/SA8KWexZZ+I58lNXEJ1p4vzoCqXncCQdgd+CiupQf6cSsL4ziC2DPaRKzoifmHEN4huEkoJXwwMRGzOAETAeedqUNZ9EeOtVF7RogNpoQZlR6+iLh1na/S9xAQKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8hxSXSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8hxSXSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A511F000FF;
	Wed, 30 Sep 2026 17:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790693;
	bh=H5tS6Pmi8OBRP/0ZWP5mwT+4mgFBtZxZ0Rl3XoOOlmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8hxSXSCKl/KIwjC/pK6NmJyL/S8iRVHd246nLn57htiEKI3xzjWRjo9+8K7UvpLX
	 fMhc03dOJuGFXyHUKEJV8WG/+GDygDLgNTPK0LUiRneDRlX9K9I5w95+1Fjdf/Dgb3
	 RTnS/+5NF3BAMADsl1cpzSYve3fLBPKpT/Tc9Cv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/752] wifi: mac80211: dont call ieee80211_handle_reconfig_failure when not needed
Date: Wed, 30 Sep 2026 17:18:32 +0200
Message-ID: <20260930152359.062670895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5b1799dfa6757..30185e82ed433 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2543,11 +2543,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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



