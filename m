Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1E240F75A;
	Fri,  4 Sep 2026 05:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498746; cv=none; b=rdZWc8TmrGFaBZ6+0Gj1RbZnRK8BOhQwuSg1TkfzdxVD5KCRgpsnAeP3ticswZQLef334VKHfXd80Yb2MrMoQqz5JG0KdVU2Y/3ii8fd9M8VbsZvZhT1PbyI7MMMt9ELRN3yB1rDNb1UU1JzHkv8FTx+DWRwyj0ZvKGJgApEkpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498746; c=relaxed/simple;
	bh=fbgB1SjGEqIQFaInm8ycMjIbZUgNxNPG64mGLzU/77g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEQTCnsZN1TLjRsfNZMfWtbiHomRBSZqqFBH6ris4oR2CICuxLJnjf8yvSQFmB3YAY0jpOgIsyKtEnCj+SRp6kAKvcHrInoy9F38ytIPoilbRkaK7chWIy17Uu9Cg8vSn3jUTC5tkWSCl+VDJAHuyKrMdt6juzuMejHoNr+HUkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a08AKuh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a08AKuh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EBD1F00A3F;
	Fri,  4 Sep 2026 05:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498745;
	bh=3pxIboFVuNRbLDd0CNCXoKldFtY1wg6vZRzu2OQR9N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a08AKuh3ImaB+uaLpx4Mg/xNHNqljFPn7CnM3f6Nang64g3Ek3MeTjoRvswTD8eIR
	 P9VlWXOonRCrARPbVOknh5M0b5WDVsRHX15Ih2YhtV2EXPdlieOyBJhh/g7XjTa7Ez
	 jmdNgDJNZjw4I+PUSh1YgNipyPH9pLm1X/nOnPQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yang <jason98166@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.2 129/713] phy: rockchip-samsung-dcphy: fix out-of-range max_register
Date: Fri,  4 Sep 2026 06:51:37 +0200
Message-ID: <20260904045806.723468408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jason Yang <jason98166@gmail.com>

commit 4486e75ba647bd8b98fc1f053101b40caceeed4b upstream.

The PHY register block is 64KB, so with a register stride of 4 the
last accessible register sits at offset 0xfffc. max_register names
0x10000, one register past the end of the mapping: dumping the
registers through the regmap debugfs interface reads beyond the
ioremapped region and oopses on the unmapped page. The oops fires
with the regmap lock held, so later PHY operations deadlock.

Fixes: b2a1a2ae7818 ("phy: rockchip: Add Samsung MIPI D-/C-PHY driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Yang <jason98166@gmail.com>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20260811-dcphy-maxreg-v1-v1-1-aa63f6a63a64@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c
@@ -1526,7 +1526,7 @@ static const struct regmap_config samsun
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
-	.max_register = 0x10000,
+	.max_register = 0xfffc,
 };
 
 static struct phy *samsung_mipi_dcphy_xlate(struct device *dev,


