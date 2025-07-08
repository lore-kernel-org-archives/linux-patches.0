Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8D82E5425;
	Tue,  8 Jul 2025 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992370; cv=none; b=XBBxrjG8ToJKJ7BDw3m9p1jNRM0UAi7GAN4HCQmUTCZuRfRJ/9unAuRbrrKKp1bo+d8ttv402yEFbeDpFxJB2xD3uluICamZ0meJq3zku9whkdXAoVvD95PuwsHWmsHFRPv+LIbyKx/jBlkDBnG79PgFqNNxckl2w+fgMAiiquM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992370; c=relaxed/simple;
	bh=83nF9MFRNIWSlFs7ZyBWEDPBfOWCKZH4ynIXdcgeQe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+IoJwEZ/2nHKagTcf2HxeCU8taVjtBv3ET3m/jXiwWIgkjZY0k826cGoJsOdiv5+wE92rVBrGNAd1PV8jUPXSf6/MVfG8PtP5yu6ScD3D9Sk4l8HbZrJsrvRNvE9OVXQR3TQ90ZcvHWrf6Bcoip0VRqojZNjXPRPWyc655mLcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8uPlNtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8uPlNtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA24BC4CEED;
	Tue,  8 Jul 2025 16:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992370;
	bh=83nF9MFRNIWSlFs7ZyBWEDPBfOWCKZH4ynIXdcgeQe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8uPlNtKBzYqS3nkdhTQANJ1KKacpdO2h3S4zbfZj9yr9Ic0icslJ4PW+D96r1C1g
	 /Od2SGB//Xjkokvf8iWRGg3vv7HXQsxp1keNxb/re315pnHrb0zlKUc+P/VONpsWq+
	 qKu/lTNBjwMLO2zxzd57JSbg63tU0xyG4F1jujdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/132] wifi: mac80211: chan: chandef is non-NULL for reserved
Date: Tue,  8 Jul 2025 18:22:59 +0200
Message-ID: <20250708162232.640779520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 9bf7079bc2271321fac467cae981c44e495b76b9 ]

The last caller of this with a NULL argument was related to
the non-chanctx code, so we can now remove this odd logic.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240129194108.bad8ec1e76c8.I12287452f42c54baf75821e75491cf6d021af20a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: d87c3ca0f8f1 ("wifi: mac80211: finish link init before RCU publish")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 68952752b5990..31c4f112345ea 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -89,11 +89,11 @@ ieee80211_chanctx_reserved_chandef(struct ieee80211_local *local,
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
+	if (WARN_ON(!compat))
+		return NULL;
+
 	list_for_each_entry(link, &ctx->reserved_links,
 			    reserved_chanctx_list) {
-		if (!compat)
-			compat = &link->reserved_chandef;
-
 		compat = cfg80211_chandef_compatible(&link->reserved_chandef,
 						     compat);
 		if (!compat)
-- 
2.39.5



