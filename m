Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ECC1EB22;
	Tue, 13 Feb 2024 17:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845787; cv=none; b=rDU4lVRy1EAsY+rl7YAOyes/VarQL88TY0d47I5IZQzM61PSka54aRvPkEP70e6We+N0SAch6tm7RHoLj7AC32uRdI/oGEJWRGOMnANghDn0071WQhdB40bJIyWus7EP/87E3XS8eIImIF1y7SkldwMSDko0AyUcNCUsPMYL3ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845787; c=relaxed/simple;
	bh=gI0yEYTg+5oXf78+i0QpYTHqV1UxW9uZHzognPFDdbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBl+hL5SsMuxAAXuGAW7gNpGUKDjXNnqASedGpNePbb9M3arI+Ym9/Ja9SGCS5HeUQxcCMVvKgoKXNJ5ZvgExg9aUlb11gqK5m/GykGPmbKw2vYzURa4rpWz+gaCMyErIVG81ghLNjvXd4eaRLPBSchwqgUT3vfrqXqO8Kwipxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5t0pUQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5t0pUQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A73C433F1;
	Tue, 13 Feb 2024 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845787;
	bh=gI0yEYTg+5oXf78+i0QpYTHqV1UxW9uZHzognPFDdbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5t0pUQVsINSd5U5Ak8r41IoCCtwDhcBOMFULB+8IrMD2WNYymgr0iaMrc6mivDNZ
	 wXZ0J+1X1fklmpOOH8jprwH7u/ZUtj+UuOvdmo1yIXOCn6YycwqllZiD4QYyOf/UIq
	 IV+6FoyLn/6ze52CTNqC5dg7AeRYoaGXAJbtM4e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 028/124] wifi: mac80211: fix waiting for beacons logic
Date: Tue, 13 Feb 2024 18:20:50 +0100
Message-ID: <20240213171854.552866642@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a0b4f2291319c5d47ecb196b90400814fdcfd126 ]

This should be waiting if we don't have a beacon yet,
but somehow I managed to invert the logic. Fix that.

Fixes: 74e1309acedc ("wifi: mac80211: mlme: look up beacon elems only if needed")
Link: https://msgid.link/20240131164856.922701229546.I239b379e7cee04608e73c016b737a5245e5b23dd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bbe36d87ac59..5a03bf1de6bb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -8025,8 +8025,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 		rcu_read_lock();
 		beacon_ies = rcu_dereference(req->bss->beacon_ies);
-
-		if (beacon_ies) {
+		if (!beacon_ies) {
 			/*
 			 * Wait up to one beacon interval ...
 			 * should this be more if we miss one?
-- 
2.43.0



