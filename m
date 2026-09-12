Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746EF481A81;
	Sat, 12 Sep 2026 19:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240176; cv=none; b=ft3lHApx891sVgu+Ei9ZUqTFRmWqD+ca5vXcwmsaUdkqvmGpAXRbL2+sMTM7cqOM1yPgRj9AHzTxys27kKjB87QaKeRLKtbylqKK9DBWkwmhMreWrSAoyH6gdTb3aj9xBCAxFWX+8mQHWKccEkLPY3yxHZtvuFuG6qZtnrGpkq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240176; c=relaxed/simple;
	bh=cgOkzglWCFezACuX62fLbp5Stk1iZ8U41tDdnl62t3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBw5uxYyKJPNRyFdEJI5CbvImnvjbWrCKsSenmEbVSVuBp4R7Iflg6ELhOd3lHvpR7TdmJ6LF7lzqt5XBalkEyP4VDOY2fIqICPGjjvH1ue0TBAOP+avWdb2CEK+rgnfln72GYaNwL2BtQSgNaazRAJ/gWhVGDVz6B81JWAoy9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecVInqZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecVInqZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7E51F000FF;
	Sat, 12 Sep 2026 19:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240175;
	bh=b2GNI6tkdJcUOhZJ/HGCWpH6frWAL45K/scBPRepwMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecVInqZ381hwFNW1GDLW16WdrWDVAKEUqlZr/NpBT5l4mbub+isI/5Obb6Dwq4kaf
	 VKLyqnVDb2/oi4WVyMOTmErIDaq0FwgfDDo7rYA0tLBZIJQqS+cPUucUb9XCpXVdPp
	 zAdeqmgy0Rbeg6i4WPrNVRLq847YNha3prq/m7gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 771/935] spi: sprd-adi: Fix probe succeeding without registering the controller
Date: Sat, 12 Sep 2026 09:03:21 +0200
Message-ID: <20260912065544.513813078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 1edbf44c05a72..8eebe732157b5 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -564,6 +564,12 @@ static int sprd_adi_probe(struct platform_device *pdev)
 		}
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



