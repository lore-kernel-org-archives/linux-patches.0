Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064952;
	b=gX/h0xYWuC8jjIMtOKPQconMNutf+JZ6VH978xCCGJzKvUp4bC6b8JW47yEaUmCldqpM
	 Jun926l+hHIybG6VhMjyOJdQZgk8SMc871LLKhpqNaw6USg+9HZqQCnpvuv9gvHIqcrcR
	 eRv+g3BNum7WWHUa24vQ9gxMU8QozctLxyJ/Bu5PuGnG++OnTuQbYRxhmhTk1cYMS8U9g
	 FfnSiab5rbl3rTz5PyKsy3jQwftGCDZsUZCOGmN/EV6Rj5V4kxoCa5f+t0q05d206OfLy
	 kPkJnVmFtZJ2NxSL8s9K+Ds84/1x6nGRFcZ2RSYuRtEP7/Kz5T+WLJ3g7yQ0uTQo90Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EdkHJjk3RPPwxpAs7BOL56KjFo9A8JDB/5Tv9AM0lWU=;
	b=J2GWYE66V1DC7UZ9CD09qr7PgQrajZAxeG9intVC5jxGftmKY8yTO90kzzHqAX0hs4i2
	 y2OGk1ZW1yNogPFgWGAMu9kb+7SuhFr3o2XsKPUxK67umPkNWiIiDka6Ne+p06wtu0NEF
	 trKp64UByT/+mdsnoc/b6KXweDuaDwjU3Hxei1BXxmoO2VR84hnEI26shed4ilLZGcPhs
	 mADE+GoG5JdjlW91MxPeS8NLSPenZTS8DVpI6m6XF6C3ccblSMlLsnoPKLb2Lz9apWSHt
	 yO01e8mY1Ag66t89X8o+qYujmD4bbJf/hpeiMZEtsEeEhXDCwGsTmH9bXSLQbX/JxCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDnDHV3G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E07606A335;
	Sat,  7 Nov 2026 15:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDnDHV3G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572481F0089F;
	Sat,  7 Nov 2026 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064951;
	bh=EdkHJjk3RPPwxpAs7BOL56KjFo9A8JDB/5Tv9AM0lWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDnDHV3GJjMByFNvIT+t+D1FaLk3YYSzsdnYbfX9xzMaQVMg8xw4Tn+7nJqhi8XSZ
	 SfukJzzFeBVjEb+FNHHcdGob4vzMmvhqf5gLAOLvht/OpLA9xxfDQbpwJdynwlUtF9
	 NeMY6EyVJTAOs0/sbmE4/nEO7vc3hZXOeAoA9UXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0789/1257] irqchip/mchp-eic: Fix clock reference leak in mchp_eic_probe()
Date: Sat,  7 Nov 2026 08:51:25 -0500
Message-ID: <20261107135001.119123117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index be007d325e672..5250e6baff63c 100644
--- a/drivers/irqchip/irq-mchp-eic.c
+++ b/drivers/irqchip/irq-mchp-eic.c
@@ -233,7 +233,7 @@ static int mchp_eic_probe(struct platform_device *pdev, struct device_node *pare
 
 	ret = clk_prepare_enable(eic->clk);
 	if (ret)
-		goto unmap;
+		goto clk_put;
 
 	for (i = 0; i < MCHP_EIC_NIRQ; i++) {
 		struct of_phandle_args irq;
@@ -270,6 +270,8 @@ static int mchp_eic_probe(struct platform_device *pdev, struct device_node *pare
 
 clk_unprepare:
 	clk_disable_unprepare(eic->clk);
+clk_put:
+	clk_put(eic->clk);
 unmap:
 	iounmap(eic->base);
 free:
-- 
2.53.0



