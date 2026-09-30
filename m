Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885283AF674;
	Wed, 30 Sep 2026 18:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794672; cv=none; b=iuMwHik147NPeUqW9wfG2f6ZmUWErHcOpcK64yp0dU4tqZhtu3FRLxEUIGcOjU+3U5+E6S2IdD9hHz5vrVTN2vEUU/rThWlm7CFF22VE+BkiYoYUi5a9uM0ji9fx1t/BXODDuCKEq91aJhDWzys8GAzN7knecZ1mZyBahHgCUaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794672; c=relaxed/simple;
	bh=qWuwjWZXy8tfpF/q+CG0ycSLttz2S5r3orzCXNZqsOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8NqkgL0VXPYhTnvND/xwNNwiT/VecTCnnhFTqZiBwoShWsg+Wt77RKB6niiHKfQVI+wFzmbcqAn7Nd6GIRKoR3XaMcGXvfYojAFbykwXYDxhrzj2j5vOIGLNu/baT2O04T2LwUxwkxMSAAegRX6WXD6hZfTOUBngLBFFLgIMbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJIsFpqg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJIsFpqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D211F000FF;
	Wed, 30 Sep 2026 18:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794671;
	bh=4jbgaMcmmYS6miWr055Hn8C8aCx7j+7lNY9yGNINuvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJIsFpqgMk2cKdMRqs59cQsU63Ti/O2asmoja/UMz7wE6+kLYc8mn8hYBDaqbcb3T
	 4Cs2uS9oKjkQuQKPArhgjE444Fbaa3NLYuB9ooDS8dX4sXQRUXTokLSDuJaF9uRPpp
	 Mk4edeAofz9HC22+/Us8GkcYj3fQSyyzDg3lkNYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0294/1193] wifi: cfg80211: validate rx/tx MLME callback frame lengths before access
Date: Wed, 30 Sep 2026 17:16:18 +0200
Message-ID: <20260930152440.693077583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit d5e4586546974179feca305a94e07fac3e9727fe ]

cfg80211_rx_mlme_mgmt() and cfg80211_tx_mlme_mgmt() call tracepoints
before rejecting frames shorter than the frame-control field. After
that, they only require len >= 2 before dispatching into subtype
handlers that assume their fixed fields are present.

The frames that trip this are not shorter than 2 bytes; they are short
relative to their subtype. mwifiex is a concrete in-tree example on the
length side: mwifiex_process_mgmt_packet() only requires a 4-address
ieee80211_hdr plus the 2-byte firmware length prefix before handing the
frame to cfg80211_rx_mlme_mgmt(). After stripping the length prefix and
removing addr4, pkt_len can be exactly 24: a bare 3-address management
header with no reason-code body. The existing WARN_ON(len < 2) does not
fire on such a frame, and cfg80211_process_deauth() then reads
u.deauth.reason_code as a two-byte access starting at offset 24,
immediately past the 24-byte buffer.

Add a frame-control length gate, then validate each subtype's minimum
frame size in an if/else-if chain that mirrors the dispatch logic. Trace
only after the frame is known to be well-formed.

Side effects of this change:
 - The WARN_ON(len < 2) is dropped. It only guarded the frame_control
   read, never the subtype fixed fields, and it does not fire on the
   frames that actually trigger the out-of-bounds read (which are >= 2).
   The len >= 2 check is kept as the guard before dereferencing
   frame_control, but without the warning: these are exported callbacks
   and a malformed frame from a driver should be dropped silently rather
   than backtraced.
 - cfg80211_tx_mlme_mgmt() previously routed every non-deauth subtype
   through disassociation handling; it now silently ignores unrecognised
   subtypes.

Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260707025336.22557-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 6fbcc9f70b6d0..ecde84d9070de 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -164,19 +164,35 @@ void cfg80211_rx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_mgmt *mgmt = (void *)buf;
+	__le16 fc;
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	trace_cfg80211_rx_mlme_mgmt(dev, buf, len);
+	if (len < sizeof(fc))
+		return;
+
+	fc = mgmt->frame_control;
 
-	if (WARN_ON(len < 2))
+	if (ieee80211_is_auth(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.auth.status_code))
+			return;
+	} else if (ieee80211_is_deauth(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.deauth.reason_code))
+			return;
+	} else if (ieee80211_is_disassoc(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.disassoc.reason_code))
+			return;
+	} else {
 		return;
+	}
+
+	trace_cfg80211_rx_mlme_mgmt(dev, buf, len);
 
-	if (ieee80211_is_auth(mgmt->frame_control))
+	if (ieee80211_is_auth(fc))
 		cfg80211_process_auth(wdev, buf, len);
-	else if (ieee80211_is_deauth(mgmt->frame_control))
+	else if (ieee80211_is_deauth(fc))
 		cfg80211_process_deauth(wdev, buf, len, false);
-	else if (ieee80211_is_disassoc(mgmt->frame_control))
+	else
 		cfg80211_process_disassoc(wdev, buf, len, false);
 }
 EXPORT_SYMBOL(cfg80211_rx_mlme_mgmt);
@@ -229,15 +245,28 @@ void cfg80211_tx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_mgmt *mgmt = (void *)buf;
+	__le16 fc;
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	trace_cfg80211_tx_mlme_mgmt(dev, buf, len, reconnect);
+	if (len < sizeof(fc))
+		return;
 
-	if (WARN_ON(len < 2))
+	fc = mgmt->frame_control;
+
+	if (ieee80211_is_deauth(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.deauth.reason_code))
+			return;
+	} else if (ieee80211_is_disassoc(fc)) {
+		if (len < offsetofend(struct ieee80211_mgmt, u.disassoc.reason_code))
+			return;
+	} else {
 		return;
+	}
+
+	trace_cfg80211_tx_mlme_mgmt(dev, buf, len, reconnect);
 
-	if (ieee80211_is_deauth(mgmt->frame_control))
+	if (ieee80211_is_deauth(fc))
 		cfg80211_process_deauth(wdev, buf, len, reconnect);
 	else
 		cfg80211_process_disassoc(wdev, buf, len, reconnect);
-- 
2.53.0



