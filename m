Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C673B3C15;
	Tue, 21 Jul 2026 20:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666041; cv=none; b=Gy2uH9Sj+DkdU9UOXjTyxbHBCRPZDoEkzJNl6megjycTCj0n/736jWYoEUF/lSKW95jz5FGNCmgbyzVVbvlafQsZ+Ub6nurfrh0RiMeSNSSKbz6otxjXOQzMnrWMyzgzxnqyJ16zDWwM8MWwBhKHKvdKOTDed8qPUi39ttmU0SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666041; c=relaxed/simple;
	bh=25eNqVZ62FhRQ7tXlzBI7x/I6IJ4eN5Z5F5Rs6y+90g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTEbCAMFchyP+13YdRXOCh5JBeeaQxdSpnyzZl5y69kX9gI0Rd0kfl0ebgBclOjS0GTfA5OBpqA4C4R7p/a+eFhYeXEC8mPWl41IuAPWwctJZ6E7Y49mwgi/WEIszbss5frbWVdETIM7HwNfYbDVuQjQL3wGQoQm/wqZ9+tfwKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLbl3JCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLbl3JCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D97F1F000E9;
	Tue, 21 Jul 2026 20:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666040;
	bh=7b0mB2uxEOZeKDFf+/T4e/JxMp/m1GGRFMibLu0RTfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLbl3JCDcW8aN44nNOktPEKmRZnYmkJt/MRgmn5fQQ9cOuAVnev+h9RgrI56hSYnC
	 NV8AT3s2Awe898d6f/L8CbCx/ut0RV3c6u/miE7nycs6MfD3x20cXxd/hrN4oiTyE2
	 azmIRlpynqAXmkrOSbpv5s/YmfMV1XGzVNwwIOzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0532/1266] spi: meson-spifc: fix runtime PM leak on remove
Date: Tue, 21 Jul 2026 17:16:09 +0200
Message-ID: <20260721152453.763224966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 606c0826bd90384a54571c0c5475ca41f50164ea ]

pm_runtime_get_sync() increments the runtime PM usage counter even when it
returns an error. meson_spifc_remove() uses it to resume the controller
before disabling runtime PM, but never drops the usage counter again.

Balance the get with pm_runtime_put_noidle() after disabling runtime PM,
matching the teardown pattern used by other SPI controller drivers.

Found by static analysis. I do not have hardware to test this.

Fixes: c3e4bc5434d2 ("spi: meson: Add support for Amlogic Meson SPIFC")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260609052647.5-1-ruoyuw560@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spifc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-meson-spifc.c b/drivers/spi/spi-meson-spifc.c
index 06626f406f6847..fd1f294af02e23 100644
--- a/drivers/spi/spi-meson-spifc.c
+++ b/drivers/spi/spi-meson-spifc.c
@@ -363,6 +363,7 @@ static void meson_spifc_remove(struct platform_device *pdev)
 	pm_runtime_get_sync(&pdev->dev);
 	clk_disable_unprepare(spifc->clk);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0



