Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C99349AF9;
	Wed,  3 Dec 2025 16:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780619; cv=none; b=MZCowS7xKqrWkZQ4xjPvHmrxX0fMHOHOyJowe/YOYxGl69oaiAVA0IvWjpxXeuLN8w8GcwI8Hcu4jqa1IlEPuJ5cj/e2M4E7cb8wECAElelUOww+mGR6TCGdglYmGdyrrZAP9sc25q62Ie+qMn+4qndkIweYSlkFuV+/izJDz40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780619; c=relaxed/simple;
	bh=M9nJ91ZnLQsDFiNi6SBFfq2D5bk1fC85DqV9kB6uOqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgxtYKWOnM6hxNSBSlmQwGAzkESjzS/soMkRwMD8hj/aaOq6skNFXeJOA8O5RPlBKt9ibCmMj97jS2X4BqND+82+d9qzdMtwYZIT6drSpSzDbodHzvdjtlIOwaPO5usaWHHJvh9k+iyTTe55dGAkoTZ8GG46UlSpWdUK+f+BEsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6CvfEkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6CvfEkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55443C4CEF5;
	Wed,  3 Dec 2025 16:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780618;
	bh=M9nJ91ZnLQsDFiNi6SBFfq2D5bk1fC85DqV9kB6uOqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6CvfEkhCPXvghEUABlE3BPX2uzjjNu89IVZUKsZb+gDks2OGblJCw3nmcFT095ZG
	 tnD6DUxohhUEWgEM8aTLkgs6T0Acza93CNedszyZ7sq9kHPDSDtxTl5Dc0fLqfLm8v
	 yqOTj+INxops0Zv1X5q0hfSLJZJXnCaKtAmesjlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/132] spi: amlogic-spifc-a1: Handle devm_pm_runtime_enable() errors
Date: Wed,  3 Dec 2025 16:28:39 +0100
Message-ID: <20251203152344.781192909@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit a90903c2a3c38bce475f46ea3f93dbf6a9971553 ]

devm_pm_runtime_enable() can fail due to memory allocation. The current
code ignores its return value, potentially causing runtime PM operations
to fail silently after autosuspend configuration.

Check the return value of devm_pm_runtime_enable() and return on failure.

Fixes: 909fac05b926 ("spi: add support for Amlogic A1 SPI Flash Controller")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251124015852.937-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spifc-a1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-amlogic-spifc-a1.c b/drivers/spi/spi-amlogic-spifc-a1.c
index fadf6667cd51c..b430bca4f8bce 100644
--- a/drivers/spi/spi-amlogic-spifc-a1.c
+++ b/drivers/spi/spi-amlogic-spifc-a1.c
@@ -349,7 +349,9 @@ static int amlogic_spifc_a1_probe(struct platform_device *pdev)
 
 	pm_runtime_set_autosuspend_delay(spifc->dev, 500);
 	pm_runtime_use_autosuspend(spifc->dev);
-	devm_pm_runtime_enable(spifc->dev);
+	ret = devm_pm_runtime_enable(spifc->dev);
+	if (ret)
+		return ret;
 
 	ctrl->num_chipselect = 1;
 	ctrl->dev.of_node = pdev->dev.of_node;
-- 
2.51.0



