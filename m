Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF27218B12;
	Tue, 26 Aug 2025 12:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212586; cv=none; b=Nf1KeBYZ6tIvcHmFjHfs04OWs2OuO5zDKvxgL5guACN75DVgsYyYZUiFzRdCijjvZ65V8PDuB4SRk/io5nOxp7L/xfnfIllAOTvCxu078QpGVpQUVdlrDkU2gi58kEa80MuYYSVjV0aR8Qi40BWFNxKWOSthTNgNG2sLErz6R6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212586; c=relaxed/simple;
	bh=7U9Vl8z1ZxRK33Prsx4EJAAHfQ/OJANOlo5MYIsosaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zsm/3tD0jI47qbo/Uug5AEkGCtOm2wyj0ClepjNGEAaIzL3IKmEe+ZqwShYQVfIyyiItrSlnqs1VfmkqPZjG6hKgtXiWWVNp4utBw/pYEkkAc1vJ1+54bU6LFRWIR4eWZJnBs3LHehc1YMxvVCnwwmcGecaaI/z/X01iAwuJA5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cn/GEmxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cn/GEmxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F29C4CEF1;
	Tue, 26 Aug 2025 12:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212585;
	bh=7U9Vl8z1ZxRK33Prsx4EJAAHfQ/OJANOlo5MYIsosaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cn/GEmxVkpI3ktnAmmkCmRbWu4NEyvLuuEPh/IbjonwZxXfGUITJEXisv81E3z625
	 B1W+bqADrHG9kbq1NwNs6dcPcLFtZsk/9GsFsqNZUiVHFcx977myE4RLNQivbmd93Z
	 84yCg6xa3/NJ5bE1weKgRGrSvPV2utD/eHxtlfPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 009/587] gpio: mlxbf2: use platform_get_irq_optional()
Date: Tue, 26 Aug 2025 13:02:38 +0200
Message-ID: <20250826110953.187328607@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Thompson <davthompson@nvidia.com>

commit 63c7bc53a35e785accdc2ceab8f72d94501931ab upstream.

The gpio-mlxbf2 driver interfaces with four GPIO controllers,
device instances 0-3. There are two IRQ resources shared between
the four controllers, and they are found in the ACPI table for
instances 0 and 3. The driver should not use platform_get_irq(),
otherwise this error is logged when probing instances 1 and 2:
  mlxbf2_gpio MLNXBF22:01: error -ENXIO: IRQ index 0 not found

Fixes: 2b725265cb08 ("gpio: mlxbf2: Introduce IRQ support")
Cc: stable@vger.kernel.org
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20250728144619.29894-1-davthompson@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mlxbf2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -397,7 +397,7 @@ mlxbf2_gpio_probe(struct platform_device
 	gc->ngpio = npins;
 	gc->owner = THIS_MODULE;
 
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
 	if (irq >= 0) {
 		girq = &gs->gc.irq;
 		gpio_irq_chip_set_chip(girq, &mlxbf2_gpio_irq_chip);


