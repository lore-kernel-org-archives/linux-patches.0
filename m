Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89FA17BED0;
	Sat, 17 Oct 2026 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253325; cv=none; b=rjam4Jaczjf31dPVWxEbK6qAthYM0nMRJN6S8Y9T6+o2tv1cTp8yf/opfgVIR7YucN3pmFTCbU0P7ByWjkRtrylkquWBci/YkXnzxLhy6BNf1s/viJsZKdJMER4K0NC/Cl2ZFMC+L8XG7Da75bd8dxxyyLHyuergW0KdEPnJQts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253325; c=relaxed/simple;
	bh=xSIopImmpdBwjGYCvlCLEDoHLdbPCX9wzKyvO7avudw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eto+MVpCqD50PBVdxI5Wi07v0mbZHMYFjeSdLUAfGjmAhaGRoS+6FWIgZRpeN8nEJW8PbXaT9Btf1Q4clRQzAOZj1Mgebs88ydEzbYpzfCUORmWVU7dgofrTmgPCjnoEWnOg/tVgh3n5FvpqJlaGz+A7cNyQxk2J0WKnFQ9Ynz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7I38JrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7I38JrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDB01F000C4;
	Sat, 17 Oct 2026 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253324;
	bh=Sfurqs3NKja8m4hqfoP1W+LEhHmxKIjr78rNOlpC3sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7I38JrR7l6eEeGTcg6KuQaucfJGdTC9t1Y3Q1Z/7GNBeQ9hhOUndcrVPf/el3ixO
	 l/d9w7/8DjLCL2dTXSLqmLKmDKc7tnkR4Wq8ljjpfFjgN3e+pRKWhguMK+AEINlTgE
	 VIqfbseaGbjGazsQi7UzYYjrDFXNmwlhZFKheRzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram R <quic_srirrama@quicinc.com>,
	Rameshkumar Sundaram <quic_ramess@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/869] wifi: ath12k: prepare vif data structure for MLO handling
Date: Sat, 17 Oct 2026 17:48:43 +0200
Message-ID: <20261017160039.131180772@linuxfoundation.org>
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

From: Sriram R <quic_srirrama@quicinc.com>

[ Upstream commit 3dd2c68f206ef7020d12b9f85cbfe05ca8662cf4 ]

To prepare the driver for MLO support, split the driver vif data structure to
scale for multiple links. This requires changing the use of arvif to per link
and not per hw which can now comprise of multiple links. Also since most
configurations from mac80211 are done per link, do refactoring of the driver
functions to apply these configurations at link level.

Split ath12k_vif which is the driver private of ieee80211_vif to store link
specific information as ath12k_link_vif. For default use cases the ath12k vif
will have a preallocated link vif called deflink which will be used by non ML
and the first link vif of ML vif.

With MLO support to be added, remaining link vifs will be allocated during
channel assignment where vdev create/start happens. These link vifs will be
freed during interface down.

       		Current ath12k_vif(arvif) structure

             +---------------+      +---------------+     +---------------+
             | ieee80211_vif |      | ieee80211_vif |     | ieee80211_vif |
             | private data  |      | private data  |     | private data  |
             |               |      |               |     |               |
             |  ath12k_vif   |      |  ath12k_vif   |     |  ath12k_vif   |
             |  (arvif)      |      |  (arvif)      |     |  (arvif)      |
             |               |      |               |     |               |
             |  +----------+ |      |  +----------+ |     |  +----------+ |
             |  |*ar (2GHz)| |      |  |*ar (5GHz)| |     |  |*ar (2GHz)| |
             |  +----------+ |      |  +----------+ |     |  +----------+ |
             |               |      |               |     |               |
             +---------------+      +---------------+     +---------------+

The new ath12k_vif (ahvif) containing ath12k_link_vif(s) (arvif) (deflink is
preallocated member which is always the first link if ieee80211_vif is MLD and
is the only link otherwise):

       			+---------------------------------+
       			|     ieee80211_vif               |
       			|     private data                |
       			|                                 |
       			|   ath12k_vif(ahvif)             |
       			|                                 |
       			| +-------------------------------+
       			| |ath12k_link_vif deflink (arvif)|
       			| |        +---------------+      |
       			| |        | *ar(2GHz)     |      |
       			| +-------------------------------+
       			| +-------------------------------+
       			| |  ath12k_link_vif *link (arvif)|
       			| |        +---------------+      |
       			| |        | *ar(5GHz)     |      |
       			| +-------------------------------+
       			| +-------------------------------+
       			| |  ath12k_link_vif *link (arvif)|
       			| |        +---------------+      |
       			| |        | *ar(6GHz)     |      |
       			| +-------------------------------+
       			|                                 |
       			+---------------------------------+

To refactor existing ath12k_vif to make use of link vifs, following
changes are made:

 1. ath12k_vif now called by variable name ahvif storing multiple
    arvifs (struct ah12k_link_vif) and also has a back pointer to ieee80211_vif.

 2. In this patch set, only deflink is used to be on par with the
    existing code. When MLO support is added the link id will be used to fetch
    the arvif.

 3. For mac80211 ops which doesn't use specific link_id, the config or info
    is common for the vif, hence apply the config to all link vifs.
    The links_map in the ahvif, will be used to identify all the link vifs that
    are setup.

 4. Change ath12k_vif_to_arvif() as ath12k_vif_to_ahvif() to fetch the
    hw level vif. The link vif can be fetched from ahvif->link[], or the
    deflink can be accessed via ahvif->deflink. API to access link
    vif (arvif) by passing link_id can be introduced with MLO Support.

 5. The ieee80211_vif can be accessed from ahvif using ath12k_ahvif_to_vif().

The locking continues to use wiphy_lock() for protecting access to most data in
struct ath12k&co, there are no changes in that regard. Though struct
ath12k_vif::link[] is protected with RCU.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Co-developed-by: Rameshkumar Sundaram <quic_ramess@quicinc.com>
Signed-off-by: Rameshkumar Sundaram <quic_ramess@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20241015171416.518022-2-kvalo@kernel.org
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Retain only the removal of the blank line immediately before the rx_stats
allocation in ath12k_mac_station_add(). This supplies the exact preimage
needed by the subsequent allocation guard fix. Keeping the separator
causes that fix to conflict, including when using a three-way merge.

Drop the MLO vif split and associated API changes. The allocation guard
does not need them, and they assume locking changes that are absent here.
There is no runtime behavior change.

Stable-dep-of: c426497fa205 ("wifi: ath12k: Fix memory leak due to multiple rx_stats allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index f3785bc0f4c8e..3a7fb0e490fa3 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4481,7 +4481,6 @@ static int ath12k_mac_station_add(struct ath12k *ar,
 			    ar->max_num_stations);
 		goto exit;
 	}
-
 	arsta->rx_stats = kzalloc(sizeof(*arsta->rx_stats), GFP_KERNEL);
 	if (!arsta->rx_stats) {
 		ret = -ENOMEM;
-- 
2.53.0



