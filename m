Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B695F349AF5;
	Tue, 12 May 2026 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609120; cv=none; b=n3sOJeL3toaiIZvJkG4Uh1tXKa+L8w6lEplYMqHNt9Ws0KPsEOUVtVUa2DNce/Frq2UCjOWdzHwPCA3pi9P1yY82WU2SjJJGchTrMryZpp4tQJySdA3Ipkfu93wXMe1m0LFcCm0uWdkrR6kurUVxUctw+xQ2Y5zR+Tyc1ehkxcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609120; c=relaxed/simple;
	bh=hwlyQ/iOFcEwDOe6Rn4lJQpYefUEaUHQaCtai2q2OdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+yQjMeV+eG7YggZf505GwFvNS9XmqGoEzVGL4TqO571XRMYSYQrXKZV5gaKThU5P5RNR4HpMT5fPzzEAMl+HIG8mnxYr9ps1mFOPNrSshdF16pBKXFmJLimEaiL6vDtf5xDd9CmJ1EvRh7yR/7djeUkHC8ILIxOOiBukq4rCjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFEEcgJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFEEcgJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D40FC2BCC7;
	Tue, 12 May 2026 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609120;
	bh=hwlyQ/iOFcEwDOe6Rn4lJQpYefUEaUHQaCtai2q2OdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFEEcgJf3Aico3KFj3PaOFq8oNHLMzSy6n8ZGNRunn4uHyU3N/RmTfx5NuEaOCBJl
	 wqjmfjcz9YId+O8KfRT6vMX6DL0/cwxfN/E/McZDCvT1mBkDUwO6z91s51CcB0ysEc
	 6beYAGZDhLXAx04BUKk+mveeeNhF14JmCFykPMKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.0 031/307] wifi: mac80211: remove station if connection prep fails
Date: Tue, 12 May 2026 19:37:06 +0200
Message-ID: <20260512173940.782841316@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9053,7 +9053,7 @@ static int ieee80211_prep_connection(str
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *new_sta = NULL;
 	struct ieee80211_link_data *link;
-	bool have_sta = false;
+	struct sta_info *have_sta = NULL;
 	bool mlo;
 	int err;
 	u16 new_links;
@@ -9072,11 +9072,8 @@ static int ieee80211_prep_connection(str
 		mlo = false;
 	}
 
-	if (assoc) {
-		rcu_read_lock();
+	if (assoc)
 		have_sta = sta_info_get(sdata, ap_mld_addr);
-		rcu_read_unlock();
-	}
 
 	if (mlo && !have_sta &&
 	    WARN_ON(sdata->vif.valid_links || sdata->vif.active_links))
@@ -9239,6 +9236,8 @@ static int ieee80211_prep_connection(str
 out_release_chan:
 	ieee80211_link_release_channel(link);
 out_err:
+	if (mlo && have_sta)
+		WARN_ON(__sta_info_destroy(have_sta));
 	ieee80211_vif_set_links(sdata, 0, 0);
 	return err;
 }


