Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11CF5372FC;
	Wed, 23 Sep 2026 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174885; cv=none; b=urd5pzblnP8nBpkCHutITVVZzYRBKf/0WU1tXB8/kYGG4AgpojIpUXh7ji9AOz8G9az4Ra4kV9UO15ud11fUN4yFANaN+JLHD46CBO3hZv0TZHs2yVHbPHGMWT06JVmGhVPugwy6LXZNhPi0u+jOuYehPQvjS9itnDoI+zyY5sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174885; c=relaxed/simple;
	bh=9+1cw/S1DvnPW/1xXkcHvptt+slvIo/ivrBqzb6qN9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2HfyjC3BqMigu3iLI8LzX1rGsj4MljRsGCOf8pcIuZx9k/2qI8s+kso47D5G80XzlcuaU5l4XKarGFG2Sy3CWPQhSlsGVEFoHFI7tnF7ZEwWoR9gTygvbVnL7xzKQsYW6lq4XP8nMtEKqCDbSkQBt6Yt3EDEGJMTPZ0fEKlEtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOkc/GPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOkc/GPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094051F000FF;
	Wed, 23 Sep 2026 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174884;
	bh=wAReV6725kUKBLI7DExAt8jI2t4lw3V7qejE8SDMxgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOkc/GPfmuTKvJE+W2Sp4X0Vz8ijvkFO95ta9Z2YohjmGS72k+cSLGIq3sEwOa1qj
	 5moeyeoJBAa35q4z2DpoEbICm1ffV8XUJnKGGwslTjsPZuNKHLnZvHEdYakA+JrQBK
	 cZoxde4Bj5JeMeZMQRtm53hSttNnbGlwgcgLt6n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.18 256/398] soc: samsung: exynos-pmu: fix use-after-free of interrupt generator node
Date: Wed, 23 Sep 2026 16:05:30 +0200
Message-ID: <20260923140650.051252098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Alexey Klimov <alexey.klimov@linaro.org>

commit 4dd1999783d7d12434006289338373e49492dc96 upstream.

The setup_cpuhp_and_cpuidle() parses the device tree node for the
interrupt generation block via of_parse_phandle() and decrements its
reference count using of_node_put() immediately after fetching the resource
address. However, later the intr_gen_node pointer is passed into
of_syscon_register_regmap().

Fix this by declaring intr_gen_node with __free() and removing
of_node_put().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260513-exynos850-cpuhotplug-v4-0-54fec5f65362@linaro.org?part=3
Fixes: 78b72897a5c8 ("soc: samsung: exynos-pmu: Enable CPU Idle for gs101")
Cc: stable@vger.kernel.org
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20260828-exynos-pmu-cpuhp-idle-fixes-v2-1-06bce6107bd6@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20260917081641.72291-2-krzk@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/samsung/exynos-pmu.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -540,13 +540,12 @@ static struct notifier_block exynos_cpup
 
 static int setup_cpuhp_and_cpuidle(struct device *dev)
 {
-	struct device_node *intr_gen_node;
+	struct device_node *intr_gen_node __free(device_node) =
+		of_parse_phandle(dev->of_node, "google,pmu-intr-gen-syscon", 0);
 	struct resource intrgen_res;
 	void __iomem *virt_addr;
 	int ret, cpu;
 
-	intr_gen_node = of_parse_phandle(dev->of_node,
-					 "google,pmu-intr-gen-syscon", 0);
 	if (!intr_gen_node) {
 		/*
 		 * To maintain support for older DTs that didn't specify syscon
@@ -562,8 +561,6 @@ static int setup_cpuhp_and_cpuidle(struc
 	 * syscon provided regmap.
 	 */
 	ret = of_address_to_resource(intr_gen_node, 0, &intrgen_res);
-	of_node_put(intr_gen_node);
-
 	virt_addr = devm_ioremap(dev, intrgen_res.start,
 				 resource_size(&intrgen_res));
 	if (!virt_addr)


