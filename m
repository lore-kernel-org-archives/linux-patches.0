Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E077939A7EF;
	Mon, 23 Mar 2026 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283152; cv=none; b=Cf3DZ2r3/X33SiMCplHxiQk0LyLZUpzekO7JWKY29d5R9JwAK8Blw4ULU+7pafTKs6CE3gxRAaEBVQmhIsFnzvgIB2odkeYh4hCju9yzG1NH7BwS8ir3oUZ8NxjF7ZBP29tXBnaIcEfmKF3SFr5r0GHwNe63g6VN+Qdepv872P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283152; c=relaxed/simple;
	bh=kDdtEcrMwI7YQlV2ApdSXHbGn01Ob/qMvNhgqWpQfVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3I1Ilm6hsl3anOVzNJOTzP6BpFk+FTROEjqiT59nU2KgRlL6sM5Rb42/D7ynSD9mXs4dyCFdlZUHPT7JUHak4//AXdi/yxtko6oW5RjJiMcrsyTNPHjmmWx0fIoacYTDkaTd6yb93FMjiwXJYs731Us6NwJbAYMFo9p27W1FZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR76Blei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR76Blei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79248C4CEF7;
	Mon, 23 Mar 2026 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283151;
	bh=kDdtEcrMwI7YQlV2ApdSXHbGn01Ob/qMvNhgqWpQfVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZR76Blei+McNfcOoLliu8DEEhdxAiF3YJDfn/RhnI0lZSsWiclzPgkH6dfwKUyKrS
	 ftf0PtV6f+TBPAY3bpyw7gfmJbRnc/PT8HOiYgi2Pp8dY/n2wCmwZsQOzORgIgSryr
	 O3D6Eed8J2Smr9+eI83gUPNmyQAcIj5hwVTzZ+H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Dhruva Gole <d-gole@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 6.1 377/481] mtd: spinand: macronix: use scratch buffer for DMA operation
Date: Mon, 23 Mar 2026 14:45:59 +0100
Message-ID: <20260323134534.321383265@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit ebed787a0becb9354f0a23620a5130cccd6c730c ]

The mx35lf1ge4ab_get_eccsr() function uses an SPI DMA operation to
read the eccsr, hence the buffer should not be on stack. Since commit
380583227c0c7f ("spi: spi-mem: Add extra sanity checks on the op param")
the kernel emmits a warning and blocks such operations.

Use the scratch buffer to get eccsr instead of trying to directly read
into a stack-allocated variable.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/Y8i85zM0u4XdM46z@makrotopia.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/macronix.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/macronix.c
+++ b/drivers/mtd/nand/spi/macronix.c
@@ -83,9 +83,10 @@ static int mx35lf1ge4ab_ecc_get_status(s
 		 * in order to avoid forcing the wear-leveling layer to move
 		 * data around if it's not necessary.
 		 */
-		if (mx35lf1ge4ab_get_eccsr(spinand, &eccsr))
+		if (mx35lf1ge4ab_get_eccsr(spinand, spinand->scratchbuf))
 			return nanddev_get_ecc_conf(nand)->strength;
 
+		eccsr = *spinand->scratchbuf;
 		if (WARN_ON(eccsr > nanddev_get_ecc_conf(nand)->strength ||
 			    !eccsr))
 			return nanddev_get_ecc_conf(nand)->strength;


