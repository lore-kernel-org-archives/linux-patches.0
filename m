Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0BA3A9879;
	Sat, 17 Oct 2026 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257103; cv=none; b=lLAj9Abju/KYU+sBp4DFbhWdz1dL5nh2iB0GZ3xiuDis5XwLJvWR88umS7kKdZj4Nk41rbwn8oO/cud5n62jGo84z8y4IpqNnM0vbQx8DSdQoNM6dEtOobzC5LBLalKyNekLiTlFurSPlfYqJMhy+yR/37g+T1MOTE01x3jwJgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257103; c=relaxed/simple;
	bh=z8OSDlSNZk/EcGBAj6MYxIm9o/SgRRN4ZdUUTHp86SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzvVQyLNfuU6cPRbObKDvyGJtxBOviwYAQYRSH7MhGIAbPnjwKG7vRn6YNVkIOLBmX017UZpFdldlvrFoIqd3DkJh6PZWsVabGvLSKgQqWqvljCX2DFBNiBeJCaVdIW+pft7FfXphLk6lgoj/kvWJCkIw6WikYC0Q1AuYStmBAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rys91N4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rys91N4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA471F000C4;
	Sat, 17 Oct 2026 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257102;
	bh=a7dSVfrS7PVlUWlMade0c0ubURpRhH7jEcEUGlhSwVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rys91N4bOQGpdpA7Cajz9XssQOmJHC7EONLTWRqgNYSRCeEv/djWRnPZSYp1GW+pQ
	 tx9bPC2xnb8kdIDJto2mr/lNs82QVelcxle07he9X45Q0TOUsKKbqfFYfaP8UA2tXt
	 /JkX5d2ieZSeiz3pkhqLgm9rgGrbk34ZXML9CcqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0452/1674] wifi: cfg80211: release locks on error in cfg80211_wext_siwgenie()
Date: Sat, 17 Oct 2026 17:45:24 +0200
Message-ID: <20261017160442.719832594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

This error path returns while both wiphy_lock() and wdev_lock() are still
held, so one malformed IE request can permanently block later operations
on this wiphy. Route the error through out to release both locks.

This bug is stable-specific: it was introduced by the stable backport
commit d01f1600e8b0 ("wifi: cfg80211: validate IEs in
cfg80211_wext_siwgenie()") of upstream
commit a2f5286ca4f3 ("wifi: cfg80211: validate IEs in
cfg80211_wext_siwgenie()").  Upstream is safe because that function
runs under guard(wiphy)(), added by
commit f42d22d3f7963 ("wifi: cfg80211: define and use wiphy guard"),
while this tree still uses explicit locking and the separate wdev
mutex that upstream removed in
commit 076fc8775dafe ("wifi: cfg80211: remove wdev mutex").  Backporting
those locking reworks is not appropriate as a minimal stable fix.

This is a fix for stable v6.6.158 backport commit, so no upstream commit.

Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Closes: https://lore.kernel.org/all/93db0eae-f479-4343-a126-59987ae0dc22@oracle.com/
Fixes: d01f1600e8b0 ("wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/wext-sme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index cfa903eb0e82f..0e7c314bdeef0 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -354,8 +354,10 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 			/* nothing */
 		}
 
-		if (!for_each_element_completed(elem, extra, ie_len))
-			return -EINVAL;
+		if (!for_each_element_completed(elem, extra, ie_len)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
 		if (!ie) {
-- 
2.53.0



