Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E8351B191;
	Wed, 30 Sep 2026 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791140; cv=none; b=i6fEirxuN5TzoZUlQPpfe3Jnjw6HyAKYH3lwQ633xEn1wVgiHQPBapR5CmRW6AJjuelxpQy5T4PRZp/md5ebrWSSbRsjCXVWRHvX1i9kuwNmus9MQ8asEMia+q/KOZZoqaN9Jh+QdQ0hHJRuVGAYJkcSJZo51OI1iiBNTmlpD7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791140; c=relaxed/simple;
	bh=XcJcfvIAaYEiorNSrl2n6Z7yl702Vho6czqn5q4d/zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXE29t5bKB/LC9/qNm3/BxJMBDbjaHACStMTFSqkvUBJO40BCtD20y50tfEowzXHqwQflBg9HlKy0SGJGW+V0ln6fcx2PptZnMb6jWpwofnts1xUlUlqep6mmHPW/T+xBLwsLUVazyatFT2+1Mq7N8AZhxTe2iV7S89WvEI4lg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diCLV+ra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diCLV+ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C677B1F00898;
	Wed, 30 Sep 2026 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791139;
	bh=74/1l7t9qR4rMthdUaMQ41qV9juNMsqsXqDyf0FHVr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=diCLV+raDJPZwgyUqsmRTLH768HFSgybeKMcHvx26dBonv2jugeB/j9aCPuVS5T4u
	 uJDHJdeYVq1HJgm6GYasT7pIYOOjUR0PXqnxM05YDHWJhMTlXhd4zhDqEMYGA1GZVh
	 cc2g47KdYr+NhuHAmqrMLipDxrKaN/7uXZNsY6U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/752] wifi: cfg80211: validate rx/tx MLME callback frame lengths before access
Date: Wed, 30 Sep 2026 17:21:08 +0200
Message-ID: <20260930152402.504678472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5c805a2bda62f..2aeaff9d4e789 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -125,19 +125,35 @@ void cfg80211_rx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_mgmt *mgmt = (void *)buf;
+	__le16 fc;
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	trace_cfg80211_rx_mlme_mgmt(dev, buf, len);
+	if (len < sizeof(fc))
+		return;
 
-	if (WARN_ON(len < 2))
+	fc = mgmt->frame_control;
+
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
 
-	if (ieee80211_is_auth(mgmt->frame_control))
+	trace_cfg80211_rx_mlme_mgmt(dev, buf, len);
+
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
@@ -188,15 +204,28 @@ void cfg80211_tx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len,
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



