Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595C221018A;
	Tue, 17 Jun 2025 16:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176078; cv=none; b=JJgfJPmx22S8a5YdIOFkrz1oyqn5uhZgIDOCVKh1PwT2pIiQEojw+qDqt14OS83gxmit5i5qGSQh8qBaWOCk2F/Qlt1krG3ngpx/dh0kyEHbF6amPUs39IlsW6ypuHDSMerNrZt9Rp/xqQO3qj95XMKFSLyHh7ARFY916u2asWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176078; c=relaxed/simple;
	bh=JjBpgtKwzGqEx8R7mHAiGT1hJ+yzwu9NlGZ9eZygxt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs4AOFeCjaU+aObISBMHAsNoh2QFVgdcYC6tzfRXgmcyogHZhnwE4zopyosqRV2jQ7z0g+2fkZnbnDTdmA4Vf3OIAZbC5R+Mi3G3g4DKX3M+5UuW4ExVLZDEAicwgo058gh6sQRkWbksgrX/sfGCQ9Sqy0WqJuNgAc8An4QKK1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4kKaRl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4kKaRl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCECAC4CEE3;
	Tue, 17 Jun 2025 16:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176078;
	bh=JjBpgtKwzGqEx8R7mHAiGT1hJ+yzwu9NlGZ9eZygxt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4kKaRl0sas13L9w7gmS4VQawvnPiZLRuchZqf/JNXJRWyV4BiG6XFB7GEtMUv1Ru
	 3PedS074dQyQi5dO3zJ4TuUxYIucWmkYzRtQonrLTj99SLuMrEsjQDY/bK09pDO+eR
	 +Slsu7d8BilmlgJwcorOJST1t4YNo065PgVL0Lfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/356] phy: qcom-qmp-usb: Fix an NULL vs IS_ERR() bug
Date: Tue, 17 Jun 2025 17:25:41 +0200
Message-ID: <20250617152347.298581985@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit d14402a38c2d868cacb1facaf9be908ca6558e59 ]

The qmp_usb_iomap() helper function currently returns the raw result of
devm_ioremap() for non-exclusive mappings. Since devm_ioremap() may return
a NULL pointer and the caller only checks error pointers with IS_ERR(),
NULL could bypass the check and lead to an invalid dereference.

Fix the issue by checking if devm_ioremap() returns NULL. When it does,
qmp_usb_iomap() now returns an error pointer via IOMEM_ERR_PTR(-ENOMEM),
ensuring safe and consistent error handling.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: a5d6b1ac56cb ("phy: qcom-qmp-usb: fix memleak on probe deferral")
CC: Johan Hovold <johan@kernel.org>
CC: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250414125050.2118619-1-chenyuan0y@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index c697d01b2a2a1..5072bca0af7c5 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -2044,12 +2044,16 @@ static void __iomem *qmp_usb_iomap(struct device *dev, struct device_node *np,
 					int index, bool exclusive)
 {
 	struct resource res;
+	void __iomem *mem;
 
 	if (!exclusive) {
 		if (of_address_to_resource(np, index, &res))
 			return IOMEM_ERR_PTR(-EINVAL);
 
-		return devm_ioremap(dev, res.start, resource_size(&res));
+		mem = devm_ioremap(dev, res.start, resource_size(&res));
+		if (!mem)
+			return IOMEM_ERR_PTR(-ENOMEM);
+		return mem;
 	}
 
 	return devm_of_iomap(dev, np, index, NULL);
-- 
2.39.5



