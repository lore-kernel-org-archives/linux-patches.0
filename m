Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE962F6931;
	Mon, 13 Apr 2026 16:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097280; cv=none; b=Y9ObzebvuE7TshwAHpKh73RslAsMgRm4MEcsb6LBc1hlpa+yt8Ypg2DK0AlekVh86GrqKy/OgfTB1rlIzu76+6qLFM/IC6rSxkP4YxqBD4yaG7528Jtbk/9JtFCONxZYgPWvvxx9zf2xnrLkIf7fTDugwgtBLW2V9vEHAKlaU8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097280; c=relaxed/simple;
	bh=mwHt8QAJbkDzk1KNlSBWSSq8+1b1MVb4wgctQEt5W+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=in3Jhy/DuhrFqyFgBCVXuSTY8AVO7d4GWWCU8gCGeNI6mvZTrahUnJU2itTOia0LK2i5wIiniEHTCVQsYE2DCYNcY7F/TxM0xcuFXzbgfGgZcfO1fWqxhAt/waLcTEPpDpGjzFKrVaHFtszPtK9BY/YNl5bdl2BmtKeuXxoCQu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrnMvZeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrnMvZeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417CAC2BCAF;
	Mon, 13 Apr 2026 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097280;
	bh=mwHt8QAJbkDzk1KNlSBWSSq8+1b1MVb4wgctQEt5W+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrnMvZeCE2tbSS2yz7ih6TsSmKdsytRMoIzC/ghkuGL9f/ibCTGwFPfTfKjz5MHVh
	 FV4U68BdjhBEG8Y6QeayP1QbUNbZXoI2doNpWN6TSeXvDDtbwLX/s6tJSv5Hy76Q/b
	 7rHzHusO5IEA7uk0hK2LAI7O30nfgFslVGbWPYJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/570] wifi: wlcore: Fix a locking bug
Date: Mon, 13 Apr 2026 17:53:26 +0200
Message-ID: <20260413155833.250643272@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7d664380c4771..5842fe6bfb855 100644
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



