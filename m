Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0E5455162;
	Sat, 12 Sep 2026 11:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211006; cv=none; b=QFYw+SHWuSb2K1wpGQG4nvG/pKK0aygwTF04N/tmuAaXXOzdrW3dvZ/D2ajs3uWze+DN9s2PQaPwBKwsgnm0P/+bdgmr5+5seYrcjRyUIl2Vvq7UL68hhKLghej+PN2qblOive+Z5IHrg0PgrXwpf0cTHcIof9+LYNWDjs+JEPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211006; c=relaxed/simple;
	bh=qCXQM3C+SkqOSwJPHCmJ+hKI/aCUdufewe1ZPEATfD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXl+qK+o/IHV1DK7tUr1J3dx+iEgm8FXarLMMms7H9aZ/MYf+Ke38m/5jXISFYieX2MYsDJo2jvZyZy5KHjWoj3e6PO8zAdNDTTRui1WRo49J+KegGNNYj8s48h9dvLCm2GxKbwNE3vQqmIH49HdRwGOAPPJ+MvhajzCqPxJegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRKIPCku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRKIPCku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390E01F000FF;
	Sat, 12 Sep 2026 11:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211004;
	bh=SlDNtKNVUF5E+vSzZ+y0yfg+GkaRybMkuBf8tT/g5wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRKIPCkuAczN4i1G5n7n1Wn1WugjKO4x/R4btpEoNjFvZ8C1VJ5B2h8sx+ASDQLjp
	 UD8W+YWAp8brviW73yXTpjmYiEN6lj9c8j5VIPH+pTpVq11WGTG/BaB9f/4t7GDfUj
	 Y3ItTkyhW+8D2OlQw8seYZTkUP4LXDvGe49cvndc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1105/1518] spi: sprd-adi: Fix probe succeeding without registering the controller
Date: Sat, 12 Sep 2026 08:54:34 +0200
Message-ID: <20260912065648.448079319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



