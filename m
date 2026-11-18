Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031500;
	b=DkhdbAWsTQY8P6H6/uhB+2+sQf2HFwdBDvsRx8wivseAba/iNOjfe14ZJNm0Q7s/GHYy
	 4hj9v8Xi3AgaVlOz89TH5R3PgV2sd8noFMZ9uH/mjlsVmI3jmWqvQleS9uJ3C48xsNFa5
	 q3dw1vORgKli6ygF+stq1LcPrv+7eOq53jev+lYQDKZc1ttbGsDtCviOFja8rZvW0Oywv
	 /hdLaSea/uPfUmeyIXKrMVt0FJXIVRRUjxcHEHLzF/A5RaWd84E1mS837zzYviKc6E8xu
	 1IK8nmxlnzayu8I34Ucyat/yqOOhrKK86Uj4rORWLwM4j1YkYgw+9DcetzSGM3nm+Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G2aA5+jp0wHn50qyHZsrCU1B+3yt9S4EtisDyHwIns4=;
	b=fhCK/8gfHKdU6eOv8T2ZLT1TJ8xsTkS5gvySTZEfDGlLQuqxlCRUyL5teB4TI0fShy05
	 PUq/oMWczptJp51IunfVLV8RaPWmqHiZnE3yVlU8Tfkhfr5iq2D1+0AxLsUe59sGNt4qS
	 pJ0rs1O+3P8yaE0t4rTuMav+fVqNI8INl0/FH6TzhI2HGK31EIWojl073i6UYnRiN56YT
	 PGtSn1k7S+jLEo3yazh/lDk+2fJCiYxIRC5usOhCOxiukcFst7LJNQRtD8thaqVBqep2I
	 unDsu3kYK/XThB9ILMMmzeRXEcYv65fDw4f/niyxItx4YTxhFlC7CHGgLZaBHSjgxRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLplUhBV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3CE606A31C;
	Wed, 18 Nov 2026 19:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLplUhBV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B98E1F000C4;
	Wed, 18 Nov 2026 19:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031500;
	bh=G2aA5+jp0wHn50qyHZsrCU1B+3yt9S4EtisDyHwIns4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLplUhBV83AxNyBAEhGkPf3+qC9srQMYpIDKX3uNaX/32Ot9/vASFC0/AR6HI63xN
	 N62oO5XtSILgQ2ITTYCilUYOngDJcqbPvP3PRBQrXIABijAuaBzMcYgrriA2vPMlJp
	 cQ5ruCWf3yk/pMz6PWCSrebiOXPK618FsT6PkbmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1081/1756] mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interface()
Date: Wed, 18 Nov 2026 15:53:28 +0100
Message-ID: <20261118150053.249731608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1ce45f0e74d60e8279ed380c97047e6c351aee1b ]

pl35x_nfc_setup_interface() obtains a reference to the SMC "memclk" with
of_clk_get_by_name() and only uses it to read the clock rate. The
reference is never released: the function has many early return paths
and no clk_put() call anywhere, so the clock reference is leaked.

The hook is invoked repeatedly by the NAND core (nand_reset(),
nand_setup_interface() and the NAND_DATA_IFACE_CHECK_ONLY mode probing
loops), so the reference count keeps growing.

Release the clock reference with clk_put() as soon as its rate has been
read.

Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 05522e81a17a2..254dd0cc5a5ee 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -807,6 +807,7 @@ static int pl35x_nfc_setup_interface(struct nand_chip *chip, int cs,
 	 * macro to convert from one to the other.
 	 */
 	period_ns = NSEC_PER_SEC / clk_get_rate(mclk);
+	clk_put(mclk);
 
 	/*
 	 * PL35X SMC needs one extra read cycle in SDR Mode 5. This is not
-- 
2.53.0



