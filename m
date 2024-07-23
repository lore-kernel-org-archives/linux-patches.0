Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B86F15884E;
	Tue, 23 Jul 2024 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760270; cv=none; b=ZrjrMPfektphIIXdRNWWKYK1Xv8VK/LlFWlTv73dPtRmjcttfyfBWw1jpZqC+suIWhllIkS0E+Ee66xoo567kJx7o9lpCRX/TKNLRSSotG6plCL9xbpjq8HUdOG3uybMjDhtTK911hdqNKwlw8cZE/r5VdJvt4P/OntaIszaJFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760270; c=relaxed/simple;
	bh=k4Mg9wH6SmTEHTiRsq5IY/pxnryYO8IoOosqylJ4O/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kw5RtxLcabk3mJ0Sk15j4vleldmHrea2TDoMNClITx7rf6IYO2uRg41nTZH/3L/lOGR6YPrQhEtSsP5Ao0f3bq2tyCh2E/WOUSmm7ROtoXAjQrviv4J2jq3SK6lum35v23Je/zXcboJ/QtkmrXMYC6CkVO9knjlW641PEGkjhfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbCFcjos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbCFcjos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856BDC4AF0A;
	Tue, 23 Jul 2024 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760269;
	bh=k4Mg9wH6SmTEHTiRsq5IY/pxnryYO8IoOosqylJ4O/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbCFcjos3KA3b8w1XOqRuBolVm/wd36pZHou9x/vvzdmJgNsrb2khgb9Z5iiVkXqy
	 PCZ5TavGRiH24JTvbINQjykaoUDPCgF5J9BxKCn8D4121j8ei1bx1UOU1KluhC5t4r
	 avcVTIFRRkeOP7pCOZSfOQVWgpVOgEadoAY1JQ7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d516edf1e74469ba5d3@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.9 159/163] wifi: mac80211: disable softirqs for queued frame handling
Date: Tue, 23 Jul 2024 20:24:48 +0200
Message-ID: <20240723180149.614472179@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 321028bc45f01edb9e57b0ae5c11c5c3600d00ca upstream.

As noticed by syzbot, calling ieee80211_handle_queued_frames()
(and actually handling frames there) requires softirqs to be
disabled, since we call into the RX code. Fix that in the case
of cleaning up frames left over during shutdown.

Fixes: 177c6ae9725d ("wifi: mac80211: handle tasklet frames before stopping")
Reported-by: syzbot+1d516edf1e74469ba5d3@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20240626091559.cd6f08105a6e.I74778610a5ff2cf8680964698131099d2960352a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/main.c |    1 +
 net/mac80211/util.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -423,6 +423,7 @@ u64 ieee80211_reset_erp_info(struct ieee
 	       BSS_CHANGED_ERP_SLOT;
 }
 
+/* context: requires softirqs disabled */
 void ieee80211_handle_queued_frames(struct ieee80211_local *local)
 {
 	struct sk_buff *skb;
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1567,7 +1567,9 @@ u32 ieee80211_sta_get_rates(struct ieee8
 
 void ieee80211_stop_device(struct ieee80211_local *local)
 {
+	local_bh_disable();
 	ieee80211_handle_queued_frames(local);
+	local_bh_enable();
 
 	ieee80211_led_radio(local, false);
 	ieee80211_mod_tpt_led_trig(local, 0, IEEE80211_TPT_LEDTRIG_FL_RADIO);


