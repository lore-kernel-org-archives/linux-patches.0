Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056057;
	b=YD5fXrIRsUMaQvarqKaq9TE4Rb7nxoC9gSNMJHsoqb7qX1UQJ5pd+bjSPYJylVnvVmZi
	 rdPgVghrK4+vWhDGD/1GMOXEeQrkux5UBGDpw2Sq3rbfttv2zB+VOj1DVK9cnr/8f5HXf
	 Y0WLVNi/rkQI98Ujo4/qfLyDS6illdHVl70WUcdwPVAPMv69afBFSUX5HsE81vZKJF7fw
	 RvKcCzr10JWKr0NNgqCcjlbWLRXh35vho7LucLTr13LrfLUNFgIDaTAFGwQb6Sy9I7Yaa
	 6QvXXX+ZvLXKYZJAM6SWXpdGyFb3ZWGqxHDIKkiDs2OZTge5AGBIWlZLLKBlyiwrSGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y9Dh8/1upjnMohTxED2VuS5+pf+Y5dN7wCagG9Xs5gw=;
	b=QKqVWd31kmMlZLzZ0Djh9v7yV0VfipMmN0KeqIM/zIP5ywA1M0A+bCWSfOXXl3wRrlSJ
	 jgTxF032P1p/3aZCXSxcLksvPlKB0YYiNLDdoBkF+8EPb3Ruj28Ih5BcwUShrJL/hP0CI
	 QGneOOZ8xg3nWk6fzakcyNLf7Rne76BG8w5+qkCuzNYSZCtfs159c7vfJ6zw0ztBAnTdd
	 EoUUYLAMiQroi2f8luohZ8XwlscJNB5UMUFfhWZWvQ3ZuaP0y5hCZW9XcJEJJJv447MrE
	 ChuV4qooxgKy+NJCXV3GYYSInWt8eIBIvNc29MDqYmHmWSxt4iURIWEFcKIHb6Y9Ktw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQHiEQ67;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9173606A320;
	Thu, 19 Nov 2026 02:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQHiEQ67
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B766F1F000C4;
	Thu, 19 Nov 2026 02:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056057;
	bh=Y9Dh8/1upjnMohTxED2VuS5+pf+Y5dN7wCagG9Xs5gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQHiEQ67A0tQduyp1ztHBfTmj/3vJP9ObnzJ+8AXQTdsFsthJxSUg8AyZVWDu4OEb
	 6SR0f1CqtVHkeGww+qwp2EfMriu/vc9SAEBe2dxs986HlvGP3xURIWLCJtVm/8QEDg
	 1unLxH9ZN0ab9pYpTV/zx/d67GOJwTj8aKIKjS80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1851/2214] mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interface()
Date: Wed, 18 Nov 2026 15:58:47 +0100
Message-ID: <20261118150125.426745580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 04e62c3ab5975..2b6626f34b697 100644
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



