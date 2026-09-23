Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FF75372F7;
	Wed, 23 Sep 2026 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174312; cv=none; b=i3jZHKPrf58kbVjV4Pt6w23VnrF3BvY5HrZDCkI+ErBqFRzzugYRbbsVE5iPQz4irkkilaIn92lVQXiQpSWDLS15v4vZ5wxee1z1mSa8+DwOCMLSU3xKeOq4PF6CmJEu44HvxyfxpVP0+NSWAwKlTUswkBEURyAyro+8wcx1w/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174312; c=relaxed/simple;
	bh=74DSPuT06NmYNxl1QhlvZQ69VESrIgieZHrQ4hhsW18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+bUUfjggDU9oRqkTq9WLAc4N/EDeZzP0WHF0ILlsUVtWybMuxXZW16h3jToIdYKLGaedKeWaRMalY1JRcH0/PR/G5d4msTGqHQJQhjfbTOuDo3f7xjxOS8f3taNeSfhpkX06ruC6uZC5he7W1URLEs6gxXCK5pHTRxyvx0SzM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVVZCI+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVVZCI+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00981F00893;
	Wed, 23 Sep 2026 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174311;
	bh=rZGkugKZypWrqDI2cn1znOE7c2KHtF1w7irukJS0Ymw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVVZCI+y0nH1ex4zBYwa89+dU7crp0I7OH9f5CnZMp/CVBK/Xhtq/LYZsIIn3Q6zg
	 aMXC/snd+qtQtMVIdZkkc15wckQlcs5r9f5Kix4hMlD6VZGENYCXxCd++xAtEuroyr
	 xXmJsBJcgQ6BeHzR9Jybjm1EH2RYDeu8YeRPOdt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ca7a2759caaa6cd4e3db@syzkaller.appspotmail.com,
	syzbot+c4686c3eb8b64032618f@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/398] wifi: mac80211: reset state when starting AP fails
Date: Wed, 23 Sep 2026 16:02:21 +0200
Message-ID: <20260923140645.168604594@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3f28551d0241254a75626d868041c6340285088b ]

ieee80211_start_ap() can set enable_beacon (and beacon_int) and fail
later, leaving it set forever. Scanning can then attempt to restore
beaconing on such an interface, leading to:

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:mac80211_hwsim_link_info_changed+0xca7/0xf00
  Call Trace:
   drv_link_info_changed+0x413/0x860 net/mac80211/driver-ops.c:495
   ieee80211_link_info_change_notify+0x24b/0x3c0 net/mac80211/main.c:427
   ieee80211_offchannel_return+0x381/0x580 net/mac80211/offchannel.c:160
   __ieee80211_scan_completed+0x993/0xe30 net/mac80211/scan.c:519
   ieee80211_scan_work+0x472/0x2010 net/mac80211/scan.c:1193
   cfg80211_wiphy_work+0x2b7/0x550 net/wireless/core.c:538

in hwsim. Also, cfg80211 then allows changing the interface type,
and the off-channel path getgs confused about beaconing as well,
leading to another warning:

  WARNING: net/mac80211/driver-ops.c:468 at drv_link_info_changed+0x583/0x880
   ieee80211_link_info_change_notify+0x24b/0x3c0 net/mac80211/main.c:427
   ieee80211_offchannel_stop_vifs+0x328/0x5c0 net/mac80211/offchannel.c:122
   ieee80211_start_sw_scan net/mac80211/scan.c:583 [inline]
   __ieee80211_start_scan+0xfb6/0x1af0 net/mac80211/scan.c:882

Reset the state on failures to always have it correct.

Assisted-by: LLM
Fixes: d6a83228823f ("mac80211: track enable_beacon explicitly")
Reported-by: syzbot+ca7a2759caaa6cd4e3db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ca7a2759caaa6cd4e3db
Reported-by: syzbot+c4686c3eb8b64032618f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c4686c3eb8b64032618f
Link: https://patch.msgid.link/20260904165722.9629429a5221.I7f599412bfe12a09d41ea4901be9ad165d07d133@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f6e8352665c1a..84e27d8a75ef1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1717,6 +1717,9 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 
 error:
+	link_conf->enable_beacon = false;
+	link_conf->beacon_int = prev_beacon_int;
+	sdata->vif.cfg.ssid_len = 0;
 	ieee80211_link_release_channel(link);
 
 	return err;
-- 
2.53.0



