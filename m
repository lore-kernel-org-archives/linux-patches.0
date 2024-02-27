Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85EB13F007;
	Tue, 27 Feb 2024 13:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040764; cv=none; b=VKqUtVKPvwcM3r3lYo0BMlASHZcGcF7DgRPRRb+Co9VQ87GE2zmYPET959fZd4xkTNN3DjRZBbuVT+l/m2caDamS9VN/L1SDXaDhWZUca2qr8xPHNHo/W/HEcqWW5yHHKZpJYJaI4T+NWTsCfPHXz7iwv+PpPv31oEoT/Lr4icg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040764; c=relaxed/simple;
	bh=bG164DjzlGAqbya5QQnzoe/Ls5pnnmDOLkMiWkVw27E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFV/HawOsPY3v3ujVt5FF5w7B3uh8yqWylJRD5jb3Ka6m31vtrPACHHamdAns54BvRPCFX+IUFA4HGFCXmPOOIeIGehpmnOEG6YwkLTk76PgA/1Hz7ywOsJ5aZDSGBVGool+0KbV7kIecKEDqF33RddxnY5UCJc619qKSNlXV64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLwJd8cS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLwJd8cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF7DC433F1;
	Tue, 27 Feb 2024 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040763;
	bh=bG164DjzlGAqbya5QQnzoe/Ls5pnnmDOLkMiWkVw27E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLwJd8cSJLbD4XGR/3zrmZKZFn3bMaguMzDKOwfDfWT2iawuLYmdO1i9sAbJriKxf
	 rg33iaLEnFZ1jAvVT3GT4nG77nax7IV44jHMKnPc4VbcTiY2jOVqiy3+7tQki9ZmRa
	 tXGiXe5xTKVsjbwachSqkgCaLgYt4c0TUqBzZ7uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 102/334] wifi: mac80211: fix driver debugfs for vif type change
Date: Tue, 27 Feb 2024 14:19:20 +0100
Message-ID: <20240227131633.785127584@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 733c498a80853acbafe284a40468b91f4d41f0b4 ]

If a driver implements the change_interface() method, we switch
interface type without taking the interface down, but still will
recreate the debugfs for it since it's a new type. As such, we
should use the ieee80211_debugfs_recreate_netdev() function here
to also recreate the driver's files, if it is indeed from a type
change while up.

Link: https://msgid.link/20240129155402.7311a36ffeeb.I18df02bbeb685d4250911de5ffbaf090f60c3803@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 4 ++--
 net/mac80211/debugfs_netdev.h | 5 -----
 net/mac80211/iface.c          | 2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index dce5606ed66da..68596ef78b15e 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -997,8 +997,8 @@ static void add_link_files(struct ieee80211_link_data *link,
 	}
 }
 
-void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata,
-				  bool mld_vif)
+static void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata,
+					 bool mld_vif)
 {
 	char buf[10+IFNAMSIZ];
 
diff --git a/net/mac80211/debugfs_netdev.h b/net/mac80211/debugfs_netdev.h
index b226b1aae88a5..a02ec0a413f61 100644
--- a/net/mac80211/debugfs_netdev.h
+++ b/net/mac80211/debugfs_netdev.h
@@ -11,8 +11,6 @@
 #include "ieee80211_i.h"
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata,
-				  bool mld_vif);
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_recreate_netdev(struct ieee80211_sub_if_data *sdata,
@@ -24,9 +22,6 @@ void ieee80211_link_debugfs_remove(struct ieee80211_link_data *link);
 void ieee80211_link_debugfs_drv_add(struct ieee80211_link_data *link);
 void ieee80211_link_debugfs_drv_remove(struct ieee80211_link_data *link);
 #else
-static inline void ieee80211_debugfs_add_netdev(
-	struct ieee80211_sub_if_data *sdata, bool mld_vif)
-{}
 static inline void ieee80211_debugfs_remove_netdev(
 	struct ieee80211_sub_if_data *sdata)
 {}
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e4e7c0b38cb6e..11c4caa4748e4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1783,7 +1783,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	/* need to do this after the switch so vif.type is correct */
 	ieee80211_link_setup(&sdata->deflink);
 
-	ieee80211_debugfs_add_netdev(sdata, false);
+	ieee80211_debugfs_recreate_netdev(sdata, false);
 }
 
 static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
-- 
2.43.0



