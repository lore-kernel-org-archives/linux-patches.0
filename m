Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D7F192B75;
	Tue, 11 Nov 2025 00:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822156; cv=none; b=NdH3Jf8vo6hlelSST2vFwRsiiZf8aSQSoNQhMZUxrK5MbwEwBIDA0N1FwjoUlS3Sk4HKW8sGaTedBy0gWzJBZEou2Ta5sUgeFrBhrD+ZIrMn2nMrue8HIkqPQNy9ZwTCDNsg/dy0Fd3KYxJfgyqucDMrlQAc1pUK/tBZU7U0DVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822156; c=relaxed/simple;
	bh=7S5RTgnEIXB3VO+jYxJtvGkWBEbpigCqe2sSjMPvmys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0Or1i3bEqpw5u7JpwTdZxTFouIxxwuS7GcYo7uDt///7x68KdcAgJFjOQh0kHA5dn7a0Qs7VULVB/b7wFvJjsiKq1x3Eo9Gi373yx1gz4bLRDPZyWNu4mfnEKWuVtt4Grwna2Y53g4PjYKnsO42UM6OEbAeCcB9cML4D5knlPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTjDNdNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTjDNdNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3129FC4CEFB;
	Tue, 11 Nov 2025 00:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822155;
	bh=7S5RTgnEIXB3VO+jYxJtvGkWBEbpigCqe2sSjMPvmys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTjDNdNNiXyXCIRKZduzsLqbE4owFjHWyDPD9waQkqod7IPGa4O3Pio3uBe8aYuWO
	 a18Bi8xbsKDagt2y+QzOMGzcSdQAn8IugD7o7LgteDNRQX7lhYSTryFm51fAWTOsnU
	 vUNSB7fjtlB4laz9VZ7alts8poPu8AfMzjxeTorQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 039/849] wifi: mac80211: reset FILS discovery and unsol probe resp intervals
Date: Tue, 11 Nov 2025 09:33:29 +0900
Message-ID: <20251111004537.385618746@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>

[ Upstream commit 607844761454e3c17e928002e126ccf21c83f6aa ]

When ieee80211_stop_ap() deletes the FILS discovery and unsolicited
broadcast probe response templates, the associated interval values
are not reset. This can lead to drivers subsequently operating with
the non-zero values, leading to unexpected behavior.

Trigger repeated retrieval attempts of the FILS discovery template in
ath12k, resulting in excessive log messages such as:

mac vdev 0 failed to retrieve FILS discovery template
mac vdev 4 failed to retrieve FILS discovery template

Fix this by resetting the intervals in ieee80211_stop_ap() to ensure
proper cleanup of FILS discovery and unsolicited broadcast probe
response templates.

Fixes: 295b02c4be74 ("mac80211: Add FILS discovery support")
Fixes: 632189a0180f ("mac80211: Unsolicited broadcast probe response support")
Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Link: https://patch.msgid.link/20250924130014.2575533-1-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7609c7c31df74..e5e82e0b48ff1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1772,6 +1772,9 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	link_conf->nontransmitted = false;
 	link_conf->ema_ap = false;
 	link_conf->bssid_indicator = 0;
+	link_conf->fils_discovery.min_interval = 0;
+	link_conf->fils_discovery.max_interval = 0;
+	link_conf->unsol_bcast_probe_resp_interval = 0;
 
 	__sta_info_flush(sdata, true, link_id, NULL);
 
-- 
2.51.0



