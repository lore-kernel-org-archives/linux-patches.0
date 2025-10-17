Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3EC1D5CE0;
	Fri, 17 Oct 2025 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714253; cv=none; b=pX2KqV3GnsiL/16w2KMUvyUIbmtLHjXHdfZbynzUMiTcqfpOynupRLvLJuNu9W0l+blLBkrugILH1xqYumO/X+cUdaDBLyRXQ6FRISzDcPMV1C59pAwI204yYV03XChO74ApbFekgmbrKgxE7GBuZNOHFIdkpz5cWPe6va95yuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714253; c=relaxed/simple;
	bh=UsGhDM1nIWk0ari7BLXKPa0sxUQ7DAPRBVPjS5cvSQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFxrG7Rh3b9lVmH11PQ7F2o5bHsEbImgzcDAElAALvrGhpCHQ7ncfOrvn6JBV4BI5EViwmutkCfHLNHf0YAk3hpcCBSlqWA/mGwitQz0v1l178Tb9PH4Zk0WdHhJcAEyPtwO3tmKBYPFvD2nyTDjsX5jeaVUuKb6V3y1v+D5Lg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJQVtppn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJQVtppn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E384C4CEE7;
	Fri, 17 Oct 2025 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714253;
	bh=UsGhDM1nIWk0ari7BLXKPa0sxUQ7DAPRBVPjS5cvSQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJQVtppn9yktxZBxTxDUuCFyKQjfivT/8yWQOz9/pjTWmX++LPDtDC1UlfWlu2LCA
	 TKqMMgFxDB3Rfdy28K0sZsFwy0SmvHlzmm/AVbUEjToP2QXixYBPiFdLFRR+8OT3RF
	 Z49CpfVeMwlS0SbTrDgBrD9UJ2ylZhKPyQkp9zZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/277] gpio: wcd934x: mark the GPIO controller as sleeping
Date: Fri, 17 Oct 2025 16:51:28 +0200
Message-ID: <20251017145150.092838064@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit b5f8aa8d4bde0cf3e4595af5a536da337e5f1c78 ]

The slimbus regmap passed to the GPIO driver down from MFD does not use
fast_io. This means a mutex is used for locking and thus this GPIO chip
must not be used in atomic context. Change the can_sleep switch in
struct gpio_chip to true.

Fixes: 59c324683400 ("gpio: wcd934x: Add support to wcd934x gpio controller")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wcd934x.c b/drivers/gpio/gpio-wcd934x.c
index cfa7b0a50c8e3..03b16b8f639ad 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -102,7 +102,7 @@ static int wcd_gpio_probe(struct platform_device *pdev)
 	chip->base = -1;
 	chip->ngpio = WCD934X_NPINS;
 	chip->label = dev_name(dev);
-	chip->can_sleep = false;
+	chip->can_sleep = true;
 
 	return devm_gpiochip_add_data(dev, chip, data);
 }
-- 
2.51.0



