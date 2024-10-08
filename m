Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4151E485;
	Tue,  8 Oct 2024 12:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389734; cv=none; b=Xdj3JzNBoTfC100GRP+4xTznMAsFY2kYTZdYiFjkL10jFMSPbE4dEAievDeEwOYMRPDbZSTASDG4NyAlowdTokVdbzZV41ppe0bHaHHgk0c/xiHhbaanuZkb/ir2DDnpLHkW95qampq2Ehy8ckx8XuUKBfx9qURzQwO1XDwfRPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389734; c=relaxed/simple;
	bh=KPvEndCVal1HGXyLB/aXiU723IL9MtaqRrH8BlXCReQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHpNKJNf+Xhs8kqZsFhdi76ZEHeCNfrzNBb9SCjtLXjaRdLIQ9WF/rYicTB24IXVu2fOYSwEB2EpHpsCHlXXF7XeLGub6U9Cd6NRQTVZSW9PC6G4GpwGsK2cw2lwpB3xab/A3jsGZfpjAQ89xGDpvrgzX4WEeCnGDqq4AeLHHb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=angWKaEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="angWKaEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FE2C4CEC7;
	Tue,  8 Oct 2024 12:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389734;
	bh=KPvEndCVal1HGXyLB/aXiU723IL9MtaqRrH8BlXCReQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=angWKaEJJXserkxB2lEC2qi9fud4Ft7hy2rPD0usM5B112t9Qb50NftlU57ETOLV4
	 jLRpUD38Y02ePzrDtDGO2J9XFXML2ChRyFCkDiAR8JJ6v+hRkVb1Pjtl0zA+cWE5aJ
	 GoMUoFlUxlWhRQ3oCFC2ruGSbKt87iFwI5GoGyNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kretschmer Mathias <mathias.kretschmer@fit.fraunhofer.de>,
	Issam Hamdi <ih@simonwunderlich.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 080/482] wifi: cfg80211: Set correct chandef when starting CAC
Date: Tue,  8 Oct 2024 14:02:23 +0200
Message-ID: <20241008115651.454629286@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Issam Hamdi <ih@simonwunderlich.de>

[ Upstream commit 20361712880396e44ce80aaeec2d93d182035651 ]

When starting CAC in a mode other than AP mode, it return a
"WARNING: CPU: 0 PID: 63 at cfg80211_chandef_dfs_usable+0x20/0xaf [cfg80211]"
caused by the chandef.chan being null at the end of CAC.

Solution: Ensure the channel definition is set for the different modes
when starting CAC to avoid getting a NULL 'chan' at the end of CAC.

 Call Trace:
  ? show_regs.part.0+0x14/0x16
  ? __warn+0x67/0xc0
  ? cfg80211_chandef_dfs_usable+0x20/0xaf [cfg80211]
  ? report_bug+0xa7/0x130
  ? exc_overflow+0x30/0x30
  ? handle_bug+0x27/0x50
  ? exc_invalid_op+0x18/0x60
  ? handle_exception+0xf6/0xf6
  ? exc_overflow+0x30/0x30
  ? cfg80211_chandef_dfs_usable+0x20/0xaf [cfg80211]
  ? exc_overflow+0x30/0x30
  ? cfg80211_chandef_dfs_usable+0x20/0xaf [cfg80211]
  ? regulatory_propagate_dfs_state.cold+0x1b/0x4c [cfg80211]
  ? cfg80211_propagate_cac_done_wk+0x1a/0x30 [cfg80211]
  ? process_one_work+0x165/0x280
  ? worker_thread+0x120/0x3f0
  ? kthread+0xc2/0xf0
  ? process_one_work+0x280/0x280
  ? kthread_complete_and_exit+0x20/0x20
  ? ret_from_fork+0x19/0x24

Reported-by: Kretschmer Mathias <mathias.kretschmer@fit.fraunhofer.de>
Signed-off-by: Issam Hamdi <ih@simonwunderlich.de>
Link: https://patch.msgid.link/20240816142418.3381951-1-ih@simonwunderlich.de
[shorten subject, remove OCB, reorder cases to match previous list]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e3bf14e489c5d..9675ceaa5bf60 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10024,7 +10024,20 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 
 	err = rdev_start_radar_detection(rdev, dev, &chandef, cac_time_ms);
 	if (!err) {
-		wdev->links[0].ap.chandef = chandef;
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
+			wdev->links[0].ap.chandef = chandef;
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			wdev->u.ibss.chandef = chandef;
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			wdev->u.mesh.chandef = chandef;
+			break;
+		default:
+			break;
+		}
 		wdev->cac_started = true;
 		wdev->cac_start_time = jiffies;
 		wdev->cac_time_ms = cac_time_ms;
-- 
2.43.0



