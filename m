Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBD9243376;
	Wed, 25 Feb 2026 01:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983517; cv=none; b=m/vA4QDnU4YzhOcXF9pySDhL3AECsybd7iJsoxr+KxsU/LtqIyPiap12igkInx7dNqDUDzkabgXX4oBY/gFs5Wr8jcZwcD6sb26hsRy9cCzIW1yBJz5XbQyIXc4P4ZBhTRAgByWeXKQinsylXq709DJXUNxJSIQ1XhNLAKPZXnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983517; c=relaxed/simple;
	bh=yvqb7ez7Ru5Cl71RVNPNHYrtBrjpzKfX9z2L4L2EB/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON4nVc2Ihemu8rHUJeM19QrsRTv4TXjVsv0NES3CgetvkHcNKhzZ4mNHJMIJX3QmVGyMdtVdnp9HX9mtMRoIhVxmgY+Z8rg6rzxGpesrE/fp6NF+XgV8COv0BPTjYAB0QjWicVQMpexIdgMpxysOud6kpXRAuKh76+tbW8cGzgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HB0sr3rP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HB0sr3rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D476C116D0;
	Wed, 25 Feb 2026 01:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983517;
	bh=yvqb7ez7Ru5Cl71RVNPNHYrtBrjpzKfX9z2L4L2EB/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HB0sr3rPliGNUxCE2E+SRW/mHfDMzehnOJP29a545EQyK5ooGwyLji1tBlW+ssVdl
	 nBkeiQHMar/epd/2ZsG6hKFHoI+1LogyM3vfH82/TEz7/fnrO/ALmqSeCnycmsjZ1t
	 R93igrYcho508qPDuXgZhmrZQ4ibCZ/Yo0n/phmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 582/781] watchdog: starfive-wdt: Fix PM reference leak in probe error path
Date: Tue, 24 Feb 2026 17:21:31 -0800
Message-ID: <20260225012414.073290347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit 3f2d8d79cceb05a8b8dd200fa81c0dffc59ec46f ]

The PM reference count is not expected to be incremented on return in
functions starfive_wdt_probe.

However, pm_runtime_get_sync will increment pm usage counter
even failed. Forgetting to putting operation will result in a
reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: db728ea9c7be ("drivers: watchdog: Add StarFive Watchdog driver")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/starfive-wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/starfive-wdt.c b/drivers/watchdog/starfive-wdt.c
index ed71d3960a0f2..af55adc4a3c69 100644
--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -446,7 +446,7 @@ static int starfive_wdt_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, wdt);
 	pm_runtime_enable(&pdev->dev);
 	if (pm_runtime_enabled(&pdev->dev)) {
-		ret = pm_runtime_get_sync(&pdev->dev);
+		ret = pm_runtime_resume_and_get(&pdev->dev);
 		if (ret < 0)
 			return ret;
 	} else {
-- 
2.51.0



