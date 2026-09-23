Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13850352017;
	Wed, 23 Sep 2026 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175158; cv=none; b=enZu2fQRLA8m2yfweaBqULjAq42FfmCESD/qDNlH7K5/P38K4jxMp6B/IoAhYkX+4h6su9br/aJbBrLFJLaQUlGb5FBl7ASgY4geu8IR4juzVinapu2JHkTGiDv9KL2Y/8BWFkNk791lBZQNH++Bu1ZEqkMqzjJt/qGsdWtyojs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175158; c=relaxed/simple;
	bh=pE1miGGZBSi1mLG5rWNX2hizKfCk/t6B3AEjCEIEJgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbNe4TpF2vRYcqGptv1yEY6iwFH+An9F4QgwtnbB182KAS/OYtx/rqqRK5YldOblznNxbwW0UimePqnJIJtiKJCpBORj1OIvuo39+gBQiEELUwGxcNOluyaTyhxV6Aaq58uA+Vd/1ognG6DFmzRL6x2YJ+FCRDrBhnn+RA8Vr+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0sVVsKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0sVVsKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825B21F00893;
	Wed, 23 Sep 2026 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175154;
	bh=sCQGWDOrtSIDkqh4GJvIz/jp5ZmoGeqCmSGL4BX2sFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0sVVsKhKEjfztRI4xsy9zdiS4Nd/GgRlpxTT8uQ+ruA+HP9VdY6tRP93Gx98J5GD
	 cBJaayTU1PMymkR5S6R5374Bo16Q8ZdnPiugdg0/O0k1kNX9u3ppJ64vGNMT+SkKSl
	 Xgp+o6A/z5bJ/+wI4sYC2SbUlcjn6cm/DDC8aNr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com,
	Rik van Riel <riel@surriel.com>,
	syzbot+dcaca020ca8377e7ced0@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 337/398] wifi: mac80211: avoid WARN in set_bitrate_mask when sdata not in driver
Date: Wed, 23 Sep 2026 16:06:51 +0200
Message-ID: <20260923140652.159305310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Rik van Riel <riel@surriel.com>

commit da2ca406f45a6e21760243152ed8d2e8e72915c2 upstream.

ieee80211_set_bitrate_mask() checks if the interface is running via
ieee80211_sdata_running(), but it does not check if the interface is
still present in the driver.

When sdata is running but IEEE80211_SDATA_IN_DRIVER is not set, the
call reaches drv_set_bitrate_mask() in driver-ops.h which hits

  wlan1: Failed check-sdata-in-driver check, flags: 0x0
  WARNING: net/mac80211/driver-ops.h:884 at drv_set_bitrate_mask

Syzkaller triggers this via wext SIOCSIWRATE ioctl. The Call Trace shows
wext_ioctl_dispatch() in wext-core.c dispatching the ioctl, calling
ioctl_standard_call() for SIOCSIWRATE, which calls cfg80211_wext_siwrate()
in wext-compat.c. That builds a bitrate mask and calls
rdev_set_bitrate_mask() which ends up in ieee80211_set_bitrate_mask() in
cfg.c. The interface is marked running via SDATA_STATE_RUNNING but
flags is 0, so check_sdata_in_driver() fails.

When the interface is being torn down, or when wext ioctl is issued
during interface bringup before drv_add_interface() sets IN_DRIVER, the
running check passes while IN_DRIVER is clear.

Check IEEE80211_SDATA_IN_DRIVER in ieee80211_set_bitrate_mask() before
calling the driver, returning -ENETDOWN. This avoids the WARN_ONCE in
driver-ops.h and matches other cfg.c operations that bail early when not
in driver.

This change should be safe because wiphy mutex is held in
cfg80211_wext_siwrate() via guard(wiphy), and IN_DRIVER is set/cleared
under RTNL and wiphy paths in drv_add_interface() and
drv_remove_interface() in driver-ops.c, so the check is race-free
against driver add/remove. Returning -ENETDOWN is the same error other
not-running paths use and does not introduce new locking.

Reported-by: syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=af177aa139efdd13a9da
Link: https://lore.kernel.org/all/6a75205c.59b6c763.2bba34.00c3.GAE@google.com/
Fixes: 554a43d5e77e ("mac80211: check sdata_running on ieee80211_set_bitrate_mask")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2 syzkaller
Signed-off-by: Rik van Riel <riel@surriel.com>
Link: https://patch.msgid.link/20260808104755.319c686e@fangorn
Reported-by: syzbot+dcaca020ca8377e7ced0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dcaca020ca8377e7ced0
[also add second syzbot report]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3738,6 +3738,9 @@ static int ieee80211_set_bitrate_mask(st
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
+	if (!(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+		return -ENETDOWN;
+
 	/*
 	 * If active validate the setting and reject it if it doesn't leave
 	 * at least one basic rate usable, since we really have to be able


