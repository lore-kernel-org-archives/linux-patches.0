Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD713AEF5F;
	Mon, 23 Mar 2026 14:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274504; cv=none; b=Ns2jh8UqBuO4jl8DTsHEJg0hIoDGIkmjhUqhwQ9fgs0iwJrfhEOTy4njz1/pfl/WicmZodVYJodgZMhkcCx3eoDkZLSCjCfVaT4t59oOiWPjiZ1uN3a5uLcKSJGtiL1ui21b3uE3ZdK9ebazY2APh35C2MmY7pCMnkl0ygCmi6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274504; c=relaxed/simple;
	bh=nI57aAdO1R8Zwc5kguQ6zWdeQ/T1lTP1dpjnM9T0DrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC01TQZ28PPhNw4L0i2eVqcMXU6/T2zJ+OwHuZsUacCaCzruPH+eqZSa2HcjEOkf3Cme+t+R/QG8I1Kq1Lj/b4v5G2+lScMSTXIoAi2Ugj3OGievxiO3rZwVxaFsNePmfCKUjfSKEteNTKaIcAk/JEjypYp+bX4bUvfeS8WgNE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6JYwcFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6JYwcFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F34C4CEF7;
	Mon, 23 Mar 2026 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274504;
	bh=nI57aAdO1R8Zwc5kguQ6zWdeQ/T1lTP1dpjnM9T0DrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6JYwcFTF7GIHc+WEgJhUoRKi9eAono6HxQ098DahD6y/tSIlRNbQPqQyCJ+iDo4a
	 tNGscTYvuQP4x+N3R0t1KnGkJz8LgMG6Jw2R6eNSP3RDcsa388Eu3nlkdqa9pNblhf
	 nPf9g52pf2pHyrWVELATTPAoKtc0tfSdEdScoE4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 019/212] mac80211: fix crash in ieee80211_chan_bw_change for AP_VLAN stations
Date: Mon, 23 Mar 2026 14:44:00 +0100
Message-ID: <20260323134504.367397086@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

commit 672e5229e1ecfc2a3509b53adcb914d8b024a853 upstream.

ieee80211_chan_bw_change() iterates all stations and accesses
link->reserved.oper via sta->sdata->link[link_id]. For stations on
AP_VLAN interfaces (e.g. 4addr WDS clients), sta->sdata points to
the VLAN sdata, whose link never participates in chanctx reservations.
This leaves link->reserved.oper zero-initialized with chan == NULL,
causing a NULL pointer dereference in __ieee80211_sta_cap_rx_bw()
when accessing chandef->chan->band during CSA.

Resolve the VLAN sdata to its parent AP sdata using get_bss_sdata()
before accessing link data.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20260305170812.2904208-1-nbd@nbd.name
[also change sta->sdata in ARRAY_SIZE even if it doesn't matter]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/chan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -441,14 +441,16 @@ static void ieee80211_chan_bw_change(str
 	rcu_read_lock();
 	list_for_each_entry_rcu(sta, &local->sta_list,
 				list) {
-		struct ieee80211_sub_if_data *sdata = sta->sdata;
+		struct ieee80211_sub_if_data *sdata;
 		enum ieee80211_sta_rx_bandwidth new_sta_bw;
 		unsigned int link_id;
 
 		if (!ieee80211_sdata_running(sta->sdata))
 			continue;
 
-		for (link_id = 0; link_id < ARRAY_SIZE(sta->sdata->link); link_id++) {
+		sdata = get_bss_sdata(sta->sdata);
+
+		for (link_id = 0; link_id < ARRAY_SIZE(sdata->link); link_id++) {
 			struct ieee80211_link_data *link =
 				rcu_dereference(sdata->link[link_id]);
 			struct ieee80211_bss_conf *link_conf;


