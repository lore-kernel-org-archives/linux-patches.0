Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869D023E342;
	Mon, 13 Apr 2026 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098748; cv=none; b=DM76yeHyxaYUSGF628l7U2NC0gSmFxZglBltxnpQywQ+DIEmPGG9kiLt2IVjGu3XeVibVmdDreZ7T+3wVVHOUOFHjLvzwVQTssYjyJPw83p6vgN/a0b5IHt1w7vqBhXtiY8pDTLm7UJhdLtRl5ftTXUiHQtok8sGhlBUVrvon08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098748; c=relaxed/simple;
	bh=r7g+mh/Nvy964uGXdvrwIj2Y5VYXQig1iWrk9KlWDAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJuzSMhW8Mp/YUSUeVawOOQa4c0v7NnEOc/WbRzdYfdmHCtvCbixv8EvERslq4IwIblPOuw0vLBsKByK3dtWDQhAouxjJoC8EMj042DR2/EcDCB31H0uncxbtQZIEOKBTiVKZ1dNQr0qC6ZOc/aJ0cEl2q01S7AOx9yWafDnxqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxR8dA8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxR8dA8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF18C2BCAF;
	Mon, 13 Apr 2026 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098748;
	bh=r7g+mh/Nvy964uGXdvrwIj2Y5VYXQig1iWrk9KlWDAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxR8dA8DFGoPtYXzx+7Asw5hFDKDx163v9HCeMAKRIJ4cKeAJscvAzCbjbrOrcWW0
	 Mk9OVp4ExnOpJIVddb62jKEchvpqB4eW2uZEnIvK00q1FqHBGJ8joQw1Vg3JUFGcWw
	 q/ZfHCfkRmQW7o4Y0Ao0Dk2OmDLdpTb4vx3xaPmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/491] wifi: wlcore: Fix a locking bug
Date: Mon, 13 Apr 2026 17:54:46 +0200
Message-ID: <20260413155820.590973050@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 72c6df8f284b3a49812ce2ac136727ace70acc7c ]

Make sure that wl->mutex is locked before it is unlocked. This has been
detected by the Clang thread-safety analyzer.

Fixes: 45aa7f071b06 ("wlcore: Use generic runtime pm calls for wowlan elp configuration")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223220102.2158611-26-bart.vanassche@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 109c51e497926..30430b4a4188f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1813,6 +1813,8 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		     wl->wow_enabled);
 	WARN_ON(!wl->wow_enabled);
 
+	mutex_lock(&wl->mutex);
+
 	ret = pm_runtime_force_resume(wl->dev);
 	if (ret < 0) {
 		wl1271_error("ELP wakeup failure!");
@@ -1829,8 +1831,6 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		run_irq_work = true;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	mutex_lock(&wl->mutex);
-
 	/* test the recovery flag before calling any SDIO functions */
 	pending_recovery = test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
 				    &wl->flags);
-- 
2.51.0



