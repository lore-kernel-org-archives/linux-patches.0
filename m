Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4197D36A37E;
	Wed, 30 Sep 2026 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788284; cv=none; b=VoPCdPliZTV1DtgJADrRF7SJVf8pzLF6iwycwroJUlDh1c3qf8nptzLRD8RY5TxvK1VKroI9PyXw0G0XJacZhm9UC+Vt4sJa9VKvDaTIy4P/e6syCVxGT7g+ndSsd5goXoy0g8X/FYYnA8b2OL3eodvZ32iWObnSstyEvHHUfJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788284; c=relaxed/simple;
	bh=NqpG5x+k1+BcM6GcKIjQmGb9Y+pw9/4kXEx6fArYcEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbPKAYtIw2HiaraliQRooMLtzAzNpXajvDrxCcjXYaV3N5ZpQEdyHf9uSwzEvh+8MLous/ti9FXRQnFjVY5XoTQ4oqidVdOJIMS4JBg3F5HdQ08NO22nw9jKPacRhH0dZX4Y6l92JlCjgaBg052V9pWAl6hVCTqynDTaJSoGIo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oru1y6Az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oru1y6Az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B12E1F000FF;
	Wed, 30 Sep 2026 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788283;
	bh=QheO3PXWOtHrJRoc/blw4gKqj1f7F2feT39FU3KGFxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oru1y6AzMLyecXJrcDmkTkZTEBcgmQbQ6io3R/flwUDKP0MBVTGwqfYDQlqqBFezZ
	 qlQOylKSt2o5dMu/6R+995W4nulK8bCASZQ+QNzmO7opT96tt3PX/hLRwWQaXMlwTB
	 ZL32nb/p1HNPFeeEQtQLF3cizDkVUi+RPOu39NFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+81cd9dc1596563141d19@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/877] wifi: mac80211: abort chanswitch when leaving a mesh
Date: Wed, 30 Sep 2026 17:16:14 +0200
Message-ID: <20260930152416.101106434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit ac7472a24bd433b81c06582835dd1d5547c10da9 ]

The code in ieee80211_stop_mesh() leaves CSA active, but leaving
the mesh released the channel context, so the CSA finalize work
crashes:

  Oops: general protection fault, probably for non-canonical address
        0xdffffc0000000003
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  RIP: 0010:ieee80211_put_srates_elem+0x42/0x640 net/mac80211/util.c:3272
  Call Trace:
   ieee80211_mesh_build_beacon+0xa83/0x1b50 net/mac80211/mesh.c:1093
   ieee80211_mesh_rebuild_beacon+0xc7/0x170 net/mac80211/mesh.c:1147
   ieee80211_mesh_finish_csa+0x131/0x210 net/mac80211/mesh.c:1542
   ieee80211_set_after_csa_beacon net/mac80211/cfg.c:4085 [inline]
   __ieee80211_csa_finalize net/mac80211/cfg.c:4133 [inline]
   ieee80211_csa_finalize+0x633/0x1150 net/mac80211/cfg.c:4155
   cfg80211_wiphy_work+0x2ab/0x450 net/wireless/core.c:438

Abort the channel switch properly.

Assisted-by: LLM
Fixes: b8456a14e9d2 ("{nl,cfg,mac}80211: implement mesh channel switch userspace API")
Reported-by: syzbot+81cd9dc1596563141d19@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=81cd9dc1596563141d19
Link: https://patch.msgid.link/20260904165722.d0b87eee08aa.I80550d6127e0bb26efb49a5fbe95be1aef1cd0cb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 253f4b0642842..57cf3f90f7fbe 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1225,6 +1225,10 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	netif_carrier_off(sdata->dev);
 
+	/* abort any running channel switch */
+	sdata->vif.bss_conf.csa_active = false;
+	ieee80211_vif_unblock_queues_csa(sdata);
+
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata, -1);
 	ieee80211_free_keys(sdata, true);
-- 
2.53.0



