Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A2E32E757;
	Sat, 12 Sep 2026 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223519; cv=none; b=lRb+vo9pI5ef4vLtRMwpm/K4tY/YPEmnhcLt/UqUNIwgOvKZlpEBOGCPa56iMdR2SG0/o1yhd0MiSGrxzvUAu2PShgXWqGXz/JM+SR0vpgERZjsQKwD8H+QU/Jhx9091UL3VgahCW87f3Xp4/uniSAXZxfYxCbWfvJ8kCfNNQA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223519; c=relaxed/simple;
	bh=XIOGAzMo5zBCWdpAJ25cFWLY2JveuPSgfUcXcaogrBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VG4hjq/2bYGNV3tCL7HPpdkXQctF/BfGPo7rx3qALzN8/SoHJr/47lomxJqpGHirC6dySF2ar6NsXU8zdtnqcASYNPo04kTPfBRjNeTFwC7cSXbnFYFMvxB5T8n0/om8WMGW3zZhb9PJiEi7KUrbyhyrxtOJddnqYkXK/GhVSO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqYzP5SA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqYzP5SA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FF11F000FF;
	Sat, 12 Sep 2026 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223517;
	bh=sK9Ccm6fxoNgtrM3Ir5Nzgd8596XWmodLqQw/kWW3nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqYzP5SAbiHY1M9VaqE3+/RGO080aTomzSu5P+ZqJQoBjY+Epv7EP5acM3+Saqnhr
	 DD4hPdpARiJPJxrJ9fGx0Gxt4rYU50bS8UTQvcQCRo65rp1Eoa0coZEkPEKCJ7YRh2
	 icfAB70ZxP0KG7igZzt0uWfBvvlW3akFuvY7yaqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Md Shofiqul Islam <shofiqtest@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0805/1424] soc: ti: knav_qmss_queue: Implement resource cleanup in remove()
Date: Sat, 12 Sep 2026 08:53:57 +0200
Message-ID: <20260912065625.320777904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 0f252c2549ba3..66a2d5690cf2a 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1886,7 +1886,12 @@ static int knav_queue_probe(struct platform_device *pdev)
 
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



