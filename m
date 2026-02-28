Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73914383C86
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302158; cv=none; b=ecmw8dS94ZLALwho8eunqeYsGSOJlYcsM/uVOEKgNuOjjhkA7XU70oeP99DZ7fQe33YaZvDX2xo1K92NHMq546kE05yd4EBXe2/FhpFB4ao0/AnG/LSlRyuwmc+uNdNZfHdUzMPZKlzyy3VsnbsflA5+GsG0uQdZ0qPe1Lh+86E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302158; c=relaxed/simple;
	bh=EqLYzkjld4P6e7EGanRH+fUI4zjxtkrvY+I/2z9FUT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eiOc7o4sqssB/Tpio8i06STVcDKkyvh6r4RMZvLRZ59J8CGb5kTo43hv9zpYObBtPj3Oa257knr6cGzQymibTjvpiTo/UFdir0khU2g2hudcycbebNG+PhxdvWccxq9vFDirz96EjGSYITYG1ij+hMDXnOMlBFHmeJDM0mQ85lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wm/JmAsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wm/JmAsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EAFC116D0;
	Sat, 28 Feb 2026 18:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302158;
	bh=EqLYzkjld4P6e7EGanRH+fUI4zjxtkrvY+I/2z9FUT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wm/JmAsZlTExyE6OIoBC6I6igBJxfjg8EAvGvbiOlQKme1Y+Vj+MXhyS4vTtKL2ZQ
	 vyejlkjj+BzNjUqw8Vff2Sg9jblecO+Y40o38xvmWNODfVMq83IvkR0BxSmMqiZAwb
	 VOfnaZYp4AyRxHaJIZNLvKmlWuQEiMGIziQSySuU5zv77JH60XAT+HmFvB3z0NSYwz
	 tU5u1E1+p69F8pnRSvg9KQZtdGNZz7QgdaM0ddlsikSG+L7Ps7Ri6nFipgwWnyK7D4
	 Ag7NcxIs8L1BAXKqcMpr0fozILYDscN6UCmYqGDk7bnx+IPRBf2GLQ5/7VlLK3gsf/
	 Fv+HY99XYgfPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Sean Anderson <seanga2@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/283] net: sunhme: Fix sbus regression
Date: Sat, 28 Feb 2026 13:04:55 -0500
Message-ID: <20260228180709.1583486-153-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: René Rebe <rene@exactco.de>

[ Upstream commit 8c5d17834ec104d0abd1bda52fbc04e647fab274 ]

Commit cc216e4b44ce ("net: sunhme: Switch SBUS to devres") changed
explicit sized of_ioremap with BMAC_REG_SIZEs to
devm_platform_ioremap_resource mapping all the resource. However,
this does not work on my Sun Ultra 2 with SBUS HMEs:

hme f0072f38: error -EBUSY: can't request region for resource [mem 0x1ffe8c07000-0x1ffe8c0701f]
hme f0072f38: Cannot map TCVR registers.
hme f0072f38: probe with driver hme failed with error -16
hme f007ab44: error -EBUSY: can't request region for resource [mem 0x1ff28c07000-0x1ff28c0701f]
hme f007ab44: Cannot map TCVR registers.
hme f007ab44: probe with driver hme failed with error -16

Turns out the open-firmware resources overlap, at least on this
machines and PROM version:

hexdump /proc/device-tree/sbus@1f,0/SUNW,hme@2,8c00000/reg:
00 00 00 02 08 c0 00 00  00 00 01 08
00 00 00 02 08 c0 20 00  00 00 20 00
00 00 00 02 08 c0 40 00  00 00 20 00
00 00 00 02 08 c0 60 00  00 00 20 00
00 00 00 02 08 c0 70 00  00 00 00 20

And the driver previously explicitly mapped way smaller mmio regions:

/proc/iomem:
1ff28c00000-1ff28c00107 : HME Global Regs
1ff28c02000-1ff28c02033 : HME TX Regs
1ff28c04000-1ff28c0401f : HME RX Regs
1ff28c06000-1ff28c0635f : HME BIGMAC Regs
1ff28c07000-1ff28c0701f : HME Tranceiver Regs

Quirk this specific issue by truncating the previous resource to not
overlap into the TCVR registers.

Fixes: cc216e4b44ce ("net: sunhme: Switch SBUS to devres")
Signed-off-by: René Rebe <rene@exactco.de>
Reviewed-by: Sean Anderson <seanga2@gmail.com>
Link: https://patch.msgid.link/20260205.170959.89574674688839340.rene@exactco.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sunhme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b983b9c23be68..61ca7377b612c 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2551,6 +2551,9 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 		goto err_out_clear_quattro;
 	}
 
+	/* BIGMAC may have bogus sizes */
+	if ((op->resource[3].end - op->resource[3].start) >= BMAC_REG_SIZE)
+		op->resource[3].end = op->resource[3].start + BMAC_REG_SIZE - 1;
 	hp->bigmacregs = devm_platform_ioremap_resource(op, 3);
 	if (IS_ERR(hp->bigmacregs)) {
 		dev_err(&op->dev, "Cannot map BIGMAC registers.\n");
-- 
2.51.0

