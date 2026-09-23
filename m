Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D59B51EE1A;
	Wed, 23 Sep 2026 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172846; cv=none; b=ZIdYmqDWGfoq80HD66qFFs1Z7X90jCKeCNm062uPY2lD6agZArHS54zqOMVaKFsqGNlJHcG5+4ppbsoSjC8dshB006OIcnjK8lIisCviE63j7nvTN6Q3+/3C9S2evN3/Kj6KnfTjxlikCkvNCJ3YCLzy4KxcOu+estjbXFt3tSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172846; c=relaxed/simple;
	bh=Hd6bEj8P1Um+ITgNr4yUg5FD/E7OAzs+fBRotCTSNOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d90pMr+j79BwbBxDEX3UsHKE/tOPZvadU3TEQjHp/QnCFN3x1rxxBFIZwkuZz751krxVR5UpulCH9e3hwfLCrY+CxMBeubSIME9FIFgCtmnIES/upghNxNldX657jdmNHhFdFMGu85zcJdKchMdbn/Aa8TPeiXE4LzlYbjLQNcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXLm2ckR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXLm2ckR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9853C1F000FF;
	Wed, 23 Sep 2026 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172845;
	bh=ojy2Ez+4dROi7nznEAsef5TT2g+bmOkb6i+fLoRBpEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXLm2ckRgJDqjiF4KH8rE7e7+DtLhAQUE+HuTvYwEjsiu/KSKQWMLQSKiwRcvvRpM
	 Ylja8MWpHXl4oqj3PiZFJx53Zx4kRAudu/3Wm5VrtRC//MrLISZkIN0VmuqeQ4/eaw
	 EKh2lnmnzZSHLn+lu6nNRaYLNJjl9VJT3wDYkMDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e84ecca6d1fa09a9b3d9@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 075/438] wifi: mac80211: reset the LED state when ifup fails
Date: Wed, 23 Sep 2026 16:01:36 +0200
Message-ID: <20260923140646.729779388@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 78183e8331958fda11cd2b6850bb424a9747c4b2 ]

When the first interface comes up, the radio LED is turned on. This can
start the TPT trigger timer, which continues running.

But if bringing up the interface fails then the timer keeps running and
won't be stopped by anything, eventually it can be freed:

  ODEBUG: free active (active state 0) object: ffff888127e12130 object type: timer_list hint: tpt_trig_timer+0x0/0x300 net/mac80211/led.c:145
  WARNING: CPU: 0 PID: 5923 at lib/debugobjects.c:612 debug_print_object+0x1a2/0x2b0
   debug_check_no_obj_freed+0x4b7/0x600 lib/debugobjects.c:1129
   kfree+0x436/0x670 mm/slub.c:6818
   ieee80211_led_exit+0x162/0x1c0 net/mac80211/led.c:210
   ieee80211_unregister_hw+0x27e/0x3a0 net/mac80211/main.c:1706
   rt2x00lib_remove_dev+0x55b/0x670

Undo the LED state in the error path.

Assisted-by: LLM
Fixes: 67408c8c7b9d ("mac80211: selective throughput LED trigger active")
Reported-by: syzbot+e84ecca6d1fa09a9b3d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e84ecca6d1fa09a9b3d9
Link: https://patch.msgid.link/20260904165722.044aa432f873.I601a67a2cd558b8ef8416a07554ae7efe896e9d8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8c300e045fdf9..4c34c3287eb4a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1606,8 +1606,12 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
  err_del_interface:
 	drv_remove_interface(local, sdata);
  err_stop:
-	if (!local->open_count)
+	if (!local->open_count) {
+		ieee80211_led_radio(local, false);
+		ieee80211_mod_tpt_led_trig(local, 0,
+					   IEEE80211_TPT_LEDTRIG_FL_RADIO);
 		drv_stop(local, false);
+	}
 	if (sdata->vif.type == NL80211_IFTYPE_NAN_DATA)
 		RCU_INIT_POINTER(sdata->u.nan_data.nmi, NULL);
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-- 
2.53.0



