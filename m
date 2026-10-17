Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8BC2C026C;
	Sat, 17 Oct 2026 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254311; cv=none; b=anFjWJ63eobinnXYQV0ggc/n4HZ0HZRGrh6zNHUYnzdaSun5nN4ekdoCYa/Nl+AuAAoxu4Kw0ZM3lBJU6Kg9GPi1qKaOSyrj9I4Ek3TTqguUVkOOaMTbdtWDkXZsCR3xF2iQkTi88iO0qB9h069sQd4mo50uhqaVIp3kZoevPPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254311; c=relaxed/simple;
	bh=Ql7e0B/H/jyPTgfcmgop4r73i11nsuEL+HiEluCKINo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhoHW2zMAnn74dNEJSFQV6G+21VIy3aTiSSnT1T7HQ3CsA54jbGQo1MnFo4X4XkR38QIIlEq7s2EWYPrjk+pVsOkOquaVXcb3c8LvB0KshqgQqSSO6jzQOTVp047DYQM0pf/MnjvbIVsf31dlNtlV8fA6siGcjNBLH3Guo/LZs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLZJ5PGV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLZJ5PGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C34D1F000C4;
	Sat, 17 Oct 2026 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254310;
	bh=2c9bjJwI3AWM4wk5BUAKicOK35mSI41+TzF5dBDMc3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLZJ5PGVEuuhT6pe8oAZHEF3fll1LGrOkEZ5ypQO2VVVe88vv/2J3GxNZ2ARCsMkK
	 0CFGg/f9Kayr8Il0dFZsa4XlfMouO2kJs1MvQm3n32wMorQntOgx71tS1qiRBoLMXT
	 cXjVK31CX8cq5qoH+CDO5ZKtsqahfZSR7/7/TBVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 405/869] wifi: cfg80211: add link_station_info structure to support MLO statistics
Date: Sat, 17 Oct 2026 17:54:06 +0200
Message-ID: <20261017160047.518779517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit d2329fff7e527e8b350086be2e7cbf0d190177a3 ]

Current implementation of NL80211_GET_STATION does not work for
multi-link operation(MLO) since in case of MLO only deflink (or one
of the links) is considered and not all links.

Therefore to support for MLO, add link_station_info structure
to account link level statistics for station.

Additionally, add valid_links in station_info structure to indicate
bitmap of valid links for MLO. This will be helpful to check the link
related statistics during MLO.

Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Link: https://patch.msgid.link/20250528054420.3050133-3-quic_sarishar@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: aa2eb6252518 ("wifi: mac80211: defer link RX stats percpu free to RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 101 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a04b98eff1666..83558dec5132d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2049,6 +2049,99 @@ struct cfg80211_tid_stats {
 
 #define IEEE80211_MAX_CHAINS	4
 
