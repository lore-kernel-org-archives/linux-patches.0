Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC91F1DDCE;
	Tue, 16 Jul 2024 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146355; cv=none; b=ITSwXCTYcm8lwHyDoBDSP9XZ1+du+k7iIAGNf1HULxH3r0//DMt7p3/ZiQ6rJIzkDmrKe8A/TG2ivN1sV4a+PsMcTraLQTG4MIm4rJv1DZN6czUfNVQREZ7O8Rgv3WMF6xSlneFi8PTzlT3DjHFDb5wdBzZlfhOPNL28GekvTwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146355; c=relaxed/simple;
	bh=WIrfYMbxCeQE8CLUhAHOFbtlZjZ47ce+8Fv0zGNes14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjUfWoCrY35idnrRgNwLchYSdjjfmzIRGcrKAgbeiPJmAqEZEi2RRm6NoTm1dFENYRUVfNiT6x2efAPkJ+FjLsUWOJV/TXgSsMyOVEVoi4mEulEzBQtX8cC3hZgahDgTepWQJQwsZIuc3Z3cmzy5W2uG2HeGBnhdJYa3utJj/gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzRAMJ4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzRAMJ4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73214C4AF0D;
	Tue, 16 Jul 2024 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146354;
	bh=WIrfYMbxCeQE8CLUhAHOFbtlZjZ47ce+8Fv0zGNes14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzRAMJ4U+uKzghIRenatslXg2y6D57cgInHQ7wS+pDDxKOVfX5Svtf+2VO1vUXXx+
	 WoLTWOghgHM+H3RN6sZ6H2Pv8or9bMr9q/IBfAZfWUKu1OzNMDvN6EJAubUx/QM+hs
	 bfoy0dQizLzOesZH4pja8zwt30eSsTnUSlfazhHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/144] i2c: rcar: clear NO_RXDMA flag after resetting
Date: Tue, 16 Jul 2024 17:33:29 +0200
Message-ID: <20240716152757.892495209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e24ced623c9ad..1b5ea222f4c60 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -835,10 +835,10 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
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



