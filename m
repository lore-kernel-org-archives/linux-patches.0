Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704172;
	b=3OgfTmuUR3Ns5NeMB+h1aWZcqpwYh2FfKgSy1EZ6clhIfedy3xRtDW49XARaCXHMgYq9
	 azWE6JZrONUBrBvgDpWT9+PeCyO9d/BVdUufqBulE7bmruPxWUfXZZI0rv9dmetkYgcny
	 ZXOVJgb75Jtcc5Xvw+cfeksVMAFqbpFO+IO1GbOzZLlllyAbyYTBULbz8BfzdrEKWNZHI
	 AAX93inf8T3p+Oply+11p09h7fNH3oVlU0MmPxZFI2HqjijszzQwJc/ZHvfPgDtXW7zm4
	 DCBNkXfqi/UfypQYI1kj+ddV4LHjWlT5eS4sN7ippNRT3MLV4hEzM5o1g0Puqj6UuCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bmp1A/257PTm3l7V5BhiSBXE8atWsfJpzvBxgAn/c4g=;
	b=a9hSGACxUC1H0AzVW2V9eG/lAjCTr20MxM8G9IpaTmSABtEoFMSEhqMbg3XoqpHTwmLj
	 NsYy0u8FNYSNyalUgWJUue79atHd/zxrjyFVnzL9u/zyd/qlQzQJAz7eQhJPYTBFDY1Ct
	 wMM01tBQeTt09DkTG85odiu2kGUumwu+N2uHghAxAGzDuqQ5b3B3OWpBAS8OoW1WcXSMq
	 pG1K16nGFWQI+RNL4YPXjy2Jlz2amGk29Lh0Pyc9oigYiYTHLfGA5nINIIL3DX69zVhK5
	 qsK5iv3yXXoi5YOgLGoQvTKUZsDCUkw143RSA2gONQC3cYMsK16LG6GxTTctzJkgUOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0R1E89s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FCB606A336;
	Thu, 26 Nov 2026 14:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0R1E89s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A521F000E1;
	Thu, 26 Nov 2026 14:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704172;
	bh=bmp1A/257PTm3l7V5BhiSBXE8atWsfJpzvBxgAn/c4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0R1E89stajXUAt2HeohGbTeCRtLMF8y/+tVj9l7XILf37yInLFdK/HosGyIhajN8
	 jMkSLxFu3nic5N73Ut6/TjThJz69pzXP8vTkel9R8wtNVACqGCJ6ky4eFKH2NbnKh7
	 HNk+ISw8Jto0MawBKRdk1kHpdQL3c+k2eUWQ/pkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/265] gpio: omap: Propagate runtime PM failures in probe and request
Date: Thu, 26 Nov 2026 15:36:00 +0100
Message-ID: <20261126143607.190831598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 19af2480acf72..049ce4c49c5cb 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -778,8 +778,11 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
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
@@ -1470,7 +1473,13 @@ static int omap_gpio_probe(struct platform_device *pdev)
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



