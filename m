Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC330248F62;
	Thu, 28 May 2026 20:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000227; cv=none; b=BcptZqmlv4YcXspliHrpD+DS5xxloLw0nKJ88xzsYx6j6DqErhbVBskJ52IyZHoVjWB90/rcp+d+/u8117t9WwgWkKvzCpzdf4VEkE+kRXCk10HKRxy/YC3i0Y/DFrhoAKdw//dYQtUuPqCXdrKDaClt3qmhkV6+jSLrNHJrJxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000227; c=relaxed/simple;
	bh=s/5eFsyWT1qWBTAvllNYfm1wqXWUwAHjc3U8jt/NNvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEvfq+llNTqC3EhOZd464PVq4OJRRg1nz7utc1ky6RCFBoGDJPD+9L/PJ06yL3Ji/eDxwSsb3j3LyWSfdng1Q36Mma+9gKyCydKAGjiReuXH5OFv6ERPAB8prwbAiTw5Dezu05bKUBZR4pLArVE98y/TqoDDMlhUlXfELkkIlDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voEIrNh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voEIrNh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166451F000E9;
	Thu, 28 May 2026 20:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000226;
	bh=OAe2trpl8itHDlNpNAtLjZ3nE4WlAT2wBoIfRwbKIBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=voEIrNh2euLxhRq2YadW05jO7tOqHowJoOaqEJ8b5b55g6aa4im+d/RxNAitxYrzW
	 d/2xP8SkTcxB2cfHFm3IgtOLZuuSyGiSjys+MxJuUyx2HMuDJ8biWtAmEpJtNA6O/8
	 t3dV1gTpN/EH4P56Kf+eJCp8cB+3uUpuQbe55jqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 346/377] wifi: mac80211: bounds-check link_id in ieee80211_ml_epcs
Date: Thu, 28 May 2026 21:49:44 +0200
Message-ID: <20260528194648.440552840@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Alexandru Hossu <hossu.alexandru@gmail.com>

[ Upstream commit f718506edd2d9c6a308ded9d13c632bf7b7d5a2c ]

IEEE80211_MLE_STA_EPCS_CONTROL_LINK_ID is 0x000f, so link_id extracted
from a PRIO_ACCESS ML element PER_STA_PROFILE subelement can be 0..15.
sdata->link[] has IEEE80211_MLD_MAX_NUM_LINKS (15) entries (indices 0..14),
making index 15 out-of-bounds.

A connected WiFi 7 AP can trigger this by sending an EPCS Enable Response
action frame with a PER_STA_PROFILE subelement where link_id = 15.  The
unsolicited-notification path (dialog_token = 0) is reachable any time
EPCS is already enabled, without any prior client request.

sdata->link[15] reads into the first word of sdata->activate_links_work
(a wiphy_work whose embedded list_head is non-NULL after INIT_LIST_HEAD),
so the NULL check on the result does not catch the invalid access.  The
garbage pointer is then passed to ieee80211_sta_wmm_params(), which
dereferences link->sdata and crashes the kernel.

The same class of bug was fixed for ieee80211_ml_reconfiguration() by
commit 162d331d833d ("wifi: mac80211: bounds-check link_id in
ieee80211_ml_reconfiguration").

Fixes: de86c5f60839 ("wifi: mac80211: Add support for EPCS configuration")
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260515102908.1653088-1-hossu.alexandru@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ce247dde048c0..5d1da779cd6f2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -10997,6 +10997,9 @@ static void ieee80211_ml_epcs(struct ieee80211_sub_if_data *sdata,
 		control = get_unaligned_le16(pos);
 		link_id = control & IEEE80211_MLE_STA_EPCS_CONTROL_LINK_ID;
 
+		if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+			continue;
+
 		link = sdata_dereference(sdata->link[link_id], sdata);
 		if (!link)
 			continue;
-- 
2.53.0



