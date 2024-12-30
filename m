Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B112AE68;
	Mon, 30 Dec 2024 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573671; cv=none; b=XkJ48RMDqasJ8sgqk6KPRGFFj0hKDt96nFC/QCOvnhmCQm+DdlurUzF1jsOhcHTH3cmgWShFQGUWYabeDqmgzGqISC7UZ0cLAhTdmxnrzvc3l7nRruiJa5QxtdVaZfB4+hmrS0HdoF0RHQvMWk+edBw3YzLGqmjq5oTUZqkw+38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573671; c=relaxed/simple;
	bh=wJ2h7nJQWnBB7XXdHqD/cR+4nHtosXFSRVSJz1Ssu2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuPT8IaZhTLMGV2psu+Vq0UW5TX1nAvys0O3xLjZzctCGEpnjw1k9cWx6I6nXPuI0dwo0Jc+hTE6nTyPGh/nZtJBhQG9JV4QmnUwml05Hb/Fu0uHE9aOaJ2Ex90q2h1VUImhn6/OEwCXsN+mdUplqrH/g3Xg2kaXUwngu0G/anw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVKVaRXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVKVaRXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842B2C4CED0;
	Mon, 30 Dec 2024 15:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573670;
	bh=wJ2h7nJQWnBB7XXdHqD/cR+4nHtosXFSRVSJz1Ssu2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVKVaRXhyYFDSkOanplKUtkGcsT+SmmdOcomz1V1iRn6+Zq/33Ytw5+Kf7HLnmxZS
	 ByAjfmqcOUTsBdebYcMSwBjVFGwYvff3V9dWQZmVFC1SdaeCASm6hUAYr+7AcXc4Ly
	 ZugNi8E2HUIekw9XkmGQXce7e8QwPTlDRBMBsxmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 53/60] i2c: imx: add imx7d compatible string for applying erratum ERR007805
Date: Mon, 30 Dec 2024 16:43:03 +0100
Message-ID: <20241230154209.286395404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Carlos Song <carlos.song@nxp.com>

commit e0cec363197e41af870613e8e17b30bf0e3d41b5 upstream.

Compatible string "fsl,imx7d-i2c" is not exited at i2c-imx driver
compatible string table, at the result, "fsl,imx21-i2c" will be
matched, but it will cause erratum ERR007805 not be applied in fact.

So Add "fsl,imx7d-i2c" compatible string in i2c-imx driver to apply
the erratum ERR007805(https://www.nxp.com/docs/en/errata/IMX7DS_3N09P.pdf).

"
ERR007805 I2C: When the I2C clock speed is configured for 400 kHz,
the SCL low period violates the I2C spec of 1.3 uS min

Description: When the I2C module is programmed to operate at the
maximum clock speed of 400 kHz (as defined by the I2C spec), the SCL
clock low period violates the I2C spec of 1.3 uS min. The user must
reduce the clock speed to obtain the SCL low time to meet the 1.3us
I2C minimum required. This behavior means the SoC is not compliant
to the I2C spec at 400kHz.

Workaround: To meet the clock low period requirement in fast speed
mode, SCL must be configured to 384KHz or less.
"

"fsl,imx7d-i2c" already is documented in binding doc. This erratum
fix has been included in imx6_i2c_hwdata and it is the same in all
I.MX6/7/8, so just reuse it.

Fixes: 39c025721d70 ("i2c: imx: Implement errata ERR007805 or e7805 bus frequency limit")
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Fixes: 39c025721d70 ("i2c: imx: Implement errata ERR007805 or e7805 bus frequency limit")
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20241218044238.143414-1-carlos.song@nxp.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -287,6 +287,7 @@ static const struct of_device_id i2c_imx
 	{ .compatible = "fsl,imx6sll-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx6sx-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx6ul-i2c", .data = &imx6_i2c_hwdata, },
+	{ .compatible = "fsl,imx7d-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx7s-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx8mm-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx8mn-i2c", .data = &imx6_i2c_hwdata, },


