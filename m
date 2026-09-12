Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FB238F236;
	Sat, 12 Sep 2026 19:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242773; cv=none; b=Fdq/qxRz3TRrxLq5SEPuVDuwKLT5EK0T+EQNcps8TSrKm7G7fWZBBhaH0S85K7MJWaU/lLJ9Zykf+eJki5P9sY+5FUJk73vjVTT9MnGQxTuVszTHIHUY/3seo/iTct7fJVUtSm3ygapPOJAWcTEsnbLRPHu0Yc8i1FZhiwpi9o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242773; c=relaxed/simple;
	bh=phgpN9UVKsg6orID/oKHjtLTyKzMBFKvb4hLFZ8rZ4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3gFwl9fqlXMy3tk9kYpJi8bCbocs09e7d+mNht9dZ4DtU4vVmbaQEij9qAlDBpP6ok8uQTURV26j/v53OAaFQ+YacPBCf3mRRX2tEaut0I8JJTaFwfJFzTG6/4UkJpEs7RV6NRUYCZyLTouzXQx53EXuosygRM95u1c7Qc92/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QH2AMLv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QH2AMLv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3031F00898;
	Sat, 12 Sep 2026 19:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242771;
	bh=tkLIx5MX5V4L6ShYwzcoACzt3c1BWqsaxCwa8DHuITo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QH2AMLv2SSR0TiLaJBko6yCPMNhJDRSOPKAa+jiYnIOrWNxIx0HBLeToAqoQF/FFv
	 SzqKCS4HlxvRUm4cGxICG43oyWV2260GCtTXKrdkACPN/Zj05Bsx3Pn0zqB7juIoLy
	 d6L8Z91WtVb7TgYrwilGS1meWuPvUUP8b2kAUZeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Md Shofiqul Islam <shofiqtest@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 468/798] soc: ti: knav_qmss_queue: Implement resource cleanup in remove()
Date: Sat, 12 Sep 2026 09:01:36 +0200
Message-ID: <20260912065527.871990865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Md Shofiqul Islam <shofiqtest@gmail.com>

[ Upstream commit 10a1969353b20caa50c320717e054601631c0d3e ]

Implement the TODO in knav_queue_remove() by stopping PDSPs and
freeing queue regions and queue ranges before disabling runtime PM,
mirroring the cleanup performed in the probe error path.

Set device_ready to false before cleanup to prevent any further
use of the device during teardown.

This ensures resources are released on driver unbind and avoids
leaking queue/region state.

Suggested-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Md Shofiqul Islam <shofiqtest@gmail.com>
Link: https://lore.kernel.org/linux-arm-kernel/20260506154114.2288-1-shofiqtest@gmail.com/
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: 3c8178627599 ("soc: ti: knav_qmss: Remove debugfs file on teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 20c84741639e1..1075ab64fd320 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1885,7 +1885,12 @@ static int knav_queue_probe(struct platform_device *pdev)
 
 static int knav_queue_remove(struct platform_device *pdev)
 {
-	/* TODO: Free resources */
+	struct knav_device *kdev = platform_get_drvdata(pdev);
+
+	device_ready = false;
+	knav_queue_stop_pdsps(kdev);
+	knav_queue_free_regions(kdev);
+	knav_free_queue_ranges(kdev);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return 0;
-- 
2.53.0



