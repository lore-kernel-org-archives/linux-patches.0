Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E531E2DE707;
	Tue, 11 Nov 2025 01:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823752; cv=none; b=kWbfRwlR8QDExYpV+M77XIFR/J9GUeEQkIMZvM7t17mN8TDAfydNATWodWBvWoLKf9tGjUhVL5FJhUqOoqAFaymLD8BzttozveXoCEElBz4GUxx7WbcnTivOz6AJrA4MkcNhfC16ZY396fzlqE5WzHngKoutHH0Ut73qUuH4A/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823752; c=relaxed/simple;
	bh=Bb10hC2qw0/6duv+HAKOKPhr0VjJdlqJ9ONuYoXDB48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBNHMCCf6vherxxLk0Bi4B0p2euoFOUykWp8mkxz1Lik37vodD1nxdMf61H7B5QTcfch+i+SyD/p9uAOMCMc4pYnj6jDWjHqWk2U0AXFp5Y0GBCrfAyNDOOcLM6IdAC1veoJWwpwyq5heZmb2K3c30NSxsKKqiP0jUiAd2MilV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQT9OOxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQT9OOxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87321C4CEF5;
	Tue, 11 Nov 2025 01:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823751;
	bh=Bb10hC2qw0/6duv+HAKOKPhr0VjJdlqJ9ONuYoXDB48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQT9OOxvLTm7tqEAmw8ORqLN7/Ta4Ni7r2i5FF6/3crNtn5mZcLQ+vEU8oEnJOwtr
	 Y7wBL0BJ66XFceDzDpahDP0LOfhCHsqQ8At0XB2ZwBJP5kiNfhvxJTO0WxfwJrsEHh
	 vakCGtDNNoDpgMfWiDVJLsZ+9Il9LPFO0DZCKenE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 362/849] remoteproc: wkup_m3: Use devm_pm_runtime_enable() helper
Date: Tue, 11 Nov 2025 09:38:52 +0900
Message-ID: <20251111004545.170008282@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d8be21e717212..35c2145b12db7 100644
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



