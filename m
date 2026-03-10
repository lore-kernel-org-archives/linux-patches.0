Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD70C387361;
	Tue, 10 Mar 2026 11:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142166; cv=none; b=TFL8rq2WD8E0HCgoNHSuzAQlA8symznWYh9lSy9aWF2gKNaY65WzBDMWWwJ6qPt31UV60o5OQ+gt2p+NOAeuFGtCXbQrk0aBAYpnvsjAiCQFEPbly3qHGptdG1RzLhWEmzHD+15huJ4V9OQK0sH4jtVvnQhLB55TmYjl1Mtek2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142166; c=relaxed/simple;
	bh=qjCL+pnCC78LZDhpQQeFZ2zlj4Znc/yMk5M7bDVubTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXAm6UqzFfHu/ZGojLaJG0UceACgcbbxz0G4mP9zG5q6se96wJg2haAmMG2tWcGvI6a+0sgfvFfILaebkDXaaPCSJbKc9Hn+IQz+ZnMLAaSPIte/tkMhHROw12Td3fsnANdGhUzGfrFxeBwypNYUsYTNPHdQbYkiugzQLcmtUV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I0lJrgwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I0lJrgwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E35C19423;
	Tue, 10 Mar 2026 11:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142166;
	bh=qjCL+pnCC78LZDhpQQeFZ2zlj4Znc/yMk5M7bDVubTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0lJrgwFd1rzOruCiq5+9GydnuUkq6aHalrHq3uzNN0tuoSmLsGkWiMpGO1ADDmLj
	 mmL9uwjDhAsuEaXtbjO0gAFL0ddjUTYuTr9dJND7RoYAq70Jk/HTOm4NAtcd8M9l2Q
	 /SxaTk1KkLvQbx/VAJEkCvD6TylZ95ozilKfrcXT2bDJSCHAVMD52Q4NKMJLgePovf
	 /xhQFkk7uzrzcjgaowA1QUC9hJos4bBMUUVva91RTZE1fFvj0GmIvtQBa0yOTm5bvD
	 7QtCuL8sZXF+/7hT/v+rsaRilZtjYH6nFju7xW+PFw7nh/xTPj2eADWKAcjJ/5ALSn
	 yd2E3sCPVTDYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/314] wifi: wlcore: Fix a locking bug
Date: Tue, 10 Mar 2026 07:18:33 -0400
Message-ID: <a9c719301ba38aaafaea796ff7a3ed0725829d41.1773141555.git.sashal@kernel.org>
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
index 6116a8522d960..bdb06584d7e45 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1880,6 +1880,8 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		     wl->wow_enabled);
 	WARN_ON(!wl->wow_enabled);
 
+	mutex_lock(&wl->mutex);
+
 	ret = pm_runtime_force_resume(wl->dev);
 	if (ret < 0) {
 		wl1271_error("ELP wakeup failure!");
@@ -1896,8 +1898,6 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		run_irq_work = true;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	mutex_lock(&wl->mutex);
-
 	/* test the recovery flag before calling any SDIO functions */
 	pending_recovery = test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
 				    &wl->flags);
-- 
2.51.0

