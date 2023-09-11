Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596281170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1B6C433C7;
	Mon, 11 Sep 2023 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442588;
	bh=VNDfZTpeMOp5jyqfhDhulsHJF/5ag3VhSaJcmVE2XFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFJNoKU50oEJv/gP9K3bOr7bK3wkfgWzcRPysb15bcOY1ShpKe4GSWO/isX1XiZuK
	 b1pY4lUhj/nbepjIJP3e+x1kCncLv7tFbs7p2Xly3pzfn0xMWr0DmR2fhEbTYZvp85
	 5mtFC+2mgDWSLyO+jq0vs8fuZ1dlM/sqqRfUkfgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Dong Aisheng <Aisheng.dong@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 077/737] i2c: imx-lpi2c: return -EINVAL when i2c peripheral clk doesnt work
Date: Mon, 11 Sep 2023 15:38:56 +0200
Message-ID: <20230911134652.664553456@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit b610c4bbd153c2cde548db48559e170905d7c369 ]

On MX8X platforms, the default clock rate is 0 if without explicit
clock setting in dts nodes. I2c can't work when i2c peripheral clk
rate is 0.

Add a i2c peripheral clk rate check before configuring the clock
register. When i2c peripheral clk rate is 0 and directly return
-EINVAL.

Signed-off-by: Carlos Song <carlos.song@nxp.com>
Acked-by: Dong Aisheng <Aisheng.dong@nxp.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 4d24ceb57ee74..338171f76daf7 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -209,6 +209,9 @@ static int lpi2c_imx_config(struct lpi2c_imx_struct *lpi2c_imx)
 	lpi2c_imx_set_mode(lpi2c_imx);
 
 	clk_rate = clk_get_rate(lpi2c_imx->clks[0].clk);
+	if (!clk_rate)
+		return -EINVAL;
+
 	if (lpi2c_imx->mode == HS || lpi2c_imx->mode == ULTRA_FAST)
 		filt = 0;
 	else
-- 
2.40.1



