Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5644E2AD37;
	Fri,  4 Sep 2026 05:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500542; cv=none; b=VJ+U5IAsJX2oDuFUsFQK9sP5Mhs7HjwAb6jJTHYG2BcIOUlp4C2jEAVrt4El5/NvXsJho5/DYf1s9l3RTL9udaA/Vj/AKKXah42eUa9O0Tf9NWP2ei2Cg/3ZBcSsW5p13NBSfYvShkXFWGjCzNC9sSvKwKsinLFKLIcS01PqUxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500542; c=relaxed/simple;
	bh=qyfmhTsqKUZBDqKZ+mV34N0rvdwIMuPmd4+JAlbYJyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A362l7WIn/2FavZV3xlTKSmSil+z9SeOtxwk2BK8M9aR5EG4kwior9ckBa8tQVHEdbdSJ5/gO63+xwGWFqDwYFVD7xAtS/EIM2KmLEDN1NwOdpZzmTvPSQEWtQkXbazG+5Eh5WyUIwrNRKDNQN4aIodNoCoSlLXQUj0wQH2mf50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUbbRGOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUbbRGOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2031F00A3D;
	Fri,  4 Sep 2026 05:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500541;
	bh=DhU9gR4hnmBjb7DzdbF8wqV/1IzcwCSUt8pUeQxYg38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUbbRGOrE749ZD/2R9k8SKiLKojX0/xxBXvG0xNtRlUVUQRG3geaoqQb38ZlDX5LM
	 eWGVJlfqKjh8Zrdm7pK/FKJd3TwAF0V29AK+LmkHsYvpBXdMbsFmD4EOGLklkkAyHe
	 /s6fTEhulYrpiB69MpMRh3i2t7SQqh5PfoVkBDAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yang <jason98166@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 093/552] phy: rockchip-samsung-dcphy: fix out-of-range max_register
Date: Fri,  4 Sep 2026 06:54:10 +0200
Message-ID: <20260904045749.992602992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -1525,7 +1525,7 @@ static const struct regmap_config samsun
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
-	.max_register = 0x10000,
+	.max_register = 0xfffc,
 };
 
 static struct phy *samsung_mipi_dcphy_xlate(struct device *dev,


