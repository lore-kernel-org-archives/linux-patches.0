Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE7C53E30D;
	Thu, 17 Sep 2026 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664824; cv=none; b=rrH1Xqcz6UuUY/wivTB2HatV6kD2D8ITuXinH/vUB+n9XbUzGIuiunF8gD5jlqyWxB6q3uBEUMZdKgfh0W0m0j+vnHI2IRBvZP3VWxxHvMO0dS09TpwZOqZDBS2gM7ieLToMMuqT1aY+ZZFIbc0jjH8UC9lW/3cQ0dRZzZNGHko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664824; c=relaxed/simple;
	bh=vAU2SeXZvLiCaqbPUHv7A1iPsf82ss49f4fKsV9Olqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKn5FY8q+hHgl7+JSuHuk2QrhBzibRwB9KFTR2PPIfdrh0D1Y11BOjYtMWP+Y0ziQpogHMvGmDu1t0uOrGsHQQPBRap0Q1+wXTJlmaQ/TpR/rs5lR9Eli8Il5mQAaFeWsl4iE88pRFMPMEZ4De6X+ewvY6iI7EU4iGa+kzInSjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQ27pHtO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQ27pHtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983581F000FF;
	Thu, 17 Sep 2026 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664823;
	bh=Adijb5gHn4qLnWhWyVeTSIAXkso7vN25xaN1Spsdjyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQ27pHtOKwUj9CUbldfCJajG5WzEKidxSLKIWFKhhh3uLeyiTmKLGB1qEbwfUGHEI
	 odp92VF/px+tIIn7X8T2a7h0w3jLHqMJQ8CLoYrdG0OM2f86JYbyzjQVNBt9NXhrvH
	 utcOhefmw9QrN9Hrn5rLUr+DOUpcHVhsWaD1YbTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0500/1250] wifi: cfg80211: validate rx/tx MLME callback frame lengths before access
Date: Thu, 17 Sep 2026 16:04:55 +0100
Message-ID: <20260917151605.512219063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index bf2c0d26e11c6..a304c0e8736f6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -164,19 +164,35 @@ void cfg80211_rx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_mgmt *mgmt = (void *)buf;
+	__le16 fc;
 
 	lockdep_assert_wiphy(wdev->wiphy);
 
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
 
 	lockdep_assert_wiphy(wdev->wiphy);
 
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



