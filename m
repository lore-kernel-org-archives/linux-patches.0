Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52101B4223;
	Mon, 23 Mar 2026 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273818; cv=none; b=Q9YdLZHrgksSMDaxJ7A69AGwdsGHAc9MfVx+rNhjYMBDZ0/4dIEKADJFozgME4KUsXH4Qsyz/6dEscxU5WZiLfIUy3VWyMoJCl5AUnVzS8sruJEVo6uWIMiUHlolk9h/ZwFInTzSd/6LZtYBHQmtJzegWQ+6Y+Ac4TFIQN9I81w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273818; c=relaxed/simple;
	bh=s5RiZRtE+V/A9+f0cZUOkk5QZ8Y74YuUSYPviVa7W1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/rnUEOlq4I9lWXfk1wSl/+h58iLuSNi1p6SZn1p9aTiXgEzD+MNegLXLKuoFdcMANN6PGShjtLx9eSQBJsByB2CIxyKpBC6QziOiQLA6W0vdViU/4J/NspdeMIWwUsh+vf+NM8a48ZP19IXqiy7MTm3GOEBqGmRrIcDaHngIGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEbCTnN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEbCTnN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F216DC4CEF7;
	Mon, 23 Mar 2026 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273818;
	bh=s5RiZRtE+V/A9+f0cZUOkk5QZ8Y74YuUSYPviVa7W1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEbCTnN2gdjeXbQNmR/5yINrbKGZVGMrTF/99gkFbF+Tf4lLiqtgGP+XmfCSXP562
	 kOm5aeP+rTe9mQQ5A78GLEewN7+1o+MUJAuz2JaVeRGIg0n7joQlYnDtoYArXMwaKA
	 Z0omhoAXrCr6LWFuEy4C+h0xIsUeRMjhthI/yHfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.19 019/220] mac80211: fix crash in ieee80211_chan_bw_change for AP_VLAN stations
Date: Mon, 23 Mar 2026 14:43:16 +0100
Message-ID: <20260323134505.185993036@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -561,14 +561,16 @@ static void ieee80211_chan_bw_change(str
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


