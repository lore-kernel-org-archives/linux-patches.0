Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5507386454;
	Tue, 10 Mar 2026 11:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141236; cv=none; b=efdNT5gS+Z1lzrAm3Ds9dOWSxAMY5Qd5oEwgbspsE20ku/JNEbQzVb9YxSr3XaFg/zXT4aMFpNcZrt7TSg2t/hqmqkKu9FcKQYuHhdXfFef7dm/7hCUngNk/LnkrMj8l2cn2xPnxwfj1cfqiyONWi9FaC+geGvdbTYm22axjiPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141236; c=relaxed/simple;
	bh=L1F2gdsOdFlLRbaoWUQAWM+wjHuuHX1wOdOXUHDMEIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqydqKaJeQWFkLmhuFhOCTVDdEdESrqkWzc9/RtbNvtYQx44zSnDtZEtClMNcx5+kakUMtXTlWWW1fv9BtuYpB/PGM9GIilkpUBExN68NUwmU3Qjm/t8/0kQGN/iNC84tz8NOKwPoGKdRWrqjL/RqGMfyAGK1C0NXg3ZI2nmSko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nVIXhwtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVIXhwtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2D8C19423;
	Tue, 10 Mar 2026 11:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141236;
	bh=L1F2gdsOdFlLRbaoWUQAWM+wjHuuHX1wOdOXUHDMEIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVIXhwtVvP5sEi4UTcnipVsaIhZ+GQDUSB25PT3r9N5UIg4zCVVks3vn7evtSUdwK
	 zQpMploKmIWK9vuYNLzDJ8oovOZAPEzBAeInXZs9uxvcP7RHwvSxGsGw9kQySS1a6z
	 yXAAmGFxOxbiEKoSQHr2bb5K/UqGLBXGi3YnrcjLZP760pWms6lN767ZXaJqXKPMqW
	 ZHbkTttVRTNcYF2G+XxE3fO0ImlT6V5wBldlT3urILZLlp7sLfHL8w8b5Gv7ET+vXa
	 iGPUindwHEfSEigV24s6df98kbAvWDIF8wtudNy7RguquH7jibnGFFVvJWNQxiaGFH
	 ShkswIYOQc9tA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 238/311] wifi: cw1200: Fix locking in error paths
Date: Tue, 10 Mar 2026 07:04:45 -0400
Message-ID: <e07bdaba7169bb1b16595a0232eb5a404f3de720.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

