Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC3919F489;
	Tue, 16 Jul 2024 15:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145215; cv=none; b=oNCC8GnX09OAeQggqj07N954r24d0thx8s7uIFVmrBBcj20uskS40ZLYUSuQf3qFQrUM1EecuPQxcE4iy/MDxQnH2oIQpFnAfn+kzcR7czi57DzQLAAovejZBv0nRXMN2vxCKYCjjMRWhvlad2UN7VHEYZUbE3K3mfmhJmGnOCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145215; c=relaxed/simple;
	bh=8gI9R9y71E7afqG1AoGD6bo6lj8v0OOJhqGPtVn/mYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTgiZGWNlpUDcugJkbO422eH4TKn15RnMypYPO7b9CQaKZ2S/eTKJbQVdaT6i8pauJXsVCMU1sBHYIOuyl46L6FSV5YfnrDMmASV5AfHKMLlmfN3JRfktuBXJds2fLHFYcfNgLgYXqtD25Esh133x0kUYvvLZWxn70lzUoKyIJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfxXtKWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfxXtKWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCFBC4AF0D;
	Tue, 16 Jul 2024 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145214;
	bh=8gI9R9y71E7afqG1AoGD6bo6lj8v0OOJhqGPtVn/mYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfxXtKWA4YFHgFkBhIdvZ8WleTHO+OBFxOlB3TFd/OXHBBcOLKZrLW2aSET/Rk0CH
	 JIvojpQsaNPSuzDYu+HC/2d3lFsQWs052BkiaWfOd4tQd+72aFWhDRn5NkTyK0Dwvo
	 B2mA403ih6MCwfmHJv9iu0w0OYvugxOkeMHYcHDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 136/143] i2c: rcar: clear NO_RXDMA flag after resetting
Date: Tue, 16 Jul 2024 17:32:12 +0200
Message-ID: <20240716152801.228105439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ec73463ea9b5e..f0724c8e4b219 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -911,10 +911,10 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
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



