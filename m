Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD74276057;
	Tue, 27 May 2025 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364857; cv=none; b=RoJ2+zgZ93HsGTVcCDqTW3vAvCwpF0DicxIoe3r7xCAaeCYcYMcmqnn3ivmNA/08XkUGCh+nIO8ulT9lzxf2UBuuQy0jC9UVFvBJBSmpgF4tnHseWkET1yQON4mMqQT9xwqgmipQ7LHgbMC4cq7CTeuWsucpm/Kdbpd2qgUQghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364857; c=relaxed/simple;
	bh=7P5+AqYcV5ovo9c44vtQpH6IZQTkxE5aHRrnmMXLpbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJcYHma3065b1UaYLyteyr1awTxMOGcI/1L7nOs2Soo8aP7j5h1h9EqYHPGuVbMYwms0/QDDh4EpEUnlM5S0Bdh1HxwUSWBesEDNr7h+GQelzNmz3s8DE/uoOOJv4M+j52TAhC5mLQEAaidkQOZirmnQc3GaAreTi+siaatjqfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2fy/bhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2fy/bhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA72C4CEE9;
	Tue, 27 May 2025 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364857;
	bh=7P5+AqYcV5ovo9c44vtQpH6IZQTkxE5aHRrnmMXLpbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2fy/bhkOxy4qvxvoUpEtNlwgGP9LCjZKrqrrqMLNX1cqDXMWBqmsNGcbwnVk3BcY
	 gpOAosfhGsyCkoH/wFs9dEhIx4bVekpERKu1eb8jFvDTPJkd56AeNpIb2DNq2OKx7M
	 /8gcpOjM/XUuqjie7tujCKu2+SXSjwNWscAms8MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/626] wifi: mac80211: fix warning on disconnect during failed ML reconf
Date: Tue, 27 May 2025 18:21:22 +0200
Message-ID: <20250527162452.695482539@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0e104aa3676d020f6c442cd7fbaeb72adaaab6fc ]

If multi-link reconfiguration fails, we can disconnect with a local link
already allocated but the BSS entry not assigned yet, which leads to a
warning in cfg80211. Add a check to avoid the warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308225541.699bd9cbabe5.I599d5ff69092a65e916e2acd25137ae9df8debe8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cc8c5d18b130d..3a279ded46c2f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4033,7 +4033,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 			struct ieee80211_link_data *link;
 
 			link = sdata_dereference(sdata->link[link_id], sdata);
-			if (!link)
+			if (!link || !link->conf->bss)
 				continue;
 			cfg80211_unlink_bss(local->hw.wiphy, link->conf->bss);
 			link->conf->bss = NULL;
-- 
2.39.5



