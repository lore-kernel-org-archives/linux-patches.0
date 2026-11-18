Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045153;
	b=rqRLuL2XJpDo4LgCBmh62OnCJae7dY5igpzBBO4MZ9SvlOxqeLSSgUtuvkcV8Kzx5b2X
	 nvttWUD56teXA6/dUgvLpXYueP6A3Cnoqz9v3LW1jLnwuwzXm3Ny5qmp/sWhqfvxYd635
	 1sC/cT8JlcOtYH/MLkYhvXky04wTykD11JaTeD4bRa7pIZ5t1rCRVfCqzbGMBj3EKmyfR
	 iouOYweWpGubvMcVen6OU4yhGtH2TeZ7ghTKHvdVRLGxPl++M/E0W8aqzOe4XZxDBHQ4k
	 iFHIt/wQefXGKTKMHPVhQ7vsJnK0QM96angFXGQOi34kzTm/lZN5uvFCjx1r/gHgYsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D1KPO1EaShRSCJwvBSlPhMbeUxrcVBcYP87tb1ENInA=;
	b=y236pIQgwkciAMRaV/ybVjrD0n6O9E0uiQgA4E6Y9kWC5oXbbt13aUU1QKMiPUNMdM4/
	 +6DrM9ANeYIJqVfWRn9sQLWCrn+sqH9mabHyAvVIrpKmZ1yY+LGjkBdtLFtAXXGicGH1R
	 A8RikxxlabgrGMaMUVPloDBu0mOzAqmZLaCfDM7neu+0HbmP4qre5syd1BSwsWWn2RwFC
	 EmeUvKyJyaJXn7K6GPnFzE4CChjRjaxZBALqeZClnmEDtErjgwrCqriHysVOrPgTBKXEU
	 ehdKt4pm5qJG5oBSixTT0/WqyHw1jNRNDVOrtI6pHUNpssUt+2T/kZBeaNe9Rj4+PQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPxVHKfM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4476606A32A;
	Wed, 18 Nov 2026 23:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPxVHKfM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464561F000C4;
	Wed, 18 Nov 2026 23:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045152;
	bh=D1KPO1EaShRSCJwvBSlPhMbeUxrcVBcYP87tb1ENInA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPxVHKfMqw6ge+2860jxScsPtQBeXjPeBhJr1rSsMw19OaIanVBLNN3fHoknU+6cm
	 zF1K64EfiT8A/2IO4HR0rP5AAvxeB0/10zOVjQD/CfdwS7vbcOMJX6WYW3+1MArIlt
	 IRrmrMR7SfSf9YjreJ9Wtd+5n/3KI/V96bqN7u7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0821/2857] mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()
Date: Wed, 18 Nov 2026 15:30:55 +0100
Message-ID: <20261118150231.135358938@linuxfoundation.org>
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
index 56fd897721ad5..bac452bfb6e94 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2079,7 +2079,7 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
 		ret = -EINVAL;
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2087,11 +2087,13 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
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



