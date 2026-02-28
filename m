Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEBB3451CC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301820; cv=none; b=OrNWSzJRdriak2IIRL18x14a19UGwlMCttGjrfjwUedxImPMkM09ZRCU021f4UDVgzAGHuDQs9aY8v33mjDFaVAPQtQ991n8y+t7Cmp0g99d6l5WFDcFn+tiKQG4oY2cyPIq0e8sUvXikKxAH+8si3JVSyB8HQP6gvR1D12w52w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301820; c=relaxed/simple;
	bh=PdSmqa0tna4ZJjUyZ0AXO+jfpye2djY1z4VwjRr54mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YR0yZ1qXIPVgDFZLCKYkxHkhqtDQK8TGmdOGPrwFFne5KSpumbN1KScTi5cAF/BvCVJ64WXjRb8p2lwSauKnwiCha4JWlCBTV049LpmvAMrsWY1co7voMDtiZe9VR92wU27RowmpGI6HWCD1iX9//wFiqZdSSzvXUIEBZHWOm9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLHiANrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLHiANrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329A8C19423;
	Sat, 28 Feb 2026 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301820;
	bh=PdSmqa0tna4ZJjUyZ0AXO+jfpye2djY1z4VwjRr54mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLHiANrEtgurDMrGmY2gQWg6GXxeQdSTBzPJqoa4wWmowGOmdSYuoplVcgc9cJ2kB
	 u3pV9Piog40loN1ms+lqDBlb0HvATZkNuirDz7WpDU2dKRYIwLleGULsbMmazntogS
	 X3xIbyA2lzxCST5Bf8mprQxMoqyJRmy21ANKOHX5aP5Yy5C/Pcd7fL52On3MLq/3TX
	 hVQ133+KTiJN9G3TN2Up0rxXKLfX3PWHKsBLoCx6rgw0HPI+gd17qmZpbaB+6H2sYe
	 1UsziFYjwitgA0065yHtDHqcGVW7ZxklCSYujGSC350M9mNS+5/kF/WylIYGUPlqrh
	 WAkaUwgWrvdog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Sean Anderson <seanga2@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/385] net: sunhme: Fix sbus regression
Date: Sat, 28 Feb 2026 12:57:37 -0500
Message-ID: <20260228180011.1568201-235-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 50ace461a1af4..89ac15190770d 100644
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

