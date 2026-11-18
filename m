Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060595;
	b=R0A8vW4hph5n+wH7x2oqLdLUW0lctXTMAur2D1dUU/S7b/+W8PVuvVqAjc5R3e6DiMKo
	 SOYELzgBIxZNsvhOD5WeutxvZdZlgjlGnbsNDaSfdYDDDuaaWcAV7aE8XFgs82kXfcb74
	 pZYN2P8ZJ71M91vWVsOTbWjsDswUi97guGXhKebLg+B+0/m/l8Yu/fc319agOyamso4dK
	 XwsWsWPwgNJh4KT7tdu1OVdg/9Bt14PxzELRbv0oej0okZdKCNsRWgsdfhJvu9EF4Q6kT
	 WpqP1UEI1do09gpHN8GdImawc1My28bFsm2VTGfPxBElz4+cH9CvIKFxLfAcoX3EVmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J9RPFUevH1cez8Zy0p5PgqYIgopsjuHZbtrbeco2UGY=;
	b=MC/y3CNAMy5Y6nWt9/CfD7r+jPrPk8qtMbqkL2J6X99f2y2MSq0fmjybv0jFj/KbtLft
	 dkwPVhd2ySk0virM6dze/G0XH65owBtYlUAFn/y/aTZ29swtVQqfJDEIoyzOJOgVoMOqP
	 dZjy5B2Oyzwq8n5vEL9BE8YGEZFUBz3Z5W8Q6IssfVUnxlX03iNdweEep0evZxB4mhYpZ
	 lRiLKimPi/5bph/Ztmd5SOt/FQDUPM7ok2fDkc6WKzArup34WtM1Jjz7h636COUpEpRwE
	 RN6tC58o6PAd4ZZzrKndd43Nz2/CLfqVSfSH+1IhGunBsN45l76qYdWk3G8TlijlFCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11X514nx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0C8606A326;
	Thu, 19 Nov 2026 03:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11X514nx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9241F1F000C4;
	Thu, 19 Nov 2026 03:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060595;
	bh=J9RPFUevH1cez8Zy0p5PgqYIgopsjuHZbtrbeco2UGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11X514nxpUnoiZBj2MdmWy8HePgaEIXMAT5umGiznR1Y7GGIGbniYDt+xdv4VkkHv
	 /kjROWfv2H2+MWR+ria7WPQd0kwCjcK54G2QlyhFk4Kh2RrrvRb685jcz1dVj9QnNk
	 mjgM0pXSpdUddHupaz1JAXICRqlyDcc4MYDCvKRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1256/1848] dmaengine: mv_xor: kill tasklet on channel add error path
Date: Wed, 18 Nov 2026 15:54:54 +0100
Message-ID: <20261118150012.331014866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit bcb4d469b19d53dc21e4a1da12d4438e7489e150 ]

If request_irq() succeeds but a later step (self-test or device
registration) fails, the error path at err_free_irq frees the IRQ
but does not kill the tasklet.  A previously scheduled tasklet can
still run after the channel is freed, accessing freed memory.

Add tasklet_kill() after free_irq() on the error path.

Fixes: ff7b04796d98 ("dmaengine: DMA engine driver for Marvell XOR engine")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260909234601.101883-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 8224d52d16901..4047312fbb6c5 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1162,6 +1162,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 err_free_irq:
 	free_irq(mv_chan->irq, mv_chan);
+	tasklet_kill(&mv_chan->irq_tasklet);
 err_free_dma:
 	dma_free_wc(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
-- 
2.53.0



