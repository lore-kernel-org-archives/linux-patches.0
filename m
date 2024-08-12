Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8786B187553;
	Mon, 12 Aug 2024 16:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479270; cv=none; b=nTNJNxx3XPMDu+XL3Xh51RrHacbhT0m1Ns4s0cp4CAT9th7OntUdTxeTPgmITXACc2ly89rhByC/PjC0n2RvBP5Q/k11One8z5ESMGe+Atdz/ekH5HnlDow3Ts0mb3VYH8pFV1cSill6IaB/w1veKgn0uLuaZsTXiKWPgRu83fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479270; c=relaxed/simple;
	bh=SlqimF2OD3AMO1Wjbc+KQxZ8BAyqBsJzeoFsDzU/dkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csoViygthJO0CmvfEDu4egf5g/itkCKkvFh/BmbnCFoqLHNRke9VIB1XMncUcnp/o+dkQBWaUY++3KnX7tKKlOtl7cmj+142Coc3OTHXrVxKNvC3tb57f8OzMo23kZ6ZYomWuOCN8BBYcGXB96+xj+gwdiP+rUfjuBgKC5n1zyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hK9MWCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hK9MWCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C083C32782;
	Mon, 12 Aug 2024 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479270;
	bh=SlqimF2OD3AMO1Wjbc+KQxZ8BAyqBsJzeoFsDzU/dkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hK9MWCKy09E/2WpFU7pwExDM7c7ESh92fLlZLeU6HeOW6sVc1jCJ5CSLNkfIes67
	 eO57VhlkMNZNs1cMPewE8LhFOKPXhF5I0MG2v4wBj5KRkBCpcJWomP6KCHGO1hJyEl
	 TtDYwLBbow19//rCVN741X09d1KCbDPJg8s7DTSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc0f5b92cc7091f45fb6@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/189] wifi: nl80211: disallow setting special AP channel widths
Date: Mon, 12 Aug 2024 18:01:31 +0200
Message-ID: <20240812160133.498147085@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 23daf1b4c91db9b26f8425cc7039cf96d22ccbfe ]

Setting the AP channel width is meant for use with the normal
20/40/... MHz channel width progression, and switching around
in S1G or narrow channels isn't supported. Disallow that.

Reported-by: syzbot+bc0f5b92cc7091f45fb6@syzkaller.appspotmail.com
Link: https://msgid.link/20240515141600.d4a9590bfe32.I19a32d60097e81b527eafe6b0924f6c5fbb2dc45@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8f8f077e6cd40..053258b4e28d2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3398,6 +3398,33 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			if (chandef.chan != cur_chan)
 				return -EBUSY;
 
+			/* only allow this for regular channel widths */
+			switch (wdev->links[link_id].ap.chandef.width) {
+			case NL80211_CHAN_WIDTH_20_NOHT:
+			case NL80211_CHAN_WIDTH_20:
+			case NL80211_CHAN_WIDTH_40:
+			case NL80211_CHAN_WIDTH_80:
+			case NL80211_CHAN_WIDTH_80P80:
+			case NL80211_CHAN_WIDTH_160:
+			case NL80211_CHAN_WIDTH_320:
+				break;
+			default:
+				return -EINVAL;
+			}
+
+			switch (chandef.width) {
+			case NL80211_CHAN_WIDTH_20_NOHT:
+			case NL80211_CHAN_WIDTH_20:
+			case NL80211_CHAN_WIDTH_40:
+			case NL80211_CHAN_WIDTH_80:
+			case NL80211_CHAN_WIDTH_80P80:
+			case NL80211_CHAN_WIDTH_160:
+			case NL80211_CHAN_WIDTH_320:
+				break;
+			default:
+				return -EINVAL;
+			}
+
 			result = rdev_set_ap_chanwidth(rdev, dev, link_id,
 						       &chandef);
 			if (result)
-- 
2.43.0



