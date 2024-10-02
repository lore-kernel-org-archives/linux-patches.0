Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24EA1D0795;
	Wed,  2 Oct 2024 13:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877320; cv=none; b=YQtghP2es/xbGqF+bVg0aLPlO1qNUg2dKTn+zeXazYHvo+3fLcyjX9KfYM9JdOvBVeZmvEq8DUa8icv0IxFL0Kdw7vEfoxi7Abz4xxo+M4ZLGHBM+Vr8RcNkzIE7JYzp6vXNc/MBN2z3H3glJW50IcJlBfzDNO2wOumEoC5LA2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877320; c=relaxed/simple;
	bh=Uo8Fegrp8DDxcO3oCtopQVdCemE3b+cVA/r5Vg0SKpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCfihiz4tiiZ2dUe6behuopIl7JBmxZs67oQScax4a1HVsXdfE9Vft1NBq1d9Z76ze+cQMCC5ui7cZuZ4ZM0s57AmqfFEzmWSvNeSjCEYZRikKx9ea449sGtu5Igvus92SD5zxPkCfESCmluhZPA9LVuaQ74pg9xD344zqceyug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOxm+2RV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOxm+2RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48229C4CED6;
	Wed,  2 Oct 2024 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877320;
	bh=Uo8Fegrp8DDxcO3oCtopQVdCemE3b+cVA/r5Vg0SKpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOxm+2RVbiuzFZRR2POYKvkK3U28Eg65pvFVnFeksuk1P2PnNBbHB9bPywaqhdcHp
	 pFIori0yT+yDV6ATolzxYw5OIWhy+r+4N8FDJoi1vxCtcd8D9++UiFD1EniN4q6cdp
	 lPQkmLEDWfSSYgQofiI8HCHfX0U1L7ba6yUgMvAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 042/634] wifi: mac80211: fix the comeback long retry times
Date: Wed,  2 Oct 2024 14:52:22 +0200
Message-ID: <20241002125812.761939028@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 1524173a3745899612c71d9e83ff8fe29dbb2cfb ]

When we had a comeback, we will never use the default timeout values
again because comeback is never cleared.
Clear comeback if we send another association request which will allow
to start a default timer after Tx status.

The problem was seen with iwlwifi where the tx_status on the association
request is handled before the association response frame (which is the
usual case).

1) Tx assoc request 1/3
2) Rx assoc response (comeback, timeout = 1 second)
3) wait 1 second
4) Tx assoc request 2/3
5) Set timer to IEEE80211_ASSOC_TIMEOUT_LONG = 500ms (1 second after
   round_up)
6) tx_status on frame sent in 4) is ignored because comeback is still
   true
7) AP does not reply with assoc response
8) wait 1s <= This is where the bug is felt
9) Tx assoc request 3/3

With this fix, in step 6 we will reset the timer to
IEEE80211_ASSOC_TIMEOUT_SHORT = 100ms and we will wait only 100ms in
step 8.

Fixes: b133fdf07db8 ("wifi: mac80211: Skip association timeout update after comeback rejection")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20240808085916.23519-1-emmanuel.grumbach@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ad2ce9c92ba8a..51b00ff7edf15 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7121,6 +7121,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
 	assoc_data->tries++;
+	assoc_data->comeback = false;
 	if (assoc_data->tries > IEEE80211_ASSOC_MAX_TRIES) {
 		sdata_info(sdata, "association with %pM timed out\n",
 			   assoc_data->ap_addr);
-- 
2.43.0



