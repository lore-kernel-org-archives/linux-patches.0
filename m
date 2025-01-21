Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63091F427B;
	Tue, 21 Jan 2025 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482697; cv=none; b=k6xKhKAn7/av5RPe/G2t0AEvRvpiK2ZG3M5L5YE+TWo/BIgnhyfzhpDV/MOubAZAln/GW810Q1nXNMlChBvv1Itx+kSEtj+GVDtDrDLRcpM1wUAmHklawm9JOJWDHRVgRdjU1Rp5gw/lO5BpBgeO4mZ1BjD3a3o6ASSfvi2+Z6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482697; c=relaxed/simple;
	bh=FAnrHkdo3s6Tr6o9JCz7yRk4KTwpoMGa8vexHefjl7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4nSQ3enOFw8ZxBH6WaH7z2m1KrwGiDkHKFX/zOUdATMfk/qcjM1bItN2EkYR+Jek5MdIV6tQwRPbAj7E4TC91wo3DTfsmHbw4bq9R6Rn6JE/QJQ9lB5jSyukma67HEZELV+SHgQXjbZjDF69OpaZcNkUhb3PH4VuS96OI35BSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT9HQMkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT9HQMkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ED4C4CEDF;
	Tue, 21 Jan 2025 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482697;
	bh=FAnrHkdo3s6Tr6o9JCz7yRk4KTwpoMGa8vexHefjl7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fT9HQMkq1lR2FOcYzlbbcZC7qh0clGe9YTxSjQw/hkcxgAEMTq5qy+FAK/NXH5tYq
	 LuUvhNjjlp7dPuDqmIhzNckYdp9zBpZF7kbFcHz3IZ3VOHW+//kydx0fsaAkkpdgRt
	 m+zpcv2oeobwJYnX+5g/cP1FK91DhZz27zDf1rAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 43/64] irqchip: Plug a OF node reference leak in platform_irqchip_probe()
Date: Tue, 21 Jan 2025 18:52:42 +0100
Message-ID: <20250121174523.197158964@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 9322d1915f9d976ee48c09d800fbd5169bc2ddcc upstream.

platform_irqchip_probe() leaks a OF node when irq_init_cb() fails. Fix it
by declaring par_np with the __free(device_node) cleanup construct.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: f8410e626569 ("irqchip: Add IRQCHIP_PLATFORM_DRIVER_BEGIN/END and IRQCHIP_MATCH helper macros")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241215033945.3414223-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irqchip.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -35,11 +35,10 @@ void __init irqchip_init(void)
 int platform_irqchip_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *par_np = of_irq_find_parent(np);
+	struct device_node *par_np __free(device_node) = of_irq_find_parent(np);
 	of_irq_init_cb_t irq_init_cb = of_device_get_match_data(&pdev->dev);
 
 	if (!irq_init_cb) {
-		of_node_put(par_np);
 		return -EINVAL;
 	}
 
@@ -55,7 +54,6 @@ int platform_irqchip_probe(struct platfo
 	 * interrupt controller can check for specific domains as necessary.
 	 */
 	if (par_np && !irq_find_matching_host(par_np, DOMAIN_BUS_ANY)) {
-		of_node_put(par_np);
 		return -EPROBE_DEFER;
 	}
 


