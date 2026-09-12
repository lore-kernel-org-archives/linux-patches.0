Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D85E2F617C;
	Sat, 12 Sep 2026 12:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215723; cv=none; b=BF4eExe8/I3JsLiPMSC+R/orgtIkHVuJBzibfW35grhSoFlMijAiNUbm2tuIy4fAwlDkmze708sK9Tp142QiqJjddFlj4vQ+DY9qsdCgrA76/CifHc/2y7VnY5qc4q00HjbuKiVBJN9G6N0dqTOryx2P4rjJPO1qtq6hycoY5wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215723; c=relaxed/simple;
	bh=OjHzZJz9UVDiDjWzk9mGa8BM1S0IFUm5GXkK/JwyBUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEFm0CduSX6Na1rH5TTN8lxkDj5w61MdJkK1zMAX4M6LdTcUWdQop7V3dMZ4OSBzx51oaZHdHsAySw0qSizlIiBF8Tibgjxuzet91D3UcnNwbAdqOvreu+6m2ya5vnttuXSIrc3pPMfzJ5Lnh7LHcgtUwDf+ql9B+YgtTjgITQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3mA/0aL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3mA/0aL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56031F000FF;
	Sat, 12 Sep 2026 12:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215722;
	bh=jKdFxhcMD3xoNRFWQVDxxxX56BO3GGroMIdozAAnKzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3mA/0aLle5exSSetYuDGOwLEjNB0ZvQRwspWPKFrXyg5Ln57vFjL54UA4Rfso0Qu
	 syZje4UtuedculAWRFt3JX84O4V9b2GDoUXWHih2Kd88qJf4VGJE1ghaPPnmGJSjAi
	 sDOZ+LgJE+IuToqRr3tjHNDAvlSMcEWYVbZs2+hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Md Shofiqul Islam <shofiqtest@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0589/1376] soc: ti: knav_qmss_queue: Implement resource cleanup in remove()
Date: Sat, 12 Sep 2026 08:50:15 +0200
Message-ID: <20260912065620.661182842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index c2ad1863048fe..df66fb15e4f95 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1887,7 +1887,12 @@ static int knav_queue_probe(struct platform_device *pdev)
 
 static void knav_queue_remove(struct platform_device *pdev)
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
 }
-- 
2.53.0



