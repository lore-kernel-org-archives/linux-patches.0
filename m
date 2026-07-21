Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8003955F4;
	Tue, 21 Jul 2026 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649563; cv=none; b=WJQAuSLgyQoWVFFULLNRa2BgTSkXlz/7MinioXFZAYOoeaNyowqmhh78IoMGlBX0FdMu32WF2e7am9EIp+GT704FQotvCnp80ukhNbpLoUoLHto4gCiH7IGD84nDejvTEy2GwtEdaaVO/vGT4KuskpKNOWZDGjvXqRHcsuYlU8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649563; c=relaxed/simple;
	bh=CFDwNzTymoXwyIBL8Wdsg1Z4o0bFC47pPSM7b4sDexY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6RiPUG6A3XGg6kpMf5cxuJBcDdwqiLc2uh6QfrmU93roZFpCoxrydTph4lh4/6ZpfXdHLwyEhBFQHU2SJBIYkjI1PLAJsOvzYCT9rjZqCbTf7wt3rE8RetQblETj0KJUnKxD5CdQw0Xg+DnXtkbSFywjSqAc8uw/qz4uOOvFUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI67im7w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI67im7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF9E1F000E9;
	Tue, 21 Jul 2026 15:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649561;
	bh=3G5Zngz75y0zhakdSgPRwiz/p/xnydt4zrGVe1880Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XI67im7whhXvOE/gJ6Q5MQn7z5xUayoO4XjECi0Gyshbw+MYpFs5s1J2UMZHN9J6h
	 y7Erd8TyKGgq7lVcVjd62Hj1I0rMZ1PT1YzdFbmedmxkaIP9Sz41h27cqjL5IsmeA8
	 SobaqINPNwSWUgjwRZtYCWcqNL160pFvlow5qxMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0624/2077] spi: meson-spifc: fix runtime PM leak on remove
Date: Tue, 21 Jul 2026 17:04:57 +0200
Message-ID: <20260721152607.523064784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b818950a8cb7d1..e2d19c3873f712 100644
--- a/drivers/spi/spi-meson-spifc.c
+++ b/drivers/spi/spi-meson-spifc.c
@@ -351,6 +351,7 @@ static void meson_spifc_remove(struct platform_device *pdev)
 {
 	pm_runtime_get_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0



