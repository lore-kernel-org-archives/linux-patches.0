Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049516;
	b=4zQdBtAM9ZxlGPlyy1NVdcvR4q1ZKP2mSZhn46bGfsWmgNAGNm+4YoSre+1Sghk4aKny
	 5RIs1NqG7dKYt973ULZeY+tIOMge3MzB1jPnoem4QwReXlf6wbGdsHfPh8SmpJkv6Y0kM
	 NsBkd66UqS7Kc4XQ15JxI635txCo3xfg3MBFBFNhDbWQPBQACyJC9YnYx/PvdkYXSfooj
	 0mhUp0HdMU0Co07+mHbFd4cQ6hPkgPUFrIBNMYTHbWHWCuojuPqQ+o89I72pD9W/qqGQT
	 7tIw/xmX8lAFjiKiuPCzVST8cztktmMA7sNmL+B6OjcYmyhiDpmcI6aD48U9vGqQT4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOOT2tNWk+/0AjxndcBZb240LnUuYmRkU0pAFPrx3oo=;
	b=UeciStPxQmo6WM7m0sX+kyGSsQyX80QOYlQQaiEi2k1pO+jvOu/E+P6bVFCa9uYXmcYr
	 bArBOdQqqkbUkerDxCbDgH4PNDpQfbtIhCTs9wgBBSy+ivh+wH5cfhblk5mW/R/UTiAnY
	 5heAJ9lCBvJ2UOtneHIWzNhpbXy/lWVgV9rO9ydkOCzHmqv4QMNf0BRJlxJp2f5Cfr2R/
	 fuQR7qj0YmHw4z4pplzb++Qve5Ak/Z8gW6hTJGnu+R1PxyJVYgBg+lb20o+KgdUMB64y2
	 UZYZes3Td4RMnqiXQjPizKgC9EzT5lNz/6fsY8nYLsRMpB8vNvjG0LrN1kz+o7BVA9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EizG4oJo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C845606A320;
	Thu, 19 Nov 2026 00:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EizG4oJo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD93B1F000C4;
	Thu, 19 Nov 2026 00:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049516;
	bh=WOOT2tNWk+/0AjxndcBZb240LnUuYmRkU0pAFPrx3oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EizG4oJoZqqhU8PpVwkSRoYQNmqQW1XuYkSKQzK8GuZxBNU1n8QLRC5iIg0cqwuB3
	 f0qEyrSkNbUKuaaNMa1NgukLiEyZwcLued1DX33od2UQYGcRNPJUUnhrJqmF591OlL
	 if8JuUmLYf1s4aHJ7w2dkSo202yVxfGT0r5xU0go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2379/2857] mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interface()
Date: Wed, 18 Nov 2026 15:56:53 +0100
Message-ID: <20261118150327.186499847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 48886a89ea28c..d1c1c7b21586f 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -809,6 +809,7 @@ static int pl35x_nfc_setup_interface(struct nand_chip *chip, int cs,
 	 * macro to convert from one to the other.
 	 */
 	period_ns = NSEC_PER_SEC / clk_get_rate(mclk);
+	clk_put(mclk);
 
 	/*
 	 * PL35X SMC needs one extra read cycle in SDR Mode 5. This is not
-- 
2.53.0



