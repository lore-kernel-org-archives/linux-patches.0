Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E6B4315F;
	Thu, 25 Jul 2024 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919071; cv=none; b=QAKY6AMnofPoE29P/mENeVkGeWwjxMc9zryw6JtTHma7vw7C0sQQhOFAZMa1FzK4WsJZ3hzz34Dcz5bCghQUEaIpjKb2/yU7o1GbfIBIcoM0AuhPaFY8oPgTFQj2mfal0OMEhAO8NT5Udx0iDkYOk5pg7vptoytQgOqz0fNnbXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919071; c=relaxed/simple;
	bh=5zAkD4uy2NJ0WdC3QIe4He+F17SxZR60mi6F6Ogq6bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buAfP6OS3AgJHwRtIWrpYVkqiTvYez2l34BBRtOtXp25D9W8LRjfqq29uG1l882M2+2ilDD1ydVNjlJmC6S5x3yjG2p/BnZr91UX013YCZ9dPC0R5taItHeRXg8e/ljbKjF13AvMZNIPZgvv3hvq1YaTKT0Z+lRBbGfGJ7lDc/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjeGjRQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjeGjRQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC82EC116B1;
	Thu, 25 Jul 2024 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919071;
	bh=5zAkD4uy2NJ0WdC3QIe4He+F17SxZR60mi6F6Ogq6bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjeGjRQIZnWs/WV4KhkulakZVErYsKzWtECmOzbcGjulvCJFeOzCbEmLYWHz1iSUF
	 jpujCJzigmZBhtrK7s0BvAQD3unc9emI1tee7wz75h7OVlnaY02LDacFINT294GHHS
	 eSR9cNy4Ve3jYL3n8fn6aMuj1fxvHYeB2F/k8uX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8830db5d3593b5546d2e@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/87] wifi: mac80211: handle tasklet frames before stopping
Date: Thu, 25 Jul 2024 16:36:48 +0200
Message-ID: <20240725142739.007940535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 177c6ae9725d783f9e96f02593ce8fb2639be22f ]

The code itself doesn't want to handle frames from the driver
if it's already stopped, but if the tasklet was queued before
and runs after the stop, then all bets are off. Flush queues
before actually stopping, RX should be off at this point since
all the interfaces are removed already, etc.

Reported-by: syzbot+8830db5d3593b5546d2e@syzkaller.appspotmail.com
Link: https://msgid.link/20240515135318.b05f11385c9a.I41c1b33a2e1814c3a7ef352cd7f2951b91785617@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/main.c        | 10 ++++++++--
 net/mac80211/util.c        |  2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 03f8c8bdab765..03c238e68038b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1803,6 +1803,8 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 void ieee80211_configure_filter(struct ieee80211_local *local);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
+void ieee80211_handle_queued_frames(struct ieee80211_local *local);
+
 u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local);
 int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 			     u64 *cookie, gfp_t gfp);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 9617ff8e27147..7d62374fe727b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -220,9 +220,8 @@ u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 	       BSS_CHANGED_ERP_SLOT;
 }
 
-static void ieee80211_tasklet_handler(struct tasklet_struct *t)
+void ieee80211_handle_queued_frames(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -247,6 +246,13 @@ static void ieee80211_tasklet_handler(struct tasklet_struct *t)
 	}
 }
 
+static void ieee80211_tasklet_handler(struct tasklet_struct *t)
+{
+	struct ieee80211_local *local = from_tasklet(local, t, tasklet);
+
+	ieee80211_handle_queued_frames(local);
+}
+
 static void ieee80211_restart_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 354badd32793a..3d47c2dba39da 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2146,6 +2146,8 @@ u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_stop_device(struct ieee80211_local *local)
 {
+	ieee80211_handle_queued_frames(local);
+
 	ieee80211_led_radio(local, false);
 	ieee80211_mod_tpt_led_trig(local, 0, IEEE80211_TPT_LEDTRIG_FL_RADIO);
 
-- 
2.43.0



