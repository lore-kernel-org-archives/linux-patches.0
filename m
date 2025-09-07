Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119154315A;
	Sun,  7 Sep 2025 20:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277855; cv=none; b=OoQ+2EfmrIhuaWHELKiMAFDiJf01ngc4YwXs5ZexfjHXyV5qX38wnH3iC6KSgKwJ9+xtnAZfIds5KtsAdhzq/3kaRY83WmB8d1sXodmX8k23E+iTa6jUFIIFic5KGr4V8KqcsEOIPWASfE035OPtA6Pw8tPJP28zybjghIlGBcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277855; c=relaxed/simple;
	bh=QqDsaFyxhmez6DvgpSugps0OW2ynd7hmXjuE8gIH6QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbknBqf2H7WT7xHlYNz7pYCaQxiBSvxkUlxlwjzEsowx7ZE678Rku/tnm19PrJdC9OTgJ9lUrkbIccHttLUSci4H2wwtGeHTxAlpvYDr/FQ3GHRe07dZer/Awld+V4rf4zWuyWPLrsNQwl09YC3be7z45QmlB1NugceS0DAh6Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipTdTa73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipTdTa73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B883C4CEF0;
	Sun,  7 Sep 2025 20:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277854;
	bh=QqDsaFyxhmez6DvgpSugps0OW2ynd7hmXjuE8gIH6QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipTdTa73TeAFm9wU5KAmg1tCmn9FfXv+9ICyuOIXVvgMg94lzJwQYtKyIM+r1wryn
	 7Cd4FHTgdYtS9ifVVX2iNKfWgpFv+lfQv/CTA0HHvdFwBc6W7URHyo56KA82j58TXn
	 d/yZJfxMZ4wXgdLQzVlkqueKaY3EhWziO9aaaVg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.16 117/183] wifi: mac80211: do not permit 40 MHz EHT operation on 5/6 GHz
Date: Sun,  7 Sep 2025 21:59:04 +0200
Message-ID: <20250907195618.570645208@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

commit 75575e2d252afb29fdbcbeec4d67e042007add52 upstream.

The EHT PHY requirements state that 80 MHz must be supported on the 5
and 6 GHz bands unless the STA is 20 MHz only. So if the channel width
is limited to 40 MHz on a band other than 2.4 GHz, then disable EHT and
downgrade to HE.

The primary case where this can happen is if the hardware disables
puncturing using IEEE80211_HW_DISALLOW_PUNCTURING.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250826202553.a6582f3abf57.Ic670429dc7127f68c818b4290d950ebfb5a0b9e1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c            |    8 ++++++++
 net/mac80211/tests/chan-mode.c |   30 +++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 5 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1193,6 +1193,14 @@ again:
 			     "required MCSes not supported, disabling EHT\n");
 	}
 
+	if (conn->mode >= IEEE80211_CONN_MODE_EHT &&
+	    channel->band != NL80211_BAND_2GHZ &&
+	    conn->bw_limit == IEEE80211_CONN_BW_LIMIT_40) {
+		conn->mode = IEEE80211_CONN_MODE_HE;
+		link_id_info(sdata, link_id,
+			     "required bandwidth not supported, disabling EHT\n");
+	}
+
 	/* the mode can only decrease, so this must terminate */
 	if (ap_mode != conn->mode) {
 		kfree(elems);
--- a/net/mac80211/tests/chan-mode.c
+++ b/net/mac80211/tests/chan-mode.c
@@ -2,7 +2,7 @@
 /*
  * KUnit tests for channel mode functions
  *
- * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2024-2025 Intel Corporation
  */
 #include <net/cfg80211.h>
 #include <kunit/test.h>
@@ -28,6 +28,10 @@ static const struct determine_chan_mode_
 	u8 vht_basic_mcs_1_4, vht_basic_mcs_5_8;
 	u8 he_basic_mcs_1_4, he_basic_mcs_5_8;
 	u8 eht_mcs7_min_nss;
+	u16 eht_disabled_subchannels;
+	u8 eht_bw;
+	enum ieee80211_conn_bw_limit conn_bw_limit;
+	enum ieee80211_conn_bw_limit expected_bw_limit;
 	int error;
 } determine_chan_mode_cases[] = {
 	{
@@ -128,6 +132,14 @@ static const struct determine_chan_mode_
 		.conn_mode = IEEE80211_CONN_MODE_EHT,
 		.eht_mcs7_min_nss = 0x15,
 		.error = EINVAL,
+	}, {
+		.desc = "80 MHz EHT is downgraded to 40 MHz HE due to puncturing",
+		.conn_mode = IEEE80211_CONN_MODE_EHT,
+		.expected_mode = IEEE80211_CONN_MODE_HE,
+		.conn_bw_limit = IEEE80211_CONN_BW_LIMIT_80,
+		.expected_bw_limit = IEEE80211_CONN_BW_LIMIT_40,
+		.eht_disabled_subchannels = 0x08,
+		.eht_bw = IEEE80211_EHT_OPER_CHAN_WIDTH_80MHZ,
 	}
 };
 KUNIT_ARRAY_PARAM_DESC(determine_chan_mode, determine_chan_mode_cases, desc)
@@ -138,7 +150,7 @@ static void test_determine_chan_mode(str
 	struct t_sdata *t_sdata = T_SDATA(test);
 	struct ieee80211_conn_settings conn = {
 		.mode = params->conn_mode,
-		.bw_limit = IEEE80211_CONN_BW_LIMIT_20,
+		.bw_limit = params->conn_bw_limit,
 	};
 	struct cfg80211_bss cbss = {
 		.channel = &t_sdata->band_5ghz.channels[0],
@@ -191,14 +203,21 @@ static void test_determine_chan_mode(str
 		0x7f, 0x01, 0x00, 0x88, 0x88, 0x88, 0x00, 0x00,
 		0x00,
 		/* EHT Operation */
-		WLAN_EID_EXTENSION, 0x09, WLAN_EID_EXT_EHT_OPERATION,
-		0x01, params->eht_mcs7_min_nss ? params->eht_mcs7_min_nss : 0x11,
-		0x00, 0x00, 0x00, 0x00, 0x24, 0x00,
+		WLAN_EID_EXTENSION, 0x0b, WLAN_EID_EXT_EHT_OPERATION,
+		0x03, params->eht_mcs7_min_nss ? params->eht_mcs7_min_nss : 0x11,
+		0x00, 0x00, 0x00, params->eht_bw,
+		params->eht_bw == IEEE80211_EHT_OPER_CHAN_WIDTH_80MHZ ? 42 : 36,
+		0x00,
+		u16_get_bits(params->eht_disabled_subchannels, 0xff),
+		u16_get_bits(params->eht_disabled_subchannels, 0xff00),
 	};
 	struct ieee80211_chan_req chanreq = {};
 	struct cfg80211_chan_def ap_chandef = {};
 	struct ieee802_11_elems *elems;
 
+	/* To force EHT downgrade to HE on punctured 80 MHz downgraded to 40 MHz */
+	set_bit(IEEE80211_HW_DISALLOW_PUNCTURING, t_sdata->local.hw.flags);
+
 	if (params->strict)
 		set_bit(IEEE80211_HW_STRICT, t_sdata->local.hw.flags);
 	else
@@ -237,6 +256,7 @@ static void test_determine_chan_mode(str
 	} else {
 		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, elems);
 		KUNIT_ASSERT_EQ(test, conn.mode, params->expected_mode);
+		KUNIT_ASSERT_EQ(test, conn.bw_limit, params->expected_bw_limit);
 	}
 }
 


