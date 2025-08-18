Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD30346A09;
	Mon, 18 Aug 2025 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525475; cv=none; b=GlxeOV13yN5P3WvF6neHPKtPT+4Kse2rWcwktb/705Rb4ZMeirMYZP4Nx8Elr2Cumf8Q5kqTS86+hNyRNeDjtKRJlylSBF/TAEkcioqtHnV+b7hH+BUVMXLriUFLs+BaYKH0tciSAho7u/xbKtcd6JeHhhydQTdnB575YADuVc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525475; c=relaxed/simple;
	bh=3inpm9HEl7Ag3K04oEvqQBtFS9zzwcsVYY6PUSyEsjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guRyBBTTEkcrzYHl29gAXzh/ZjOFeSDLb38hLWR9mluRH2By3p3lF2ZV5HAwcZJbEWfWeQ10lTpbzvnQ2fY1ZNtax3ZviwABTqqT4pZP8mGtqMCjyIBtL0/7vWnGVWFKmJ/n2JD3HRaFd2KO+IHcQyGLOgDlUFbzFD2TBjmLxSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ib2dMJ6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ib2dMJ6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB923C4CEEB;
	Mon, 18 Aug 2025 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525475;
	bh=3inpm9HEl7Ag3K04oEvqQBtFS9zzwcsVYY6PUSyEsjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ib2dMJ6xcjuPWejK3776k615f3O3WNw86faHx3TF3sr4Lq/FLzt5NQ0YKH8sRFGPZ
	 lKTPEGfHfClInhwLCY2x8RZNwsnAdL0y49K9Xmgy/0SVEStJSxeLtzTOO57v3i14F1
	 czMICEe3ZXw0VHKEMH7GtvKKE8nVkt17J28f2gZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 243/570] wifi: mac80211: dont unreserve never reserved chanctx
Date: Mon, 18 Aug 2025 14:43:50 +0200
Message-ID: <20250818124515.182474620@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a6d521bafcb290294128a51b13dbf4baae5748fc ]

If a link has no chanctx, indicating it is an inactive link
that we tracked CSA for, then attempting to unreserve the
reserved chanctx will throw a warning and fail, since there
never was a reserved chanctx. Skip the unreserve.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709233537.022192f4b1ae.Ib58156ac13e674a9f4d714735be0764a244c0aae@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 42bb996157e9..60f943f133ac 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2535,7 +2535,8 @@ ieee80211_sta_abort_chanswitch(struct ieee80211_link_data *link)
 	if (!local->ops->abort_channel_switch)
 		return;
 
-	ieee80211_link_unreserve_chanctx(link);
+	if (rcu_access_pointer(link->conf->chanctx_conf))
+		ieee80211_link_unreserve_chanctx(link);
 
 	ieee80211_vif_unblock_queues_csa(sdata);
 
-- 
2.39.5



