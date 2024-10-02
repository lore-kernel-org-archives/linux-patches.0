Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15581D048C;
	Wed,  2 Oct 2024 13:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875693; cv=none; b=r5aXmeBpWerwUkhHwlkUZtYHeSVqwmfWGF2iJtiBgUi/Gh6GosDkPhOwlH+m2qADc2AvnzC3q7cQWzB02/SSRfmmZUru+wV1DMV0ftRROo91r/MBVqNLKmt/VlrJ9mEfhzGq2RmgaAHY8V7FWWI8vSSZgWGnqkthsQsBcMq24+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875693; c=relaxed/simple;
	bh=fCG1SFxMAnznGJEmb1p53n2kcvHQT+ZNnoMBQFPDZmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0CQjHBVLEMwSAt0XQM9j0NuurTUb0OlIygOGw4GdfwbcF0ZnTZOHzi1EpZa95IbwuTgc44y8HoAhpvfObs4nbLUWGHYp68hLKk8/5P60KFUi639u0jNCJ9AjSEYQVFZCp2eoN3yZBddsYBfTe9sy3mYUoIIwL9QS2nPPMIZKVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb8FnWZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb8FnWZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE06C4CEC5;
	Wed,  2 Oct 2024 13:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875692;
	bh=fCG1SFxMAnznGJEmb1p53n2kcvHQT+ZNnoMBQFPDZmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sb8FnWZ6bYKWAoJ4DGM5J/JjnvldxP/G/gj3jc7o8FAQnVxMu6vjAzxEnqrukZvMO
	 4M+kulQk0Ywr3F8xZo6wBt+ecxMGfk3r0eWsxxbxn96i62pSknVGVgLmMm4e8HLo2q
	 eCJQ7ya4rNzrYAlSCpo5JQekao1D2e02/lwhWMAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 157/695] platform: cznic: turris-omnia-mcu: Fix error check in omnia_mcu_register_trng()
Date: Wed,  2 Oct 2024 14:52:35 +0200
Message-ID: <20241002125828.745558307@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 2d516b8fc0f18ce9c0347a1aea6edb3d8ca1d692 ]

The gpiod_to_irq() function never returns zero.  It returns negative
error codes or a positive IRQ number.  Update the checking to check
for negatives.

Fixes: 41bb142a4028 ("platform: cznic: turris-omnia-mcu: Add support for MCU provided TRNG")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/cznic/turris-omnia-mcu-trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/cznic/turris-omnia-mcu-trng.c b/drivers/platform/cznic/turris-omnia-mcu-trng.c
index ad953fb3c37af..9a1d9292dc9ad 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-trng.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-trng.c
@@ -70,8 +70,8 @@ int omnia_mcu_register_trng(struct omnia_mcu *mcu)
 
 	irq_idx = omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
 	irq = gpiod_to_irq(gpio_device_get_desc(mcu->gc.gpiodev, irq_idx));
-	if (!irq)
-		return dev_err_probe(dev, -ENXIO, "Cannot get TRNG IRQ\n");
+	if (irq < 0)
+		return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n");
 
 	/*
 	 * If someone else cleared the TRNG interrupt but did not read the
-- 
2.43.0



