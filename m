Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B932ABC0;
	Thu, 28 May 2026 20:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999111; cv=none; b=jeScu71YsJBZA0ePNMaNR+bZLKfJxao43WSK//x8DdebmH/c/oU46bAA7NuoaLuscLwM9imN0NJcxpwZahIxET80cgeOlK0S5ohM/cAyUUo+nknXqC6PLgDQfnJONppuZ4EWDod6egs2Y6k44qLOrgogCcPQBGPQr6ZgcwyK9IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999111; c=relaxed/simple;
	bh=g/AxR0cI+ghiHJH5skQRidL25W+zcYFtK4btzv/8J2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGTA3EcQ8BeNt/adNatU6HuM5g8N5asfrpCKVC07ngXMgsxUOc1uhwMzzLKjduwYp4FHLVkt0NFOoawMD/744c3326bNc2ZE5PLEgojvsFuoJjjXz21/EuSwx71TSmqp/+QcpUVfj9wemkXQBTeYYCAL3YKoeTpqBncFCJ0eEEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7mMU7KW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7mMU7KW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF81A1F000E9;
	Thu, 28 May 2026 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999110;
	bh=zKrfK6w677vCAoQuBRjoQ5u+SyVynJh50piOFQ7VfCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7mMU7KWZoC0sWrZBdPL4WaAZD99Pq0xkqY0ESy7DDT7/K1IK/NEWlH7OUTDUKyxR
	 tkPgRJ8oWWq1WNkJnISI9PNE0cOX/VJVpNCuf0g3KP6lsMyEEzYINQT6ZWjMOqntRH
	 FBqNYqzaRHG3kyUi6FV0BetYEMxUth4cNKj22mwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 412/461] wifi: mac80211: bounds-check link_id in ieee80211_ml_epcs
Date: Thu, 28 May 2026 21:49:01 +0200
Message-ID: <20260528194659.415391799@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 991519ea44827..eba890366e9fe 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -11137,6 +11137,9 @@ static void ieee80211_ml_epcs(struct ieee80211_sub_if_data *sdata,
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



