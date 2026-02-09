Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3166A23D291;
	Mon,  9 Feb 2026 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647698; cv=none; b=LtdnBmSKkVb2uKFzdN8YKLYzgBb3fwfRVV1fonCG95j6+4aP0Vt5JF3hwhdT5c/yQXNGlMjHlPtDRVysA3lN6l3Hasd1m9z9zuGjzuejDze1uzJ/Pme5FvoT0kOuaSrRi2bu2GHGYn2J00DR6hEFInQytwvDnMv16UlwggbYtbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647698; c=relaxed/simple;
	bh=4wEU8F/Z/pFUvGstqlx634pa8OOx2/JZGaJFGBhmVN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0wFh4uJ9IBTi7IvQO/XIh5+Uip89GW5SKZBMLrDTEFurs0ECoBYdMFyHhSCTLWXqCsBvzY68+ngCRw8JFULCdKzfAWnu14mn41okpMrrFFucRwIYkLkGpvowuZnHsOk51SLN9yjcrNrwUf5TlJNK1ccoq09DFHLohMdQ8MMTyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpcibDmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpcibDmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E51C116C6;
	Mon,  9 Feb 2026 14:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647697;
	bh=4wEU8F/Z/pFUvGstqlx634pa8OOx2/JZGaJFGBhmVN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpcibDmjzrqEwruXY7pgfCIibPMLvHyHf6xyV7astYPBCgrwSHDe+uKSE9hVcRrqW
	 ZZxugu6TRCHCuhAqxIZZY2RKfOES4zlUpcknyV3SlEJL8D2E1dVH1cTyOGG9i47vc6
	 KI5M56N95OVhLI7WV9QzRp+BCWqMtEwlh22Sr+Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LI Qingwu <Qing-wu.Li@leica-geosystems.com.cn>,
	Stefan Eichenberger <eichest@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.18 163/175] i2c: imx: preserve error state in block data length handler
Date: Mon,  9 Feb 2026 15:23:56 +0100
Message-ID: <20260209142326.352297184@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LI Qingwu <Qing-wu.Li@leica-geosystems.com.cn>

commit b126097b0327437048bd045a0e4d273dea2910dd upstream.

When a block read returns an invalid length, zero or >I2C_SMBUS_BLOCK_MAX,
the length handler sets the state to IMX_I2C_STATE_FAILED. However,
i2c_imx_master_isr() unconditionally overwrites this with
IMX_I2C_STATE_READ_CONTINUE, causing an endless read loop that overruns
buffers and crashes the system.

Guard the state transition to preserve error states set by the length
handler.

Fixes: 5f5c2d4579ca ("i2c: imx: prevent rescheduling in non dma mode")
Signed-off-by: LI Qingwu <Qing-wu.Li@leica-geosystems.com.cn>
Cc: <stable@vger.kernel.org> # v6.13+
Reviewed-by: Stefan Eichenberger <eichest@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260116111906.3413346-2-Qing-wu.Li@leica-geosystems.com.cn
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1103,7 +1103,8 @@ static irqreturn_t i2c_imx_master_isr(st
 
 	case IMX_I2C_STATE_READ_BLOCK_DATA_LEN:
 		i2c_imx_isr_read_block_data_len(i2c_imx);
-		i2c_imx->state = IMX_I2C_STATE_READ_CONTINUE;
+		if (i2c_imx->state == IMX_I2C_STATE_READ_BLOCK_DATA_LEN)
+			i2c_imx->state = IMX_I2C_STATE_READ_CONTINUE;
 		break;
 
 	case IMX_I2C_STATE_WRITE:


