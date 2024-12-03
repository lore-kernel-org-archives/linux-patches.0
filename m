Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B313F204F80;
	Tue,  3 Dec 2024 15:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240592; cv=none; b=jhGDOSpBkwh24NoZT2bvnDrVIf8jRSk6XVWrRpbudjp6Vb7AZfMMtogF5uMainMlKRJ2YRLr4dPLDfFXLmdc/nhSCRHmTvFNSe483KTctRFjLKlNMUvFzzHa99WoC+UBB/F85s50r2E1vQBM1eQ+SWJqX4eqA81pO78ymAqsgeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240592; c=relaxed/simple;
	bh=N4TsBWuTqIcTxBp21JGMX7ayXkhQCjGdwiwQu0WYcBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zrl1UN4YyoKLuiRCy81cP0Lqo4hjRY1n/dE2dPSz4h2WdL9Q/r1dbmrzPshkXqykIl9N8gXqeGpzvwUJeELWoeAXrmujMb10mtYh3hX9nXedjAcagcQCrqHIGHDh9FYY5hdae+ACIgX1KVvs7Olp0rhJx5/n228dS9mrlQ2rxzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJH/uGBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJH/uGBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31097C4CECF;
	Tue,  3 Dec 2024 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240592;
	bh=N4TsBWuTqIcTxBp21JGMX7ayXkhQCjGdwiwQu0WYcBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJH/uGBEKQYaxv3/YsMD4mPo0w0gyUrZGlFcf3J8deSl2pWVLwQcTRDSsVraXx681
	 wvZ6bBTJa8ObxcddaY9NHN+iESaiVoZrhhdoJ+dU/iKb+IBsRhMu3kwGrzBYm0kZuA
	 fYFYsHHydzDqdGNjjUTDCLAsrsFch0P+5gcah+7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufan <chenyufan@vivo.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/826] drm/imagination: Convert to use time_before macro
Date: Tue,  3 Dec 2024 15:38:28 +0100
Message-ID: <20241203144750.796552472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yufan <chenyufan@vivo.com>

[ Upstream commit 7a5115ba1d691bd14db91d2fcc3ce0b056574ce9 ]

Use time_*() macros instead of using jiffies directly to handle overflow
issues.

Fixes: cc1aeedb98ad ("drm/imagination: Implement firmware infrastructure and META FW support")
Signed-off-by: Chen Yufan <chenyufan@vivo.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240823093925.9599-1-chenyufan@vivo.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_ccb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_ccb.c b/drivers/gpu/drm/imagination/pvr_ccb.c
index 4deeac7ed40a4..2bbdc05a3b977 100644
--- a/drivers/gpu/drm/imagination/pvr_ccb.c
+++ b/drivers/gpu/drm/imagination/pvr_ccb.c
@@ -321,7 +321,7 @@ static int pvr_kccb_reserve_slot_sync(struct pvr_device *pvr_dev)
 	bool reserved = false;
 	u32 retries = 0;
 
-	while ((jiffies - start_timestamp) < (u32)RESERVE_SLOT_TIMEOUT ||
+	while (time_before(jiffies, start_timestamp + RESERVE_SLOT_TIMEOUT) ||
 	       retries < RESERVE_SLOT_MIN_RETRIES) {
 		reserved = pvr_kccb_try_reserve_slot(pvr_dev);
 		if (reserved)
-- 
2.43.0



