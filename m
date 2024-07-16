Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FAB19B59C;
	Tue, 16 Jul 2024 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145520; cv=none; b=FjmcL21+QjOK88uHdCNv8NMMMIjwBX9P+p+RuKZe3pV6x+VQDo5msyWRZAavc6IOaTnZskhas/rPoWMKogokr8vx01lQntcaJvrdU7UoUOgzCUBaAdHgJMt77Y0TcVEMTv5Bx+gtw5e7/TsC1kC0MZJl7OZpkO6XrqsHKxrcAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145520; c=relaxed/simple;
	bh=H/yR3sN67Yoww1uw+gpxaCzL0JFOzc4vun0jHNWnUIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zg+pquZtqPKWJep83ub+qIKfmX5eSjQivV/W1abYxl2wn41isWvxUk4EjOIwwivq8ZLLtIxgTF3u3ab4TEMnGjajLD7EjPSGDOAAme9QK+OEmMST4m9TVJW3AFfNW7ZMFU3EsziWzaWp57Q6/Fv2xgFnLQGPdiw3NvGvoECR384=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrCniTlv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrCniTlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED51C116B1;
	Tue, 16 Jul 2024 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145519;
	bh=H/yR3sN67Yoww1uw+gpxaCzL0JFOzc4vun0jHNWnUIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrCniTlvcAjpRu/NSlxg5bdA0PL2s32O6fQSWZXzhS9VsTs54tmZJWKJqeQlkzS/z
	 HmkwPbGh3EEau++4Z7NzSIUrbX1CczJCnTY1qEv40TxVw9TarVKfxJOVp9hVD6LSbZ
	 D33NQkNBZKq6jnOU8nLBLICJL54aauIkhz4oA8aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 92/96] i2c: rcar: clear NO_RXDMA flag after resetting
Date: Tue, 16 Jul 2024 17:32:43 +0200
Message-ID: <20240716152750.050838229@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit fea6b5ebb71a2830b042e42de7ae255017ac3ce8 ]

We should allow RXDMA only if the reset was really successful, so clear
the flag after the reset call.

Fixes: 0e864b552b23 ("i2c: rcar: reset controller is mandatory for Gen3+")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index c7a51e0876cf5..a006fef1d34b0 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -856,10 +856,10 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
 	/* Gen3+ needs a reset. That also allows RXDMA once */
 	if (priv->devtype >= I2C_RCAR_GEN3) {
-		priv->flags &= ~ID_P_NO_RXDMA;
 		ret = rcar_i2c_do_reset(priv);
 		if (ret)
 			goto out;
+		priv->flags &= ~ID_P_NO_RXDMA;
 	}
 
 	rcar_i2c_init(priv);
-- 
2.43.0



