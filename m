Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C64A3876CD;
	Tue, 10 Mar 2026 11:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141237; cv=none; b=SE8hAFjci7JtasVJ9lwOYYwZ/4RHX5YTPO+YfKeXpWbCL6856/hK8hcH6pFc3NO+NEUPbbc0rkXBtmY3qbAKsM5BS2q8v5cP2Rka5on/AltFM2DOS24gQJGC6Hr6nHDWNRQUHZiaqlJ8A8/WYe0SBJVn1ma171W8NKqO3FXpWXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141237; c=relaxed/simple;
	bh=HScrlgn3ixQRzaL5xVa8+dn8LtmeMD1xlEIDgvXBz7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e23vwzQgjKH/5XCEMz47wUQvWUDzPrtCZWvqKmJQluzxZ6rS23ePuSllt5WMEuzXMlJcgTHPjcOQRGECddH5GlOpWbAL0utJRN8IIGZH2RW8fhvuzaXa+5ltVyCorOcfcUCsIyr5b4US6ovkqL6Sa1EI1WwbBZ07yJjmcisRstk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0kqr+GW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0kqr+GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2FDC2BC86;
	Tue, 10 Mar 2026 11:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141237;
	bh=HScrlgn3ixQRzaL5xVa8+dn8LtmeMD1xlEIDgvXBz7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0kqr+GWZ0iNUmsw2NSL+uChDbWzRF9dYMFA2xWO0erIChllbhlde5Zra8RKi8G80
	 WLW6fS6Kae72Q1bDA8wga50WuE8SBVVCJKRosxMUAZrE/ZK5WU0jAYPJ23F1lD8PF6
	 E5kTD9Zcr7VDU3oe/rPmSiVyt1GRmJphEI976fXXPOfTjrKyYkjSne2yNCjbeoowxJ
	 /pbHn8VY130JgamKAG9Q2nYdX+fAAZxaTq3dK5se2jrnt7/UHydQ1wi6SGp3Fphp8b
	 Cbf3Vtjtg0dJlfilFy5vcoP4amjWgdv+ie9YD26jb4Afmmg8YPaqxm6yRwRR13M4Pf
	 Al+eoA2qOwDIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 239/311] wifi: wlcore: Fix a locking bug
Date: Tue, 10 Mar 2026 07:04:46 -0400
Message-ID: <dc9adde283b416bddd645808191a6b17160c4560.1773140655.git.sashal@kernel.org>
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
index 12f0167d7380e..1f6b906594930 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1875,6 +1875,8 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		     wl->wow_enabled);
 	WARN_ON(!wl->wow_enabled);
 
+	mutex_lock(&wl->mutex);
+
 	ret = pm_runtime_force_resume(wl->dev);
 	if (ret < 0) {
 		wl1271_error("ELP wakeup failure!");
@@ -1891,8 +1893,6 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		run_irq_work = true;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	mutex_lock(&wl->mutex);
-
 	/* test the recovery flag before calling any SDIO functions */
 	pending_recovery = test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
 				    &wl->flags);
-- 
2.51.0

