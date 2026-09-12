Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E881337699;
	Sat, 12 Sep 2026 08:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203084; cv=none; b=G4EdA1bL11AEbZegB2mN4u8wfnVY7wWBgUt2y8CQZ1rlxAnZEpGcxNYNRc4g9BGZXgD3pPJ3XKyTvZO1l3+5MLoyHKijzjn9q3ut+rXxQi4prif6DJH9AOWU6oEIxVlsbo3RETjMioaIAMVRyr+V+6d1LnaPYG9FmLSAQ1ikDr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203084; c=relaxed/simple;
	bh=X/9g9ie73ZezyOiq2N1FWExv8a70iM1jX92NSMFDy4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUvjEwyLank7ydLQft0XbEuGAjxJadAyvHagOS/AmEzmVexNLct5Uuo1ica4z2FhCASQHH3Kk0N74wlYb7C64XnGseazFYT+UPFpIVzV5vS7FX+zku1IWcs92tA4ZxLLfsWwiTBt73THUFrXzFYgduQ+QpQfcS10XPxronE0XHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+sIPfh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+sIPfh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D0A1F000FF;
	Sat, 12 Sep 2026 08:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203083;
	bh=iQqosGRkuRRMQgEO/tTlPfwfoA+SenB9FiDaA6OeUa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+sIPfh7UP1e2l+RIbfvnL0934VRcFf1tkAgo1O5vMkY0TO0OFD2AKTmHnCpgZVKR
	 M38fE8m87ys0i6x2E1HdAMN3+VzzctDo85iuxHhR7KKm9mrUg08KaTrNVQKCexwKEM
	 MxePu6yDjrVjAKgOmGXIFfxT7/yjj30hR/0xagro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1337/1815] spi: sprd-adi: Fix probe succeeding without registering the controller
Date: Sat, 12 Sep 2026 08:51:27 +0200
Message-ID: <20260912065720.408436703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babanpreet Singh <bbnpreetsingh@gmail.com>

[ Upstream commit f092e1c935015ee0a0fea1a0374f4cab7b71953c ]

With CONFIG_HWSPINLOCK=n the of_hwspin_lock_get_id() stub returns 0
unconditionally. In sprd_adi_probe() the guard

	if (ret > 0 || (IS_ENABLED(CONFIG_HWSPINLOCK) && ret == 0))

is false for that 0, so it takes the else branch, where the switch has no
case for 0 and lands in

	default:
		return dev_err_probe(&pdev->dev, ret, "failed to find hwlock id\n");

dev_err_probe() returns its err argument unchanged, so probe logs
"failed to find hwlock id" and then returns 0, reporting success.
sprd_adi_hw_init(), the restart handler and devm_spi_register_controller()
are all skipped: the device binds but no SPI controller is ever
registered.

The hardware spinlock is optional for this controller and the -ENOENT arm
already covers "no hardware spinlock supplied". Treat the stub's 0 the
same way and continue without a lock; all four users of sadi->hwlock
already test it for NULL.

This is not reachable on production kernels. Kconfig has

	depends on HWSPINLOCK || (COMPILE_TEST && !HWSPINLOCK)

so the affected configuration exists only under COMPILE_TEST, where no
real hardware is present.

Found by smatch:
drivers/spi/spi-sprd-adi.c:560 sprd_adi_probe() warn: passing zero to 'dev_err_probe'

Fixes: f9adf61e983f ("spi: sprd: adi: Change hwlock to be optional")
Assisted-by: Claude:claude-opus-5
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Babanpreet Singh <bbnpreetsingh@gmail.com>
Link: https://patch.msgid.link/20260729053543.7-1-bbnpreetsingh@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index e7d83c16b46c0..a6baaf02b3c86 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -553,6 +553,12 @@ static int sprd_adi_probe(struct platform_device *pdev)
 			return -ENXIO;
 	} else {
 		switch (ret) {
+		case 0:
+			/*
+			 * Only reachable with CONFIG_HWSPINLOCK=n, where the
+			 * of_hwspin_lock_get_id() stub returns 0.
+			 */
+			fallthrough;
 		case -ENOENT:
 			dev_info(&pdev->dev, "no hardware spinlock supplied\n");
 			break;
-- 
2.53.0



