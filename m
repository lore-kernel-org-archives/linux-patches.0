Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6B23AC0FC;
	Sat, 30 May 2026 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163515; cv=none; b=p9gi26USj/AbrGH7pOg8HJf8daQxfoarqUJggLNnAtg7QCfo7M441Hll2HKI9+cZnnNnGg6C9mZAWgQFKXBX3D4sbMnt0el/YuM9QQHfHKY1lku5PQ66b4Inep1h3k0Wyepjy3HQzWRBz5OsIEMH0XJ5HplotROPydia2kxLZj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163515; c=relaxed/simple;
	bh=c9kw/Dva0GTFbqOP/VBiT6JSGj11BvYZQCRqqFrbbPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru+SdAFcwqWGpeD3mO7LcSlzlbAiqVsCoxBN1QJCeDoTnMJwZtQn9JS5Zebo+ROLeztOFijwshtB+bBW54F4SgOMHSHf4thjT7Y41iFNg93PSIZgtsQ3JgJZr5Ml+WZAmz8h6fpxPzdOlOXwd2rRs4IZ763lzuTvjr145f0kXI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wv/37L4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wv/37L4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FD31F00893;
	Sat, 30 May 2026 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163514;
	bh=5sqk8ST/i5chB39arKhXcHSKFBgkMKO7kW8vN/v39I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wv/37L4inRt1ztSQtY43/I0DD3sB3WMypS8N0E6lDxsh2oojRCoJRlFImODjfBMu
	 9JyE8ToZCFgcuLG9cfe5GDSuLI+ntBZUsz2rIVsKV93eyMios4Qf5p9WQQSxPG8pcb
	 VNtVFbB96ZrwT75G27xZVRTiuD1erLTS2YqFsljA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/776] spi: meson-spicc: Fix double-put in remove path
Date: Sat, 30 May 2026 17:59:55 +0200
Message-ID: <20260530160247.820253723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 63542bb402b7013171c9f621c28b609eda4dbf1f ]

meson_spicc_probe() registers the controller with
devm_spi_register_controller(), so teardown already drops the
controller reference via devm cleanup.

Calling spi_controller_put() again in meson_spicc_remove()
causes a double-put.

Fixes: 8311ee2164c5 ("spi: meson-spicc: fix memory leak in meson_spicc_remove")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260322-rockchip-v1-1-fac3f0c6dad8@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ In v5.15, commit 68bf3288c7eb ("spi: meson-spicc: switch to use modern name")
has not been applied, so the driver still uses the legacy spicc->master field
and spi_master_put() API. The line to remove is spi_master_put(spicc->master)
rather than spi_controller_put(spicc->host) as in the upstream patch.
They are functionally identical. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 6974a1c947aad..ae818e7df7919 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -863,8 +863,6 @@ static int meson_spicc_remove(struct platform_device *pdev)
 	clk_disable_unprepare(spicc->core);
 	clk_disable_unprepare(spicc->pclk);
 
-	spi_master_put(spicc->master);
-
 	return 0;
 }
 
-- 
2.53.0



