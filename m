Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322C342315F;
	Wed,  4 Feb 2026 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217503; cv=none; b=eNjkfWvDW8wAepvAdekFS195A8FzUU2LoWzocWpppIeiMqGlH6QuA+bwqRC9oi500HUjKCh8Ig/jGZcoJO9aN5TuKDMW/mXejYlfUKcCfsWf7cQNl+EAIEN1K3EbgSnybjU105JE7U70uHdmwHE3EYOPosPpoyrjcBDklj5LVr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217503; c=relaxed/simple;
	bh=KKYoOaSbHCzKWYUpqqeBrPquhGt2tnBa7/W6cIib638=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPZVIqTmXPF9csfSSrGuHsCA3ObzwFINsryRgEgPqEbCj1hmi9d/FwR3kNoc3hMpVzdiXV4Dv7gXIPWLDjxYMDQU2Xoppmhqorcbk3D9SODS+qpR6R852E1vbK/wJm8i0SEd27q+mYApnYololG/MYJPRw8bIlQj7eKEMadD/t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNfY+xHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNfY+xHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56312C4CEF7;
	Wed,  4 Feb 2026 15:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217502;
	bh=KKYoOaSbHCzKWYUpqqeBrPquhGt2tnBa7/W6cIib638=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNfY+xHfNLoxqqqoL6nC6r+WXmHDnaHySi+SmatuMJ6fioB0cBNwDcKJ+arcOikdy
	 bgunRQxp4a5aOjhsMDQgxVXgvQWkbm2Ep0FIBQZkfeuBkEzn3GQ8uDP2pFOrKLSvey
	 1kJJHAdB4OeNiSy1pb9EiTEPFQV4+JryfUlzIOGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/280] phy: broadcom: ns-usb3: Fix Wvoid-pointer-to-enum-cast warning (again)
Date: Wed,  4 Feb 2026 15:36:48 +0100
Message-ID: <20260204143910.866348060@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit fb21116099bbea1fc59efa9207e63c4be390ab72 ]

"family" is an enum, thus cast of pointer on 64-bit compile test with
clang W=1 causes:

  phy-bcm-ns-usb3.c:206:17: error: cast to smaller integer type 'enum bcm_ns_family' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

This was already fixed in commit bd6e74a2f0a0 ("phy: broadcom: ns-usb3:
fix Wvoid-pointer-to-enum-cast warning") but then got bad in commit
21bf6fc47a1e ("phy: Use device_get_match_data()").

Note that after various discussions the preferred cast is via "unsigned
long", not "uintptr_t".

Fixes: 21bf6fc47a1e ("phy: Use device_get_match_data()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20251224115533.154162-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-bcm-ns-usb3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/broadcom/phy-bcm-ns-usb3.c b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
index 2c8b1b7dda5bd..5c2710597df2c 100644
--- a/drivers/phy/broadcom/phy-bcm-ns-usb3.c
+++ b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
@@ -203,7 +203,7 @@ static int bcm_ns_usb3_mdio_probe(struct mdio_device *mdiodev)
 	usb3->dev = dev;
 	usb3->mdiodev = mdiodev;
 
-	usb3->family = (enum bcm_ns_family)device_get_match_data(dev);
+	usb3->family = (unsigned long)device_get_match_data(dev);
 
 	syscon_np = of_parse_phandle(dev->of_node, "usb3-dmp-syscon", 0);
 	err = of_address_to_resource(syscon_np, 0, &res);
-- 
2.51.0



