Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547FE18801C;
	Tue, 30 Jul 2024 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358434; cv=none; b=aAcvQ3ihRv6ADFBbQVXjdnd1fINu68hVpb03QMZ8FShj/nWPXf2IQpZIFw2r3Tbhm/Vs2D64/gPSIF5ZhNCW/tYv9kjGJJwQNTcMSSQyZByz7ROVEng4Wz1lqVzssEENZ5pm81zaSDaUPeVQCpOxdEni5ewprHlI5VxkbGPWvK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358434; c=relaxed/simple;
	bh=4DzYK3dtGfH/zMbybc9d9eQ/Yz6sROOJoliebTeQlOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAwhvd5jiFKSmoT5NLsbLqTGZuNoA2Gw8r0PDS3FBl8bPRh/xIgYaUWtLi/HRIsFv4N6mn3ejIaK5MXjT2bXI7wylrdm5/3BNKub/ThORZwFWBAVIE8lRhZYfqEvFlaB0dDhRzp8XQ1ymzEnkX4RKMv474ojEaFzp4BriTztd2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7hZYF3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7hZYF3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAE9C32782;
	Tue, 30 Jul 2024 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358433;
	bh=4DzYK3dtGfH/zMbybc9d9eQ/Yz6sROOJoliebTeQlOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7hZYF3h43fJwiPsjMU+MRGwauC0vScZtY2GaEhEOZI6PLh7nMzpymahHJSkj4f2a
	 eLSLzepf8/CpZup2UIv4E/ieI5JohdZhKj4Hn+6XHj5ow5wD4S6MPOGx6vEXyB+47W
	 Yal+mLuefyJOQIF+8pl5DbtdmXrL6tWAkT2oEcxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <quic_ramess@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6.1 390/440] wifi: mac80211: Allow NSS change only up to capability
Date: Tue, 30 Jul 2024 17:50:23 +0200
Message-ID: <20240730151631.036728149@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rameshkumar Sundaram <quic_ramess@quicinc.com>

commit 57b341e9ab13e5688491bfd54f8b5502416c8905 upstream.

Stations can update bandwidth/NSS change in
VHT action frame with action type Operating Mode Notification.
(IEEE Std 802.11-2020 - 9.4.1.53 Operating Mode field)

For Operating Mode Notification, an RX NSS change to a value
greater than AP's maximum NSS should not be allowed.
During fuzz testing, by forcefully sending VHT Op. mode notif.
frames from STA with random rx_nss values, it is found that AP
accepts rx_nss values greater that APs maximum NSS instead of
discarding such NSS change.

Hence allow NSS change only up to maximum NSS that is negotiated
and capped to AP's capability during association.

Signed-off-by: Rameshkumar Sundaram <quic_ramess@quicinc.com>
Link: https://lore.kernel.org/r/20230207114146.10567-1-quic_ramess@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/vht.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -637,7 +637,7 @@ u32 __ieee80211_vht_handle_opmode(struct
 	enum ieee80211_sta_rx_bandwidth new_bw;
 	struct sta_opmode_info sta_opmode = {};
 	u32 changed = 0;
-	u8 nss;
+	u8 nss, cur_nss;
 
 	/* ignore - no support for BF yet */
 	if (opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)
@@ -648,10 +648,25 @@ u32 __ieee80211_vht_handle_opmode(struct
 	nss += 1;
 
 	if (link_sta->pub->rx_nss != nss) {
-		link_sta->pub->rx_nss = nss;
-		sta_opmode.rx_nss = nss;
-		changed |= IEEE80211_RC_NSS_CHANGED;
-		sta_opmode.changed |= STA_OPMODE_N_SS_CHANGED;
+		cur_nss = link_sta->pub->rx_nss;
+		/* Reset rx_nss and call ieee80211_sta_set_rx_nss() which
+		 * will set the same to max nss value calculated based on capability.
+		 */
+		link_sta->pub->rx_nss = 0;
+		ieee80211_sta_set_rx_nss(link_sta);
+		/* Do not allow an nss change to rx_nss greater than max_nss
+		 * negotiated and capped to APs capability during association.
+		 */
+		if (nss <= link_sta->pub->rx_nss) {
+			link_sta->pub->rx_nss = nss;
+			sta_opmode.rx_nss = nss;
+			changed |= IEEE80211_RC_NSS_CHANGED;
+			sta_opmode.changed |= STA_OPMODE_N_SS_CHANGED;
+		} else {
+			link_sta->pub->rx_nss = cur_nss;
+			pr_warn_ratelimited("Ignoring NSS change in VHT Operating Mode Notification from %pM with invalid nss %d",
+					    link_sta->pub->addr, nss);
+		}
 	}
 
 	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {


