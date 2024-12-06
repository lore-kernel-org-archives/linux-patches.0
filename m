Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C5A10E0;
	Fri,  6 Dec 2024 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496449; cv=none; b=Z/ISJ7DjHujVrOGYyPecJE/TRy76FZlvb+Ne9/jSUiN8BmXvImw6avGq/USQ0OCJDsTmO4VEt3kvjpjzUmwUwlj+SPz3UXVjf4SDlj1idxMduWWjF3Ihonvkr0hDa7NtTQrmYnQBwhlT/7a5MzDnHzMdMmbTEXZzimsh/xDJ81M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496449; c=relaxed/simple;
	bh=NMepVzQn6MxgvZup+5rVs/A97z7oASIWDe9XBWXJREc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgoN+s4Tnv3FyKj1HebqPx38zW8MXkIZ6LuuMxvsqPuMWw0TS3Y4AZ8oYzvWbEvrrX3dHrtVCrkXJWBCRHOcgFUNjdC2t5hlWnRDhbsUcvUdTkfk+hJ7YVFdv9ekTeg6nbgALqxgXY1qeKxhbm0pDDxLHzd4fRoDDJY7TJd0vg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAlaoJ6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAlaoJ6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EB6C4CED1;
	Fri,  6 Dec 2024 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496447;
	bh=NMepVzQn6MxgvZup+5rVs/A97z7oASIWDe9XBWXJREc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAlaoJ6z+wMFnPaHdeEHsfeKBvezZpOrGsZfeWvkSsHaSvTLqaoOtNRlU7J+DrjPm
	 fWIV9Wbxbkuh6Zra7exKZaI6RWy7e9gG16cEPjApYuXZmxta5M66PM6u9j8xT4jZQ2
	 7+n/6uNRuGIBYlW7akp3acVnQAui2LjXc5060sMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/676] wifi: radiotap: Avoid -Wflex-array-member-not-at-end warnings
Date: Fri,  6 Dec 2024 15:27:00 +0100
Message-ID: <20241206143653.412492460@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 57be3d3562ca4aa62b8047bc681028cc402af8ce ]

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

So, in order to avoid ending up with a flexible-array member in the
middle of multiple other structs, we use the `__struct_group()`
helper to create a new tagged `struct ieee80211_radiotap_header_fixed`.
This structure groups together all the members of the flexible
`struct ieee80211_radiotap_header` except the flexible array.

As a result, the array is effectively separated from the rest of the
members without modifying the memory layout of the flexible structure.
We then change the type of the middle struct members currently causing
trouble from `struct ieee80211_radiotap_header` to `struct
ieee80211_radiotap_header_fixed`.

We also want to ensure that in case new members need to be added to the
flexible structure, they are always included within the newly created
tagged struct. For this, we use `static_assert()`. This ensures that the
memory layout for both the flexible structure and the new tagged struct
is the same after any changes.

This approach avoids having to implement `struct ieee80211_radiotap_header_fixed`
as a completely separate structure, thus preventing having to maintain
two independent but basically identical structures, closing the door
to potential bugs in the future.

