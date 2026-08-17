Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56073D301E;
	Mon, 17 Aug 2026 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977554; cv=none; b=E5A0W2j2eyOy1cWHkXDsFR9Uu7liHDIOTB8J7dPS3auwoVAeQNuEYu67C4LIfhpF/axTMp6HaQZ320oZjPnFf1XB61WEgb1NUDUp+lh0wDO9ARiQ5i1/oFLmZ7Mim/4VH6hiqEfinSGgB8fP3NvCeD/9bgVsMDEG0tNBeSCWfbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977554; c=relaxed/simple;
	bh=rXmugMMKnC1W+SGVlZutXG0fLI9M0StZLtWwD9ivdYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkluEjvJW4zyYdu+MCnEP4iTBha1r/k3Xq5Bsh9nNrXaABMvd5jsPsVZ9nSv1q/Ma8m9MwFs0ZnpBVEq4gm7t1fWcU+MxDbvKXZRsxoPaIDuGGaUGiJtsnwAgBA2Fx3llCuDqGtbbC9LyCydUM8bvW8Y5ga2F9xcaYeVpBmtgG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wu204w2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wu204w2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5471F000E9;
	Mon, 17 Aug 2026 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977553;
	bh=8KE52ZcfMck41e5YZingDFTbBAkiGakeXsflng3GYaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wu204w2y9Ey1xTfAAJAnMMwJwkfQDGosB8Gmdyi9CF0Xg7N4umStoktEOf3m6HCCj
	 hKHFIh3JnSEjgmC+aPyO/omhq+lMRbH7YnmHJXhzHOsBd+8Lar8A4hv2vmvTDI0D7E
	 Ey+a9baRRfzm4wxRDXWg9lYO9Uly7RH3zCAbVAp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 370/456] ARM: npcm: Fix OF node refcount leaks in SMP setup
Date: Mon, 17 Aug 2026 15:32:40 +0200
Message-ID: <20260817132553.953457193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8eb052f48331474c2789d07b7f11165c323bd2f9 ]

npcm7xx_smp_boot_secondary() and npcm7xx_smp_prepare_cpus() look up
the GCR and SCU nodes with of_find_compatible_node(). The returned
nodes are used for of_iomap(), but the node references are never
released.

of_iomap() does not consume the device node reference, and iounmap()
only releases the MMIO mapping. Drop each node reference after the
corresponding mapping attempt.

Fixes: 7bffa14c9aed ("arm: npcm: add basic support for Nuvoton BMCs")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Avi Fishman <avifishman70@gmail.com>
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-npcm/platsmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-npcm/platsmp.c b/arch/arm/mach-npcm/platsmp.c
index 21633c70fe7fe..fe63edc9886df 100644
--- a/arch/arm/mach-npcm/platsmp.c
+++ b/arch/arm/mach-npcm/platsmp.c
@@ -35,6 +35,7 @@ static int npcm7xx_smp_boot_secondary(unsigned int cpu,
 		goto out;
 	}
 	gcr_base = of_iomap(gcr_np, 0);
+	of_node_put(gcr_np);
 	if (!gcr_base) {
 		pr_err("could not iomap gcr");
 		ret = -ENOMEM;
@@ -63,6 +64,7 @@ static void __init npcm7xx_smp_prepare_cpus(unsigned int max_cpus)
 		return;
 	}
 	scu_base = of_iomap(scu_np, 0);
+	of_node_put(scu_np);
 	if (!scu_base) {
 		pr_err("could not iomap scu");
 		return;
-- 
2.53.0



