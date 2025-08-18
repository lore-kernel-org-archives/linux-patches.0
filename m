Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AB12E22AF;
	Mon, 18 Aug 2025 13:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523024; cv=none; b=s7EEh/h4gs51y4QcyETYAm+4LxKjcsRMBMazOdYTuoDYrJG3cCt61sv2yOGnqtmsDg3qbNd5bqn0pObJX84J0XEP4D3gJtvk75P0p7r64FbjT/lYrDU/zUc54E1rFKvCPee8pwofkl6pqITHNQToYf6VwEObghquCR0UTu4BxiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523024; c=relaxed/simple;
	bh=QmyjM4XHk85C83kETB8Q708NyI9XRGyXdCEs5Pm6qkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXQ3MrtN/fq3xFx0tGzQ6ZSM0dgKmIgGl7QF5xcNPXN+mhcjkcSmKcV5b6S1QosXYWvZv1M0Q3QPBigi/VR2icF0EPqbFIPKrwW19h4wKK/YpaddrPof1T6TPFK7SuxuIudvJ+y5PtGfTrMRK0Wb6lDbIs3kFqAAYZSJrDtxqrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvdD3qzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvdD3qzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A238C4CEEB;
	Mon, 18 Aug 2025 13:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523024;
	bh=QmyjM4XHk85C83kETB8Q708NyI9XRGyXdCEs5Pm6qkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvdD3qzlLKUh6FKOPknNlAwSHbLM9nYat0/mcKHKJz31pH2XfLYrdT2LgVGOhhW6C
	 GS3AnU545NPvjB++KHEMWLWg8z6p9aWGj+UYgG1VrZWeCefZ8WFZHQYpwlR5yoBgvJ
	 /nPREPjMgr4Rfei6jpI/Pl6eYE52UdFNsmzrHJM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.15 014/515] gpio: mlxbf2: use platform_get_irq_optional()
Date: Mon, 18 Aug 2025 14:40:00 +0200
Message-ID: <20250818124458.866544766@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


