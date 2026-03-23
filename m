Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D137E32D45C;
	Mon, 23 Mar 2026 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277942; cv=none; b=Dv6JeJDdztNAVbKhAbODXkcejZbMs6SMImW1dnbUtjoph0d5M54VwvBxiXUcV85/WB9OmAzVZ8z544/5tNRyZTH3DyopiYS9lVWcm3LpsJ1DbZNnlYqFM4k+BM0G6bKdiBNjtRtUk0zuJ2vV+c0cs/KTPX33SihBW7cqdKBOLN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277942; c=relaxed/simple;
	bh=YSNAzUJ4AJGV0MqnummLbSPDWmxyvbAYpa8gf674rQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q64S1znqj55B5Uo3PgNeysIaqtJXDoHxlhMkBo+qVxhIueDYNge+oIqCMMBrMmXbJM06v6OQ05w4byd8KnHB9U2IppgdVWdhSB15YdKrBjGMOa8m7y1rGyV4cZDOZZ4BsHm9C+kMXnc8IrxVwfuN10UYWu/ivqgnwdDVcryOVhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=godGO54P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="godGO54P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AD6C4CEF7;
	Mon, 23 Mar 2026 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277942;
	bh=YSNAzUJ4AJGV0MqnummLbSPDWmxyvbAYpa8gf674rQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=godGO54PyJd4nePQpQOZd+MsLrMTqahr6ssV2U0xQvvQo9v2JcYujqlBJi+n0j+iU
	 nFvhN7tFUej6cEqrjZwi7bxz7fzBdykhJ38p/ho4AFQ7ImGHvzv3yPt6xgzlMzQvyz
	 kZjVPs0c+YHqaLXujtYHoM/vWsVnCMiBK2U6aocY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/567] wifi: wlcore: Fix a locking bug
Date: Mon, 23 Mar 2026 14:41:12 +0100
Message-ID: <20260323134537.593783087@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index 9706240ddd416..d818485d7e6af 100644
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



