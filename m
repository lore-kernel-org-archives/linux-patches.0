Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8273242AC;
	Thu, 12 Mar 2026 20:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347105; cv=none; b=cxM6v2LoFd8DkEJ4SRtkaOesgCXcnpJ5bigmsvYWVtbaoLIRVyah21wORVYJMMbWPglibEtzzq64Go7F7Q3h2YP894tslkRpCYQtOP0Azfs/vTaJbPDv0so+4LPZaccPHwuj2ZIa4Q2shLbXXdvhpj/0AIXzb6YjaQ2SKTR6cLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347105; c=relaxed/simple;
	bh=qVAII23pg7HK9zZsm6LSrzk1Zk6Nl11cDkAKbJ2GbvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K07ghLX7moVNsULg8brd5ELbnSASd5/g6YL7i/BJOsv0Na6R3Rkdihm6jCHwG39GeuDxVTCMpFobYHXooibxGHoKQQ+v/EiugxxwHMGhHyG1YXfu8hORsvLDpLrxYZnfvH+kBfuP5tXlZ9WoqwZR1cmkP+Ae2JcFm94P7359uXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPYgucYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPYgucYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF2AC4CEF7;
	Thu, 12 Mar 2026 20:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347105;
	bh=qVAII23pg7HK9zZsm6LSrzk1Zk6Nl11cDkAKbJ2GbvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPYgucYarCCHZHByK/FzoyxHfHWNDjrGL9CuGOGhYl7mMDkd5jVc94Z02Isk2yk/3
	 fihnFycDPPRICc5yE4ToXGHxpprxtD5IfepuRcq195UQeGMWPSiiewrQ1d2FkgPeBu
	 2rsCnfc0H/7lcBP8BbTPq/mrEW4VBqy/iV853iDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/265] wifi: cw1200: Fix locking in error paths
Date: Thu, 12 Mar 2026 21:09:52 +0100
Message-ID: <20260312201025.725860518@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
index a20ab577a3644..212b6f2af8de4 100644
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



