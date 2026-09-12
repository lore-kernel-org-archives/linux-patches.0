Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C33A345EA7;
	Sat, 12 Sep 2026 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241118; cv=none; b=DajyD9n1IlxYqJf9/84YxCyKQAPPoBwILBknLo2VQu2BXuedh9tTfIfrbf+mvFeBCXLJaTtE50Fct4RSmvYXLoLoykNI1IufgDbQKKaQPPo1ZjLD3U8fctgEbHZtycCJ3PVUxfs8ZNHYdG6LEryZoAEq3fprndDm9O0wjvnqaNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241118; c=relaxed/simple;
	bh=IWnPqD4YieXkcwhd/VahbJJkQUJT/o//1UQl9zgZV04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUVBsCX1yj8ApTtJ+E2WWFyEd29AwhSuLU/gqggPQ7PBxVyM6ZKCOa8eTLNm+JVqIXBdS3jP9VXjIDWw04Iev1nmn5eF6+mALkEjn+/5ddZQ+roZmL7vFVTZgb1puNh9zMl1bRRmiCaLVYrBy7HReG/Plm2jCo04QaQfINoEQEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8TPz6R3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8TPz6R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6831F000FF;
	Sat, 12 Sep 2026 19:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241116;
	bh=lXFyRgoEGO1+QLOmBeYlxW6vCPokcT31fEX8P8qMzGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8TPz6R3d9m2htjq/QnpUXc6mxph7q7GzsF9rYb1iuw5f/5oGLfQ2idi0vkX36KyK
	 6+5BQvBzN7VZBYt9YQfT+mm8EiUa6II96PSyF1nIkx033WzQ3TRdQyC9t1sVuuxUsV
	 dKL/wO5BItvX3wE8GJN2RiucqCPH2cCl35K5X7wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Merlijn Wajer <merlijn@wizzup.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 071/798] hsi: omap_ssi_core: fix missing DMA mask setup for SSI controller device
Date: Sat, 12 Sep 2026 08:54:59 +0200
Message-ID: <20260912065518.591421093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>

commit e81250ec6b69248b00d38c523dc6a13efaf38aab upstream.

The OMAP SSI driver uses a synthetic HSI controller device allocated via
hsi_alloc_controller(), which does not go through the normal OF/platform
device initialization path.

As a result, the embedded struct device does not have a DMA mask
initialized by default.

After recent DMA API hardening changes, dma_map_sg() and related helpers
now require a valid dma_mask to be present, otherwise the driver may
crash or trigger warnings when attempting DMA mapping operations.

Fix this by explicitly initializing the DMA mask for the SSI controller
device and setting a 32-bit DMA mask, which matches the hardware
capabilities.

Cc: stable@vger.kernel.org
Fixes: f959dcd6ddfd ("dma-direct: Fix potential NULL pointer dereference")
Reported-by: Merlijn Wajer <merlijn@wizzup.org>
Closes: https://lore.kernel.org/linux-omap/4ed95c71-2066-6b4c-ad1b-53ef02d79d53@wizzup.org/
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Link: https://patch.msgid.link/20260724130522.706480-1-ivo.g.dimitrov.75@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hsi/controllers/omap_ssi_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -509,6 +509,12 @@ static int ssi_probe(struct platform_dev
 
 	pm_runtime_enable(&pd->dev);
 
+	ssi->device.dma_mask = &ssi->device.coherent_dma_mask;
+
+	err = dma_set_mask_and_coherent(&ssi->device, DMA_BIT_MASK(32));
+	if (err)
+		goto out2;
+
 	err = ssi_hw_init(ssi);
 	if (err < 0)
 		goto out2;


