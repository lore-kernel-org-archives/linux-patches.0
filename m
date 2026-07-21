Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB8E46EF8C;
	Tue, 21 Jul 2026 20:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664269; cv=none; b=e9B7tnGsHt6hodKsRZ71teezFYGcdLOqeIUzqLXti32slYWAOfeAX3iXnK+7Ih3RByXKb1AsPoQHr6EPZjgVmh5c1rayMLk9X8hEPtDthWU53hqSi7JyWp+kyBKmCK9MJH+UhFHyaYDJ9zSVpTZI7J8dZPU0yyr+JoJg9aqCJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664269; c=relaxed/simple;
	bh=1pj5uRPuPEAuevdI0SD3mKUXrzI4qe0Wx2iM3tiXvMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkNVmQ4ksNHLcmQsamDs0cWm2N4bzzEzCokguFT3ub1WcGmcx+29rFA0FG9dHPzUOC+dmBPePvXrW95ZyM5DyToGKmI60yf9/+zlBypbHaAadAc9580HZK2p9jQJ++4dmIwD8HGR6Cs3JkI/6tqTiMoES7DHYmdzqstRnwVC+vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=As5iUIWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="As5iUIWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5891F000E9;
	Tue, 21 Jul 2026 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664268;
	bh=DmYKljlJKLAyRqBePCdewjY1D9vx/UnMaNcbbi1eF8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=As5iUIWOy3NxGJz6mSFJsS3FljvKgWoW8Hf2vFb0NpXl8STMtjk3V1WVmkKDmvIJ6
	 giQxdy9GUwlVeFIbLSKjF9auLYShjlwKrEi5UKs76E03gIQWRzKcIQ2RjcCQ4x73A8
	 UOxia6+vT5QK+4VlxA7cp7UStZT2CrfAoveWu9y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 1109/1276] wifi: mac80211: fix memory leak in ieee80211_register_hw()
Date: Tue, 21 Jul 2026 17:25:52 +0200
Message-ID: <20260721152510.807865372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 95fc02722edde02946d0d475221f2b2054d3d8ba upstream.

If kmemdup() fails while copying supported band structures, the error
path jumps to fail_rate. This skips rate_control_deinitialize() and
leaks the initialized local->rate_ctrl.

Fix this by adding a fail_band label that shares the rate-control cleanup
path before falling through to the remaining teardown.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still present in
v7.1-rc7.

An x86_64 allyesconfig build showed no new warnings. As we do not have a
suitable mac80211 device/driver combination to test with, no runtime
testing was able to be performed.

Fixes: 09b4a4faf9d0 ("mac80211: introduce capability flags for VHT EXT NSS support")
Cc: stable@vger.kernel.org
Reviewed-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://patch.msgid.link/20260706143507.146131-1-dawei.feng@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1568,7 +1568,7 @@ int ieee80211_register_hw(struct ieee802
 		sband = kmemdup(sband, sizeof(*sband), GFP_KERNEL);
 		if (!sband) {
 			result = -ENOMEM;
-			goto fail_rate;
+			goto fail_band;
 		}
 
 		wiphy_dbg(hw->wiphy, "copying sband (band %d) due to VHT EXT NSS BW flag\n",
@@ -1635,6 +1635,7 @@ int ieee80211_register_hw(struct ieee802
 #endif
 	wiphy_unregister(local->hw.wiphy);
  fail_wiphy_register:
+ fail_band:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);


