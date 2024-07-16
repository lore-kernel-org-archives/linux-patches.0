Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A45619AD93;
	Tue, 16 Jul 2024 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145906; cv=none; b=VdqRgmuaxc1ppEIMiO37Kl7aGW6/K0vC/YVHjowGoUaYqxuOt6JgqM2xMKxTCMzU+ZDKJ26exdn6dhkZhR2ASvYhh1YkNHTafiYKOl2sRZDz9ftl3AHZ+XA4gWCT+qsHWmagLDxDZDWMw1c0m2EzmVn9T3U4fB9NOE9ebwaKVVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145906; c=relaxed/simple;
	bh=Dh91e3V+CQrJ6ZHOqaoQNTHKcCoOtVf9zS8jILJ9HjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOnwC2ddmEqLnDhFbwKjqMIt03vpCEOtPTAJ1HlwdUTbVoftijthfS+HFHKwQUg/ldM5qZJ00h0qg+dZkC/Lc+V8bp2K3dIADEjjyzQ5vYJe2Il4r9K30vKvaK2+bpdWoXfoiv8ycSyMBcX8bIrUCOvMCPr7wjrwjBrdY9Qr32E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPiuGF6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPiuGF6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21590C116B1;
	Tue, 16 Jul 2024 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145906;
	bh=Dh91e3V+CQrJ6ZHOqaoQNTHKcCoOtVf9zS8jILJ9HjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPiuGF6J1zQQFaUSX8S9KhuqozK4kPkK3Izz88K9ZmWfIf30rs2i0BT8OqY5wLRkF
	 OgbXepTGdU+nx6/v+Fn0AM4r6Q5qR9tj3hqg816xjcHBI9OYwIG/syXl4OSrfO82sR
	 TAp0XhS8TnUw1MaEQ2XeNqaMJ6exKY+ZghvQA8Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/121] i2c: rcar: clear NO_RXDMA flag after resetting
Date: Tue, 16 Jul 2024 17:32:58 +0200
Message-ID: <20240716152755.790188040@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0ba88d44a7dbe..1d341bd2b4b96 100644
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