+/**
+ * struct link_station_info - link station information
+ *
+ * Link station information filled by driver for get_station() and
+ *	dump_station().
+ * @filled: bit flag of flags using the bits of &enum nl80211_sta_info to
+ *	indicate the relevant values in this struct for them
+ * @connected_time: time(in secs) since a link of station is last connected
+ * @inactive_time: time since last activity for link station(tx/rx)
+ *	in milliseconds
+ * @assoc_at: bootime (ns) of the last association of link of station
+ * @rx_bytes: bytes (size of MPDUs) received from this link of station
+ * @tx_bytes: bytes (size of MPDUs) transmitted to this link of station
+ * @signal: The signal strength, type depends on the wiphy's signal_type.
+ *	For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_.
+ * @signal_avg: Average signal strength, type depends on the wiphy's
+ *	signal_type. For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_
+ * @chains: bitmask for filled values in @chain_signal, @chain_signal_avg
+ * @chain_signal: per-chain signal strength of last received packet in dBm
+ * @chain_signal_avg: per-chain signal strength average in dBm
+ * @txrate: current unicast bitrate from this link of station
+ * @rxrate: current unicast bitrate to this link of station
+ * @rx_packets: packets (MSDUs & MMPDUs) received from this link of station
+ * @tx_packets: packets (MSDUs & MMPDUs) transmitted to this link of station
+ * @tx_retries: cumulative retry counts (MPDUs) for this link of station
+ * @tx_failed: number of failed transmissions (MPDUs) (retries exceeded, no ACK)
+ * @rx_dropped_misc:  Dropped for un-specified reason.
+ * @bss_param: current BSS parameters
+ * @beacon_loss_count: Number of times beacon loss event has triggered.
+ * @expected_throughput: expected throughput in kbps (including 802.11 headers)
+ *	towards this station.
+ * @rx_beacon: number of beacons received from this peer
+ * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
+ *	from this peer
+ * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
+ * @tx_duration: aggregate PPDU duration(usecs) for all the frames to a peer
+ * @airtime_weight: current airtime scheduling weight
+ * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
+ *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
+ *	Note that this doesn't use the @filled bit, but is used if non-NULL.
+ * @ack_signal: signal strength (in dBm) of the last ACK frame.
+ * @avg_ack_signal: average rssi value of ack packet for the no of msdu's has
+ *	been sent.
+ * @rx_mpdu_count: number of MPDUs received from this station
+ * @fcs_err_count: number of packets (MPDUs) received from this station with
+ *	an FCS error. This counter should be incremented only when TA of the
+ *	received packet with an FCS error matches the peer MAC address.
+ * @addr: For MLO STA connection, filled with address of the link of station.
+ */
+struct link_station_info {
+	u64 filled;
+	u32 connected_time;
+	u32 inactive_time;
+	u64 assoc_at;
+	u64 rx_bytes;
+	u64 tx_bytes;
+	s8 signal;
+	s8 signal_avg;
+
+	u8 chains;
+	s8 chain_signal[IEEE80211_MAX_CHAINS];
+	s8 chain_signal_avg[IEEE80211_MAX_CHAINS];
+
+	struct rate_info txrate;
+	struct rate_info rxrate;
+	u32 rx_packets;
+	u32 tx_packets;
+	u32 tx_retries;
+	u32 tx_failed;
+	u32 rx_dropped_misc;
+	struct sta_bss_parameters bss_param;
+
+	u32 beacon_loss_count;
+
+	u32 expected_throughput;
+
+	u64 tx_duration;
+	u64 rx_duration;
+	u64 rx_beacon;
+	u8 rx_beacon_signal_avg;
+
+	u16 airtime_weight;
+
+	s8 ack_signal;
+	s8 avg_ack_signal;
+	struct cfg80211_tid_stats *pertid;
+
+	u32 rx_mpdu_count;
+	u32 fcs_err_count;
+
+	u8 addr[ETH_ALEN] __aligned(2);
+};
+
 /**
  * struct station_info - station information
  *
@@ -2133,6 +2226,11 @@ struct cfg80211_tid_stats {
  *	dump_station() callbacks. User space needs this information to determine
  *	the accepted and rejected affiliated links of the connected station.
  * @assoc_resp_ies_len: Length of @assoc_resp_ies buffer in octets.
+ * @valid_links: bitmap of valid links, or 0 for non-MLO. Drivers fill this
+ *	information in cfg80211_new_sta(), cfg80211_del_sta_sinfo(),
+ *	get_station() and dump_station() callbacks.
+ * @links: reference to Link sta entries for MLO STA, all link specific
+ *	information is accessed through links[link_id].
  */
 struct station_info {
 	u64 filled;
@@ -2198,6 +2296,9 @@ struct station_info {
 	u8 mld_addr[ETH_ALEN] __aligned(2);
 	const u8 *assoc_resp_ies;
 	size_t assoc_resp_ies_len;
+
+	u16 valid_links;
+	struct link_station_info *links[IEEE80211_MLD_MAX_NUM_LINKS];
 };
 
 /**
-- 
2.53.0



