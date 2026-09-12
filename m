Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6F5388862;
	Sat, 12 Sep 2026 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225211; cv=none; b=TLkz0VaxvN5zGabnTlj9PR6XyWQkH6PTry6c02Z7uH/gJDsGnmz9vFauXnrjgsEbp57ZKeo5p0NXr1n+ZsJPglC6GtfIkmvAPyzFxZLJ1ggfrjOOdpRGZhHTAK55JL/+vknS0XZHB/cLksIBo+aRyTYsW2NPoELsLPsGBqEgb8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225211; c=relaxed/simple;
	bh=DpYWefGymXRcRpoIpuN+XlpbINwNsf6XPxZ9g/KRkQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lG5f3SawCaUQdZbSymWBFOwwIZMwNNZ0pFVGVXOJf8s+/EKRmORzeNqSCs7MBP7jF/PmUw3Oif14Fbn5KxQsLILiFpNFFtPpKxTyIemAdMH2Ht3R9YVkybd0PtyAWtFfGYlUDPjxt7mVcu5Ow0VHKzq6sJavjg8q/Ab5GDqWQro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoRkJuDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoRkJuDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2918B1F0089A;
	Sat, 12 Sep 2026 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225210;
	bh=C9rKHFNfP69ld/zWeJ9luJEP4yjwsjlnA/DSDyVcxPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WoRkJuDytgMAATLMeeQW9b1ZoAPD9RWcfAXqJatWd9OK6ugqs8n9qVj+o9OVx+5tg
	 rlFWQvjDX4bGJDNq+B7fjP+uOHme8P/8taqae2n2Y3V9dkH+T2G2R9MRGxHZtte+OO
	 Eg9v1x3sC6Xafgsin4jOWalnkc9rgcZ+VAuoJ1h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1152/1424] spi: sprd-adi: Fix probe succeeding without registering the controller
Date: Sat, 12 Sep 2026 08:59:44 +0200
Message-ID: <20260912065633.096031161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index f25b34a91756f..72f2f30e657ed 100644
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



