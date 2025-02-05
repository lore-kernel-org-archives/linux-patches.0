Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA94F1607B7;
	Wed,  5 Feb 2025 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767689; cv=none; b=qz5ZeQFwKBy1N9IEhx0MzkbeWSFYYUYPDSjj6ppisNHPcMGrK69SDwqZLrjUFHw+rXy9pG0US41rObi69DsZR0RMAaQpSx9yjvkHr4YLwUivImvYCn5v6kQOfj7E/2kasaNakGQQYJRTCt9oIXGNIS+mGDZ75TCl+Xg5c6Dc5bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767689; c=relaxed/simple;
	bh=Hq9g/m/OVBovdzdt7O0Irn0kgFZSO2zZq815zHVur5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsEglQ2whAXLPxFI5X0CubQm3U4h0X981WPhHQd+cbpvIHBfAoJlxFMVO2Ok6UoyPmzOU/akC6PjCphuDO4wWTzIn3TOhhE0ZkBX7WgWfhaV20gX0UDSCTovAw6fM3uM/a0Sj46VjOSntQIvj6RE09tZn+YDogYOOVaKum4DwLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZaxEcX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZaxEcX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F55EC4CED1;
	Wed,  5 Feb 2025 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767689;
	bh=Hq9g/m/OVBovdzdt7O0Irn0kgFZSO2zZq815zHVur5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZaxEcX0Dr0rDfoKwojIy7KvKD2lPZ0Rgu7WBUQ6tsu7J7cAwZBck+s11ElOYp37+
	 Ezv4J8LRqiMigkftnV9vYHvfhm6tin3MNfCMDRXVNaKYw3LSrheVaQb6dOhaqqhBZt
	 7QDfEgq2S1XwXYF3Zll5mEM2WPuSfw+lGcparEhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 439/623] mailbox: th1520: Fix memory corruption due to incorrect array size
Date: Wed,  5 Feb 2025 14:43:01 +0100
Message-ID: <20250205134513.011000645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wilczynski <m.wilczynski@samsung.com>

[ Upstream commit db049866943a38bf46a34fa120d526663339d7a5 ]

The functions th1520_mbox_suspend_noirq and th1520_mbox_resume_noirq are
intended to save and restore the interrupt mask registers in the MBOX
ICU0. However, the array used to store these registers was incorrectly
sized, leading to memory corruption when accessing all four registers.

This commit corrects the array size to accommodate all four interrupt
mask registers, preventing memory corruption during suspend and resume
operations.

Fixes: 5d4d263e1c6b ("mailbox: Introduce support for T-head TH1520 Mailbox driver")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/a99e72be-8490-4960-ad26-cbfef6af238f@stanley.mountain/
Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-th1520.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-th1520.c b/drivers/mailbox/mailbox-th1520.c
index e16e7c85ee3cd..a6b2aa9ae9520 100644
--- a/drivers/mailbox/mailbox-th1520.c
+++ b/drivers/mailbox/mailbox-th1520.c
@@ -41,7 +41,7 @@
 #ifdef CONFIG_PM_SLEEP
 /* store MBOX context across system-wide suspend/resume transitions */
 struct th1520_mbox_context {
-	u32 intr_mask[TH_1520_MBOX_CHANS - 1];
+	u32 intr_mask[TH_1520_MBOX_CHANS];
 };
 #endif
 
-- 
2.39.5



