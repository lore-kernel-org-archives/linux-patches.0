Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1341589CD0;
	Mon, 31 Aug 2026 13:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184224; cv=none; b=bWlaNbC9GvJKj5QtMm4gyAx3Hji9MJ0Eg+xzkj4G7JZyxAqBwr/XypwHvMJrCSaI/ybmM5osNlkxFAB7kdNTYOya/jLDgJ8EJwWEltqmVIk7IBEDRu6yVzrKKvwb5v86WpQ/nq6z/CZeDmomaU69rh0364duIvjojiR4QaMzqJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184224; c=relaxed/simple;
	bh=EfXvpjv7H//f2vtxjvvbHypISWFKKso91kSkFGEi2V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxCT4CvlgDTFLzLGoi2OuWtgqkIauYv4vmuNE8hFfpiklamWHGPc36yqt8PIe9Hn89rAKZnGjWvKdhciZtuDhX8hwYJLX4Yw3qTj2hI60oaKts7iZ9Qqv0sHLfQ591Bzp/cxEeFKXGjuEpGGBbqa6i0LokzDbHr7rb4GWxRIPCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAH06g8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAH06g8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AD01F00A3F;
	Mon, 31 Aug 2026 13:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184222;
	bh=WZBhgq0Neci+GGphE5AfeLsh+xqCKZMlfHsWAJlwKeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAH06g8hWmwEZbplrskHFBX1LnVfqJeBE0DXh7DJs37ebIc4/a53ZbZUvYiKdIrla
	 BhWelgg99Y7nLvKU9brrquiE3Taq1yCx+6Yj6bKa5BHq5TMLXOglV6qaAVbeePOigZ
	 ksIucZMluTi5PtovJqJD9pFIk3f09SHWqgdGnbfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 33/99] Revert "PM: sleep: Use complete() in device_pm_sleep_init()"
Date: Mon, 31 Aug 2026 15:34:02 +0200
Message-ID: <20260831133401.669876215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

This reverts commit 171ef40fce41b13f5115d988c45997e94113c7ab.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 6e5586d1e43c5..abb16a5bb7967 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -100,7 +100,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete(&dev->power.completion);
+	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -237,10 +237,6 @@ static void dpm_wait(struct device *dev, bool async)
 	if (!dev)
 		return;
 
-	/* Devices with no PM support don't use the completion. */
-	if (dev->power.no_pm)
-		return;
-
 	if (async || (pm_async_enabled && dev->power.async_suspend))
 		wait_for_completion(&dev->power.completion);
 }
-- 
2.53.0



