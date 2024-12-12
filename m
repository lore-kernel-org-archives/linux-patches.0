Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B9421576E;
	Thu, 12 Dec 2024 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023108; cv=none; b=sZRotFStBDmcnSYrz8FrT5I2WIwVmlJVxzN6cwLzIhogRphAd873EpXGIuKy5w75NpyeSSl1L86D2n9LDAuTje7TNt8NdOylUs99JY6mOwT1Wa8BaNZF6Qm8NrplSGBWt0AgHwHMf0HZrH/VrFvqV7ZTL3cioD+4aT/qhq6sSG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023108; c=relaxed/simple;
	bh=iLTBcgJAsY+naBNGTNNcuFAaFRMi0DpL++fzbXEvI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRlRGZSzHE7M91FMzH7jNaP/WSSCZXlff3eTzrN25lieciGugYDUbOlQOJc5E1NICLWxBLL1TCE7lA17EzTcr0vB8cSIDtXmVK0kUiOBEe5z1c4SSHKmiLwlts0HZOssFQPewF2aPKOIMYcYDhAUXGPn+9pNvml7jb3LICynMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U02RF7Pa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U02RF7Pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E57C4CECE;
	Thu, 12 Dec 2024 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023108;
	bh=iLTBcgJAsY+naBNGTNNcuFAaFRMi0DpL++fzbXEvI+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U02RF7Pad9+Y4omTD6BTRIUYwo3zkV+sYycrYxrOj5nEJX3pf1S7qXR04ERTcsQoS
	 NczrzoRV4FsuZhNAzislyjZbzbtuNcInnW8dCbdNxjxR8PVdvYMMnMDB7MMWuac5AJ
	 NeCjxfUE02mUPW2hNdXCwYr5UC8DN567m6KXnRGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/565] gpio: grgpio: Add NULL check in grgpio_probe
Date: Thu, 12 Dec 2024 16:00:22 +0100
Message-ID: <20241212144328.558647667@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 050b23d081da0f29474de043e9538c1f7a351b3b ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in grgpio_probe is not checked.
Add NULL check in grgpio_probe, to handle kernel NULL
pointer dereference error.

Cc: stable@vger.kernel.org
Fixes: 7eb6ce2f2723 ("gpio: Convert to using %pOF instead of full_name")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241114091822.78199-1-hanchunchao@inspur.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-grgpio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index bf5ecf23cbceb..0d2441b7c6d02 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -363,6 +363,9 @@ static int grgpio_probe(struct platform_device *ofdev)
 	gc->owner = THIS_MODULE;
 	gc->to_irq = grgpio_to_irq;
 	gc->label = devm_kasprintf(dev, GFP_KERNEL, "%pOF", np);
+	if (!gc->label)
+		return -ENOMEM;
+
 	gc->base = -1;
 
 	err = of_property_read_u32(np, "nbits", &prop);
-- 
2.43.0



