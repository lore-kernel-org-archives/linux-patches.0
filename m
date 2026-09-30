Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30E7519E13;
	Wed, 30 Sep 2026 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790365; cv=none; b=SgCkDKN/eg6CG+ztFwH87jCLMExlAzYkN5QA0onNkHYiD0tTF3ZCldkLjM15RaCV/0UOH0SsZVmU3bfqZXP9B5zN6Z9v73q0jlJun3GiLznO2A83OrTeh9vhCGqAAVQp7WUK5wvhTj5UsaHds5Bkk51mxNmwTX75ImALtNVvwCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790365; c=relaxed/simple;
	bh=cI6aXbWo5VUXxjX1oDKumRadhgmLeq8A6Gt4Z3Sqyy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8ylIN1XcM8NLTkTkWaSeHJ+4PT2cm/RttGBAG0TL+YljkYYEWlRsJc7m4Y71xeYBvL3gu2txMJXTHJlMRikcY6QThIXMGIDfAJHSlhKTHz3Nk54cpswjtSh6gCTNw/S1WCunsvwbPmeJ94XjBkvvu8GDFAMnkqT38KTF/rS8uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3O0kMme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3O0kMme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC8D1F000FF;
	Wed, 30 Sep 2026 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790363;
	bh=nfOy3gsBXnx+awSmXTm/iFXi14waVjmewcv+qBd4Pos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3O0kMme20sSOglgqfldzsPbtxKa9+ifP4Nakh2kCoB9siAkSYSCXYTDpREB1fsie
	 7jvpbY0ELJ/s1BZSRHROYArOVXbU4TQj3q13ePDoWDaGKyZvg7NyZzxmFIjStLuMxM
	 RBG2t6xrN34qVB3AsHDRm4GhAy92+B3xoERL9xSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 803/877] wifi: mac80211: refuse to make a monitor active when it has no queue
Date: Wed, 30 Sep 2026 17:28:34 +0200
Message-ID: <20260930152432.044777139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 2b04d6556964ae9f89819b86a0a7801e39c3aae5 ]

A monitor interface only gets a TXQ if it's created active, and one can't
be added later. Setting the flag on a down interface is still allowed, so
the driver is handed a monitor with no queue. ath9k dereferences it:

  BUG: kernel NULL pointer dereference, address: 0000000000000066
  RIP: 0010:ath_tx_node_init+0x49/0x170 [ath9k]
   ath9k_add_interface+0x10c/0x140 [ath9k]
   drv_add_interface+0x54/0x250 [mac80211]
   ieee80211_do_open+0x32f/0x800 [mac80211]

Reached with CAP_NET_ADMIN by "iw dev X set monitor active" followed by
"ip link set X up". RTNL is held, so netlink operations block behind it.

Refuse the flag when there is no queue to give.

Fixes: 79af1f866193 ("mac80211: avoid allocating TXQs that won't be used")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260904200338.10829-1-lucid_duck@justthetip.ca
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -116,6 +116,10 @@ static int ieee80211_set_mon_options(str
 			return -EBUSY;
 	}
 
+	/* TXQs are reserved in ieee80211_if_add() and cannot be added later */
+	if ((params->flags & MONITOR_FLAG_ACTIVE) && !sdata->vif.txq)
+		return -EOPNOTSUPP;
+
 	/* validate whether MU-MIMO can be configured */
 	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
 	    (params->vht_mumimo_groups || params->vht_mumimo_follow_addr))


