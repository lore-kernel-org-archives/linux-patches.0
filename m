Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064154;
	b=0k4+UpMtgvVUlL16WPbhjn064oWqumlm75R2N/izPS4NnmRwGdlobsp9fBc9/NBLbSGh
	 Q0ZXX2+MRBSzIrLCvv1uM5TcvnirfrY5YWHfn09BRG+Do+YtxkW7a3CMedN0kJdtv5M1Z
	 2uANPTLtP+gd3QD0USYySSPolTFlsQjV0BJIzJ0P36irB5Jct/S5lUZF2nAN5lhdd0vMQ
	 xHSCBfeXqMVl6y5c8/nA4dwnmXs3JAOJI/LPkuwt/Q+SqzwIS1UUyuwbjkfuSmHQsLvS1
	 7K0jRB1IgYBtqHDTHbW26ZnetH39UXpZpQ1So118ca6WWP21RxB4+1qFbU1NQ3h9zNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vVvS+51ZaWUApzgwFOChH6i+LOftFYmTWojO6s35iik=;
	b=it4ZgY+THG3JovoNJA65rWuWzG14d67KHxtC0BTDUQT0MIbvtuID75XsTYNsViMyfngj
	 yPprYUGWha9m1ZGe7YL/PlsFWHoNGygCb/QL4cLOwbVSTipiiPQMt3ySBEaeSXA+irox/
	 iBIqJLBfoURFU61ZFLmmCjaJdCphjpeq3Tr3kUsYo3p5hbLNtVQRSrqXmEjqn9dIcfbfp
	 rM4NhAKmmRTyti9E9Yz1vr3JY5InyilV2XPwh6evAX1dPIBGn/tPoJpu9LS7TpIWNhqeP
	 Rl6t9ZLc01XXDMsLNhH+gMQtoBwjG5xjEyaLOk6TjkSQ077sin1LbVhG+3hDj6pCqFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nicGHcGZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00FC606A32E;
	Sat,  7 Nov 2026 15:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nicGHcGZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4B01F0089F;
	Sat,  7 Nov 2026 15:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064153;
	bh=vVvS+51ZaWUApzgwFOChH6i+LOftFYmTWojO6s35iik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nicGHcGZWQCr18Ly3qcQBh3kIEMmfMuDlpmy782hvvQcuyqYGGSrVyM0Nb/74HCvL
	 C8h/e9eZkEzc8PqHvFWMzX2y7AZZoJ6u6IE8Y5WEV4bvimaGUJ91z5rrcQWxypL2r0
	 A8cVBwo6eWRxoB02mvwNYnb7uP18IIkptnVCPbQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0303/1257] mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()
Date: Sat,  7 Nov 2026 08:43:19 -0500
Message-ID: <20261107134947.820025134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8a19408abb635..0bdbcbb50d94c 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2085,7 +2085,7 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
 		ret = -EINVAL;
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2093,11 +2093,13 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
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



