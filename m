Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624045;
	b=cg6cyzQmwLGL49N91CyQ8Vrn6Jm2+umqKV96VpW4jqr5xh6ZP/I/sXJ6AKxNzeSpBVgg
	 qwKX/QvK+qro7f/8Qsk8CSW6yWRDlY9LE3hzsxOIcBy6fyYp6BdAgJdMmCgAqBnq9kq6C
	 ptfaDZVICuyzz4/nmLRUFQZKMn6AcCECFY+h60mqJTeUsmnP/hEP/0mwDiBd2Q6DZZ0vv
	 bEYu2TialHiRmp1Kug/vq6lWxOTg88Xb39uR3SZGu3z92+YQiEp+y69IH4x5ZN3nh9aXP
	 wS828QfLQgKF62nix6C0Zfzl4/+rlBWsDoCvx+h5QPItiC+Icw2D5XLLCI77SebiUQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BiifJvdCXyFKq37/+ohMcUcbxLkDn2gmXYfqH+kYbZ8=;
	b=1hDC2Qtews8RS570THr4KG60NObo+br69UUEKTqh21seJYe+xOiZtZ4BTFiCD20kAaga
	 7teFHCDqeXlJtp7rOtiOGOhhnkYjNFPO77eJexu4vcTDVV7HoJnlB9icIilNkXySw0l0M
	 Go7qv2BpGGH/7aQFF3257Q1qd1/5/vsmpDiP732GwaK7wRLYSZ/VuNHzTxeAPb0/5Gzvc
	 O4HZ1kA5SkQKMBYmrny52OmJ1ih1Jc675qL0IPqxvVnEsVDenHzkxze/k9aMivvsZh1V5
	 bkYipRAz+qUMt+Wzp26AnLR/qwQn6iPYDm06N6UX1oOrIvs+E4ADeG+wbNpK99ayqIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGxBlwAA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9BB606A332;
	Wed, 25 Nov 2026 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGxBlwAA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07AC1F000D1;
	Wed, 25 Nov 2026 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624045;
	bh=BiifJvdCXyFKq37/+ohMcUcbxLkDn2gmXYfqH+kYbZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGxBlwAASZDpXHEz3HG4M7mmdeUMfEwnFzKceu5hTX46EP1qNYRti/HIaJhckz7KB
	 M2WtMOIq7YYyW0y7hP/OdDRA26EvlLKeVSarZ3Ud06VWNePBlmWRaVIP0/0/C2HzBh
	 45eFlHhIz8304QGWKe7jYSmLqdJzCJouU2TZIY08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/816] gpio: omap: Propagate runtime PM failures in probe and request
Date: Wed, 25 Nov 2026 15:26:55 +0100
Message-ID: <20261125143850.772970952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 05be1a99d6d68b24cbe24a191e1af67c70193ac3 ]

pm_runtime_get_sync() can fail when the OMAP PM domain cannot
resume a GPIO controller, but omap_gpio_probe() and
omap_gpio_request() ignore its return value.

Consequently, probe can register a GPIO controller despite a failed
resume, while a GPIO request can report success and modify GPIO
state even though runtime-PM acquisition failed.

Use pm_runtime_resume_and_get() in both paths and propagate
resume errors. On probe failure, disable runtime PM and unprepare
the debounce clock when applicable.

Reproduced both failures on QEMU N800 by injecting -EIO from the
OMAP PM-domain resume callback. The original driver continues
probe and accepts the GPIO request - while the patched driver
rejects both operations with -EIO. Normal GPIO controller
registration continues to work without fault injection.

Fixes: 77640aabd755 ("OMAP: GPIO: Implement GPIO as a platform device")
Fixes: 55b93c32520d ("gpio/omap: use pm-runtime framework")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261029103626.1527919-2-thnkslprpt@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 595ef20084049..a808ddbd8773c 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -814,8 +814,11 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_bank *bank = gpiochip_get_data(chip);
 	unsigned long flags;
+	int ret;
 
-	pm_runtime_get_sync(chip->parent);
+	ret = pm_runtime_resume_and_get(chip->parent);
+	if (ret < 0)
+		return ret;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
 	omap_enable_gpio_module(bank, offset);
@@ -1465,7 +1468,13 @@ static int omap_gpio_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bank);
 
 	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0) {
+		pm_runtime_disable(dev);
+		if (bank->dbck_flag)
+			clk_unprepare(bank->dbck);
+		return ret;
+	}
 
 	if (bank->is_mpuio)
 		omap_mpuio_init(bank);
-- 
2.53.0



