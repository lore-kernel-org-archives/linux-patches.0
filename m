Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AE83B1EE2;
	Tue, 12 May 2026 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607795; cv=none; b=LdTltYZeZEJpi2Gq0xg7MHfV7kV3P4SYawcQivjeOJw0NgbIlOexoMojMVCCBqD8zHyxdKB40B1yTNu9yJ5KgjigcWPjw3alaX+gGPGm+3unL+pOKhkoq9axjXiJvV9P2qXMsAzudlPuyD2UZMUDv9zRxC3h57vhNT3xttAZNv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607795; c=relaxed/simple;
	bh=XeTZ6t5wUMM+wt1f+WOoJLr7gYMkhx5IA+zt5eZW8z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkEjz0eotSGnb6mVtAFOEQDQgeffN5trrF2mTDNiEYx0z1w0JGpqxYr57BiCbJkHAD/zJx9aokdLb0xiwr9TLFsx6BptQ+WIgr4XQ3ju9IKcjKnyFWOz9Ggx0KTQOY1+XY4a6LP1orJKI87u9bKc99HZiVVzgchyxXbAUc1aYRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBdLU7u3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBdLU7u3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC857C2BCB0;
	Tue, 12 May 2026 17:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607795;
	bh=XeTZ6t5wUMM+wt1f+WOoJLr7gYMkhx5IA+zt5eZW8z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBdLU7u3IORMH+xAr8YzHej9mcgHRHzotqf3+AJivxIoYsqbq/+EFQmJ/fTS/dl9L
	 E+86i7JOMMMkMtLJj55ouqPaebSe+8w+20b67dy7CIVqUHSe+GxVvLyQhynWk3T9nR
	 MVNd2C2e/n15OYa2uUzfUcVkq/cQqAlH9XUygNPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 038/206] wifi: mac80211: remove station if connection prep fails
Date: Tue, 12 May 2026 19:38:10 +0200
Message-ID: <20260512173933.638973704@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
@@ -8177,7 +8177,7 @@ static int ieee80211_prep_connection(str
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *new_sta = NULL;
 	struct ieee80211_link_data *link;
-	bool have_sta = false;
+	struct sta_info *have_sta = NULL;
 	bool mlo;
 	int err;
 
@@ -8215,11 +8215,8 @@ static int ieee80211_prep_connection(str
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
@@ -8352,6 +8349,8 @@ static int ieee80211_prep_connection(str
 out_release_chan:
 	ieee80211_link_release_channel(link);
 out_err:
+	if (mlo && have_sta)
+		WARN_ON(__sta_info_destroy(have_sta));
 	ieee80211_vif_set_links(sdata, 0, 0);
 	return err;
 }


