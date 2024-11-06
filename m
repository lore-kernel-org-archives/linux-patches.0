Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CCF1DE2CF;
	Wed,  6 Nov 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899239; cv=none; b=k3RnZvTkuAFO9qTOxA0+cUofVzX81cDKGNyVTcUb8kpeoIe3VfPn3PxBjw9sRvd3FhXAXxuzum6BYVqlZ+43tolriK+F1T7BXpP4IM8I/N5RV4r9w2ekDTZVr6Q3p6GOkDHGXXi/tXKdVvLa4DwnZUie3iKq/qXH2DG/gqR97tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899239; c=relaxed/simple;
	bh=i+eXQ0YtvMoEBHmcdrXThVRc4stqL7moLZGORPwsTtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUc7G7kN1gsdyWMDDa1zABslKxTCbGSLJmeOJpCBdu9tIwYxlXneOqD57c7J+WMaw/9n+hWzoVKTuLOd+MNOwS95WPpf5VlOQjrQzME63UnLPW+dJEdvkEk6s9rsmvRrHNNg+87m0CVLqUFS5/yG1bxq+JCpA3S58rBjEqAPywE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1cZpC+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1cZpC+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078C0C4CECD;
	Wed,  6 Nov 2024 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899239;
	bh=i+eXQ0YtvMoEBHmcdrXThVRc4stqL7moLZGORPwsTtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1cZpC+LTt4wQrrseaoO9QStU4loxKX2Ue2TrBszO8bUSkqK1diPqmA5KcJNXN6Xr
	 T4PU+RkcfXfP8RldraL/uKcNquMK9xElspOwe3Phv8HNpuVXCG+kgsbb4CfNUzrgNa
	 jm5z9AxXt8JSTR/znyiO6KJLamxGTjRijC7fT7Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 44/73] wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower
Date: Wed,  6 Nov 2024 13:05:48 +0100
Message-ID: <20241106120301.280997258@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

commit 393b6bc174b0dd21bb2a36c13b36e62fc3474a23 upstream.

Avoid potentially crashing in the driver because of uninitialized private data

Fixes: 5b3dc42b1b0d ("mac80211: add support for driver tx power reporting")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20241002095630.22431-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2757,7 +2757,8 @@ static int ieee80211_get_tx_power(struct
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	if (local->ops->get_txpower)
+	if (local->ops->get_txpower &&
+	    (sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		return drv_get_txpower(local, sdata, dbm);
 
 	if (!local->use_chanctx)


