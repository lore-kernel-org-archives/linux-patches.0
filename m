Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CED47A5D;
	Mon,  1 Apr 2024 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991340; cv=none; b=MkMc+Yp/gUQLlM6fB31EmT8ld9lgDVDlSSxE7hiPDAZkccFVg7cO3C6eVk3bgacmLZvc69vlBEF7LiPUy1JIibaUgPQY/bCKL/RgJs5fXelE6UoyzDbTylkQwLNzoLl7sEAQ5VbKXFtBrUx29rvLyEHBWLHZ7zq+1lxzj+rmbhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991340; c=relaxed/simple;
	bh=bLeuoSWn1MeeuKaskzzw6UdZ52YuXYGfcbu6S9E0e+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N80Y1GXIWQDhVQY2Kr5FFjvyGv1C2rKDbp0U7MxSrKTVhENjB3UZO1mJX98pE8XRz3vHloaW+nZ8Nkked9KuG09Ynsp52qb7maa8KEjb9rp24goW73sVA1mRq8i7b+0eOj5ir5R5l0QfCf46vmAL0ZD/xYUzeoAd9mIZ4OtTYtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnFD6UBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnFD6UBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C26C433C7;
	Mon,  1 Apr 2024 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991340;
	bh=bLeuoSWn1MeeuKaskzzw6UdZ52YuXYGfcbu6S9E0e+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnFD6UBGGtCj2lkyDu9KV+aiY977hXPVc/B9oo/mGBTci50KOgceH/qKba0r5t9O6
	 SFfosXec0/kxI1919I8Gzu32fDkqs+kDuqWC4OgcJAKRbhktyeWq1oNa1+6o6lGYwH
	 hLDJVQmhxDAuHMtkiloy+CUe+VF/LfFacD7YsByk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/272] usb: dwc3-am62: fix module unload/reload behavior
Date: Mon,  1 Apr 2024 17:47:05 +0200
Message-ID: <20240401152538.311309898@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 6661befe41009c210efa2c1bcd16a5cc4cff8a06 ]

As runtime PM is enabled, the module can be runtime
suspended when .remove() is called.

Do a pm_runtime_get_sync() to make sure module is active
before doing any register operations.

Doing a pm_runtime_put_sync() should disable the refclk
so no need to disable it again.

Fixes the below warning at module removel.

[   39.705310] ------------[ cut here ]------------
[   39.710004] clk:162:3 already disabled
[   39.713941] WARNING: CPU: 0 PID: 921 at drivers/clk/clk.c:1090 clk_core_disable+0xb0/0xb8

We called of_platform_populate() in .probe() so call the
cleanup function of_platform_depopulate() in .remove().
Get rid of the now unnnecessary dwc3_ti_remove_core().
Without this, module re-load doesn't work properly.

Fixes: e8784c0aec03 ("drivers: usb: dwc3: Add AM62 USB wrapper driver")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20240227-for-v6-9-am62-usb-errata-3-0-v4-1-0ada8ddb0767@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-am62.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-am62.c b/drivers/usb/dwc3/dwc3-am62.c
index 726f96d257c8d..ad8a2eadb472b 100644
--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -247,21 +247,14 @@ static int dwc3_ti_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int dwc3_ti_remove_core(struct device *dev, void *c)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-	return 0;
-}
-
 static int dwc3_ti_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct dwc3_am62 *am62 = platform_get_drvdata(pdev);
 	u32 reg;
 
-	device_for_each_child(dev, NULL, dwc3_ti_remove_core);
+	pm_runtime_get_sync(dev);
+	of_platform_depopulate(dev);
 
 	/* Clear mode valid bit */
 	reg = dwc3_ti_readl(am62, USBSS_MODE_CONTROL);
@@ -269,7 +262,6 @@ static int dwc3_ti_remove(struct platform_device *pdev)
 	dwc3_ti_writel(am62, USBSS_MODE_CONTROL, reg);
 
 	pm_runtime_put_sync(dev);
-	clk_disable_unprepare(am62->usb2_refclk);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 
-- 
2.43.0



