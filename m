Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0022EA46B;
	Fri, 21 Nov 2025 13:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732564; cv=none; b=WabaW3gn44X05+UBWGvL/Ea/oB7nkls71jmfZkzZ5sUcXxOajrv8qrNhQc2R29E0eB/9LJQJPJqzEwbRM3p6KOzN3RkqDYhMSJ1fX/FdNsHQPjB/3fm2Dkj5keXt4I2YuHBG554wSjh2mNpKd5OM3crZvYBomQFI1fGsGQj2vJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732564; c=relaxed/simple;
	bh=e3/2FvMeE9pjKQvzGJ/x/W8qXyiHlXzHVM1uy2tmPaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9rDQEZHSkr9tjWJVVx0D7oRaDL5OwaTe+bcuickEuduSvQYx1kXHo0D7h1onSQRxe1g9Tp9LenPJGjRlpVclNYeJ+21TtpO2uvKQQjD8AC0hOa8fR79WyUQbEQORXVyHTnlPfjbEUhsAUr3HN9GYub7+KEuMaETCoEQ9iG9MGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYpb0PNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYpb0PNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24728C4CEF1;
	Fri, 21 Nov 2025 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732564;
	bh=e3/2FvMeE9pjKQvzGJ/x/W8qXyiHlXzHVM1uy2tmPaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYpb0PNrRGtIq1GQTcjF6OqlRDHeh4pKO2N31jVqjDceUPvchRBRHclozNjq+AU9R
	 XBdndyAiGmXt2nxSvjwFzYa0lwtsiRuQ9c8Vala82o3pstwwvXq+HW6m7Ty7VJZL7P
	 5/YEFiu8Gn4RV5mrCLqlgXd/HZ7WmAZHjNU6cST8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/529] remoteproc: wkup_m3: Use devm_pm_runtime_enable() helper
Date: Fri, 21 Nov 2025 14:07:43 +0100
Message-ID: <20251121130236.854947212@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 461edcf73eec57bc0006fbb5209f5012c514c58b ]

Use device life-cycle managed runtime enable function to simplify probe
and exit paths.

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20250814153940.670564-1-afd@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/wkup_m3_rproc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/wkup_m3_rproc.c b/drivers/remoteproc/wkup_m3_rproc.c
index 36a55f7ffa64d..c39bd2bf2c1e7 100644
--- a/drivers/remoteproc/wkup_m3_rproc.c
+++ b/drivers/remoteproc/wkup_m3_rproc.c
@@ -148,7 +148,9 @@ static int wkup_m3_rproc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret < 0)
+		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
@@ -219,7 +221,6 @@ static int wkup_m3_rproc_probe(struct platform_device *pdev)
 	rproc_free(rproc);
 err:
 	pm_runtime_put_noidle(dev);
-	pm_runtime_disable(dev);
 	return ret;
 }
 
@@ -230,7 +231,6 @@ static void wkup_m3_rproc_remove(struct platform_device *pdev)
 	rproc_del(rproc);
 	rproc_free(rproc);
 	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
 }
 
 #ifdef CONFIG_PM
-- 
2.51.0



