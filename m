Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A113BFACE;
	Sat, 12 Sep 2026 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203285; cv=none; b=oISbM7sDUJ+08947l4oe6ST84F4Oz6jTHwYVHWp8jH5d77/JeHsu1NVRA7EtgbwgHhNN6fyMYBL/lwKNp4FtpV0lUlauk9Z6SCY4VrboLqLFYoULn1VZvis2k+y2HIgTm6osjHSwoBKY4aaeSkjGZbhbKvzXvIh0xg59KkLFHzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203285; c=relaxed/simple;
	bh=sawnNNgNLt4AVOVe+aXIDJmwyOU08/bB/drnD1CZ94Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQDX66DxhEXC4HDDAAmgP3ogoOA0cd6LgvcWISlvjs4YVqGAa5xqCRvo3gBxyJp7+0XSdobMjCPlfmDfvn6Gg9u+vJDqPg6x4QO0L/rMTPmhlHQZZOq/j0CMs+ey2upak1Lf82w3QLv2xR2ULTsmfxyY47EKzp0Lx8sp5i1oevg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1EK6BbN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1EK6BbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889FE1F000FF;
	Sat, 12 Sep 2026 08:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203284;
	bh=k6si9MkGX9V4206ptpDdB3y5u26GcFP9nBTKaO6rejI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1EK6BbNZc5HPOd1ktF0rjoImeNTlTH83wi3ywKXHvqMWFRc/ZLRsl0Hj06p1P921
	 Cq3R4HkQbPoxDNFiNvbPqYqv3fQ/DUAxCAQ3U8M98U0ovoZ3RLPFt2hpXlU/6ZNOmm
	 VnVoFHPQl9+aL70rBtmCYViz3+6hssWHh15OvpFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Glass <sjg@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1324/1815] pinctrl: rockchip: Decode drive strength in the get function
Date: Sat, 12 Sep 2026 08:51:14 +0200
Message-ID: <20260912065720.106372091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Simon Glass <sjg@chromium.org>

[ Upstream commit 8aa25c6e8893ed911b0cad37a5562fda9bc98438 ]

The decoding of the 2-bit and 8-bit level drive-strength values sits in
rockchip_set_drive_perpin(), where it is unreachable: the SoCs whose
banks declare these drive types (RK3506 and RV1103B) take the early
ctrl->type branch in the set path, and the read-and-decode logic in a
set function has no purpose. Meanwhile rockchip_get_drive_perpin()
lacks the decoding, so pin_config_get() and the debugfs output report
-EINVAL for these SoCs.

Move the two cases to rockchip_get_drive_perpin(), where they belong.

Fixes: dbd2317d7b9f ("pinctrl: rockchip: Add rk3506 pinctrl support")
Signed-off-by: Simon Glass <sjg@chromium.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 38 +++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 08084ed2cf1bc..7f7ea3b3638d9 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -3267,6 +3267,25 @@ static int rockchip_get_drive_perpin(struct rockchip_pin_bank *bank,
 	case DRV_TYPE_IO_1V8_ONLY:
 		rmask_bits = RK3288_DRV_BITS_PER_PIN;
 		break;
+	case DRV_TYPE_IO_LEVEL_2_BIT:
+		ret = regmap_read(regmap, reg, &data);
+		if (ret)
+			return ret;
+		data >>= bit;
+
+		return data & 0x3;
+	case DRV_TYPE_IO_LEVEL_8_BIT:
+		ret = regmap_read(regmap, reg, &data);
+		if (ret)
+			return ret;
+		data >>= bit;
+		data &= (1 << 8) - 1;
+
+		ret = hweight8(data);
+		if (ret > 0)
+			return ret - 1;
+		else
+			return -EINVAL;
 	default:
 		dev_err(dev, "unsupported pinctrl drive type: %d\n", drv_type);
 		return -EINVAL;
@@ -3390,25 +3409,6 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 	case DRV_TYPE_IO_1V8_ONLY:
 		rmask_bits = RK3288_DRV_BITS_PER_PIN;
 		break;
-	case DRV_TYPE_IO_LEVEL_2_BIT:
-		ret = regmap_read(regmap, reg, &data);
-		if (ret)
-			return ret;
-		data >>= bit;
-
-		return data & 0x3;
-	case DRV_TYPE_IO_LEVEL_8_BIT:
-		ret = regmap_read(regmap, reg, &data);
-		if (ret)
-			return ret;
-		data >>= bit;
-		data &= (1 << 8) - 1;
-
-		ret = hweight8(data);
-		if (ret > 0)
-			return ret - 1;
-		else
-			return -EINVAL;
 	default:
 		dev_err(dev, "unsupported pinctrl drive type: %d\n", drv_type);
 		return -EINVAL;
-- 
2.53.0



