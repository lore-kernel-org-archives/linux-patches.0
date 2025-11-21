Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1904D275B18;
	Fri, 21 Nov 2025 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731359; cv=none; b=On0bHe1U6JWD0V6hU0lt/v2mOjl7+GvWvsd3OVe5SL4nAK66HN9upw2EIp7urOMmMnwUVfeljzqpw4FAufTZCc1HpZbonT5rroCpMcR6RWO//Ax2MAGx/Z9vonKpItlReZZGk+L7c+kYJnIgig98L6mL8fvkikvjmfp8AhVwu/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731359; c=relaxed/simple;
	bh=H7n5sSb9xZODVAN028BV35a2fjM4VsVLvt9+gC/seGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYmzs5QtmCGnalp4Q2GM7LqydX5EcjRsg2irX5Lr/Z0kXMDy6Ex38fLtjVHdc+ZWkQzkfcOfnYmCjRSGDLMFycyr1WoqPgtI9855cQdKQZsqss1jQKA1oo9z/CKO7Tf/6Hkq3DTM7rxpdzpgN1lnm3l2X93d+73xiJUppHhNRkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBuLmaXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBuLmaXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C66EC4CEF1;
	Fri, 21 Nov 2025 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731358;
	bh=H7n5sSb9xZODVAN028BV35a2fjM4VsVLvt9+gC/seGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBuLmaXekQaqVY4RluR6aJ4TPF3gXgZoZ8v73qMFWPeDtxXOrfiBMKJdfsx2BaoKD
	 Hlu9SN2WK40/4Uj6QCbKFtw6QcZYLDg22+qkQHg8YowKzuCfY5nRiLuCwxHtYln2L3
	 8MDtQbRuPeGoTq3tQUpuGdt0mmX7X/uvRl0Oh9xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.17 180/247] wifi: mac80211: reject address change while connecting
Date: Fri, 21 Nov 2025 14:12:07 +0100
Message-ID: <20251121130201.182920283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit a9da90e618cd0669a22bcc06a96209db5dd96e9b upstream.

While connecting, the MAC address can already no longer be
changed. The change is already rejected if netif_carrier_ok(),
but of course that's not true yet while connecting. Check for
auth_data or assoc_data, so the MAC address cannot be changed.

Also more comprehensively check that there are no stations on
the interface being changed - if any peer station is added it
will know about our address already, so we cannot change it.

Cc: stable@vger.kernel.org
Fixes: 3c06e91b40db ("wifi: mac80211: Support POWERED_ADDR_CHANGE feature")
Link: https://patch.msgid.link/20251105154119.f9f6c1df81bb.I9bb3760ede650fb96588be0d09a5a7bdec21b217@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/iface.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -223,6 +223,10 @@ static int ieee80211_can_powered_addr_ch
 	if (netif_carrier_ok(sdata->dev))
 		return -EBUSY;
 
+	/* if any stations are set known (so they know this vif too), reject */
+	if (sta_info_get_by_idx(sdata, 0))
+		return -EBUSY;
+
 	/* First check no ROC work is happening on this iface */
 	list_for_each_entry(roc, &local->roc_list, list) {
 		if (roc->sdata != sdata)
@@ -242,12 +246,16 @@ static int ieee80211_can_powered_addr_ch
 			ret = -EBUSY;
 	}
 
+	/*
+	 * More interface types could be added here but changing the
+	 * address while powered makes the most sense in client modes.
+	 */
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
-		/* More interface types could be added here but changing the
-		 * address while powered makes the most sense in client modes.
-		 */
+		/* refuse while connecting */
+		if (sdata->u.mgd.auth_data || sdata->u.mgd.assoc_data)
+			return -EBUSY;
 		break;
 	default:
 		ret = -EOPNOTSUPP;


