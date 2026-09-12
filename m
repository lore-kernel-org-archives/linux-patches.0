Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CB23491C9;
	Sat, 12 Sep 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238529; cv=none; b=EwLf0+6zyqPuT13+y6av5B5FdPJUgPc7i4SCWwT7Zaf2X03kfCzeAmyPXZAYzvm0Y25wgXmaOvV3OIqpTi14bZmy6Xm5GJkIEOQXSWxCYP0mGeUz7i3Xr8GWaPJNvuo4TAXWjcPNivPs6LFu5Sn8Cw3JxtpzJhkBw4XWsQeErYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238529; c=relaxed/simple;
	bh=qAiGetzfUF3r3jWYCTYEBqzqpPx9tIo5nE1VvuaA4HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdWwsAsal41ugP+8DwPhFRfYN4sJbL9gGNQQOzCMfVZBKO7iJ1sCl2jOODhwyZZOXqglF0aDhETBDwssye8ohBAEDx2P0+I7XHhYN/eiZ/yhZ6iwsxTLujjmltCgcUNmDvz1Gl0IMBrMBzm+bwBZwADcEwIDoPPzl0M5fD2q4RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOtoW2G6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOtoW2G6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F7D1F000FF;
	Sat, 12 Sep 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238527;
	bh=hVDaJ9hP3qNfr74/5DOME4eFLo6jZgQOzjfH4Kt8jHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOtoW2G6bFEuYfAGxx4xM9Riv1JozdltUuu/kXiCxdT13oxR1RomMayuCusPZMx1z
	 +PktPY/yg62Kzv7/sElHSJIpeCbQT5cGVtKfT6nDBTezl70FMLm5315jdZ/FhUM2NJ
	 qKH4Fuh5BzXAJjEwzTIqXfOE6DcWbyXRpRWIAOrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/935] iommu/mediatek-v1: Fix off-by-one in MT2701_LARB_NR_MAX
Date: Sat, 12 Sep 2026 08:58:29 +0200
Message-ID: <20260912065537.810758894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit aebaa93f3da1572877579c2e15ebf27be2dcc7fb ]

The mt2701_m4u_in_larb[] array contains 4 (for LARB0 to LARB3)
elements, meaning mt2701_m4u_to_larb() can legitimately return 3.
The current check `if (larbid >= MT2701_LARB_NR_MAX)` incorrectly
rejects valid LARB3 with -EINVAL.

Fix this off-by-one error by updating MT2701_LARB_NR_MAX to 4.

Note that this does not cause immediate issues with the current
mt2701.dtsi and mt7623n.dtsi because it only defines 3 LARBs:
    mediatek,larbs = <&larb0 &larb1 &larb2>;
Thus, larbid never reaches 3 in the existing upstream device tree.

Fixes: de78657e16f4 ("iommu/mediatek: Fix NULL pointer dereference when printing dev_name")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index 2e64755df3d0d..058a3569e7a49 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -80,7 +80,7 @@
 /* MTK generation one iommu HW only support 4K size mapping */
 #define MT2701_IOMMU_PAGE_SHIFT			12
 #define MT2701_IOMMU_PAGE_SIZE			(1UL << MT2701_IOMMU_PAGE_SHIFT)
-#define MT2701_LARB_NR_MAX			3
+#define MT2701_LARB_NR_MAX			4
 
 /*
  * MTK m4u support 4GB iova address space, and only support 4K page
-- 
2.53.0



