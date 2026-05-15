Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EDF3F58FC;
	Fri, 15 May 2026 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861080; cv=none; b=cx5hyvYe17JBIdENqJoJKOUIco5UbLFjFzhcvsK4y2Lf4420+nDrop9PKimN2T9o5qDESkNH4jYBRxjCcRBGPc6NWGkc28i2ezcR1oj7cA77IcDVKcbShcEJIJnpiOgUMi1uNSeEKZATFo5btkGKHaIF2Kgtna9qkkr2/60w6X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861080; c=relaxed/simple;
	bh=Z//QNG2qaYEkFLArtCgrFiAPOSOrhT6Xlmbfy/FW/Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RppxA3BC4GosH3nABNG9gHocjA9K/8OrHuIqEbW9/MWdTuxEZlzMIaIIjO5JB7A1DOFfa6/0cKtR4q42NRrK34h0f+VggPU/H5xF7k00/JZTLMQBmynEpzhocwAEFERrV6LIIAP1Uk/DC6CJzlUjKt7w6L/3NVS8IVrA36h9ty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgmgyOiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgmgyOiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A9CC2BCB3;
	Fri, 15 May 2026 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861080;
	bh=Z//QNG2qaYEkFLArtCgrFiAPOSOrhT6Xlmbfy/FW/Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgmgyOiXIilI+BSMmWi1lLnhmgPf5jXKf58FMVv8dPtG0WhiG/T/k03qkirneG4D7
	 XUZ1XrD57PIdO7iW6n+1hVYQdTt94demT57dwtJ/o+trPfvfQzTjh89P/Ekmq1o8Cb
	 +tjoIcIWCiaAkXuqCxGsKlwy47D9dP9XfbfcD8cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 190/474] wifi: mac80211: remove station if connection prep fails
Date: Fri, 15 May 2026 17:44:59 +0200
Message-ID: <20260515154719.131514015@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 283fc9e44ff5b5ac967439b4951b80bd4299f4e4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6940,7 +6940,7 @@ static int ieee80211_prep_connection(str
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *new_sta = NULL;
 	struct ieee80211_link_data *link;
-	bool have_sta = false;
+	struct sta_info *have_sta = NULL;
 	bool mlo;
 	int err;
 
@@ -6978,11 +6978,8 @@ static int ieee80211_prep_connection(str
 		goto out_err;
 	}
 
-	if (assoc) {
-		rcu_read_lock();
+	if (assoc)
 		have_sta = sta_info_get(sdata, ap_mld_addr);
-		rcu_read_unlock();
-	}
 
 	if (!have_sta) {
 		if (mlo)
@@ -7106,6 +7103,8 @@ static int ieee80211_prep_connection(str
 out_release_chan:
 	ieee80211_link_release_channel(link);
 out_err:
+	if (mlo && have_sta)
+		WARN_ON(__sta_info_destroy(have_sta));
 	ieee80211_vif_set_links(sdata, 0, 0);
 	return err;
 }


