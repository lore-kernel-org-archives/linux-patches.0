Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026246;
	b=J1eXufKNh/HVcBYYoWhlwRxFZlVMOhbg3G6XCG2iJakvk8OTuqtW7l2AwRzW1AHNA2Di
	 uBbmkcwKkkj9f8a6ipJ4aYb8dZ6Fbh+w5WWYvWJMF+hxnVpgKDwyFfuNdfIjOG2np/GCR
	 OXjYa/oIYuINybeG0VDCQDfZUBJ4R8J7/CLr9ojISQPtwVsLWv6c5wcQrGtVPe3mwOvr1
	 28IGBFE1oiXOLCh2Xrbv8q3EWZx0qVGrvh+eVUVfUVsLXXs2SzDQdpofwmdnV+zVJNaip
	 /CrLds/SA5Z5sTGte6Gyph0SOvPdwi/7oDOE4FtZJzj/VFSXOU+gi9BOuCl/3uEJ3CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P87kaoTdv5lMDtJq33ksg5Ndik2inr7HiIm05UqD/8c=;
	b=cQoWLbi8907YKUJs/1HN1+4rmOBcpA+J2C61RZzfW7T3javNZcYFHexLsmznv21vGJ9J
	 LRjAQn2BqVx/XFa4j/9UyDSRGP/BhYTBje5LYmelz2FaU6cttsPW8z7IhvWLvo7XD3fX4
	 D7E7Mrs3kNMBrOlz14T/wi61ymgTqlFRcb/OH9WyC9QjgEuvDozBD7ML4oCy+10NpPkgA
	 NiM0ehPysFkgaPQY0htI33Xj0GiLhfUX888yp9Dirbmsha/1qCjLAnxZ9+VdAXs88sqws
	 3Y0sX0iryWb51HZO03nzt0NIG0T1uWS+UfZ4C1yYcKYNDqcXICVg4Hx/AdZh5wTx+Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ogj3woCu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64A5606A320;
	Wed, 18 Nov 2026 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ogj3woCu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B04A1F000C5;
	Wed, 18 Nov 2026 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026246;
	bh=P87kaoTdv5lMDtJq33ksg5Ndik2inr7HiIm05UqD/8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ogj3woCujmyQidWNyNXe7UFuUxAGsyRnYYkgsI+Z+04ZeVAMbrf6SlZyOs7iT+Tkm
	 NCRNvysedcs3QRSHc7yRSGS2rDWwFnlNl9zxGXK6ie5KcZwepBTfIjdN73WdR7xhzy
	 dgp13/9wkwpn91wkBSV4V84TKPE/kiI281bb1LAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1366/2151] mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interface()
Date: Wed, 18 Nov 2026 15:51:41 +0100
Message-ID: <20261118150211.781644096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 12b9e0936c8f1..8a6892f7623d9 100644
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