So, with these changes, fix the following warnings:
drivers/net/wireless/ath/wil6210/txrx.c:309:50: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/intel/ipw2x00/ipw2100.c:2521:50: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/intel/ipw2x00/ipw2200.h:1146:42: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/intel/ipw2x00/libipw.h:595:36: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/marvell/libertas/radiotap.h:34:42: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/marvell/libertas/radiotap.h:5:42: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/microchip/wilc1000/mon.c:10:42: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/microchip/wilc1000/mon.c:15:42: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/virtual/mac80211_hwsim.c:758:42: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/net/wireless/virtual/mac80211_hwsim.c:767:42: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/ZwBMtBZKcrzwU7l4@kspp
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c       |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c  |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h  |  2 +-
 .../net/wireless/marvell/libertas/radiotap.h  |  4 +-
 drivers/net/wireless/microchip/wilc1000/mon.c |  4 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c |  4 +-
 include/net/ieee80211_radiotap.h              | 43 +++++++++++--------
 7 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index f29ac6de71399..19702b6f09c32 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -306,7 +306,7 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 				       struct sk_buff *skb)
 {
 	struct wil6210_rtap {
-		struct ieee80211_radiotap_header rthdr;
+		struct ieee80211_radiotap_header_fixed rthdr;
 		/* fields should be in the order of bits in rthdr.it_present */
 		/* flags */
 		u8 flags;
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 0812db8936f13..9e9ff0cb724ca 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -2520,7 +2520,7 @@ static void isr_rx_monitor(struct ipw2100_priv *priv, int i,
 	 * to build this manually element by element, we can write it much
 	 * more efficiently than we can parse it. ORDER MATTERS HERE */
 	struct ipw_rt_hdr {
-		struct ieee80211_radiotap_header rt_hdr;
+		struct ieee80211_radiotap_header_fixed rt_hdr;
 		s8 rt_dbmsignal; /* signal in dbM, kluged to signed */
 	} *ipw_rt;
 
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.h b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
index 8ebf09121e173..226286cb7eb82 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
@@ -1143,7 +1143,7 @@ struct ipw_prom_priv {
  * structure is provided regardless of any bits unset.
  */
 struct ipw_rt_hdr {
-	struct ieee80211_radiotap_header rt_hdr;
+	struct ieee80211_radiotap_header_fixed rt_hdr;
 	u64 rt_tsf;      /* TSF */	/* XXX */
 	u8 rt_flags;	/* radiotap packet flags */
 	u8 rt_rate;	/* rate in 500kb/s */
diff --git a/drivers/net/wireless/marvell/libertas/radiotap.h b/drivers/net/wireless/marvell/libertas/radiotap.h
index 1ed5608d353ff..d543bfe739dcb 100644
--- a/drivers/net/wireless/marvell/libertas/radiotap.h
+++ b/drivers/net/wireless/marvell/libertas/radiotap.h
@@ -2,7 +2,7 @@
 #include <net/ieee80211_radiotap.h>
 
 struct tx_radiotap_hdr {
-	struct ieee80211_radiotap_header hdr;
+	struct ieee80211_radiotap_header_fixed hdr;
 	u8 rate;
 	u8 txpower;
 	u8 rts_retries;
@@ -31,7 +31,7 @@ struct tx_radiotap_hdr {
 #define IEEE80211_FC_DSTODS          0x0300
 
 struct rx_radiotap_hdr {
-	struct ieee80211_radiotap_header hdr;
+	struct ieee80211_radiotap_header_fixed hdr;
 	u8 flags;
 	u8 rate;
 	u8 antsignal;
diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index 03b7229a0ff5a..c3d27aaec2974 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -7,12 +7,12 @@
 #include "cfg80211.h"
 
 struct wilc_wfi_radiotap_hdr {
-	struct ieee80211_radiotap_header hdr;
+	struct ieee80211_radiotap_header_fixed hdr;
 	u8 rate;
 } __packed;
 
 struct wilc_wfi_radiotap_cb_hdr {
-	struct ieee80211_radiotap_header hdr;
+	struct ieee80211_radiotap_header_fixed hdr;
 	u8 rate;
 	u8 dump;
 	u16 tx_flags;
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 07be0adc13ec5..d86a1bd7aab08 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -736,7 +736,7 @@ static const struct rhashtable_params hwsim_rht_params = {
 };
 
 struct hwsim_radiotap_hdr {
-	struct ieee80211_radiotap_header hdr;
+	struct ieee80211_radiotap_header_fixed hdr;
 	__le64 rt_tsft;
 	u8 rt_flags;
 	u8 rt_rate;
@@ -745,7 +745,7 @@ struct hwsim_radiotap_hdr {
 } __packed;
 
 struct hwsim_radiotap_ack_hdr {
-	struct ieee80211_radiotap_header hdr;
+	struct ieee80211_radiotap_header_fixed hdr;
 	u8 rt_flags;
 	u8 pad;
 	__le16 rt_channel;
diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 2338f8d2a8b33..c6cb6f6427423 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -24,25 +24,27 @@
  * struct ieee80211_radiotap_header - base radiotap header
  */
 struct ieee80211_radiotap_header {
-	/**
-	 * @it_version: radiotap version, always 0
-	 */
-	uint8_t it_version;
-
-	/**
-	 * @it_pad: padding (or alignment)
-	 */
-	uint8_t it_pad;
-
-	/**
-	 * @it_len: overall radiotap header length
-	 */
-	__le16 it_len;
-
-	/**
-	 * @it_present: (first) present word
-	 */
-	__le32 it_present;
+	__struct_group(ieee80211_radiotap_header_fixed, hdr, __packed,
+		/**
+		 * @it_version: radiotap version, always 0
+		 */
+		uint8_t it_version;
+
+		/**
+		 * @it_pad: padding (or alignment)
+		 */
+		uint8_t it_pad;
+
+		/**
+		 * @it_len: overall radiotap header length
+		 */
+		__le16 it_len;
+
+		/**
+		 * @it_present: (first) present word
+		 */
+		__le32 it_present;
+	);
 
 	/**
 	 * @it_optional: all remaining presence bitmaps
@@ -50,6 +52,9 @@ struct ieee80211_radiotap_header {
 	__le32 it_optional[];
 } __packed;
 
+static_assert(offsetof(struct ieee80211_radiotap_header, it_optional) == sizeof(struct ieee80211_radiotap_header_fixed),
+	      "struct member likely outside of __struct_group()");
+
 /* version is always 0 */
 #define PKTHDR_RADIOTAP_VERSION	0
 
-- 
2.43.0



