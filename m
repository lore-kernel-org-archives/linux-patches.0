Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41822566;
	Tue, 15 Jul 2025 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585508; cv=none; b=j/alqWbgqdn4LizJJXMLScs+GcQ5N9gY7dGj+ypHKXpdvzR56+VzXZq6Rj2RhVI0qI/mE7xqa4GYo+alvdlYr1WE6BGb1pRnollZ8VlTxxgcfg+ndBgTVn2rM9CR2ueZ2s40phTMKIBk/8BmKB9yR2qv2kIhLPHOBCcaq9h9jRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585508; c=relaxed/simple;
	bh=kZxvYFR46O2xkYDOMUogCqNV0FX3ta0YE6wtE/ZYN04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFfKLf7QWQH8RGaBr9i4AWWn+IdTzLpxBTwAZm75mrAn5ev+xYQvSIyIJPF1Wo9LqMiJLWkJQyqAFDoBg/APPahlJF9PyvBMetoxrB2Vc80UGgXUtkgDEDfxoiSmQYZB5/5CTBvzqc4cWGRUu7TNOI1uqHv3/Io8jEwo4xbGnlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NA9nvHK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NA9nvHK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0668CC4CEE3;
	Tue, 15 Jul 2025 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585508;
	bh=kZxvYFR46O2xkYDOMUogCqNV0FX3ta0YE6wtE/ZYN04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NA9nvHK2IkbAt88bCE3EXWymu/q6SjWQXoeDt+basNx26Jrd+5d0SO13jyFzi7UoZ
	 cs3VsKOTewUhB37M+UPwYMvcs5PGPztdeYSrYTchR86yZ0ye23mFovHdhBKiirwJZW
	 ZtigSvG4tYOQzKXkFh8DgTey9hU0Soh5iyaP1CB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitor Soares <vitor.soares@toradex.com>,
	Jeff Chen <jeff.chen_1@nxp.con>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 067/163] wifi: mwifiex: discard erroneous disassoc frames on STA interface
Date: Tue, 15 Jul 2025 15:12:15 +0200
Message-ID: <20250715130811.432918869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vitor Soares <vitor.soares@toradex.com>

commit 3b602ddc0df723992721b0d286c90c9bdd755b34 upstream.

When operating in concurrent STA/AP mode with host MLME enabled,
the firmware incorrectly sends disassociation frames to the STA
interface when clients disconnect from the AP interface.
This causes kernel warnings as the STA interface processes
disconnect events that don't apply to it:

[ 1303.240540] WARNING: CPU: 0 PID: 513 at net/wireless/mlme.c:141 cfg80211_process_disassoc+0x78/0xec [cfg80211]
[ 1303.250861] Modules linked in: 8021q garp stp mrp llc rfcomm bnep btnxpuart nls_iso8859_1 nls_cp437 onboard_us
[ 1303.327651] CPU: 0 UID: 0 PID: 513 Comm: kworker/u9:2 Not tainted 6.16.0-rc1+ #3 PREEMPT
[ 1303.335937] Hardware name: Toradex Verdin AM62 WB on Verdin Development Board (DT)
[ 1303.343588] Workqueue: MWIFIEX_RX_WORK_QUEUE mwifiex_rx_work_queue [mwifiex]
[ 1303.350856] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 1303.357904] pc : cfg80211_process_disassoc+0x78/0xec [cfg80211]
[ 1303.364065] lr : cfg80211_process_disassoc+0x70/0xec [cfg80211]
[ 1303.370221] sp : ffff800083053be0
[ 1303.373590] x29: ffff800083053be0 x28: 0000000000000000 x27: 0000000000000000
[ 1303.380855] x26: 0000000000000000 x25: 00000000ffffffff x24: ffff000002c5b8ae
[ 1303.388120] x23: ffff000002c5b884 x22: 0000000000000001 x21: 0000000000000008
[ 1303.395382] x20: ffff000002c5b8ae x19: ffff0000064dd408 x18: 0000000000000006
[ 1303.402646] x17: 3a36333a61623a30 x16: 32206d6f72662063 x15: ffff800080bfe048
[ 1303.409910] x14: ffff000003625300 x13: 0000000000000001 x12: 0000000000000000
[ 1303.417173] x11: 0000000000000002 x10: ffff000003958600 x9 : ffff000003625300
[ 1303.424434] x8 : ffff00003fd9ef40 x7 : ffff0000039fc280 x6 : 0000000000000002
[ 1303.431695] x5 : ffff0000038976d4 x4 : 0000000000000000 x3 : 0000000000003186
[ 1303.438956] x2 : 000000004836ba20 x1 : 0000000000006986 x0 : 00000000d00479de
[ 1303.446221] Call trace:
[ 1303.448722]  cfg80211_process_disassoc+0x78/0xec [cfg80211] (P)
[ 1303.454894]  cfg80211_rx_mlme_mgmt+0x64/0xf8 [cfg80211]
[ 1303.460362]  mwifiex_process_mgmt_packet+0x1ec/0x460 [mwifiex]
[ 1303.466380]  mwifiex_process_sta_rx_packet+0x1bc/0x2a0 [mwifiex]
[ 1303.472573]  mwifiex_handle_rx_packet+0xb4/0x13c [mwifiex]
[ 1303.478243]  mwifiex_rx_work_queue+0x158/0x198 [mwifiex]
[ 1303.483734]  process_one_work+0x14c/0x28c
[ 1303.487845]  worker_thread+0x2cc/0x3d4
[ 1303.491680]  kthread+0x12c/0x208
[ 1303.495014]  ret_from_fork+0x10/0x20

Add validation in the STA receive path to verify that disassoc/deauth
frames originate from the connected AP. Frames that fail this check
are discarded early, preventing them from reaching the MLME layer and
triggering WARN_ON().

This filtering logic is similar with that used in the
ieee80211_rx_mgmt_disassoc() function in mac80211, which drops
disassoc frames that don't match the current BSSID
(!ether_addr_equal(mgmt->bssid, sdata->vif.cfg.ap_addr)), ensuring
only relevant frames are processed.

Tested on:
- 8997 with FW 16.68.1.p197

Fixes: 36995892c271 ("wifi: mwifiex: add host mlme for client mode")
Cc: stable@vger.kernel.org
Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.con>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20250701142643.658990-1-ivitro@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/util.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -477,7 +477,9 @@ mwifiex_process_mgmt_packet(struct mwifi
 				    "auth: receive authentication from %pM\n",
 				    ieee_hdr->addr3);
 		} else {
-			if (!priv->wdev.connected)
+			if (!priv->wdev.connected ||
+			    !ether_addr_equal(ieee_hdr->addr3,
+					      priv->curr_bss_params.bss_descriptor.mac_address))
 				return 0;
 
 			if (ieee80211_is_deauth(ieee_hdr->frame_control)) {


