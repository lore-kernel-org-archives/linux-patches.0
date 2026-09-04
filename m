Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C96414A2A;
	Fri,  4 Sep 2026 06:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501784; cv=none; b=JGnUjYAhC3xVjTpBCl0AB4xHyYybX3VYwr2u7Gd+MwY7NtrNz4Cwumnr/4syG/b5w3SFdi8o9qDfyGQJCj1ZtTiRSSQ4ulCpucR43PWCa5LXSkg0zdo2KFWJnhcKeQBpmkl9q5jiN94mZlncW4TJ1zF42YvTt48GRVv7eRxzWS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501784; c=relaxed/simple;
	bh=zQDw39Gz4WR4FCxKQRpkmbd5Z0Jy5qF3fi6/gIjPpXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS2BcuYpvhIT36eOe2Warep12F/6VnehHbrxaAi51PgknRGW/s1mO2vsjjBYGZmoqarovX/uerjfQuG9a9RJSTfczWUJSbEEVKElfHdCW0xPujAsq5/R1uEea3gSvL3x7d2C5uLe3/ab+8QppSi0wU1Hi9eTh7JmupukOJr6+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sYAmVW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sYAmVW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58F01F00A3D;
	Fri,  4 Sep 2026 06:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501783;
	bh=HVZJ5wlcksl8FfOY/91Tc9REWVziGTeV0fUqesayu4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sYAmVW5eV2mj12e0sdPygDIzl0TQsme48nbj6w8bbn6ERrFglOvIbQdbknZoVqib
	 q/znUT+hhMdFD5amXEDhIb0bIRT0eSpySo96u0XV1PSBmaUP7e6qFHzU733O1QDxaX
	 /HqvJHq4a9RjJpS7j4WYD2jsxYVg44pKmwu1JeAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.18 529/552] wifi: rtlwifi: rtl8192du: check QoS TID before indexing tids
Date: Fri,  4 Sep 2026 07:01:26 +0200
Message-ID: <20260904045802.614296481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit ed4f05d9f2f42fd866f55108db8123eefcc5fb33 upstream.

rtl92du_tx_fill_desc() uses ieee80211_get_tid() to read the QoS TID
from the 802.11 header and then uses it as an index into
sta_entry->tids[]. ieee80211_get_tid() returns the low 4-bit QoS TID
value, so the result can be in the range 0..15.

rtlwifi only allocates MAX_TID_COUNT entries for sta_entry->tids[], and
MAX_TID_COUNT is 9. A QoS TID greater than 8 therefore indexes past the
aggregation state array. Keep the default RTL_AGG_STOP state for
out-of-range TIDs, matching rtl92cu_tx_fill_desc().

This issue was detected by our static analysis tool and confirmed by
manual audit. UBSAN validation for the same bug pattern reports an
array-index-out-of-bounds access with index 10 for type
'rtl_tid_data [9]'.

Fixes: 8321424134a4 ("wifi: rtlwifi: Add rtl8192du/trx.{c,h}")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260620025632.46206-1-runyu.xiao@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/trx.c
@@ -106,7 +106,8 @@ void rtl92du_tx_fill_desc(struct ieee802
 	if (sta) {
 		sta_entry = (struct rtl_sta_info *)sta->drv_priv;
 		tid = ieee80211_get_tid(hdr);
-		agg_state = sta_entry->tids[tid].agg.agg_state;
+		if (tid < MAX_TID_COUNT)
+			agg_state = sta_entry->tids[tid].agg.agg_state;
 		ampdu_density = sta->deflink.ht_cap.ampdu_density;
 	}
 


