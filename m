Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B86E13AA4C;
	Tue, 27 Feb 2024 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043113; cv=none; b=csGa0noO/0hfc1hKlLOOVAxht7SyVR6djVg5Z4eULll/3L7FzgkRl1e9VfJrK5HfMLwPzjpIGea0Wz1rhaPsuY7r7N2DxSKBwzgAac8ZQbIRRgpH7OYNjpcwA+ZjeAFWCu7ElqCuBY4xU90FZ9kkbZQjSiRucKukFqACaDD4Wqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043113; c=relaxed/simple;
	bh=2FOaGcfrqOVfDImTVlZS5Roheq3vQ9MXJVsP81OZ8cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdKJtjQuqgRtHbuchWXm1NJgzk7LAzysEQUIM4hFckPdCIKFy4IkF8XmXNuuHCxsqakm0l49ANz0/2GOW8lFbmElxyhH2HEK81aCfKJrRqbURxIPBFjSa5/dujmMs3pAOPZqWBs5Sgk4JWPN+Xs5NrFt3W+2Ksj5skjoK5pez3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2a7Re039; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2a7Re039"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B90AC433F1;
	Tue, 27 Feb 2024 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043112;
	bh=2FOaGcfrqOVfDImTVlZS5Roheq3vQ9MXJVsP81OZ8cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2a7Re039BmG1QfpnjfKgiRWPPoP8sraa9G0cbOpzAVcAE4I4x+YyyyFfVWbT9mGAF
	 2HH7ZsvdASqeiCDFVREfS/SfItJsw1xhoC5xue7QjesVgTYAvFp5LJMvI9WPU9cm3a
	 D21ilzwu1njjtl7GpDdtR3DxKTTeWFT8PCqBLbzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <minyard@acm.org>,
	Andrew Manley <andrew.manley@sealingtech.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/245] i2c: imx: when being a target, mark the last read as processed
Date: Tue, 27 Feb 2024 14:27:06 +0100
Message-ID: <20240227131622.901148156@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Corey Minyard <minyard@acm.org>

[ Upstream commit 87aec499368d488c20292952d6d4be7cb9e49c5e ]

When being a target, NAK from the controller means that all bytes have
been transferred. So, the last byte needs also to be marked as
'processed'. Otherwise index registers of backends may not increase.

Fixes: f7414cd6923f ("i2c: imx: support slave mode for imx I2C driver")
Signed-off-by: Corey Minyard <minyard@acm.org>
Tested-by: Andrew Manley <andrew.manley@sealingtech.com>
Reviewed-by: Andrew Manley <andrew.manley@sealingtech.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
[wsa: fixed comment and commit message to properly describe the case]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index d545547c89ca7..fae674969628b 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -771,6 +771,11 @@ static irqreturn_t i2c_imx_slave_handle(struct imx_i2c_struct *i2c_imx,
 		ctl &= ~I2CR_MTX;
 		imx_i2c_write_reg(ctl, i2c_imx, IMX_I2C_I2CR);
 		imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+
+		/* flag the last byte as processed */
+		i2c_imx_slave_event(i2c_imx,
+				    I2C_SLAVE_READ_PROCESSED, &value);
+
 		i2c_imx_slave_finish_op(i2c_imx);
 		return IRQ_HANDLED;
 	}
-- 
2.43.0



