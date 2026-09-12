Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281EA4BEE43;
	Sat, 12 Sep 2026 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238879; cv=none; b=X0bOnqLFpCYZ/kF67Zhz7uS9FNKKE/GXBIGFlBAVAKhprm2HZ5AW0Yb6yp0BPy3mQxdoiKeuA9mDoNcep6MyFeqLU/NpXs7k5gQ8Z640sucdZOHIgrGOnTyb4gTOpTKAyAdhPg7Wnxj4GfyNUSBhLlCPdIDBY8FFWP2GQw0e5ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238879; c=relaxed/simple;
	bh=6QVe1IJRcDL8lSJQDp0+cOEAOrtGo5XtdsA/aEqGH+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmr7xEKm5SgK15nCB8gyZvbZGJ0zVXubTHKAny9Vin0NJZZfZaR9cntJsy5qSY5CMdnq5qyT0EJUwBvov53l2iFrFajLJyfc9kDXWcLEReuOLwoqI4M955Yrbj8BWrNZPr+MRJb06kQREbMIVa/+OkrV6ZX4yHu+wRUNZVG5Aww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sH0LeUUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sH0LeUUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3161F000FF;
	Sat, 12 Sep 2026 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238878;
	bh=WvXyjn9L0Je+th/dANzIJ+nP3Zq5ngBETsgw2GvDDGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sH0LeUUbWHjN7vLRHG9xoGhKn4YZOjzkaQk6JWTKvuEkA+az/xu8YBSPWyOYtcpq9
	 ZBc5hRa+b4p+hC6B8mhDCRZfRLOatfgF29a8BGKwFg655fpSvLxVINU/9atsrjr96T
	 68QcDrmmpxvsm/e7gYeFqUMBLpBwdJvx/SzJT7hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Md Shofiqul Islam <shofiqtest@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 552/935] soc: ti: knav_qmss_queue: Implement resource cleanup in remove()
Date: Sat, 12 Sep 2026 08:59:42 +0200
Message-ID: <20260912065539.486268311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 52389859395c6..c8191b6200947 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1888,7 +1888,12 @@ static int knav_queue_probe(struct platform_device *pdev)
 
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



