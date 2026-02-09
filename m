Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0D936EA81;
	Mon,  9 Feb 2026 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647460; cv=none; b=OiaE7ZiiHlX8FGEUsBHrnpJLSTDm5/Wv+QxSKJbI+sk3Ri3uBOZmdaE24KVysG+vkW7rySdQgH/+FLE8vyjn7p47Zi/00sl8v7kg/PqAr4A95u+bfO58VBhRU5q1Wzqnm3IGlfQyw/wCKEapkGnHIKJqxPRQKZXo/FqPoG0vCCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647460; c=relaxed/simple;
	bh=XzVZKsykTpA5r3L4Xhy43+9CCY8ve65roVgWBGQ/GS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFDZh9XOC8eBvA3fBrl1XbJ7Z7jP5h/9P0fWiWxehmOnQ4b/WM0JMFA0e7zuqVNYsWO62JLqg8paXLPK5TJuTaDjobsnhQzTqSXvvry5YWpwqGBAOS9ftosdy8gBn49qFjuqjn3V8UO2htD2qu0ewooWuKfB56pXD+Ix41cT0Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9zA9ZSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9zA9ZSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D16C116C6;
	Mon,  9 Feb 2026 14:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647460;
	bh=XzVZKsykTpA5r3L4Xhy43+9CCY8ve65roVgWBGQ/GS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9zA9ZSmMWMKftyh+GswgMHPpvEi7mb7EH88e9yiQjLx7hgFpgb1CLFtxPjksrfyA
	 ZJ9JCWlKCfi+9n0e6lSdUJdh9veIPd3adln0euqlO5VG4cP4NM3titUL446v8UpyL6
	 joOELn7yCnw0bqmIv/hzoLnw8DsbPXOhquOK8ttg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/175] wifi: mac80211: correctly check if CSA is active
Date: Mon,  9 Feb 2026 15:22:59 +0100
Message-ID: <20260209142324.236960920@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

[ Upstream commit db1d0b6ab11f612ea8a327663a578c8946efeee9 ]

We are not adding an interface if an existing one is doing CSA.
But the check won't work for MLO station interfaces, since for those,
vif->bss_conf is zeroed out.
Fix this by checking if any link of the vif has an active CSA.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260111191912.7ceff62fc561.Ia38d27f42684d1cfd82d930d232bd5dea6ab9282@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0ca55b9655a7f..72c129478da08 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -350,6 +350,8 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		if (nsdata != sdata && ieee80211_sdata_running(nsdata)) {
+			struct ieee80211_link_data *link;
+
 			/*
 			 * Only OCB and monitor mode may coexist
 			 */
@@ -376,8 +378,10 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 			 * will not add another interface while any channel
 			 * switch is active.
 			 */
-			if (nsdata->vif.bss_conf.csa_active)
-				return -EBUSY;
+			for_each_link_data(nsdata, link) {
+				if (link->conf->csa_active)
+					return -EBUSY;
+			}
 
 			/*
 			 * The remaining checks are only performed for interfaces
-- 
2.51.0



