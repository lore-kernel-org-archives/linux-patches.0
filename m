Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EE53B9611;
	Mon, 23 Mar 2026 16:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282347; cv=none; b=XhSAgfzVTRtTHNJBhYLmhNUA/fSg7eB9Tj9eaJmh0kLGJYjPaDFhqW5fN2gbeO1N0rPUJeErzwoT5fQ3JYoEnyXavVkHwp9l3vz1pZ73EOubX5IWI81JpYuQcHWbBMR0k0+uc9d2VKpbceYnPPQ/3qbNxBwnnG7KM+PH+sA0o2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282347; c=relaxed/simple;
	bh=YuMDg4l/mQ5PCMcLY0aG5CBCSWVCzAdwe7ZPpr8rXDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwSu+WNcfdKWzsfWUabGhmYVgx/gz2aGfE5uwFdxw8Lh0VWyk1Hh4GP6Vg9ahrF282Y/MaQ6/p1iQ9RO6rvRBMbpjvxGfHAPYSumYzhzqxFTVTggWc2rkCC3qdLs9HlJDHm7gpoHCWWCmbyvEN1mVOcVsrsFuHHIISrssCxquSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oM1M//Yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oM1M//Yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9C2C4CEF7;
	Mon, 23 Mar 2026 16:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282347;
	bh=YuMDg4l/mQ5PCMcLY0aG5CBCSWVCzAdwe7ZPpr8rXDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oM1M//YbigUCLjMEVh0xP1+mOHjY7TQpY52Bs86C2C6/UfIY2KdFOmFOM8jKfBL+R
	 QJHw09zfaPWDIBqqCbhfk1KaRZsfsbb9Twwh4oTCXpojlXCHuqbauJjoGR3P0lUKqN
	 wmx1AWMmWCN/END3+7pAh1yTHI9ueJxWw1H5DwJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/481] wifi: wlcore: Fix a locking bug
Date: Mon, 23 Mar 2026 14:41:44 +0100
Message-ID: <20260323134528.257896798@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b88ceb1f9800c..95de73f4a7dfd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1800,6 +1800,8 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		     wl->wow_enabled);
 	WARN_ON(!wl->wow_enabled);
 
+	mutex_lock(&wl->mutex);
+
 	ret = pm_runtime_force_resume(wl->dev);
 	if (ret < 0) {
 		wl1271_error("ELP wakeup failure!");
@@ -1816,8 +1818,6 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		run_irq_work = true;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	mutex_lock(&wl->mutex);
-
 	/* test the recovery flag before calling any SDIO functions */
 	pending_recovery = test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
 				    &wl->flags);
-- 
2.51.0



