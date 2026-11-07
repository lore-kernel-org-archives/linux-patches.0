Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062985;
	b=cmcO2KV7VOh8KIM8zaNt9BMYacB3qBnZ3J5b1V0+jb4iOhQF6RAs+nW2vr1PP9FxumBI
	 ibFdPlx2Vv4OMUgh9T8RcF59NPcDzaoS2VE8C1DNT2jCh0Z1GR4T5c8dp8gOsKlBXBo0M
	 T1YyAWPPp+U9erCoyJ+VahP2yr02qoMglYGfC/psXcwB/q2GzaVOctYRfQc69Ifho/RKa
	 /5MZfS8XBvMH0oQFJDbL3HkbMONUE0ZF/k4bIls4Bxn5LgonY7a7/pWmFB8byx94JKYI6
	 P0w7ImSa/ReOPtSYjyBFUneEuIJiR3+KAKNtBdyLeAh9F1x9HgOSER5J08hHzpxjYpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQiBj0hnFoVpQMRj24WXUXY1dYX8CSmB4EmpdPLnypo=;
	b=mjnIhhJLIbENZB4zaI8WEB/zq+e1kIZpiaZqf8rPaNQKh7f8aoF3WAjWo6rGtZyxYCtb
	 4tDeTApkhLdJ5DGQSIiXUjd3PFaUp5RFibuqYjgzoIGk4m7gzCcT0lsUTmFFMW7DYhwpK
	 uFU7/WvqOGi0A7ZwPWSTI51y3SotqHfVe582iymufFaeHUVib2G1vzvtaMAOdscP1FuLo
	 oiMRkwlztCTmq9pegADZ0iLs0MSId08w3r7/pWwKtVHoojzExgL4imVEMCXLw6XeUcCU/
	 iyxnYsj3EPmiIMg1UGC608bf5K4n2wOoGhkT83No36JJkalmM1peILUSMPHJLgDRwOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COi8vWjg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4B4606A326;
	Sat,  7 Nov 2026 14:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COi8vWjg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8501E1F0089F;
	Sat,  7 Nov 2026 14:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062984;
	bh=TQiBj0hnFoVpQMRj24WXUXY1dYX8CSmB4EmpdPLnypo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COi8vWjg9gRMrSmvxSYCbarHQl2FLpb8kIfwLCR49DDbOSO0LNDXNMmpL68Hakbf5
	 p8slrLEyH0X8BbC9I5vaMmp1zHOfRzq1VVY8y2KfoxLrSGXAHkJ6rrlXMRAv/5eBpi
	 AFC7RTE6f8B9JcRGl8DHCcuesxFkg1reYmE0N8Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 244/869] mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()
Date: Sat,  7 Nov 2026 08:48:46 -0500
Message-ID: <20261107134900.078369711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 94edcda45d888c3bb1310de11e10e4537c166f00 ]

atmel_nand_controller_init() takes a reference to the MCK clock with
of_clk_get() and keeps it in nc->mck for the lifetime of the
controller.  If the "atmel,smc" phandle is missing or the SMC regmap
cannot be obtained afterwards, the error path jumps to out_release_dma
which only releases the DMA channel, so the clock reference is leaked.
The callers return the error directly and never run
atmel_nand_controller_cleanup(), where the clock is normally put.

Release the reference on those error paths.  The path on which
of_clk_get() itself fails keeps jumping to out_release_dma, as nc->mck
only holds an error pointer there.

Fixes: f9ce2eddf176 ("mtd: nand: atmel: Add ->setup_data_interface() hooks")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index 83ba4ebd02d41..b954e70b4c6b3 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2086,7 +2086,7 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
 		ret = -EINVAL;
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2094,11 +2094,13 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (IS_ERR(nc->smc)) {
 		ret = PTR_ERR(nc->smc);
 		dev_err(dev, "Could not get SMC regmap (err = %d)\n", ret);
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	return 0;
 
+out_put_mck:
+	clk_put(nc->mck);
 out_release_dma:
 	if (nc->dmac)
 		dma_release_channel(nc->dmac);
-- 
2.53.0



