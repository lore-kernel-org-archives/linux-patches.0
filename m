Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C8C5326AC;
	Wed, 23 Sep 2026 14:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173961; cv=none; b=GAJhKIgFE91mV1MQgJnzqYtGuDzrHV3wfwX6eBUZnJKWcBngd/hhCRArbI5SqYVOPsYSv1cbQ12qpyl7JhuSemVDx84YofcS+P/gKYfBq1HNt5/ugBobZ1/lSUJlZxStfddlFzCSSdSUNGPG1iixxqohxHSs6HVYGJccwzlVsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173961; c=relaxed/simple;
	bh=AR+CiD/oIjeFJA2svzUMoJlejweM+kZjv5Ys43V6EaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QErz3JrO2KHmkXTr1e8ws8le1qBUfFby/nHbUkvPrnA98FhOe/lUFp2Fycgn9hHV6SPQhjW76BZ3mPtx+zNtj3DLAU/elN6qpOmJduxBkCCO6QMFEZ08Zswh/S8ocgW41VEakhobYki1paifZc16DCywpGFwxVdMI7UvRjLOeSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOSMbf3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOSMbf3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E578D1F00893;
	Wed, 23 Sep 2026 14:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173960;
	bh=cqa+UmQZpRYE46rnn8GfuonaZZVFZy4tNwhoWfXL41g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OOSMbf3OOa+e6+VwJNL7LqxSFS8j2IKdma3iMnd0BCrc+NHP6cBVHvklyUCvZAU4P
	 /ioy3IDPxAeU2hX9G/RT06UcReRY8DFZH+1NfVwslyW68h7Z8tehsg9ZyppPx6MUZ0
	 rbbyqmSzgUSlZzdjKsrX/AYaepzPmf8WZjcgzdg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com,
	Rik van Riel <riel@surriel.com>,
	syzbot+dcaca020ca8377e7ced0@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 397/438] wifi: mac80211: avoid WARN in set_bitrate_mask when sdata not in driver
Date: Wed, 23 Sep 2026 16:06:58 +0200
Message-ID: <20260923140655.181002294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4120,6 +4120,9 @@ static int ieee80211_set_bitrate_mask(st
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
+	if (!(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+		return -ENETDOWN;
+
 	/*
 	 * If active validate the setting and reject it if it doesn't leave
 	 * at least one basic rate usable, since we really have to be able


