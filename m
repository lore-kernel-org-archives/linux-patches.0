Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A715E8B;
	Mon, 30 Dec 2024 15:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573935; cv=none; b=lHn736eSS/UKge+u+UtWHNgBvVhjwISt8tXtO1oUa0Lqvgpvti92OpdBPIi815bIKKNVyQlTa3j6FH3PJXEikmWHZsE0TRxityS9j5z4NVGg5g5bC8VCaee4z4j/tiCwdagj3iKLJy8/vtOcS6MoesDw/2pvQB8PtynOp9m1gog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573935; c=relaxed/simple;
	bh=R1JuZ2PHIRxFrHIZNzNQIjyiWT16aL/DB1d6miYdm5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQfaDPz/D48A3ddDv34a84CYggKS4wZpqQRsELLbAl47ZZk8bEqKFWA7Hfq8P1FS27ikx7ZpSICPs8kUHyKV5s/hRyJzQYaf/hWmtQUslrLbCu1VU0j8GhZ+kMEJnbR9wZH9dVPNoxb2DPSqzHBD06xVZjUow3YCQLFz3LCdehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cixOQMLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cixOQMLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEE6C4CED0;
	Mon, 30 Dec 2024 15:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573934;
	bh=R1JuZ2PHIRxFrHIZNzNQIjyiWT16aL/DB1d6miYdm5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cixOQMLb1ah1GzS/yiuHNXExm/d8kuNSXscgU9PrgsFVXBzC8goizgesHqd/5iP4N
	 vI7HlnsPGqoJTJPx5C+eBTbXNgL8EUry0HyVBxVwlLgh3XD1ESL9iSXqaQR2AnEV1Q
	 8UI9rpujjMzwbB0cO43w1Dde/5BIg4lqFSXcyit0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 78/86] i2c: imx: add imx7d compatible string for applying erratum ERR007805
Date: Mon, 30 Dec 2024 16:43:26 +0100
Message-ID: <20241230154214.669703077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -286,6 +286,7 @@ static const struct of_device_id i2c_imx
 	{ .compatible = "fsl,imx6sll-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx6sx-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx6ul-i2c", .data = &imx6_i2c_hwdata, },
+	{ .compatible = "fsl,imx7d-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx7s-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx8mm-i2c", .data = &imx6_i2c_hwdata, },
 	{ .compatible = "fsl,imx8mn-i2c", .data = &imx6_i2c_hwdata, },


