Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD437B413;
	Tue, 10 Mar 2026 11:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142165; cv=none; b=XtpFvWm3Nt65F5AdoW2kzgrO4ptJEQKzeZIZMpP/uy/H6/NiXJ6oPkyEbmdUYZ9Yen4fGREeJzyiy3wGYiZt2TCj/D4B0cGc+30f0B4uyiZ3vyhwxpBhbQlNWnG4XzYlNg2Z4//EMU9yix3/ziUnJefEwPL5vsuH2pZkKAHJ7b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142165; c=relaxed/simple;
	bh=L1F2gdsOdFlLRbaoWUQAWM+wjHuuHX1wOdOXUHDMEIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GD1HNZiXH1y4MpopAokYWnZdPOu9FqYasp4mCOtMsOfNaiYCgu088g+S9sBnyg6tSJJkHkfwa6gxCHA7KEyJ/4ZrF/SeiP4a3bhYYcjtsIxg79Yjiw+E0wwHKFMp+/hRX2rB/FAhVr7aGVWEQyPNBbAFsmFbDpSrRgbFicXQbs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PtdGmfdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtdGmfdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE10C2BCAF;
	Tue, 10 Mar 2026 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142165;
	bh=L1F2gdsOdFlLRbaoWUQAWM+wjHuuHX1wOdOXUHDMEIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtdGmfdVOOfh7URWqNFjSMfRmX98qoLsWhlD/BLx9PYBGxpmbDIRxZq6FcbxJgImC
	 5I5CwlTjDm8JJ53sCjfU1yh6hi7emyUKeG9kBjF965Hgt/3t5dTl+Fp0+8QefGWa1d
	 3ZbWvC9xKhBNJNjVG5oKeG1bCIV49ZHIv72En3VqNWme4mH3yoJpRvkRKaxpF2j/as
	 ZmDnonDNzuOKn3of6S3YvnzujjaDxhyuWDw0YRsDI/IE/7jKt+thGgUyHLsLFlJoen
	 WfcYczY1DsoyWFQ2G0BEw8u4TM0+Fa/R7no4oZzE24KL3SxD+dzaKe43xZmLUaqAHA
	 O5xoVOZL9NA7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/314] wifi: cw1200: Fix locking in error paths
Date: Tue, 10 Mar 2026 07:18:32 -0400
Message-ID: <c278552ac7b5017982a09be30401a5554fd700df.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d98c24617a831e92e7224a07dcaed2dd0b02af96 ]

cw1200_wow_suspend() must only return with priv->conf_mutex locked if it
returns zero. This mutex must be unlocked if an error is returned. Add
mutex_unlock() calls to the error paths from which that call is missing.
This has been detected by the Clang thread-safety analyzer.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223220102.2158611-25-bart.vanassche@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/pm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/st/cw1200/pm.c b/drivers/net/wireless/st/cw1200/pm.c
index 2002e3f9fe45b..b656afe65db07 100644
--- a/drivers/net/wireless/st/cw1200/pm.c
+++ b/drivers/net/wireless/st/cw1200/pm.c
@@ -264,12 +264,14 @@ int cw1200_wow_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		wiphy_err(priv->hw->wiphy,
 			  "PM request failed: %d. WoW is disabled.\n", ret);
 		cw1200_wow_resume(hw);
+		mutex_unlock(&priv->conf_mutex);
 		return -EBUSY;
 	}
 
 	/* Force resume if event is coming from the device. */
 	if (atomic_read(&priv->bh_rx)) {
 		cw1200_wow_resume(hw);
+		mutex_unlock(&priv->conf_mutex);
 		return -EAGAIN;
 	}
 
-- 
2.51.0

