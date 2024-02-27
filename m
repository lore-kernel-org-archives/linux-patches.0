Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700CE13AA50;
	Tue, 27 Feb 2024 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042421; cv=none; b=muLccr9qFJglUYOACV/H24w4KYzkq/olTUsz1Y8uSP53JkVG+KfCFx+P42zcohI90N7Uhcw7LSAixsVB2Wg8mmh/RhNRoKgq72tSVL5WHT3rkiVzqmhDKQFaFqlUL26kpqvda6KlNqTGb1NwLF4/iFk5iv4HWAMYJf1aPc1vc+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042421; c=relaxed/simple;
	bh=UaFbNjX0ks7d8ZJn+EKE0Fas9zF9I+khVN8pRwY+cpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYME8bausJWBVJvhvm90KS03lGcyqls3mvjYfWizfYBnXr9SuP/HcRPw9XIoWiKgBtzrGG5GK6HOj1UQVO0TabMUaQqSKn9PWb3l+QeRTP5f4HZr7TbsuTEipYo6sI3JOQgwYbOrRL2wyAibiTLJrbGCdDAk3FULOJ+X0kqwhvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aW+5u8lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aW+5u8lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB78C433F1;
	Tue, 27 Feb 2024 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042421;
	bh=UaFbNjX0ks7d8ZJn+EKE0Fas9zF9I+khVN8pRwY+cpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aW+5u8lzYeovk7i7hjtBat0YNE9rbKz/utZUfa7cBwbQxY2BWkZHs95tRSlKFOXGv
	 ZvlnFR2lczJvHqVF6sEJ0vFkIc1MuP97u2emJrpbHJwmAbA45hUtfV04zDRSDddD48
	 nY5jPpbR65+rtIomiOYEPqEYuWpXnLU6rPgq8TM4=
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
Subject: [PATCH 6.6 290/299] i2c: imx: when being a target, mark the last read as processed
Date: Tue, 27 Feb 2024 14:26:41 +0100
Message-ID: <20240227131635.003493660@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
index 1775a79aeba2a..0951bfdc89cfa 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -803,6 +803,11 @@ static irqreturn_t i2c_imx_slave_handle(struct imx_i2c_struct *i2c_imx,
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



