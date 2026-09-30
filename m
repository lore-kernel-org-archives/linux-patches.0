Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDF950277A;
	Wed, 30 Sep 2026 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783652; cv=none; b=YaBmSxXRFOKDvfMIwPXI1j3GB5pP/g3ttq50NLwgw2i3TNBuWmes8wgmMxZU/aXGhbFHe/f79iXYImU5QHCNM7/tD2BOH861jbMHSkY0nRIS3aAhqQxOXKjzFM0cCxzY7vl0xsWtT/jFEHgxVxcSw3Gf2qvfjEDgc0+Qy9T1W94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783652; c=relaxed/simple;
	bh=73lAtEdUegwYSMc/HlQJxuG5z+kC6OzUo2hXCXjhLew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qykSlOlMc1t6nEmYjrhnrGkeKhggQGQsR0nfOEHZgzjtnpXHHx18OS77GWeXAGbjY6UJeLqcno3zeSbFZl5jTrIiQvISEqyJgOiWLzXLy/XidytjVcrt7z83o+jZGONo61Xyzjic0cJwDtU8mF21bbCfEmpsBqHEUnKVArVCm24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuoesuRB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuoesuRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7C31F00898;
	Wed, 30 Sep 2026 15:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783648;
	bh=ryZakyDH4HNZCQJMN08kApIAwuu9I/f3J2cVvLgv6Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuoesuRB9iSIvjhKfWI4Rt20kLrjEwdILDFYHn3xsmDWTscafj04MQVO27Oq+TLr4
	 PHkq+ZzcPAHGJMJRMdeB8lKyHbT0jLABwWWXbVpjyr4UVXn5vGae+sW6dAsW0NmNZX
	 7njufD1J9LrfuKJW3XiW1iiTrEWzyXtaEOSk0EDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com,
	Rik van Riel <riel@surriel.com>,
	syzbot+dcaca020ca8377e7ced0@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 473/595] wifi: mac80211: avoid WARN in set_bitrate_mask when sdata not in driver
Date: Wed, 30 Sep 2026 17:26:06 +0200
Message-ID: <20260930152357.855937858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2951,6 +2951,9 @@ static int ieee80211_set_bitrate_mask(st
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
+	if (!(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+		return -ENETDOWN;
+
 	/*
 	 * If active validate the setting and reject it if it doesn't leave
 	 * at least one basic rate usable, since we really have to be able


