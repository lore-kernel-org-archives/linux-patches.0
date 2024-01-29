Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DFF76C75;
	Mon, 29 Jan 2024 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548653; cv=none; b=FThb7X0sKbh65kOrBptJfmh/2hSr9S82SdOz5lyopmjBRvVyfHsEsg5tktk87Gj3nqnaJB5n2vRvKawtlYRzvIlZpiFr8SvOT3QZ4k4TJmCxIvOHXt3LVEjdE27gsljM63JxDTzZAfqjhtctA81j3sXH76zaPPJJ8jXZ6mm7jZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548653; c=relaxed/simple;
	bh=W+FXRcRoUKGPwT2qy9FeHCb/y5rhYdjjiCIJ6lCsO0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYVcb5I+gV4iiAZQBHYRe5MN80cIh9GP0WkIp4MF4/Yozn0URRH6ZXja/rB/Zf8jcK9nbLaFQGMR8QI5zG4TSwZ0RRO56RZwmwTo85im7Lfr5zPwr+J7jwp0ZnUArXUpFHf+A8kUU6OHgRLWpVzbT9fjvA6kUjb9A62U5tGTH04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/z2USzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/z2USzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204EFC43390;
	Mon, 29 Jan 2024 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548653;
	bh=W+FXRcRoUKGPwT2qy9FeHCb/y5rhYdjjiCIJ6lCsO0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/z2USzS5e6Ve1E1VgZpTlcv+IFKYZIXcN55bEWH003B70tA0oNNhb54SnwUKSZGn
	 i8jPiGYnLue1rE2IP8bh2N3CQziYLz8VTE5KqwapopMYppf5zSGc6iTD9lRebUWg2x
	 B8pq0qixb6aoc0VajxMOCr1orFNMp5P9G3eqM2zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <dawei.li@shingroup.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 326/331] genirq: Initialize resend_node hlist for all interrupt descriptors
Date: Mon, 29 Jan 2024 09:06:30 -0800
Message-ID: <20240129170024.421646430@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Li <dawei.li@shingroup.cn>

commit b184c8c2889ceef0a137c7d0567ef9fe3d92276e upstream.

For a CONFIG_SPARSE_IRQ=n kernel, early_irq_init() is supposed to
initialize all interrupt descriptors.

It does except for irq_desc::resend_node, which ia only initialized for the
first descriptor.

Use the indexed decriptor and not the base pointer to address that.

Fixes: bc06a9e08742 ("genirq: Use hlist for managing resend handlers")
Signed-off-by: Dawei Li <dawei.li@shingroup.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240122085716.2999875-5-dawei.li@shingroup.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdesc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -600,7 +600,7 @@ int __init early_irq_init(void)
 		mutex_init(&desc[i].request_mutex);
 		init_waitqueue_head(&desc[i].wait_for_threads);
 		desc_set_defaults(i, &desc[i], node, NULL, NULL);
-		irq_resend_init(desc);
+		irq_resend_init(&desc[i]);
 	}
 	return arch_early_irq_init();
 }


