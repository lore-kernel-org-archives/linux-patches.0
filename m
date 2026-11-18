Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039935;
	b=YqFzil8qg34wdk/Vt7GFmc7+I0KFTcy7B7rddQCQtc31kU8vM+TcnnLSmDS428s+d8Zd
	 2mMiDhiTzR74vzy17274rbnqS2qGe+7kgShxS1I8cE5O6SabhNIsc2dfgcs9/mkS6OPaQ
	 E7xyjhmS9rKhJZytrjm29e2CqavCd3KYm8w+cgepWLNi/12KdDEJkg7a2f7dzizr7K4uO
	 vRo9tU9N1uYMYVscFy1sD1tVG6VQ63z1M7pd6/MecQAmVIhenfZY/syUk4rFO4QplJqFU
	 riDOTNXpacPHTvU1x3kjBK37umu/VVBjgi453dKwMWMX4ANjp3JGZYtpOnw7+tprlaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cHuRr6Lb9uhSNcPphj6Ls7gNCgi2JaiEJ0mQj8Jq5XA=;
	b=v8pxLW8QQZmbTugrP1TnNFER+qs0Y6284SkTEG3twtJZaMxxVY32xLkFbqkYuTZAr3y6
	 0EOk1rYHX/J95riindvDRv3aUY5r1m4ZXaYPq00yQYsrq5zFA/RjgJTWBYXMrUFZDBCHR
	 LUZarnqTtzP3yZ2sBaps0xFe3o/GAdxDsmBFOzDy/HTf5vZn2Cnk3ziKyaavuDf6armZo
	 KDtHET1EQifwwbg6k1W5CEZLvUOytoMx6c75qMZ8UQXIQTeDCezPL+tFQe7soITEpmUuf
	 poqDm0lpDtS1J/jeqD1A27/PRunZ5wl1Y392qruBpXs1N6KnTVUKqbAfcsYQ67O8DJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yogOUcOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC45606A31C;
	Wed, 18 Nov 2026 22:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yogOUcOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B6F1F000C4;
	Wed, 18 Nov 2026 22:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039935;
	bh=cHuRr6Lb9uhSNcPphj6Ls7gNCgi2JaiEJ0mQj8Jq5XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yogOUcOqBh6HKdG6nByLSYAmHu9/VWS1jdEOn8Eb7n1zQKKKYXLBnXYA1nCsJhTQq
	 /1+VN2MkhhNvXPw8+T/Q0Y5YCJ/a2uOhKCAh8feklHGDVNPqkIc8xKJQ+7t8+HQa7r
	 mbCAnocCJMTxXOtJn3uCY+1E732T26hl0yByS2rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2226/3318] dmaengine: mv_xor: kill tasklet on channel add error path
Date: Wed, 18 Nov 2026 15:47:28 +0100
Message-ID: <20261118150428.661778824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8b215cbca1186..7c1fdb2c91ce1 100644
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



