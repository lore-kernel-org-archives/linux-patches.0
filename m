Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77CF27FD54;
	Tue, 11 Nov 2025 01:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823473; cv=none; b=Q7bQz8GREMaP1V3FuwUjqTpRulESFLJKUa3avR1LazdOJ9kyCyA7JZ0BK1ON8Nn1uBhmUdFGBlOj6y6gEgtphr5p1mB+R9qAk58JS6A3j1sl64nymNnOSBlJ174daQiS/bQEeac6wzxAlO5ynND0zFTIypovUPwJIlnbfRHHj5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823473; c=relaxed/simple;
	bh=7w+NS156tK3pGcF+IxjH7aqqA+zlaiQ+QulxYwT2V0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksU41Sya0tAt13MJDS4pVPa96/0EschBOyMzxVqCbd0Kt2jdGmQfPMtPLedb8yEKP912d8dYebzdg2uud6N3GdkIzEsK3Aj2GuLnklAJzzm9i3EGyC2BnGJThlqOJE5hUrT4xrkoPeJ/3brcb15I0Yjc7+wehiSjgq04bluy9Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix9c9yRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix9c9yRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746B7C116B1;
	Tue, 11 Nov 2025 01:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823472;
	bh=7w+NS156tK3pGcF+IxjH7aqqA+zlaiQ+QulxYwT2V0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ix9c9yRbj5cQ95w5RgXjcoIsqAcrjYVahzKbeEAiohEu8OdPnKZ+HJw4FpJ1OKjJf
	 lz/D4fazIhr2Y381kFK52AMV3fPyMov4sVKU9zy3o3yYfZVf48zwlyi7G9WSEII5tS
	 6W/dNagxtRO0jMH42WjUjctmBrdxPFhRzexIIKgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/565] remoteproc: wkup_m3: Use devm_pm_runtime_enable() helper
Date: Tue, 11 Nov 2025 09:41:49 +0900
Message-ID: <20251111004532.597001627@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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



