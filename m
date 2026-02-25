Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC0218B0A;
	Wed, 25 Feb 2026 01:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983295; cv=none; b=St6Y6N68sIatXfzyyOJkk9yjGm/n4DR2/S1Pu0yV8hiy7ZV+DEkJ+HtO2fpF6gq7yPpsjaDaHtHqroNgaqryOky96HUhvR1LkX45cgkjgw8htFSf+/YRZjfh12fAcpK06NotCVgoI9ubF5hOKA4NAaD9p93vdzfX8LjZxNeAoA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983295; c=relaxed/simple;
	bh=LSexQfAsFpMeZ47F3fMhDTMutuur6gmBAAKoRbmQa3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pE1H1cvzRSxWPR+GdQaP4LwNAAgRnVCNMFOv8Dnu7dLVbgAh8QukfTj2x/aIWueM+BqrQ4K7yfr2JTSPD8JXxMrVwwLC1RPUMiaNF6z4JHMH34Pya6xVnNdyjHmMJV1F943MeqsS/bX5U7nM26h+W4vr7LbXX8ir687YPjwTgY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPDsqv8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPDsqv8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF943C116D0;
	Wed, 25 Feb 2026 01:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983295;
	bh=LSexQfAsFpMeZ47F3fMhDTMutuur6gmBAAKoRbmQa3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPDsqv8hymGfKTP3PXOFR26dG4mYlE/KJxCkscuievlHQMc4C4WpwAmNa7tpeKn0l
	 1w0Bcj+ia7MszEOOlu0S/TKrsyigIYzrvqbEGG7c7DTn13DwWX0UxgW27inj1fFAPn
	 e4nVO2aD/EwsiVh3SyD+/ZRRJS/ouZlsvxc88uds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Sean Anderson <seanga2@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 429/781] net: sunhme: Fix sbus regression
Date: Tue, 24 Feb 2026 17:18:58 -0800
Message-ID: <20260225012410.220508779@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 48f0a96c0e9e3..6669980829980 100644
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



