Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E11386441;
	Wed, 23 Sep 2026 14:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174417; cv=none; b=cgun6EcNeSBCDBQ/fR1Th+QORU08oz3V0L4KCF6SHSo2ByaYJjTdSpQD8Yb+jhS0l9seu+TObL2u64YaA+Vz97z5/fONilp42lUvMLDhpYf7/KGpf9AD7CTaVJr12PhOYu9Dv0gVPEmZoXxb/V3VyQaCJt3iAYFrGvs2hl61Ueo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174417; c=relaxed/simple;
	bh=pKMK8Zf0WRTRMdsd4UEtJQSO6imfO2TWN32t3oizh+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L56xxxg5TZX9IgjwNLuL2gf4Mt7OPAYrFGDfC/+Bj3woy57NixKOAjjskQUUaS6wA3iNmhhiRMlpVuHHZph0k2SZ3M+wJWfng5K6++XAdXufDLSCzm5Mj+AT1pRoUxYE5pcyg458KJYqTMaAvGBEwjc/onaKSo0swaeAfXTzU4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y787E8PW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y787E8PW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5931F000FF;
	Wed, 23 Sep 2026 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174416;
	bh=sJjH+hOF64QHFAJDg46ERCo0sRIUFHJzt6JOYLnN0tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y787E8PWBkYLlo1pexYRugNj8dyKih9H93guZjG3SLQDhB07IWNOsInJlpPzCz4wh
	 ZcQRHS372Kqj6wOFg8swi3zmqt/Q2YnOd7b4rDBWLdGmvGHA+zX7RI2nvYaOnqF0m9
	 uVSpdi9ygpbIRJPcUfV9gGIg4uHP/K5K0mC+Xy2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+81cd9dc1596563141d19@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/398] wifi: mac80211: abort chanswitch when leaving a mesh
Date: Wed, 23 Sep 2026 16:02:20 +0200
Message-ID: <20260923140645.142394260@linuxfoundation.org>
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
index 4b0eebd5c7cf8..04b3ac4525035 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1223,6 +1223,10 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
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



