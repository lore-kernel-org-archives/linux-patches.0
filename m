Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8724427A10;
	Tue, 21 Jul 2026 19:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661572; cv=none; b=b40j101GzOT8cW8OrDW4SL5d6dQTKD9hVsQN2wXYDHRZmovCdV84vdFc1P0pPuk0OabfIeBdfu3qbpfzJbHuUOF1cjk7NED2x0LF04HC3JbkE/V9t7oL4hfjx/tCSlP1/9sJWdHiFT3TwKbdOCiJ1KeAxZ+CHlHjp+ngQIQQgBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661572; c=relaxed/simple;
	bh=UsFk1FPxR23Q2pwwdWYQ9JFdOXgJAaT733oxXfYhU3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJbdTglb6IN5ooPH+FnUvscUWITP6DQUEVAl/h6Vf8OY6cssMMkCE+Q1K9hAo0hVIko4olwZEHuI0LYj2pIeVOMehivwIl4D7/jyeAQGX3hDUTyEr1R4D+7V/mFBu73CLrqnD2IP8dzI6+HmRyAYIH6Tlnufu/yiottnNEl9xjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpjPDlvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpjPDlvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3051F000E9;
	Tue, 21 Jul 2026 19:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661571;
	bh=xcN/Mu76lTff6whAkxX4/5y19V6lDiYI2bssqYYLprA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpjPDlvGxjLuR2AtxNf3WfHUqWU8YK56Ykt9xcKoF4K4/lh1bZWXY7PSdCTQfEWzJ
	 dyJY8oRpK1Rf0xumHyXiuakAQfs45thXHmG+Qrx5zNhzWUb9BSE7ayTM0dDcnRYhQg
	 bC5fDdjgzkXM+7jNg7Qnaef9cMx6KMDhVuTVWEGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0117/1276] spi: hisi-kunpeng: Use dev_err_probe() for host registration failure
Date: Tue, 21 Jul 2026 17:09:20 +0200
Message-ID: <20260721152448.716898185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

[ Upstream commit 59b991990a04b1d1ce95373983b7c8b65bdf7acc ]

When the SPI core registers the Kunpeng controller it may need to acquire
chip-select GPIO descriptors. If the GPIO provider has not probed yet,
spi_register_controller() returns -EPROBE_DEFER.

On a Kunpeng system this currently prints an alarming error even though the
next deferred-probe retry succeeds:

  hisi-kunpeng-spi HISI03E1:00: failed to register spi host, ret=-517
  hisi-kunpeng-spi HISI03E1:00: hw version:0x30 max-freq:12500 kHz

Use dev_err_probe() so that -EPROBE_DEFER is reported through the deferred
probe mechanism instead of as a hard error, while preserving normal error
reporting for real registration failures.

Fixes: c770d8631e18 ("spi: Add HiSilicon SPI Controller Driver for Kunpeng SoCs")

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Link: https://patch.msgid.link/20260515102620.1926930-1-maqianga@uniontech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 77526f7940688d..6afa37d10c7c1b 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -518,10 +518,8 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	}
 
 	ret = spi_register_controller(host);
-	if (ret) {
-		dev_err(dev, "failed to register spi host, ret=%d\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to register spi host\n");
 
 	if (hisi_spi_debugfs_init(hs))
 		dev_info(dev, "failed to create debugfs dir\n");
-- 
2.53.0



