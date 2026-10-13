Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01134EF135;
	Tue, 13 Oct 2026 11:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892462; cv=none; b=Fiujcf4jUYeNXRnYp/Le8CEwqw9B5FACoVeY6iRpcrmK7OZSpQAqCfjHG2yx7ZAs89bBqWJFDYwn82tcTm9ZXeKi4Iep3iTNkLI5PWHrurplisxquYU9w6Y4AsQFtssqFHxZF2l5XSHnFXx8LZVmcARJRizMOerRbGt3q8/LTcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892462; c=relaxed/simple;
	bh=QvkJE2EfbYS4Sa1SEagn9ucqi5eMqRF+t+O4L/zgxZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJhE9dNi1er5iUUsPJtDJBbHWj2HLWFmwLqZ2d/rnXEbKn521aXzlwhIc9Y3kBRCcghMy0+M38+niErG4klZpKsOQD/6ButiouXrIq2dSD9qYvJUrHpkt5clI3Oqj/O+7VLBNbllgkb0zGm9ILnOCOgvRIGO2EfSKZG+BeOn3oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9IGL7fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9IGL7fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084671F000FF;
	Tue, 13 Oct 2026 11:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892461;
	bh=ppnvmYEKkn/UzBLTEs7DPH0T96PHPqMsJEiRU6qN5Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9IGL7fmd7Dk0F3QJx+82RGCInEDaCeHsLyXx/qDVXYSrI/cmorjcToteZIy3Bzqh
	 JIt4MO4aAujYqLxO7fySzdbrR9c9HBkqYbcwWFMUUcWf9Du/vXiNYPCNyLUlE5ccY0
	 rNLLiu9lythQ5wp5mX4d8Nqjf3recUKYRztVHpV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 182/281] arm64: dts: lx2160a: fix the iic5 spi3 pinmux offset and value
Date: Tue, 13 Oct 2026 13:38:18 +0200
Message-ID: <20261013112859.582803374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit f14f4dc8ea3810f8ed4f0f3ea13f8bba3e2b0f04 ]

The iic5-spi3-pins node has both of its first two cells wrong.

The offset selects the register within the node's reg range, where:
  0x0 is RCWSR12,
  0x4 is RCWSR13,
  0x8 is RCWSR14.

An offset of 0x3 is not one of them and is not even aligned for the
declared 32 bit register width. It is the only node in this pinmux that
does not use 0x0, 0x4 neither 0x8.

The value is wrong too:
  IIC5_PMUX is RCWSR12[11:9] and it encodes 0b000 for IIC5,
  0b001 for GPIO_1[25:24],
  0b010 for SDHC1_CLK_SYNC_OUT/IN,
  0b011 for {IIC5_SCL,IIC5_SDA} = {SPI3_SOUT,SPI3_SIN}.

This node selects the last of those, so it needs 0x3, not the 0x2, which
is the value of the neighbouring sdhc1 clock sync node it was copied
from.

Fixes: 284ad7064aaa ("arm64: dts: lx2160a: complete pinmux for rcwsr12 configuration word")
Reviewed-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 8f33dd26577fa..6ead557a8cf19 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1783,7 +1783,7 @@ esdhc0_clksync_pins: iic5-sdhc-clk-pins {
 			};
 
 			dspi2_miso_mosi_pins: iic5-spi3-pins {
-				pinctrl-single,bits = <0x3 (0x2 << 9) (0x7 << 9)>;
+				pinctrl-single,bits = <0x0 (0x3 << 9) (0x7 << 9)>;
 			};
 
 			i2c5_pins: iic6-i2c-pins {
-- 
2.53.0



