Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86B7352FA8;
	Wed, 21 Jan 2026 18:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020172; cv=none; b=n2+ya0iCNGZmxcpPEigvdYun7NebkEwlOi1UE4n/2H0Ld0OoRwTn+l6Lb8qRHU7hssQUxjtpuIDMstSS5urv6dOgyX+B0vTfiv6CBIkLfvY7UcIfgS8kJn76GiuG3VCht7mU607vJG6zSJrcqXW2AWCPLLuqb/sexQduDtdDGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020172; c=relaxed/simple;
	bh=msCbn1r/2Q6A08qTQBojfFhRA90AD0fcFg/xwtFTZx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiZO3muJU/HLjnaCuBt8LV4bLsotmRaOVN9TsChdwZDHTAkU5tfhier6wVaCx1TwWbycXpkAbrsd2k4KmGxNcr3C5N8BngbRVE7ZgVC6TwJWA0nIt+6cDZe6VmhK6CQc+lD6o1ZswUpvgh7an9cFKe69s/0jVb8d6xMsUltTFeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kG1A/XbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kG1A/XbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BC7C19424;
	Wed, 21 Jan 2026 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020172;
	bh=msCbn1r/2Q6A08qTQBojfFhRA90AD0fcFg/xwtFTZx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kG1A/XbT7bU99TLczyM9aW19bAupC3kVvvvF9I5W5TaVn8ijJB4wb+cPtd2nbQlXQ
	 C+ttEwJyGCHJ4j9OYekAFpxfaPHV658oW63fzZk+BmwePOX7+E2agemCx8669Y+vvS
	 SZwVmESfebEEZgtNUxFdwqiST+B+h5eHihClSt7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/198] phy: broadcom: ns-usb3: Fix Wvoid-pointer-to-enum-cast warning (again)
Date: Wed, 21 Jan 2026 19:15:09 +0100
Message-ID: <20260121181421.476291509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
index 9f995e156f755..6e56498d0644b 100644
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



