Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A602C17A0;
	Wed, 25 Feb 2026 06:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002622; cv=none; b=sh2/EquTWNW5LZbj/MxNDob+ilXT/SrB5roNM+P6FADm62GLJLe27xoE75GdAKRCEWwW8tTi87oLusUvScg7QQbnV/5Doxf+CtZy3URIWMSF9/JIJVqqf6cs6GGiU5RDZNbkLo/QCNey++s1Fk9tKEcn4OFwuJi4Y9ieON/CnPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002622; c=relaxed/simple;
	bh=Xt0uAy74UXVRM5MlNTebLsja9bjjXjJosQad7Gii7T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpYlXyd96C5oVMz3qdTUJii+/9BNZijRkw8ZSCtTxNdobQLpyZecWD8YAFT8TjeabmMmoIodmfw1jWYCvJAv9SFXtiJh33wlOltL5iCgMZLItUSWcDxh02fk/Alzifpz7lsRaCsqCHLt3Q/n3bXnuyunkgJlFFrVwhHIeWD8SnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOHKOC2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOHKOC2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80298C19425;
	Wed, 25 Feb 2026 06:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002622;
	bh=Xt0uAy74UXVRM5MlNTebLsja9bjjXjJosQad7Gii7T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOHKOC2lO6UyZ7G02JLTKmiLjHWqWX+F315GvDQ27dx2RLGgjKeMd30hJLRfb8VyZ
	 1XQtJ2WRnGOR7uW1Rtxx6jfNr5GXRLic7dMVeJ68YsRyLXdw04cKjxc8OGXzmNTOxs
	 ipaGniQ3mKf7ByDC6QoXxJzwJouPKTM4Vpshe7IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Sean Anderson <seanga2@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 327/641] net: sunhme: Fix sbus regression
Date: Tue, 24 Feb 2026 17:20:53 -0800
Message-ID: <20260225012356.617609965@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



