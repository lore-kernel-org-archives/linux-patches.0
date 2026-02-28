Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A1633F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301181; cv=none; b=B2F+X/Y6ejuwdSu3F8VA61Z6HwGEl4x5ZpJ87Qzg7SWDv1mm6jFFeIcuELhVj1A/zd/npZHAz7hyBwLo4008ALIh9GVIyHYdt8gmVys2n97LR5kcXp+yw/DpJIlyAnMf4Q2LhcMZon4ZMCTbCernuoOVnPUsdj7MRUy64gzLLFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301181; c=relaxed/simple;
	bh=FTwb94O2+0BWU/8PxjRoKtacny9TIv5c8a1PPMB4qto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uekIN3Pt0Y+x57TraVEk/Oh3viI+DMvqV0tfjPaMlrCFym39KkutB8yQ26dHQqoYjB/1NBSr9cgG5/eymPBG14kfvOABb+UCVEf7eZOAO5eAX8XOuw9ssMnT9k54VEGE9tLmuLfLJyukMrB/AuBzEku6lRdhCcP3h1HchQbiTfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KB+Ko9Wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KB+Ko9Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCD7C116D0;
	Sat, 28 Feb 2026 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301181;
	bh=FTwb94O2+0BWU/8PxjRoKtacny9TIv5c8a1PPMB4qto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KB+Ko9Wtyf3Yp0C+tRDuXy6ilCninDK1Qj64Xc3GLH/nPCV1ojDDf/D8EkB576+Vt
	 vIwPs2h3DYDe0etTopiu55v2asv9mnlY3JdFEV0LJYMOrMK3a4UJGd7l8xYedZOO/k
	 9W4QZfWpsFnSzxyjv7/u1/EOatM6y0IHAvXX7Ray2+GMS1KX/HFFTjIl8NaDzrG3ne
	 BGwV7AEYed/RGGMB+fw94fN5icbXrFVlM2brdJNcOwn31tqvUwKqHxXiayHmfqnLHm
	 GReMsH8lxVQeNBiMR5iMqDS1Hlr2KjWtEZR3teUlA96lwPJY10vx46Fw4zDccXmFIB
	 xifLUwd0AyAxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 350/752] watchdog: rzv2h_wdt: Discard pm_runtime_put() return value
Date: Sat, 28 Feb 2026 12:41:01 -0500
Message-ID: <20260228174750.1542406-350-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 2dea984a74265a67e3210f818416a83b87f70200 ]

Failing device probe due to pm_runtime_put() returning an error is not
particularly useful.

Returning an error code from pm_runtime_put() merely means that it has
not queued up a work item to check whether or not the device can be
suspended and there are many perfectly valid situations in which that
can happen, like after writing "on" to the devices' runtime PM "control"
attribute in sysfs for one example.  It also happens when the kernel is
configured with CONFIG_PM unset.

Accordingly, update rzt2h_wdt_wdtdcr_init() to simply discard the return
value of pm_runtime_put() and return success to the caller after
invoking that function.

This will facilitate a planned change of the pm_runtime_put() return
type to void in the future.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzv2h_wdt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/watchdog/rzv2h_wdt.c b/drivers/watchdog/rzv2h_wdt.c
index a694786837e11..f9bb4ef3d327b 100644
--- a/drivers/watchdog/rzv2h_wdt.c
+++ b/drivers/watchdog/rzv2h_wdt.c
@@ -270,9 +270,7 @@ static int rzt2h_wdt_wdtdcr_init(struct platform_device *pdev,
 
 	rzt2h_wdt_wdtdcr_count_stop(priv);
 
-	ret = pm_runtime_put(&pdev->dev);
-	if (ret < 0)
-		return ret;
+	pm_runtime_put(&pdev->dev);
 
 	return 0;
 }
-- 
2.51.0

