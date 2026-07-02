Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783DC1C695;
	Thu,  2 Jul 2026 16:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011405; cv=none; b=pFnmaIpca/exsI2/aGx/MmYflLMSEFcuXQJu50lmvtXxUO3Vo4+vWFoZd8mO6a45MwSM7TGhqZOGkg7SUbM0US6ydqooBgyI6ejpRg1bcvCPUe+NDdWyiTno9TVStJdiG3ue/9EtsEeeoAGiGLah/wqaEL7UItv8Sd4HUX31MIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011405; c=relaxed/simple;
	bh=Gx2np9udPhXUKZuFJMCAcQDIF0C8BhzxZZ1A/C2VyEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0i+IdGN++G+3RzQcXg8rZcEG0pSrGGEtgMlqgRg7DR/IEtt0UBHTblz33DziqLZyjUMR7MofEx5tzKvVSDePTG/6s/tTmR/VVCViIYouv6ZfdwKnLY/u8HXBPEc2zkHQB4NCl9XsGLNPFP4RHL8a2D46DdhZVWodkRWQgnOvNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdrkGyEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdrkGyEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB791F000E9;
	Thu,  2 Jul 2026 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011404;
	bh=XyfdxUgZUgq4XQ/9H8d/l4YHC2Xn7NnEccRB71H8+E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdrkGyEM3oY/I638SE9QPVWLK7TfeocYOX2CItcJWu1CXpTwsDkyuFvsZnSGHawDC
	 sJcc8TrVX0bjuyIlV8pnhLZL5KKtu0qz59ygtMXF4iH5FJQNDGv3GCPyA6+tdmFTvA
	 b55qtLkzA0j/9sjzuqESR+ORQTym92KlhyfQqBcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ElXreno <elxreno@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 052/108] wifi: mt76: mt7925: dont disable AP BSS when removing TDLS peer
Date: Thu,  2 Jul 2026 18:20:49 +0200
Message-ID: <20260702155113.187782415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: ElXreno <elxreno@gmail.com>

commit 37d65384aa6f9cbe45f4052b13b378af1aab3e95 upstream.

On a STATION vif, removing a TDLS peer takes the mt7925_mac_sta_remove
-> mt7925_mac_sta_remove_links path. The first loop in that function
calls mt7925_mcu_add_bss_info(..., enable=false) for every link of the
station being removed. For a non-MLO STATION vif there is exactly one
link, link 0, whose bss_conf is the AP's. TDLS peers do not have their
own bss_conf - they share the AP's BSS.

The result is that every TDLS peer teardown sends a BSS_INFO_UPDATE
with enable=0 for the AP's BSS to the firmware, which wipes the AP-side
rate-control context. The connection stays associated and TX from the
host still works at the negotiated rate, but the AP's downlink to us
collapses to the lowest mandatory OFDM rate (HE-MCS 0 / 6 Mbit/s OFDM)
and only slowly recovers as rate adaptation re-learns under sustained
traffic. With brief or bursty traffic the link can stay at 6-72 Mbit/s
indefinitely, requiring a manual reconnect.

mt7925_mac_link_sta_remove() already guards its own
mt7925_mcu_add_bss_info(..., false) call with
"vif->type == NL80211_IFTYPE_STATION && !link_sta->sta->tdls".
Add the equivalent guard at the top of the cleanup loop in
mt7925_mac_sta_remove_links(), above the link_sta / link_conf /
mlink / mconf lookups, so TDLS peer teardown skips the loop body
entirely without doing the per-link work that would just be thrown
away.

Verified on mt7925e by triggering Samsung-S938B auto-TDLS via iperf3
and watching iw rx bitrate after teardown:

  Before: rx bitrate collapses to 6.0-72.0 Mbit/s, oscillates 17/72/
          137/288/432 Mbit/s for 30+ seconds, no full recovery without
          a manual reassoc.
  After:  rx bitrate stays at 1200.9 Mbit/s HE-MCS 11 NSS 2 80 MHz
          across the entire TDLS lifecycle.

bpftrace confirms a single mt7925_mcu_add_bss_info(enable=0) call per
teardown before the fix; zero such calls after.

Fixes: 3878b4333602 ("wifi: mt76: mt7925: update mt7925_mac_link_sta_[add, assoc, remove] for MLO")
Cc: stable@vger.kernel.org
Signed-off-by: ElXreno <elxreno@gmail.com>
Assisted-by: Claude:claude-opus-4-7 bpftrace
Link: https://patch.msgid.link/20260506-mt7925-tdls-fixes-v2-2-46aa826ba8bb@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1144,6 +1144,9 @@ mt7925_mac_sta_remove_links(struct mt792
 		if (vif->type == NL80211_IFTYPE_AP)
 			break;
 
+		if (vif->type == NL80211_IFTYPE_STATION && sta->tdls)
+			continue;
+
 		link_sta = mt792x_sta_to_link_sta(vif, sta, link_id);
 		if (!link_sta)
 			continue;


