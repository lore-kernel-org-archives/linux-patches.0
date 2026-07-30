Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29F943F0BE;
	Thu, 30 Jul 2026 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421276; cv=none; b=NWKOJeiwAUwSr7P6EC81AYeUwhEqjhxmS0I/Zc8aM2BYgKzbzaEXZdOZUE0O0zFvoo6q45+ptCeyfWa6kX2hA28oliOMV2fKPH1xDVCyvL3E96+N35xFjMh1QhdFkg35ZIcK00kM6gFr5GiO5kWREPyUEJqX2v2P/+JHqn4qkVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421276; c=relaxed/simple;
	bh=QBAROHmgIXCi4DJ+Vdg7DQ31PLW8Ieul7KloCNJvwjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGTfDpLwjKDoRjBVQoYEw8wiKxItkIwZrCtRw5i34R1UUsSpXO15C5tKhwRanAm9g2DHwSas0QcsiY2YOxv4z2voQZiIasvXViJHAEmZW4p2hctULzJ7jfecoY5HmFlfzUiBDP55kcaFmDncOSajiOwPOqHZQJBt8EOF6omalgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzguSVB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzguSVB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4021F00A3A;
	Thu, 30 Jul 2026 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421270;
	bh=Xg3dgpyFx39792mQUfDkbeCsdczqD7iuqTJ9MkoxCIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzguSVB4A0Lau9Pc2Lc6k/fmi6gH3U9CztCNQ/p0QsAo/LdjNxnO3qeIRBILdycTJ
	 qOmNNGrxYz77GOnOm9LORbVuf8QM2Ye3nK2pW8KdtVOAY8PxNjmmFWYVk3XYejmvjp
	 mWNTvYIUf2s9IUps21KHFzytmIVRe5+IMpXvbLM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 048/744] wifi: mac80211: allocate backup ieee80211_nan_sched_cfg off stack
Date: Thu, 30 Jul 2026 16:05:21 +0200
Message-ID: <20260730141445.301094234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 44494b0d1d16e76ae805817579eacc801b10ed37 ]

The ieee80211_nan_sched_cfg structure is too large to keep on the
per thread stack:

net/mac80211/nan.c:251:5: error: stack frame size (1560) exceeds limit (1536) in 'ieee80211_nan_set_local_sched' [-Werror,-Wframe-larger-than]
  251 | int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,

Allocate this dynamically using kmalloc_obj() to reduce the stack
usage of this function to a manageable 344 bytes for the same
configuration.

Fixes: 589c06e8fdee ("wifi: mac80211: add NAN local schedule support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260611130100.3387714-1-arnd@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/nan.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/nan.c b/net/mac80211/nan.c
index 4e262b624521d2..d089b18321e44c 100644
--- a/net/mac80211/nan.c
+++ b/net/mac80211/nan.c
@@ -253,9 +253,12 @@ int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_nan_channel *sched_idx_to_chan[IEEE80211_NAN_MAX_CHANNELS] = {};
 	struct ieee80211_nan_sched_cfg *sched_cfg = &sdata->vif.cfg.nan_sched;
-	struct ieee80211_nan_sched_cfg backup_sched;
+	struct ieee80211_nan_sched_cfg *backup_sched __free(kfree) = kmalloc_obj(*backup_sched);
 	int ret;
 
+	if (!backup_sched)
+		return -ENOMEM;
+
 	if (sched->n_channels > IEEE80211_NAN_MAX_CHANNELS)
 		return -EOPNOTSUPP;
 
@@ -275,13 +278,13 @@ int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
 
 	bitmap_zero(sdata->u.nan.removed_channels, IEEE80211_NAN_MAX_CHANNELS);
 
-	memcpy(backup_sched.schedule, sched_cfg->schedule,
-	       sizeof(backup_sched.schedule));
-	memcpy(backup_sched.channels, sched_cfg->channels,
-	       sizeof(backup_sched.channels));
-	memcpy(backup_sched.avail_blob, sched_cfg->avail_blob,
-	       sizeof(backup_sched.avail_blob));
-	backup_sched.avail_blob_len = sched_cfg->avail_blob_len;
+	memcpy(backup_sched->schedule, sched_cfg->schedule,
+	       sizeof(backup_sched->schedule));
+	memcpy(backup_sched->channels, sched_cfg->channels,
+	       sizeof(backup_sched->channels));
+	memcpy(backup_sched->avail_blob, sched_cfg->avail_blob,
+	       sizeof(backup_sched->avail_blob));
+	backup_sched->avail_blob_len = sched_cfg->avail_blob_len;
 
 	memcpy(sched_cfg->avail_blob, sched->nan_avail_blob,
 	       sched->nan_avail_blob_len);
@@ -377,17 +380,17 @@ int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
 		if (!chan_def->chan)
 			continue;
 
-		if (!cfg80211_chandef_identical(&backup_sched.channels[i].chanreq.oper,
+		if (!cfg80211_chandef_identical(&backup_sched->channels[i].chanreq.oper,
 						chan_def))
 			ieee80211_nan_remove_channel(sdata,
 						     &sched_cfg->channels[i]);
 	}
 
 	/* Re-add all backed up channels */
-	for (int i = 0; i < ARRAY_SIZE(backup_sched.channels); i++) {
+	for (int i = 0; i < ARRAY_SIZE(backup_sched->channels); i++) {
 		struct ieee80211_nan_channel *chan = &sched_cfg->channels[i];
 
-		*chan = backup_sched.channels[i];
+		*chan = backup_sched->channels[i];
 
 		/*
 		 * For deferred update, no channels were removed and the channel
@@ -418,11 +421,11 @@ int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	memcpy(sched_cfg->schedule, backup_sched.schedule,
-	       sizeof(backup_sched.schedule));
-	memcpy(sched_cfg->avail_blob, backup_sched.avail_blob,
-	       sizeof(backup_sched.avail_blob));
-	sched_cfg->avail_blob_len = backup_sched.avail_blob_len;
+	memcpy(sched_cfg->schedule, backup_sched->schedule,
+	       sizeof(backup_sched->schedule));
+	memcpy(sched_cfg->avail_blob, backup_sched->avail_blob,
+	       sizeof(backup_sched->avail_blob));
+	sched_cfg->avail_blob_len = backup_sched->avail_blob_len;
 	sched_cfg->deferred = false;
 	bitmap_zero(sdata->u.nan.removed_channels, IEEE80211_NAN_MAX_CHANNELS);
 
-- 
2.53.0



