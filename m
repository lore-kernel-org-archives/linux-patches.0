Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3F113B2B4;
	Tue, 27 Feb 2024 14:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043649; cv=none; b=PyAyKQzT3WayB5h9CCuTrqdXZ9SMVoD+QINCeKMLAEENQqKJ35PxXXryAqBu5aHoA7qXvyLtfhdCF2hh6yxIFIc65GZuV7dCtL0yrFgYXEr5/ro1l9ZJzzmYDMrc1VWXDICOTEYj+cAKy0DGxQduDMIahNXYcX9buUQ+vK9h6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043649; c=relaxed/simple;
	bh=atHfYaAjae53mhFZTDAyFdfEwYQwWnsoNRcIFqpHHoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbagQsXDGwILWB9M+8wHgq3Jv8NnyoePA9O76dZLH7V/C5wtHP3C8tvERuK9RB7rPPhftQfHJElvNUhnG4JD4qPqHI0243DugyWl52wMKDQn8cZl2T4uE8eOHCnOBW70VnmKD7yhw5BGhZOlg9enXWhs30FS5Voluvda/o4gIjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+xYn6w2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+xYn6w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6532BC433C7;
	Tue, 27 Feb 2024 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043649;
	bh=atHfYaAjae53mhFZTDAyFdfEwYQwWnsoNRcIFqpHHoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+xYn6w2fYhRjKu/33gJ9cyDEBF3+U1inVdvxjf8AXZUa++CNoO2pIyaBTByzU9xE
	 GR80mXM2ZAKUNhPxnH9PfqVsxEh8FkeQ5VZzDgFVEAouIMVGS9VpDANrVTB7qPisTe
	 h3FtoqkzJHZ64OyOhiKnsx47XgbiSYJKshy/Y89U=
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
Subject: [PATCH 6.1 184/195] i2c: imx: when being a target, mark the last read as processed
Date: Tue, 27 Feb 2024 14:27:25 +0100
Message-ID: <20240227131616.477786680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
index fc70920c4ddab..0c203c614197c 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -804,6 +804,11 @@ static irqreturn_t i2c_imx_slave_handle(struct imx_i2c_struct *i2c_imx,
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



