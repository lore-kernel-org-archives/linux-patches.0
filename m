Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756064F7CAA;
	Tue, 13 Oct 2026 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895950; cv=none; b=AemTXvG8vY7kaCwr5uHui5wMyX1VCV1i6L4NTr2YBVUQGEXL5Bmw85rOz6Qeb/rYkubWmG9dcI2FTBHtoiAbVXd99z2ctENUO6w1POQO4v1pczkxtg5YxxOxUyPxoZrLhsUilDa2r0hovLDpfCFxIe0jYai1Bj5c3TlTu4c2efc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895950; c=relaxed/simple;
	bh=FuwkE4oOohWicFiAtZ3GVfJ4XR2xvQy643elC6IbHR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hn09txSHdXxwTilXGeQFy8ubSQkbXCiRp0pZUS/hr93C4nhJ5JfaBWcCkhXG9Tq0vNaKbvT73gQdMlyF8CIIOgMl5eb8pEU7dUgfJcu14v9ETfOp0sI7jpcQo0Iyw5RUQxi/Lqq/b1b80b38B8XeyF/w/jsEqurSf3DwoROBTrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsAwlmBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsAwlmBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6E41F000FF;
	Tue, 13 Oct 2026 12:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895949;
	bh=Qe/1DB2mWc255CkOtkHnvOsjlg+VVMV+gJkLWZ7/cCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsAwlmBET2j1/RD6fnFKrAGelfoli5qV9ttHS7hUhL30MQJU+vXuH63RkTCZX8mc+
	 WQnCjNfX2D9/KbSHe9Z2DnRkaTnY8K5tb/fCaZMl0HXJy6Da02tNu6oJNQwQZsJHm9
	 2T8im2PeS2xEe5U6m9NM8WU87MXDKDM74ZGHjZBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 446/497] arm64: dts: lx2160a: fix IIC1 pinmux submask rejected by pinctrl-single
Date: Tue, 13 Oct 2026 13:40:13 +0200
Message-ID: <20261013112918.468973043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit 6affdda171ca8f2e082e8c4fba56233a2f8c9910 ]

IIC1_PMUX is a single bit field at RCWSR14 bit 10, so the mask for the
two iic1 pinmux nodes was narrowed from 0x7 to 0x1 to avoid writing the
two reserved bits next to it.

With pinctrl-single,bit-per-mux the driver does not take the supplied
mask as the bits to modify. It derives the field from the node's
pinctrl-single,function-mask, which is 0x7 here, and then requires the
supplied mask to match it exactly:

	bit_pos = __ffs(mask);			/* 10 */
	mask_pos = ((pcs->fmask) << bit_pos);	/* 0x7 << 10 = 0x1c00 */
	submask = mask & mask_pos;		/* 0x400 */
	...
	if (submask != mask_pos) {
		dev_warn(pcs->dev,
			 "Invalid submask 0x%x for %pOFn at 0x%x\n",
			 submask, np, offset);
		continue;
	}

A one bit mask gives submask 0x400 against mask_pos 0x1c00, so both
nodes are rejected and the pins are never muxed with this message:

  pinctrl-single 70010012c.pinmux: Invalid submask 0x400 for iic1-i2c-pins
  pinctrl-single 70010012c.pinmux: Invalid submask 0x400 for iic1-gpio-pins

The values are not changed:
  - 0x0 selects IIC1
  - 0x1 << 10 selects GPIO_1[3:2].

Fixes: 7a3cc49ad1fc ("arm64: dts: lx2160a: change i2c0 (iic1) pinmux mask to one bit")
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Reviewed-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 25efd1f60eaec..96b312dfc5a05 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1864,12 +1864,19 @@ i2c6_i2c7_pins: iic8-iic7-i2c-pins {
 			};
 
 			/* RCWSR14 */
+			/*
+			 * IIC1_PMUX is a single bit at RCWSR14[10], but bit-per-mux
+			 * uses the mask for the field to clear before applying the
+			 * value.
+			 * So bits 11 and 12, which are reserved, are written as 0
+			 * on every mux switch, it is harmless.
+			 */
 			i2c0_pins: iic1-i2c-pins {
-				pinctrl-single,bits = <0x8 0x0 (0x1 << 10)>;
+				pinctrl-single,bits = <0x8 0x0 (0x7 << 10)>;
 			};
 
 			gpio0_3_2_pins: iic1-gpio-pins {
-				pinctrl-single,bits = <0x8 (0x1 << 10) (0x1 << 10)>;
+				pinctrl-single,bits = <0x8 (0x1 << 10) (0x7 << 10)>;
 			};
 		};
 
-- 
2.53.0



