Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A3433ADB9;
	Wed, 20 May 2026 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294743; cv=none; b=cZ+HnX9Z2xyEwxjSefXDa9LEP+flA64A7OhQfethiZ7k1LUiW1PvtLEAxCSFC5ysmr19xJ1jWVKlCZ28lFt+gQEXomZ/lpAz5g3viECLiZxE0t/wEHn8z5BZbTIV61n9obaKic3QFX4rwlMlan6O+VuuPBK6jK/3ptlu3XEmYqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294743; c=relaxed/simple;
	bh=3fO5Qbg4br3SvvgB2E+xXLUMPcrCPIiDtYSZSu3Z2cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RilgKBhXvxT2YHW4hSYGjkaaL0e25B2hhFqEXim7SJwVy/sSbp5oTzNBNNtb+5Nhtvwj4pN7pgk+VdxbT057mnzMsePJT1RMdWd3WZ1xxEqgTv8SnU4XvsFqBcv0IZGTgSlvggl2afktCMaRpqyTPbdQ09eYXKXIUq1ghQANB2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKfFrhM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKfFrhM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481EE1F000E9;
	Wed, 20 May 2026 16:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294742;
	bh=7bsP8bKpfqIGuI9eSYWn8mxLVUH0p9LDr8SO0hJkNVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KKfFrhM0pUgdbB7vpkFeqYHL29c9Fd3P/TA2/oGFailMFwO3DW/xBmnd7HEM3l3Ew
	 5JNyh1+4YP4ae6TYDTXo3u0EUxnwwJFhh7nJSYS4Xz9+jr5LbcyDojPgIs/Ark51/2
	 JxGHJoLBKHZjV+KTwAtMGfAsqNAtnFyP1Uzgjc54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0154/1146] wifi: mac80211: handle VHT EXT NSS in ieee80211_determine_our_sta_mode()
Date: Wed, 20 May 2026 18:06:44 +0200
Message-ID: <20260520162151.788264188@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit b5b8e295973083abf823fb66647a7c702a8db8a7 ]

A station which has a NSS ratio on the number of streams it is capable of
in 160MHz VHT operation is supposed to use the 'Extended NSS BW Support'
as defined by section '9.4.2.156.2 VHT Capabilities Information field'.

This was missing in ieee80211_determine_our_sta_mode() and so we would
wrongfully downgrade our bandwidth when connecting to an AP that supported
160MHz with messages such as:

	[   37.638346] wlan1: AP XX:XX:XX:XX:XX:XX changed bandwidth in assoc response, new used config is 5280.000 MHz, width 3 (5290.000/0 MHz)

Fixes: 310c8387c638 ("wifi: mac80211: clean up connection process")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://patch.msgid.link/20260327100256.3101348-1-nico.escande@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6a0e2896b54c7..53bd98646e33e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6009,7 +6009,8 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 
 	if (is_5ghz &&
 	    !(vht_cap.cap & (IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
-			     IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))) {
+			     IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
+			     IEEE80211_VHT_CAP_EXT_NSS_BW_MASK))) {
 		conn->bw_limit = IEEE80211_CONN_BW_LIMIT_80;
 		mlme_link_id_dbg(sdata, link_id,
 				 "no VHT 160 MHz capability on 5 GHz, limiting to 80 MHz");
-- 
2.53.0



