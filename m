Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5587C3C76AF;
	Tue, 16 Jun 2026 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632380; cv=none; b=KZqaZrg43GRPuMhpo+qguPw3y2nimaaeDSsw4hIcmwtlP0QjWEQcrWUQ7oeCupzv269RVkeIm0SnolBcmhEg6yzjrOydd1x2eloMZZh8C3VGZ0ONeutLVp5sNrBqppwTgzt1AEIiYAh86pdGTClZB411dexhv8dGF/QBYKre9LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632380; c=relaxed/simple;
	bh=nygm+PE+0lKYrsCXc32lrs90u6ZgPWxgp7dbGIUB66E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz/i4++QikHr6lhTex0ATcc/JIuwWkLmowEuTiTGaDwrhdKSxx32v4DNpZAoS4fe3ictxhZKKogpL1mVIQ82c0CiB4ruwodID3xGCQdfausJrQXmO0DkCVR0wrpUcbjb6yV+zJO5erD1nZERfSEtKdUDpMAYjgnaRnC2/T135zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KU7kes/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KU7kes/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD0A1F000E9;
	Tue, 16 Jun 2026 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632377;
	bh=R+rU7486WVez4f2z15OCPAl6fJxmNgG6PZjz/4TaSK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KU7kes/EAIwU1xXSOjcAmLF1CMqenVd/mX180koEKhRYl3OFOjL3bIZnmFYOr6t0v
	 cQKETYK1CZHIo4JcIiGIDN4JnPyrZJDuP6JZtqI5RlEzzKLxtbD5HO59OJ/N1OGNEq
	 0pbqhgR8bcv+/lMV3sWAWDAe9Q4AapSzkiAa7Aqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 372/522] wifi: mac80211: remove station if connection prep fails
Date: Tue, 16 Jun 2026 20:28:39 +0530
Message-ID: <20260616145143.177105383@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 283fc9e44ff5b5ac967439b4951b80bd4299f4e4 ]

If connection preparation fails for MLO connections, then the
interface is completely reset to non-MLD. In this case, we must
not keep the station since it's related to the link of the vif
being removed. Delete an existing station. Any "new_sta" is
already being removed, so that doesn't need changes.

This fixes a use-after-free/double-free in debugfs if that's
enabled, because a vif going from MLD (and to MLD, but that's
not relevant here) recreates its entire debugfs.

Cc: stable@vger.kernel.org
Fixes: 81151ce462e5 ("wifi: mac80211: support MLO authentication/association with one link")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260505151533.c4e52deb06ad.Iafe56cec7de8512626169496b134bce3a6c17010@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ used sta_info_destroy_addr() instead of __sta_info_destroy() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6586,7 +6586,7 @@ static int ieee80211_prep_connection(str
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *new_sta = NULL;
 	struct ieee80211_link_data *link;
-	bool have_sta = false;
+	struct sta_info *have_sta = NULL;
 	bool mlo;
 	int err;
 
@@ -6751,6 +6751,8 @@ static int ieee80211_prep_connection(str
 
 out_err:
 	ieee80211_link_release_channel(&sdata->deflink);
+	if (mlo && have_sta)
+		WARN_ON(sta_info_destroy_addr(sdata, ap_mld_addr));
 	ieee80211_vif_set_links(sdata, 0);
 	return err;
 }


