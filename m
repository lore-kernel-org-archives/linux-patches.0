Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35380403AFB;
	Tue, 21 Jul 2026 17:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655231; cv=none; b=Zh3lecMXjD3lUe8oX/NZYL7tvMiWl2QhT/lhkdqvbO7Fj2dOjKuRfqD1D821gQuRYF8oBNnw8K+PnYgDwFW0S0ZcL2BDuczWNgLVeBYaJ3v0ERZFrtXDqj2xrLUd2A14XnqiMfLF5Qv5uzBcUtqUd1kvhhKmkmMOoKownbE86hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655231; c=relaxed/simple;
	bh=L3hou97p4E6vUW/DRDvehwjcNAxXcO3vYc11Xt/dvSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDErIzjzZ6GsermjJG6Gb+6X48r8VbKU+R6EIpESIoTr9m/xMyt+wuc4FCe9OIxhb8FQqpFasHlmxAXIhrIaqbXHISlhK/W21QTT3RJdPFn+VTt/fkw71xoE0QU0LCyBCdzsJ38xS00IW81D5vP9M+StJ1ReOo0Q+ASpzlDxQVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4ffpF6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4ffpF6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D31F1F000E9;
	Tue, 21 Jul 2026 17:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655230;
	bh=utR5mbpg7YRFkHjJAOLEo+OML5WPtU0X/WR76CSAUyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4ffpF6CE3npfH7KbzG7ekA1nk9ruV1z8K7XopjoJ1YPHDi0AFTGZ6U/rWxff64gc
	 gyPZJDAOTD4buz1cCzZOQAJ+1U9P1+lzpVv1NDHRiNkHE5bjCYMVfEqSqzhyXNm2/H
	 7NSjQrZfkbjpC6pOkCJ0ntFZy4KBog5Hqm0NmdqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.1 2005/2077] wifi: mac80211: fix memory leak in ieee80211_register_hw()
Date: Tue, 21 Jul 2026 17:27:58 +0200
Message-ID: <20260721152640.001857113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1599,7 +1599,7 @@ int ieee80211_register_hw(struct ieee802
 		sband = kmemdup(sband, sizeof(*sband), GFP_KERNEL);
 		if (!sband) {
 			result = -ENOMEM;
-			goto fail_rate;
+			goto fail_band;
 		}
 
 		wiphy_dbg(hw->wiphy, "copying sband (band %d) due to VHT EXT NSS BW flag\n",
@@ -1675,6 +1675,7 @@ int ieee80211_register_hw(struct ieee802
 #endif
 	wiphy_unregister(local->hw.wiphy);
  fail_wiphy_register:
+ fail_band:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);


