Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB283EDE4E;
	Tue, 12 May 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608420; cv=none; b=VLqrDZwXm7d+7JO7YNecwacnpx/gU3SLrw2loj7gBJjZkCWiorus02DX005tVh+llNK+VNiJFXVIYwK8Gpng3kSXxHN5PgfYaGGgjloHV+skdGXRVG+q0+kxbL+Lhk7MjlPtskhvfB16YA/Tu9HHAFDQOjSbEQ96R3luuOranfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608420; c=relaxed/simple;
	bh=x+dBPVf8g2mejnqmz4uUQrEPHofRpIUmsi4VYgp6Ido=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tom8JNPC37L7ZF9Ln/++7WnhQJypmoyDZKHx09YS8zHhdmxDV1i0cw3b4es8WU61ekr65NK2cCNULCj367vozOQFPMZ8sZTK/jvDmdo5YagPm6rYSSb/M+Hh4RA+KJ/r0+7SXjkQiQCMgMCzrvB78GxOgIrqjpY1h1gd1rJro+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHQb5Yhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHQb5Yhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809C9C2BCB0;
	Tue, 12 May 2026 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608419;
	bh=x+dBPVf8g2mejnqmz4uUQrEPHofRpIUmsi4VYgp6Ido=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHQb5YhwScBMa/bOAJgtEZ9Q/0gTdDdW7dyPUapdTmJWsMd66aGJvL44BOs+KCp6k
	 ki9Gg1K+SJsAsRjEmUSfhXlhrDGz52BH4tD7PzBLjiAdXjOFApARLkmPixAO6KbFDW
	 b6vXsfDZuXS5EAAJPPIv8aZDa3/7th3PBKzX5vaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 035/270] wifi: mac80211: remove station if connection prep fails
Date: Tue, 12 May 2026 19:37:16 +0200
Message-ID: <20260512173939.194978459@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -8926,7 +8926,7 @@ static int ieee80211_prep_connection(str
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *new_sta = NULL;
 	struct ieee80211_link_data *link;
-	bool have_sta = false;
+	struct sta_info *have_sta = NULL;
 	bool mlo;
 	int err;
 	u16 new_links;
@@ -8945,11 +8945,8 @@ static int ieee80211_prep_connection(str
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
@@ -9108,6 +9105,8 @@ static int ieee80211_prep_connection(str
 out_release_chan:
 	ieee80211_link_release_channel(link);
 out_err:
+	if (mlo && have_sta)
+		WARN_ON(__sta_info_destroy(have_sta));
 	ieee80211_vif_set_links(sdata, 0, 0);
 	return err;
 }


