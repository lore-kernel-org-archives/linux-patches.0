Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062390;
	b=1DMk+2ucuDmvnWeHF00r4z/+0ix1pGIdVHRVI/2T8KE2fNEWBaWr+x8VW4wiVxGaND/t
	 dSIcZuycc+gpBeII2GisPTDFamtRvX9/W9Ks/Cj9XXy6WXQQhOp3qi9ROwkBx0NmdQwkE
	 EA4KbWep22a2jf8FFEihcR9eoGOQ2Qg+9rXjZLlSDepU3vw4Ua2wE3+4dqhPFZWXnASnT
	 kjyIRE9lLbqS6eDM99trfOYHHTbQ3VZL/E6PQcYKVU14P0OQWDaFSQrbCshg+pi3yWlcx
	 WIVYO5e873vb9yIwJ1aLX6zvn+9WSEo6ngsdavNK7a9xgY1vIdDhGzknuvM7lyWJS/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jH5WFFThbTQdEVvIf2Z277qN2No3znT1ix9iLmK1UUI=;
	b=JFQdDS75eb+ZJE3Oub8eaf9lmqY/wwyU+3pPdmlRLX5l5aTT4WMi8sXfs0vHxCaPq0EL
	 CcXr6kPdWjss6u0ywtg8x7n4UkePAK/qO51+tkXGyXHmYZf8sJNm3UQqlLFYsuL7yWYtu
	 Y2lRbmh+pwjna0ZJ1p/wwA8W7Zj33jTS+jy5VtC67CzLhYfZUA3wabA2QPN6Tbni0UXyI
	 1KBxdlyyAkD3YZgpsOT9ScT28WGNXnw+Ocbi9+VXlCFXMilLrIIW5XHGhrtPeHYofMPT3
	 UU5Ty2q8QXYwPpZsIfw7MqD8IBiV3EtwByHM+zZc+dO7Syo2tOFsGufDSgrY877Hcxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yAus1RMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF0E608361E;
	Sat,  7 Nov 2026 14:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yAus1RMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2D71F0089F;
	Sat,  7 Nov 2026 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062390;
	bh=jH5WFFThbTQdEVvIf2Z277qN2No3znT1ix9iLmK1UUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAus1RMhIqjkUUmkRkOi/qHnXOXudh01811eq1JkT/XUQlsVK/y56i5YidvlqPXRc
	 V/tAUceVy2h1s1fUMjY5p/umi8ngjY9MrnemQYxwVLIhoarYCbHTSyptYt7i9CzbLY
	 kUHduEPZohJYytdMMSldtX+RJtVE8xquHbkyieQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1309/1536] irqchip/mchp-eic: Fix clock reference leak in mchp_eic_probe()
Date: Sat,  7 Nov 2026 08:55:25 -0500
Message-ID: <20261107135034.561855127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit af9c707eb065a7d48eb92dc15acdb4346acf5db0 ]

of_clk_get_by_name() returns the clock with an elevated reference count
that mchp_eic_probe() keeps for the lifetime of the driver, but none of
the probe error paths drops it, so the reference is leaked whenever
probe fails after the clock has been obtained.

Put the reference in the error cleanup.  The clk_prepare_enable()
failure path must jump there directly as it cannot call
clk_disable_unprepare() on a clock that was never enabled.

Fixes: 00fa3461c86d ("irqchip/mchp-eic: Add support for the Microchip EIC")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916190349.2094401-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mchp-eic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mchp-eic.c b/drivers/irqchip/irq-mchp-eic.c
index 2ad3c1d02d523..7f7ae5b14a62b 100644
--- a/drivers/irqchip/irq-mchp-eic.c
+++ b/drivers/irqchip/irq-mchp-eic.c
@@ -232,7 +232,7 @@ static int mchp_eic_init(struct device_node *node, struct device_node *parent)
 
 	ret = clk_prepare_enable(eic->clk);
 	if (ret)
-		goto unmap;
+		goto clk_put;
 
 	for (i = 0; i < MCHP_EIC_NIRQ; i++) {
 		struct of_phandle_args irq;
@@ -268,6 +268,8 @@ static int mchp_eic_init(struct device_node *node, struct device_node *parent)
 
 clk_unprepare:
 	clk_disable_unprepare(eic->clk);
+clk_put:
+	clk_put(eic->clk);
 unmap:
 	iounmap(eic->base);
 free:
-- 
2.53.0



